FROM nvidia/cuda:12.6.0-base-ubuntu22.04

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install PyTorch with CUDA support first
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# Install other Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the application
COPY Transcribe.py .

# Create output directories
RUN mkdir -p /app/Output /app/Videos

# Set the entrypoint
ENTRYPOINT ["python", "Transcribe.py"]
