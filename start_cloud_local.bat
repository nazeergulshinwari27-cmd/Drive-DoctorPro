@echo off
cd /d "%~dp0cloud_api"
if not exist .venv python -m venv .venv
call .venv\Scripts\activate
pip install -r requirements.txt
if "%DD_API_KEY%"=="" set DD_API_KEY=CHANGE-THIS-LOCAL-SECRET
uvicorn app:app --host 127.0.0.1 --port 8000
pause
