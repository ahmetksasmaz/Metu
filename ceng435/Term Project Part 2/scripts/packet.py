# Import proper libraries
import struct
import hashlib
import time

# Globals About File And Packets (length, size etc.)
packetLength = 1000
partitionLength = 500
totalLength = 50000
size = totalLength / partitionLength - 1

# This function unpacks a message packet
# Then checks whether packet is corrupted or not
# If packet is corrupted, it returns false
# Else return content of the packet as tuple (time, seqNum, data)
def unpack(msg):
    checksum = struct.unpack("32s", msg[:32])[0]
    pkt = msg[32:]
    packetChecksum = hashlib.md5(pkt).hexdigest()
    if packetChecksum == checksum:
        timeOld = struct.unpack("d", pkt[:8])[0]
        seq = struct.unpack("i", pkt[8:12])[0]
        return (timeOld,seq,pkt[12:])
    else:
        return false

# This function prepares a packet
# Takes seqNum and data as parameter
# Then calculates checksum
# Finally concatenate them and return prepared packet
def pack(seq,pkt):
    part = struct.pack("d", time.time()) + struct.pack("i", seq) + pkt
    checksum = hashlib.md5(part).hexdigest()
    part = struct.pack("32s", checksum) + part
    return part

# This function also prepares a packet
# But this time, takes time and seqNum as parameter
# Sets data as b"ACK"
# Calculates checksum
# Finally concatenate them and return prepared ACK packet
def ackPack(timex,seq):
    part = struct.pack("d", timex) + struct.pack("i", seq) + b"ACK"
    checksum = hashlib.md5(part).hexdigest()
    part = struct.pack("32s", checksum) + part
    return part
