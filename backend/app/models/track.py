"""
Music Track database model
"""
from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Boolean, Float, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum
from app.db.base import Base


class TrackType(str, enum.Enum):
    """Track type enumeration"""
    RAAG_THERAPY = "raag_therapy"
    MEDITATION = "meditation"
    SLEEP = "sleep"
    FOCUS = "focus"
    YOGA = "yoga"


class GenerationStatus(str, enum.Enum):
    """Generation status enumeration"""
    PENDING = "pending"
    GENERATING = "generating"
    COMPLETED = "completed"
    FAILED = "failed"


class Track(Base):
    """Music Track model"""

    __tablename__ = "tracks"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    title = Column(String, nullable=False)
    subtitle = Column(String)

    # Associations
    user_id = Column(String, ForeignKey("users.id"), nullable=True)  # Personalized tracks
    raag_id = Column(String, ForeignKey("raags.id"), nullable=False)

    # Track Properties
    track_type = Column(SQLEnum(TrackType), nullable=False)
    duration_seconds = Column(Integer, nullable=False)
    audio_url = Column(String)  # URL or path to audio file
    cover_image_url = Column(String)

    # Generation
    generation_status = Column(SQLEnum(GenerationStatus), default=GenerationStatus.PENDING)
    instruments = Column(String)  # Comma-separated list
    tempo = Column(Integer, default=120)

    # Metadata
    description = Column(String)
    tags = Column(String)  # Comma-separated tags
    is_premium = Column(Boolean, default=False)
    play_count = Column(Integer, default=0)
    user_rating = Column(Float)

    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="tracks")
    raag = relationship("Raag", back_populates="tracks")
