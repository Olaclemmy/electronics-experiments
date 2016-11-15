#
# Ultrasonic sensor
#
# @author Glenn De Backer <glenn@simplicity.be>
#

# standard lib
import socket
import ConfigParser
import json

# serial
import serial

if __name__ == '__main__':

    # Read configuration
    Config = ConfigParser.ConfigParser()
    Config.read("settings.ini")
    udp_port = Config.getint('UDP', 'port')

    # setup UDP
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    # open serial port
    with serial.Serial('/dev/cu.usbmodemFD121', 115200, timeout=1) as ser:
        while True:
            # read distance
            distance =  ser.readline().rstrip()

            # broadcast an UDP package
            sock.sendto(json.dumps({'sensor': 'distance', 'value': distance}), ('255.255.255.255', udp_port))
