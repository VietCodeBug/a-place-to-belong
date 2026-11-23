"""Synthesize the rainy office's keyboard and printer foley with a fixed seed."""
from math import exp, pi, sin
from pathlib import Path
from random import Random
import struct
import wave


RATE = 24_000
ROOT = Path(__file__).resolve().parents[2] / "assets" / "story"
RNG = Random(10663)


def export(filename, samples, peak):
    gain = peak / max(abs(sample) for sample in samples)
    with wave.open(str(ROOT / filename), "wb") as recording:
        recording.setparams((1, 2, RATE, 0, "NONE", "not compressed"))
        recording.writeframes(struct.pack(f"<{len(samples)}h", *(int(sample * gain) for sample in samples)))


def key(samples, start, strength):
    index = int(start * RATE)
    damping = RNG.uniform(69.0, 119.0)
    body = RNG.uniform(285.0, 535.0)
    click_pitch = RNG.uniform(1310, 2190)
    smoothed = 0.0
    for offset in range(int(0.076 * RATE)):
        t = offset / RATE
        noise = RNG.uniform(-1.0, 1.0)
        smoothed += 0.46 * (noise - smoothed)
        knock = sin(2 * pi * body * t) * exp(-t * damping)
        tick = (sin(2 * pi * click_pitch * t) * 0.33 + smoothed * 0.18) * exp(-t * 370.0)
        release = sin(2 * pi * body * 0.78 * t) * 0.10 * exp(-abs(t - 0.043) * 269)
        samples[(index + offset) % len(samples)] += (knock * 0.56 + tick + release) * strength


def typing():
    samples = [0.0] * (RATE * 8)
    time = 0.12
    while time < 7.88:
        for count in range(RNG.randint(4, 12)):
            key(samples, time, RNG.uniform(0.43, 0.85) if count % 4 != 0 else 0.94)
            time += RNG.uniform(0.104, 0.221)
        time += RNG.uniform(0.25, 0.57)
    return samples


def printer():
    samples = []
    soft = slow = 0.0
    for index in range(int(RATE * 2.50)):
        t = index / RATE
        noise = RNG.uniform(-1.0, 1.0)
        soft += 0.24 * (noise - soft)
        slow += 0.041 * (noise - slow)
        motor_gate = min(1, max(0, (t - 0.14) * 12), max(0, (1.75 - t) * 5))
        roller_gate = min(1, max(0, (t - 0.34) * 21), max(0, (1.39 - t) * 12))
        wobble = 0.76 + 0.24 * sin(2 * pi * 7.2 * t)
        motor = (sin(2 * pi * 101 * t + 0.42 * sin(t * 37)) * 0.36 + sin(2 * pi * 199 * t) * 0.13 + slow * 0.35)
        paper = (soft - slow) * (0.35 + 0.16 * sin(t * 59))
        eject = exp(-abs(t - 1.42) * 66) * sin(t * 2 * pi * 224) * 0.21
        samples.append(motor_gate * wobble * motor + roller_gate * paper + eject)
    key(samples, 0.115, 0.22)
    key(samples, 1.83, 0.31)
    return samples


def tone_pair(first, second, length, gap):
    samples = []
    for frame in range(int(RATE * length)):
        t = frame / RATE
        launch = min(1.0, 180.0 * t)
        second_t = max(0.0, t - gap)
        a = launch * sin(2 * pi * first * t) * exp(-18 * t)
        b = min(1.0, 180.0 * second_t) * sin(2 * pi * second * second_t) * exp(-15 * second_t)
        samples.append(a + 0.57 * b)
    return samples


def room_sound(kind, seconds):
    samples = []
    slow = fast = air = 0.0
    for frame in range(int(RATE * seconds)):
        t = frame / RATE
        raw = RNG.uniform(-1.0, 1.0)
        slow += (raw - slow) * 0.021
        fast += (raw - fast) * 0.19
        air += (raw - air) * 0.0057
        if kind == "vent":
            drift = 0.91 + 0.09 * sin(2 * pi * t / seconds)
            sound = drift * (air * 0.45 + 0.07 * sin(2 * pi * 73 * t) + 0.035 * sin(2 * pi * 146 * t))
        elif kind == "chair":
            gate = min(1.0, 13.0 * t) * max(0.0, 1.0 - t / seconds) ** 1.6
            sound = gate * (slow + 0.20 * (fast - slow) + 0.12 * sin(2 * pi * (69*t - 11*t*t)))
        else:
            phrasing = max(0.0, sin(t * 1.82 + sin(t*0.81))) ** 1.5
            syllables = 0.34 + 0.66 * max(0.0, sin(2 * pi * (3.7*t + 0.10*sin(t*2.1))))
            sound = phrasing * syllables * (
                0.31 * slow + 0.025 * sin(2*pi*(152*t + 0.70*sin(t*1.51))) +
                0.017 * sin(2*pi*(277*t + 0.33*sin(t*4.0)))
            )
        samples.append(sound)
    fade = min(int(RATE * 0.08), len(samples) // 2)
    for i in range(fade):
        factor = i / fade
        samples[i] *= factor
        samples[-1-i] *= factor
    return samples


if __name__ == "__main__":
    export("office_keys.wav", typing(), 20_500)
    export("office_printer.wav", printer(), 17_800)
    click = [0.0] * (RATE // 8)
    key(click, 0.023, 0.55)
    export("office_mouse.wav", click, 13_500)
    export("office_chair.wav", room_sound("chair", 0.68), 13_200)
    export("office_vent.wav", room_sound("vent", 4), 11_800)
    export("office_murmur.wav", room_sound("murmur", 7), 11_000)
    export("office_mail.wav", tone_pair(670, 895, 0.42, 0.059), 10_500)
    alarm = tone_pair(855, 855, 0.30, 0.105) + [0.0] * int(RATE * 1.1)
    export("apartment_alarm.wav", alarm, 12_000)
