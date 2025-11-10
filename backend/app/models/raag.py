"""
Raag database model
"""
from sqlalchemy import Column, String, Text, JSON
from sqlalchemy.orm import relationship
import uuid
from app.db.base import Base


class Raag(Base):
    """Raag model for Indian classical music"""

    __tablename__ = "raags"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False, unique=True)
    name_hindi = Column(String)
    description = Column(Text)

    # Musical Properties
    notes = Column(JSON)  # List of notes (Sa, Re, Ga, etc.)
    thaat = Column(String)  # Parent scale
    moods = Column(JSON)  # List of moods
    time_of_day = Column(String)  # Preferred time

    # Astrological Associations
    associated_planets = Column(JSON)  # List of planet names
    associated_signs = Column(JSON)  # List of zodiac signs
    benefits = Column(JSON)  # Healing properties

    # Relationships
    tracks = relationship("Track", back_populates="raag")
