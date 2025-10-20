import whisper
import os
import re

model = whisper.load_model("turbo")
file = "temp2.mp4"
filename = re.sub(r'\.[^.]+$', "", file)
output_dir = "Output"
os.makedirs(output_dir,exist_ok= True)

result = model.transcribe(file, verbose=False)

with open(f"{output_dir}/{filename}.txt", "w", encoding="utf-8") as f:
  f.write(result["text"])




