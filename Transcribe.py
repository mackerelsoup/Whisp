#!/usr/bin/env python3
import whisper
import os
import re
import argparse
import yt_dlp
import browser_cookie3


def get_firefox_cookies(domain):
    """
    Read cookies directly from Firefox database.
    Make sure there is a running instance of Firefox logged into panopto

    Args:
        domain: Domain name to extract cookies for (e.g., 'youtube.com')

    Returns:
        Path to the generated cookies.txt file  
    """
    cookies = browser_cookie3.firefox(domain_name=domain)

    with open('cookies.txt', 'w') as f:
        # Write Netscape cookie file header
        f.write('# Netscape HTTP Cookie File\n')
        f.write('# https://curl.haxx.se/rfc/cookie_spec.html\n')
        f.write('# This is a generated file! Do not edit.\n')

        cookie_count = 0
        for cookie in cookies:
            if domain in cookie.domain:
                f.write(f"{cookie.domain}\t")
                f.write(f"{'TRUE' if cookie.domain.startswith('.') else 'FALSE'}\t")
                f.write(f"{cookie.path}\t")
                f.write(f"{'TRUE' if cookie.secure else 'FALSE'}\t")
                f.write(f"{int(cookie.expires) if cookie.expires else 0}\t")
                f.write(f"{cookie.name}\t{cookie.value}\n")
                cookie_count += 1

        print(f"✓ Exported {cookie_count} cookies from Firefox")

    return 'cookies.txt'


def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Transcribe audio/video files using Whisper")
    parser.add_argument("Url", help="URL of the video to download and transcribe")
    parser.add_argument("-c", "--cookies", default="./cookies.txt",
                        help="Manually input cookies if not using Firefox")
    parser.add_argument("-o", "--output-dir", default="Output",
                        help="Output directory for transcriptions (default: Output)")
    parser.add_argument("-v", "--video-dir", default="Videos",
                        help="Directory to save downloaded videos (default: Videos)")
    parser.add_argument("-m", "--model", default="turbo",
                        choices=["tiny", "base", "small", "medium", "large", "turbo"],
                        help="Whisper model to use (default: turbo)")
    args = parser.parse_args()

    # Extract cookies from Firefox if custom cookie path is not provided
    url = args.Url
    if args.cookies == "./cookies.txt":
        get_firefox_cookies("mediaweb.ap.panopto.com")
    cookies_path = args.cookies

    # Create directories
    video_dir = args.video_dir
    output_dir = args.output_dir
    os.makedirs(video_dir, exist_ok=True)
    os.makedirs(output_dir, exist_ok=True)

    # Configure yt-dlp options
    ydl_opts = {
        'cookiefile': cookies_path,
        'format': 'bestaudio/best',
        'outtmpl': f'{video_dir}/%(title)s.%(ext)s',  # Save to Videos folder
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'nopostoverwrites': False,
            'preferredcodec': 'best',
            'preferredquality': '5'
        }]
    }

    # Download video/audio
    print(f"Downloading from: {url}")
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        downloaded_file = info['requested_downloads'][0]['filepath']

    print(f"Downloaded: {downloaded_file}")

    # Load Whisper model
    print(f"Loading Whisper model: {args.model}")
    model = whisper.load_model(args.model)

    # Transcribe the audio
    print("Transcribing audio...")
    filename = re.sub(r'\.[^.]+$', "", os.path.basename(downloaded_file))
    result = model.transcribe(downloaded_file, verbose=False)

    # Save transcription
    output_path = f"{output_dir}/{filename}.txt"
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(result["text"])

    print(f"✓ Transcription saved to: {output_path}")


if __name__ == "__main__":
    main()




