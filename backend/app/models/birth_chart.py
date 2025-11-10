"""
Birth Chart database model
"""
from sqlalchemy import Column, String, DateTime, Float, ForeignKey, JSON, Date, Time
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from app.db.base import Base


class BirthChart(Base):
    """Birth Chart model"""

    __tablename__ = "birth_charts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), unique=True, nullable=False)

    # Birth Details
    birth_date = Column(Date, nullable=False)
    birth_time = Column(Time, nullable=False)
    birth_latitude = Column(Float, nullable=False)
    birth_longitude = Column(Float, nullable=False)
    birth_place = Column(String, nullable=False)
    timezone = Column(String, nullable=False)

    # Calculated Data (stored as JSON)
    lagna = Column(String)  # Ascendant sign
    sun_sign = Column(String)
    moon_sign = Column(String)
    planets_data = Column(JSON)  # All planet positions
    houses_data = Column(JSON)  # House positions
    chart_data = Column(JSON)  # Full chart data from vedicastro

    # Metadata
    calculated_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="birth_chart")
