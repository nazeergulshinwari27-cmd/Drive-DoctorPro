@echo off
cd /d "%~dp0windows_agent"
if not exist .venv python -m venv .venv
call .venv\Scripts\activate
pip install -r requirements.txt
if "%DD_AGENT_TOKEN%"=="" set DD_AGENT_TOKEN=CHANGE-THIS-LOCAL-AGENT-SECRET
uvicorn agent:app --host 127.0.0.1 --port 8765
pause
