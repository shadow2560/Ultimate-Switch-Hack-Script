# -*- coding: utf-8 -*-
"""
    SSNC - Switch Serial Number Checker
"""


import argparse
import requests
import configparser
import serial_checker
import json
import sys
import os

global serials
serials = {}

def arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("serial_number", type=str,
                        help="Serial Number to check")
    args = parser.parse_args()
    return args


def configuration():
    global serials
    config = configparser.ConfigParser()
    config.read(os.path.join(sys.path[0], "config.ini"))

    try:
        serials_filename = config.get("SSNC", "SerialsJSON")
        with open(serials_filename) as f:
            serials = json.load(f)
    except:
        serials_url = config.get("SSNC", "SerialsURL")
        req = requests.get(serials_url)
        if req.status_code == 200:
            serials = req.json()


def main(argv):
    args = arguments()

    try:
        configuration()
        print(serial_checker.check(serials, args.serial_number))
    except Exception as err:
        print(err)


if __name__ == "__main__":
    main(sys.argv[1:])
