import _nx
import sys
import time

from .cached_properties import (cached_property, cached_property_with_ttl,
                                cached_property_ttl, timed_cached_property)


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


def bit(n: int):
    return 1 << n


def clear_terminal():
    print(chr(27) + "[2J")


class AnsiMenu:
    """ANSI menu by DavidBuchanan314"""

    CONTROLLER_P1_AUTO = 10
    KEY_A = 1
    KEY_UP = 0x222000
    KEY_DOWN = 0x888000
    selected_idx = 0

    def __init__(self, entries, console=sys.stdout.buffer):
        self.entries = entries
        self.console = console

    def query(self):
        self.render()

        while True:
            if self.poll_input():
                break
            time.sleep(0.01)

        self.console.write(b"\x1b[%dB" % (len(self.entries)-self.selected_idx))
        self.console.flush()
        return self.selected_idx

    def poll_input(self):
        _nx.hid_scan_input()
        keys_down = _nx.hid_keys_down(self.CONTROLLER_P1_AUTO)

        if keys_down & self.KEY_A:
            return True
        elif keys_down & self.KEY_UP:
            if self.selected_idx > 0:
                self.selected_idx -= 1
                self.console.write(b" \x1b[1A\r>\r")
                self.console.flush()
        elif keys_down & self.KEY_DOWN:
            if self.selected_idx < len(self.entries)-1:
                self.selected_idx += 1
                self.console.write(b" \n\r>\r")
                self.console.flush()

        return False

    def render(self):
        for i, label in enumerate(self.entries):
            marker = b">" if (i == self.selected_idx) else b" "
            self.console.write(b"%s %s\n" % (marker, label.encode()))

        self.console.write(b"\x1b[%dA" % len(self.entries))
        self.console.flush()
