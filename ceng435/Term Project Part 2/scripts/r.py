# Import Proper Libraries
import gen
import packet
import sys
from threading import Thread

# Command Line Arguments
# Takes router name which this script is running in as parameter
me = sys.argv[1]

# Listen s and send data to d
def s():
    while True:
        (data, addr) = gen.listenSockets["s"].recvfrom(packet.packetLength)
        if data:
            gen.talkSockets["d"].send(data)
        else:
            continue

# Listen d and send data to s
def d():
    while True:
        (data, addr) = gen.listenSockets["d"].recvfrom(packet.packetLength)
        if data:
            gen.talkSockets["s"].send(data)
        else:
            continue

# Call function setUp from gen.py to define proper socket connections
gen.setUp(me)

# Make the processes at the same time
# Threads are defined and then started
sThread = Thread(target=s)
dThread = Thread(target=d)
sThread.start()
dThread.start()

# Wait until the threads done
sThread.join()
dThread.join()
