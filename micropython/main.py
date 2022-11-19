import machine

from blink import blink

pin17 = machine.Pin(17, machine.Pin.OUT)

while True :
    blink(pin17)
