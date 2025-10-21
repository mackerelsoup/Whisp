@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM Whisper Transcription - Virtual Environment
REM ==========================================

echo.
echo ==========================================
echo Whisper Transcription (venv)
echo ==========================================
echo.

REM Set paths
set VENV_PATH=%~dp0venv
set PROJECT_PATH=%~dp0

REM Check if Python is installed
echo [1/5] Checking Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [X] Python not found
    echo.
    echo Please install Python 3.10 or higher:
    echo https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)
echo [OK] Python is installed

REM Check if virtual environment exists, create if not
echo.
echo [2/5] Checking virtual environment
if not exist "%VENV_PATH%\Scripts\activate.bat" (
    echo [!] Virtual environment not found
    echo [+] Creating virtual environment (this may take a moment)
    python -m venv "%VENV_PATH%"

    if errorlevel 1 (
        echo [X] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created
`
    echo.
    echo [3/5] Installing dependencies (this may take 5-10 minutes)
    call "%VENV_PATH%\Scripts\activate.bat"
    pip install --upgrade pip
    pip install -r "%PROJECT_PATH%requirements.txt"
    pip install -r "%PROJECT_PATH%requirements2.txt"

    if errorlevel 1 (
        echo [X] Failed to install dependencies
        pause
        exit /b 1
    )
    echo [OK] Dependencies installed
) else (
    echo [OK] Virtual environment exists
    echo.
    echo [3/5] Activating virtual environment
    call "%VENV_PATH%\Scripts\activate.bat"
    echo [OK] Virtual environment activated
)

REM Check for GPU support
echo.
echo [4/5] Checking GPU support
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo [!] NVIDIA GPU not detected
    echo [i] Running on CPU (will be slower)
) else (
    echo [OK] NVIDIA GPU detected
)

REM Run transcription
echo.
echo [5/5] Running transcription
echo.
python "%PROJECT_PATH%Transcribe.py" %*

REM Check result
if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo [OK] SUCCESS: Transcription completed!
    echo ==========================================
    start "" "%PROJECT_PATH%Output"
) else (
    echo.
    echo ==========================================
    echo [X] ERROR: Transcription failed
    echo ==========================================
)

deactivate
pause