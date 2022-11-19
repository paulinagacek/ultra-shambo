import time

def blink(pin):
    time.sleep(1)
    pin.on()
    time.sleep(0.5)
    pin.off()