FROM python:3.11-slim

# Install system dependencies including FFmpeg
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY Transcribe.py .

# Create output directories
RUN mkdir -p /app/Output /app/Videos

# Set the entrypoint
ENTRYPOINT ["python", "Transcribe.py"]
