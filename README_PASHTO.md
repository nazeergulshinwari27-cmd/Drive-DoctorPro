# Drive Doctor Pro — Backend Starter v1.0

دا پروژه دوه جلا برخې لري:

1. `cloud_api/` — د Render لپاره آنلاین FastAPI سرور. د Kodular اپلیکیشن ورسره د HTTP غوښتنو له لارې اړیکه نیسي.
2. `windows_agent/` — په Windows کمپیوټر کې محلي FastAPI خدمت. دا د هماغه کمپیوټر ډرایوونه لوستلی شي.

## مهم محدودیتونه
- Render ستاسې USB/HDD/SSD/SD کارت ته مستقیم لاسرسی نه لري.
- Cloud API د حسابونو/وسایلو د ثبت، د تشخیص دندې او راپورونو د مدیریت بنسټ دی.
- Windows Agent په دې نسخه کې یوازې د ډرایو معلومات لوستل، د فولډر د فایلونو لست/هش او د ډیسک Image د لومړنیو MBR/GPT نښو لوستل کوي.
- دا نسخه حذف شوي فایلونه نه راګرځوي، خراب سکتورونه نه ترمیموي، SMART معلومات نه تضمینوي او فایل سیسټم نه بدلوي.
- د معلوماتو د خوندیتوب لپاره هېڅ لیکنیز/ترمیمي عملیات نه لري.
- د واقعي مشتریانو لپاره تر کارولو مخکې امنیتي بیاکتنه، د کارن تصدیق، TLS، backup او پراخې ازموینې ضروري دي.

## 1) Cloud API په خپل کمپیوټر کې ازمول

د Python 3.11 یا 3.12 نصب کړه. بیا:
```bash
cd cloud_api
python -m venv .venv
```
Windows:
```bat
.venv\Scripts\activate
pip install -r requirements.txt
```
د API کلید وټاکه:
```bat
set DD_API_KEY=change-this-to-a-long-random-secret
```
چلول:
```bat
uvicorn app:app --host 127.0.0.1 --port 8000
```
بیا `http://127.0.0.1:8000/docs` پرانیزه.

## 2) Render ته پورته کول
- ټول فولډر GitHub ته پورته کړه.
- په Render کې New > Blueprint وټاکه او د ریپو `render.yaml` فایل وکاروه.
- Render به `cloud_api` د Root Directory په توګه وټاکي.
- د `DD_API_KEY` لپاره قوي Secret وټاکه.
- د SQLite ډیټابېس په ځای د ازمایښتي نسخې لپاره فایل ذخیره ده. د دوامدار تجارتي استعمال لپاره Render Persistent Disk یا PostgreSQL ته مهاجرت ضروري دی.

## 3) Windows Agent چلول
په Windows کمپیوټر کې:
```bat
cd windows_agent
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
set DD_AGENT_TOKEN=change-this-to-another-long-secret
uvicorn agent:app --host 127.0.0.1 --port 8765
```
بیا `http://127.0.0.1:8765/docs` پرانیزه.
Agent یوازې په `127.0.0.1` اوري؛ دا په انټرنېټ یا LAN کې مه خپروه.

## 4) Kodular اتصال
په Kodular کې Web component وکاروه:
- Cloud API Base URL: ستا د Render URL، لکه `https://YOUR-SERVICE.onrender.com`
- Header: `X-API-Key: ستا DD_API_KEY`
- د روغتیا کتنه: `GET /api/v1/health`
- د وسیلې ثبت: `POST /api/v1/devices/register`
- دنده جوړول: `POST /api/v1/jobs`
- راپور ثبتول: `POST /api/v1/reports`

د مثال JSON د `examples/` فولډر کې دي.
**د API Key په عامه APK کې د تل لپاره پټ نه پاتې کېږي.** د عامه تجارتي اپ لپاره باید د کارن login/JWT او محدود صلاحیتونه جوړ شي؛ دا نسخه د پراختیا او شخصي ازموینې بنسټ دی.

## 5) د ازموینې حدود
- `GET /api/v1/health` باید `ok` ورکړي.
- د Windows Agent `/drives` باید د Windows د PowerShell/CIM له لارې د ډرایو معلومات راوړي.
- د ازموینې پر مهال یوازې اضافي/بې‌اهمیته USB وکاروه؛ د مهمو معلوماتو لرونکی ډیسک مه ازمویه.
