# Import proper libraries
import subprocess
import ipTable
from socket import *
from threading import Thread

# Define socket globals that listens and talk with other nodes
# It is defined as global to make available to use from every script
listenSockets = {}
talkSockets = {}

# Determines the node that this script runs in with "whoami" parameter
# "whoami" parameter value is set by the script that imports gen.py
# After set proper listen and talk sockets
def setUp(whoami):
    global listenSockets, talkSockets
    if(whoami == "s" or whoami == "d"):
        # If the node is "s" or "d", make connections with routers
        # Because connecting s or d with all routers does not affect experiment results
        # We didn't see seperating sockets according to an experiment as need
        listenSockets["r1"] = socket(AF_INET, SOCK_DGRAM)
        listenSockets["r2"] = socket(AF_INET, SOCK_DGRAM)
        listenSockets["r3"] = socket(AF_INET, SOCK_DGRAM)
        talkSockets["r1"] = socket(AF_INET, SOCK_DGRAM)
        talkSockets["r2"] = socket(AF_INET, SOCK_DGRAM)
        talkSockets["r3"] = socket(AF_INET, SOCK_DGRAM)
    if(whoami == "r1" or whoami == "r2" or whoami == "r3"):
        # If the node is a router, make connections with s and d
        listenSockets["s"] = socket(AF_INET, SOCK_DGRAM)
        listenSockets["d"] = socket(AF_INET, SOCK_DGRAM)
        talkSockets["s"] = socket(AF_INET, SOCK_DGRAM)
        talkSockets["d"] = socket(AF_INET, SOCK_DGRAM)

    for i in listenSockets:
        listenSockets[i].bind(ipTable.ip_table[whoami+"_"+i])

    for j in talkSockets:
        talkSockets[j].connect(ipTable.ip_table[j+"_"+whoami])

# After execution of a script, close all listen and talk sockets that are defined
def closeAll():
    global listenSockets
    global talkSockets
    for i in listenSockets:
        listenSockets[i].close()
    for j in talkSockets:
        talkSockets[j].close()
