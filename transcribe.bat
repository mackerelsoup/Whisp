@echo off

REM Activate conda environment
echo Activating whisperEnv...
call C:\Users\Admin\miniconda3\Scripts\activate.bat whisperEnv

REM Check if activation was successful
if errorlevel 1 (
    echo Error: Failed to activate conda environment
    pause
    exit /b 1
)

REM Run the Python transcription script
echo Running transcription...
python "%USERPROFILE%\Documents\Projects\Whisp\Transcribe.py" %*

REM If successful, open the Output folder
if %errorlevel% equ 0 (
    echo.
    echo Transcription completed successfully!
    start "" "%USERPROFILE%\Documents\Projects\Whisp\Output"
) else (
    echo.
    echo Error: Transcription failed
)

pause