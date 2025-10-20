# Whisp - Video Transcription Tool

Automatically download and transcribe videos using OpenAI's Whisper model.

## Setup

### Prerequisites
- Python 3.8 or higher
- FFmpeg installed on your system

### Installation

1. Clone or download this repository
2. Install dependencies:
```bash
pip install -r requirements.txt
```

### FFmpeg Installation
- **Windows**: Download from [ffmpeg.org](https://ffmpeg.org/download.html) and add to PATH
- **Mac**: `brew install ffmpeg`
- **Linux**: `sudo apt install ffmpeg`

## Usage

### Basic Usage
```bash
python Transcribe.py "https://example.com/video"
```

### Using Batch File (Windows)
```bash
transcribe "https://example.com/video"
```

### Options
- `-m, --model`: Choose Whisper model (tiny, base, small, medium, large, turbo)
  - Default: `turbo`
- `-o, --output-dir`: Directory for transcription text files
  - Default: `Output/`
- `-v, --video-dir`: Directory for downloaded videos
  - Default: `Videos/`
- `-c, --cookies`: Path to cookies file
  - Default: `./cookies.txt`

### Examples

**Different model:**
```bash
python Transcribe.py "URL" -m large
```

**Custom directories:**
```bash
python Transcribe.py "URL" -v MyVideos -o MyTranscripts
```

**With custom cookies:**
```bash
python Transcribe.py "URL" -c /path/to/cookies.txt
```

## Notes

- The script automatically extracts Firefox cookies for Panopto authentication
- Videos are saved to `Videos/` directory
- Transcriptions are saved to `Output/` directory
- GPU acceleration is used automatically if CUDA is available
