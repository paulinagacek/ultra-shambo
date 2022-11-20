import machine
import time


class DistanceReader:

    SPEED_OF_SOUND = 0.017  # cm/us / 2

    def __init__(self, trig_pin_index: int, echo_pin_index: int) -> None:
        self.trig_pin = machine.Pin(trig_pin_index, machine.Pin.OUT)
        self.echo_pin = machine.Pin(echo_pin_index, machine.Pin.IN)

    def read_distance(self) -> float:

        # Clears the trigPin
        self.trig_pin.off()
        time.sleep_us(3) # wait 3 microseconds

        # Sets the trigPin on HIGH state for 10 micro seconds
        self.trig_pin.on()
        time.sleep_us(10) # wait 10 microseconds
        self.trig_pin.off()

        # Reads the echoPin, returns the sound wave travel time in microseconds
        duration = machine.time_pulse_us(self.echo_pin, 1)

        # Calculate the distance
        distance = duration * DistanceReader.SPEED_OF_SOUND;

        return distance
