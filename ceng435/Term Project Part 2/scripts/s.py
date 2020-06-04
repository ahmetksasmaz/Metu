# Import Proper Libraries

import gen
import sys
import time
import threading
import random
import packet
import math
import hashlib
import struct
import os

# Command Line Arguments
# $1 Takes node name
# $2 Takes experiment number
# $3 Takes configure number
# $4 Takes experiment times
me = sys.argv[1]
experimentNo = sys.argv[2]
configureNumber = sys.argv[3]
experimentTimes = sys.argv[4]

# Some Constants For File Reading and Random Link Down
linkAliveDuration = 10
linkAliveTolerance = 1
linkDownDuration = 1
linkDownTolerance = 1
r1Interface = "eth3"
r2Interface = "eth2"
inputFile = "input.txt"
resultFile = "results.txt"

# Global Variables For Check Experiment Done and Terminate Cond
experimentDone = False
terminate = False

retransmit = False

# Check Connections
isR1connected = True
isR2connected = True

# Window Globals
windowSize = 20
seqnum = 0
base = 0

# Timeout Globals
timeoutInterval = 0.5
estimatedRTT = timeoutInterval
devRTT = 0

# Read All Data
file = open(inputFile, "rb")
data = file.read(packet.totalLength)
file.close()

# Write it into the buffer
buff = []
while data:
    buff.append(data[:packet.partitionLength])
    data = data[packet.partitionLength:]

# Thread Locks
baseLock = threading.Lock()
timerLock = threading.Lock()
buffLock = threading.Lock()
baseCond = threading.Condition()

# Results in an array
results = []

timer = False

# listenFrom listens sockets for specific experiment
# If packet is final, then make true experimentDone flag
# Else check data's seqNum is expected or not 
# If packet is expected, calculate new sampleRTT and set timer
def listenFrom(socket,experiment):
    global experimentDone, base, timer, timeoutInterval, seqnum
    msg = gen.listenSockets[socket].recv(packet.packetLength)
    data = packet.unpack(msg)
    if data:
        print "listened ", data[1], " from", socket
        if data[1] == packet.size and seqnum == packet.size+1:
            experimentDone = True
        else:
            with baseLock:
                if data[1] == base:
                    base = data[1] + 1
                    with baseCond:
                        baseCond.notify()
            if data[1] == base-1:
                with timerLock:
                    with baseLock:
                        if base == seqnum:
                            timer.cancel()
                        else:
                            timer.cancel()
                            sampleRTT = time.time() - data[0]
                            timeoutInterval = timeoutCalculator(sampleRTT)
                            if experiment == 1:
                                timer = threading.Timer(timeoutInterval, timeout1)
                            elif experiment == 2:
                                timer = threading.Timer(timeoutInterval, timeout2)
                            timer.start()
# Send Packets For Experiment 1
# If seqnum hasn't reached limit yet, send next data
# If seqnum is the first of window
# Set timer for timeout check
# Increase seqnum by one
def sendPacket1():
    global buff, experimentDone, base, timer, seqnum, retransmit
    while not experimentDone:
        if not retransmit:
            with baseLock:
                tempBase = base
            if seqnum <= packet.size:
                if seqnum < tempBase + windowSize:
                    data = packet.pack(seqnum,buff[seqnum])
                    gen.talkSockets["r3"].send(data)
                    print "packet ", seqnum, " sent to r3"
                    if tempBase == seqnum:
                        with timerLock:
                            timer.cancel()
                            timer = threading.Timer(timeoutInterval, timeout1)
                            timer.start()
                    seqnum += 1
                else:
                    with baseCond:
                        baseCond.wait()
                time.sleep(0.02)

# Listen ACK Packets from r3 for experiment 1
def listenACK1():
    global experimentDone
    while not experimentDone:
        listenFrom("r3",1)
# If a packet timeouts, stop sending packets
# Resend packets base from seqnum
def timeout1():
    global experimentDone, timer, retransmit, base, timeoutInterval
    retransmit = True
    if not experimentDone:
        with buffLock:
            with timerLock:
                timer.cancel()
                timer = threading.Timer(timeoutInterval, timeout1)
                timer.start()
        with baseLock:
            print "Retransmitting from", base, " to", seqnum
            for i in range(base,seqnum):
                data = packet.pack(i,buff[i])
                gen.talkSockets["r3"].send(data)
                print "\t packet ", i, " sent to r3"
            retransmit = False
# Send Packets For Experiment 1
# If seqnum hasn't reached limit yet, send next data
# Send data according to which connection is open
# If seqnum is the first of window
# Set timer for timeout check
# Increase seqnum by one
def sendPacket2():
    global buff, experimentDone, base, timer, seqnum, isR1connected, isR2connected
    while not experimentDone:
        if not retransmit:
            with baseLock:
                tempBase = base
            if seqnum <= packet.size:
                if seqnum < tempBase + windowSize:
                    if not isR1connected:
                        data = packet.pack(seqnum,buff[seqnum])
                        gen.talkSockets["r2"].send(data)
                        print "packet ", seqnum, " sent to r2"
                    elif not isR2connected:
                        data = packet.pack(seqnum,buff[seqnum])
                        gen.talkSockets["r1"].send(data)
                        print "packet ", seqnum, " sent to r1"
                    elif seqnum % 2 == 0:
                        data = packet.pack(seqnum,buff[seqnum])
                        gen.talkSockets["r1"].send(data)
                        print "packet ", seqnum, " sent to r1"
                    elif seqnum % 2 == 1:
                        data = packet.pack(seqnum,buff[seqnum])
                        gen.talkSockets["r2"].send(data)
                        print "packet ", seqnum, " sent to r2"
                    if tempBase == seqnum:
                        with timerLock:
                            timer.cancel()
                            timer = threading.Timer(timeoutInterval, timeout2)
                            timer.start()
                    seqnum += 1
                else:
                    with baseCond:
                        baseCond.wait()
                time.sleep(0.02)
# Listen ACK Packets from which connection is open for experiment 2
def listenACK2():
    global base, experimentDone, timer, isR1connected, isR2connected
    while not experimentDone:
        if not (isR1connected or isR2connected):
            continue
        elif isR1connected and isR2connected:
            listenFrom("r1",2)
            listenFrom("r2",2)
        elif isR1connected and isR2connected == False :
            listenFrom("r1",2)
        elif isR1connected == False and isR2connected:
            listenFrom("r2",2)
# If a packet timeouts, stop sending packets
# Resend packets base from seqnum to which connection is open
def timeout2():
    global experimentDone, timer, retransmit, base, timeoutInterval, isR1connected, isR2connected
    retransmit = True
    if not experimentDone:
        with buffLock:
            with timerLock:
                timer.cancel()
                timer = threading.Timer(timeoutInterval, timeout2)
                timer.start()
        with baseLock:
            print "Retransmitting from", base, " to", seqnum
            for i in range(base,seqnum):
                if not(isR1connected):
                    data = packet.pack(i,buff[i])
                    gen.talkSockets["r2"].send(data)
                    print "\t packet ", i, " sent to r2"
                elif not(isR2connected):
                    data = packet.pack(i,buff[i])
                    gen.talkSockets["r1"].send(data)
                    print "\t packet ", i, " sent to r1"
                elif i % 2 == 0:
                    data = packet.pack(i,buff[i])
                    gen.talkSockets["r1"].send(data)
                    print "\t packet ", i, " sent to r1"
                elif i % 2 == 1:
                    data = packet.pack(i,buff[i])
                    gen.talkSockets["r2"].send(data)
                    print "\t packet ", i, " sent to r2"
            retransmit = False
# New timeoutInterval calculator
def timeoutCalculator(sampleRTT):
    global estimatedRTT, devRTT
    estimatedRTT = (0.875 * estimatedRTT) + (0.125 * sampleRTT)
    devRTT = (0.75 * devRTT) + (0.75 * abs(sampleRTT - estimatedRTT))
    return estimatedRTT + (4 * devRTT)

# Repeat experiments again and again
def experiment(no,times):
    global results, experimentDone, seqnum, base, timeoutInterval, estimatedRTT, devRTT, terminate, retransmit, timer
    for i in range(times):
        experimentDone = False
        seqnum = 0
        base = 0
        timeoutInterval = 0.5
        estimatedRTT = timeoutInterval
        devRTT = 0
        retransmit = False
        startTime = time.time()
        print "experiment ", no, " -> ", i+1, "th started at : ", startTime 
        if no == 1:
            timer = threading.Timer(timeoutInterval, timeout1)
            sendPacketThread = threading.Thread(target = sendPacket1)
            listenACKThread = threading.Thread(target = listenACK1)
        elif no == 2:
            timer = threading.Timer(timeoutInterval, timeout2)
            sendPacketThread = threading.Thread(target = sendPacket2)
            listenACKThread = threading.Thread(target = listenACK2)
        sendPacketThread.start()
        listenACKThread.start()
        listenACKThread.join()
        sendPacketThread.join()
        timer.cancel()
        endTime = time.time()
        print "experiment ", no, " -> ", i+1, "th ended at : ", endTime 
        results.append(endTime-startTime)
    terminate = True

#Link Down Thread
def randomLinkDown():
    global linkAliveDuration
    global linkAliveTolerance
    global linkDownDuration
    global linkDownTolerance
    global r1Interface
    global r2Interface
    global isR1connected
    global isR2connected
    global terminate
    while not terminate:
        os.system("sudo ip link set dev "+r1Interface+" up")
        isR1connected = True
        os.system("sudo ip link set dev "+r2Interface+" up")
        isR2connected = True
        print "links up!"
        time.sleep(linkAliveDuration + random.randint(-linkAliveTolerance,linkAliveTolerance))
        if random.randint(1,2) == 1:
            os.system("sudo ip link set dev "+r1Interface+" down")
            isR1connected = False
            print "r1 down!"
        else:
            os.system("sudo ip link set dev "+r2Interface+" down")
            isR2connected = False
            print "r2 down!"
        time.sleep(linkDownDuration + random.randint(-linkDownTolerance,linkDownTolerance))
    os.system("sudo ip link set dev "+r1Interface+" up")
    os.system("sudo ip link set dev "+r2Interface+" up")

# Calculate collected results
def calculateResults():
    global results
    size = len(results)
    if size > 0:
        sum = 0.0
        stdevSum = 0.0
        zVal = 1.96
        for i in range(size):
            sum += results[i]
        mean = sum / size
        for i in range(size):
            stdevSum += (results[i]-mean)**2
        stdev = (math.sqrt(stdevSum) / math.sqrt(size))
        error = zVal * (math.sqrt(stdevSum) / size)
        lower = mean - error
        upper = mean + error
    else:
        stdev = 0.0
        error = 0.0
        lower = 0.0
        mean = 0.0
        upper = 0.0
    rfile = open(resultFile,"a")
    rfile.write("\n" + experimentNo + "\t" + configureNumber + "\t" + experimentTimes + "\t" + str(stdev) + "\t" + str(error) + "\t" + str(lower) + "\t" + str(mean) + "\t" + str(upper))

print "experimentNo : " + experimentNo
print "configureNumber : " + configureNumber
print "experimentTimes : " + experimentTimes

gen.setUp(me)

experimentThread = threading.Thread(target = experiment, args = (int(experimentNo), int(experimentTimes)))
if experimentNo == "2":
    randomLinkDownThread = threading.Thread(target = randomLinkDown)
    randomLinkDownThread.start()
experimentThread.start()
experimentThread.join()
if experimentNo == "2":
    randomLinkDownThread.join()

calculateResults()
gen.closeAll()
