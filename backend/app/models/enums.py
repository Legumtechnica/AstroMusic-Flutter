"""
Enums for model compatibility
"""
import enum


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


class PlaylistType(str, enum.Enum):
    """Playlist type enumeration"""
    DAILY = "daily"
    WEEKLY = "weekly"
    PLANET_BASED = "planet_based"
    MOOD_BASED = "mood_based"
    CUSTOM = "custom"
    TRANSIT = "transit"
