import gen
import sys
import time
import threading
import random
import packet
import hashlib
import struct
import os

# Command Line Arguments
# $1 Takes node name
# $2 Takes experiment number
# $3 Takes experiment times
me = sys.argv[1]
experimentNo = sys.argv[2]
experimentTimes = sys.argv[3]

# Some Constants
outputFile = "output"
outputFileExt = ".txt"

# Global Variables
experimentDone1 = False
experimentDone2 = False
expectedSeqnum = 0

mem = []

# Listen packets from a socket
# If received packet is expected, then write it into mem array
# If received packet is already received, just send the same
# If final packet is received, then send 100 ack packets for final pack
def listenPkt(socket,extrasocket):
    global expectedSeqnum, experimentDone1, experimentDone2, mem
    while True:
        if extrasocket == "":
            if experimentDone1:
                break
        else:
            if socket == "r1":
                if experimentDone1:
                    break
            else:
                if experimentDone2:
                    break
        msg = gen.listenSockets[socket].recv(packet.packetLength)
        data = packet.unpack(msg)
        if data:
            print "listened ", data[1], " from", socket
            if data[1] == expectedSeqnum and data[1] != packet.size:
                mem.append((data[1],data[2]))
                gen.talkSockets[socket].send(packet.ackPack(data[0],data[1]))
                print "sent ack for ", data[1], " to ", socket
                expectedSeqnum += 1
            elif data[1] == packet.size and expectedSeqnum == packet.size:
                mem.append((data[1],data[2]))
                for i in range(100):
                    gen.talkSockets[socket].send(packet.ackPack(data[0],data[1]))
                    print "sent fin ack for ", data[1], " to ", socket
                    if extrasocket != "":
                        gen.talkSockets[extrasocket].send(packet.ackPack(data[0],data[1]))
                        print "sent fin ack for ", data[1], " to ", extrasocket
                experimentDone1 = True
                if extrasocket != "":
                    experimentDone2 = True
                print "experimentDone from", socket
            elif data[1] < expectedSeqnum:
                gen.talkSockets[socket].send(msg)
                print "sent old ack for ", data[1], " to ", socket
    print socket, " is done"

# Repeat experiments again and again
def experiment(no,times):
    global expectedSeqnum, experimentDone1, experimentDone2, mem
    os.system("rm -rf output*")
    for i in range(times):
        expectedSeqnum = 0
        experimentDone1 = False
        experimentDone2 = False
        mem = []
        print "experiment ", no, " -> ", i+1, "th started at : ", time.time() 
        if no == 1:
            listenPktThread1 = threading.Thread(target = listenPkt, args=("r3",""))
        elif no == 2:
            listenPktThread1 = threading.Thread(target = listenPkt, args=("r1","r2"))
            listenPktThread2 = threading.Thread(target = listenPkt, args=("r2","r1"))
        listenPktThread1.start()
        if no == 2:
            listenPktThread2.start()
        listenPktThread1.join()
        if no == 2:
            listenPktThread2.join()
        mem = sorted(mem, key=lambda tup: tup[0])
        f = open(outputFile + str(i) + outputFileExt, "ab")
        for i in range(packet.size+1):
            f.write(mem[i][1])
        f.close()
        print "experiment ", no, " -> ", i+1, "th ended at : ", time.time()


print "experimentNo : " + experimentNo
print "experimentTimes : " + experimentTimes

gen.setUp(me)

experimentThread = threading.Thread(target = experiment, args = (int(experimentNo),int(experimentTimes)))
experimentThread.start()
experimentThread.join()

gen.closeAll()
