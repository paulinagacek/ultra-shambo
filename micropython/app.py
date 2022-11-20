import machine
import time
from read_distance import DistanceReader


def run():
    TRIG_PIN = 18
    ECHO_PIN = 19

    print("start")
    distance_reader = DistanceReader(TRIG_PIN, ECHO_PIN)
    
    for i in range(20) :
        distance = distance_reader.read_distance()
        print("Distance (cm): ", distance)
        time.sleep(1) # wait 1 second

    print("finish")
