"""Original seeded filtered-noise rain ambience, seamless 8 second PCM loop, CC0."""
import wave, random, math, struct, hashlib, json
from pathlib import Path
root=Path(__file__).resolve().parents[2];rng=random.Random(917);rate=22050;count=rate*8
# Circular convolution removes the loop seam without a repeating amplitude envelope.
noise=[rng.uniform(-1,1)for _ in range(count)]
samples=[sum(noise[(i-j)%count]for j in range(5))/5*.50+noise[i]*.10 for i in range(count)]
p=root/'assets/audio/rain_loop.wav'
with wave.open(str(p),'wb')as w:
 w.setnchannels(1);w.setsampwidth(2);w.setframerate(rate);w.writeframes(b''.join(struct.pack('<h',int(max(-1,min(1,s))*32767))for s in samples))
(root/'assets/audio/manifest.json').write_text(json.dumps({'license':'CC0-1.0','author':'Original procedural filtered noise; no recordings or external audio','sample_rate':rate,'duration_seconds':8,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()},indent=2)+'\n')
