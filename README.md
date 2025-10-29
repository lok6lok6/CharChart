# CharChart

SwiftUI + FastAPI app for searching Pokémon cards, viewing details, and adding to a binder.

## What works
- Health check end-to-end (`/api/v1/health`) with button → spinner → green dot.
- Card search UI with debounce (expects `GET /api/v1/cards/search?q=`).
- Card detail screen (expects `GET /api/v1/cards/{id}`).
- Add to Binder path; POST `/api/v1/binder/add` when authenticated (stub token OK).

## Layout
- `frontend-ios/` — SwiftUI app (Endpoints, APIClient, Search → Detail, Binder)
- `backend-api/` — FastAPI (`app/main.py`, `requirements.txt`)

## Quick start
**Backend**
```bash
cd backend-api
# optional: python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
curl -s http://127.0.0.1:8000/api/v1/health

# You’re currently seeing: heredoc>
# Close the heredoc by typing exactly this on its own line:
