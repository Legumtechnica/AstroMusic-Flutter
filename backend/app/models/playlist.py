"""
Playlist database model
"""
from sqlalchemy import Column, String, Text, DateTime, ForeignKey, Boolean, JSON, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum
from app.db.base import Base


class PlaylistType(str, enum.Enum):
    """Playlist type enumeration"""
    DAILY = "daily"
    WEEKLY = "weekly"
    PLANET_BASED = "planet_based"
    MOOD_BASED = "mood_based"
    CUSTOM = "custom"
    TRANSIT = "transit"


class Playlist(Base):
    """Playlist model"""

    __tablename__ = "playlists"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    title = Column(String, nullable=False)
    description = Column(Text)

    # Associations
    user_id = Column(String, ForeignKey("users.id"), nullable=True)  # User playlists
    playlist_type = Column(SQLEnum(PlaylistType), nullable=False)

    # Content
    track_ids = Column(JSON, default=list)  # List of track IDs
    cover_image_url = Column(String)

    # Metadata
    is_personalized = Column(Boolean, default=False)
    tags = Column(String)  # Comma-separated
    astrological_context = Column(JSON)  # Planet positions, transits, etc.

    # Expiration (for daily/weekly playlists)
    expires_at = Column(DateTime, nullable=True)

    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="playlists")
