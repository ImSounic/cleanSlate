# File: backend/app.py
from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from typing import Optional
from supabase import create_client, Client

app = FastAPI(title="CleanSlate API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Then check for environment variables
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Missing Supabase environment variables")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Models
class UserLogin(BaseModel):
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    password: str

class UserRegister(BaseModel):
    full_name: str
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    password: str

class UserResponse(BaseModel):
    id: str
    email: Optional[str] = None
    phone: Optional[str] = None
    full_name: Optional[str] = None

# Routes
@app.post("/auth/register", response_model=UserResponse)
async def register(user: UserRegister):
    try:
        # Create user metadata with the full name
        user_metadata = {"full_name": user.full_name}
        
        # Determine login identifier (email or phone)
        if user.email:
            auth_response = supabase.auth.sign_up({
                "email": user.email,
                "password": user.password,
                "options": {
                    "data": user_metadata
                }
            })
        elif user.phone:
            auth_response = supabase.auth.sign_up({
                "phone": user.phone,
                "password": user.password,
                "options": {
                    "data": user_metadata
                }
            })
        else:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Either email or phone is required"
            )
            
        user_id = auth_response.user.id
        
        return {
            "id": user_id,
            "email": user.email,
            "phone": user.phone,
            "full_name": user.full_name
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@app.post("/auth/login")
async def login(user_credentials: UserLogin):
    try:
        # Determine login identifier (email or phone)
        if user_credentials.email:
            auth_response = supabase.auth.sign_in_with_password({
                "email": user_credentials.email,
                "password": user_credentials.password
            })
        elif user_credentials.phone:
            auth_response = supabase.auth.sign_in_with_password({
                "phone": user_credentials.phone,
                "password": user_credentials.password
            })
        else:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Either email or phone is required"
            )
            
        user = auth_response.user
        session = auth_response.session
        
        return {
            "user": {
                "id": user.id,
                "email": user.email,
                "phone": user.phone,
                "full_name": user.user_metadata.get("full_name")
            },
            "session": {
                "access_token": session.access_token,
                "refresh_token": session.refresh_token,
                "expires_at": session.expires_at
            }
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )

@app.post("/auth/logout")
async def logout(token: str):
    try:
        supabase.auth.sign_out(token)
        return {"message": "Logged out successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@app.get("/auth/user", response_model=UserResponse)
async def get_user():
    try:
        user = supabase.auth.get_user()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Not authenticated"
            )
        
        return {
            "id": user.id,
            "email": user.email,
            "phone": user.phone,
            "full_name": user.user_metadata.get("full_name")
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication failed"
        )

# Google OAuth routes
@app.get("/auth/google/url")
async def google_auth_url():
    try:
        # Get the authorization URL for Google OAuth
        auth_url = supabase.auth.get_sign_in_with_oauth_url({"provider": "google"})
        return {"url": auth_url}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

# Main entry point
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)