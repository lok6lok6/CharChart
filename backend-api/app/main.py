# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()

# CORS (safe for local dev; tighten in prod)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)

class HealthResponse(BaseModel):
    status: str = "ok"

@app.get("/api/v1/health", response_model=HealthResponse)
async def health():
    return HealthResponse()

# (Your other routes go here)