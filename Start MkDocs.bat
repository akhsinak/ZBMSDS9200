@echo off
echo ============================================
echo  Email App - MkDocs Documentation
echo ============================================
echo.
cd /d "%~dp0"

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

REM Install dependencies if needed
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Installing dependencies...
pip install -q -r requirements.txt

REM Create symlink for Japanese docs if not exists
if not exist "docs\ja" (
    echo Linking Japanese documentation...
    mklink /J "docs\ja" "docs-jp" >nul 2>&1
)

echo.
echo Starting MkDocs server...
echo Open http://127.0.0.1:8000 in your browser
mkdocs serve

pause
