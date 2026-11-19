"""Produce the office's distant thunder roll with a fixed seed."""
import math
from pathlib import Path
import random
import struct
import wave


rate = 24_000
rng = random.Random(40262)
samples = []
very_low = low = mid = last = 0.0
for index in range(rate * 6):
    time = index / rate
    noise = rng.uniform(-1, 1)
    very_low += 0.0075 * (noise - very_low)
    low += 0.027 * (noise - low)
    mid += 0.14 * (noise - mid)
    envelope = min(time * 19, 1) * math.exp(-time * 0.57)
    envelope *= min(1.0, (6 - time) * 1.1)
    swell = 0.59 + 0.20 * math.sin(time * 7.4 + 0.6) + 0.13 * math.sin(time * 3.1)
    crack = (mid - low) * math.exp(-time * 9.4) * 1.27
    bass = very_low * 3.1 + low * 1.16 + (mid - low) * 0.26
    last += 0.33 * ((bass * swell + crack) * envelope - last)
    samples.append(last)

peak = max(abs(sample) for sample in samples)
output = Path("assets/story/office_thunder.wav")
with wave.open(str(output), "wb") as recording:
    recording.setparams((1, 2, rate, 0, "NONE", "not compressed"))
    recording.writeframes(struct.pack(f"<{len(samples)}h", *(int(sample / peak * 26000) for sample in samples)))
