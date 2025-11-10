"""
Birth Chart schemas
"""
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
from datetime import datetime, date, time


class BirthChartCreate(BaseModel):
    """Schema for creating/calculating a birth chart"""
    birth_date: date
    birth_time: time
    birth_latitude: float = Field(..., ge=-90, le=90)
    birth_longitude: float = Field(..., ge=-180, le=180)
    birth_place: str = Field(..., min_length=1)
    timezone: str = Field(..., min_length=1)


class PlanetData(BaseModel):
    """Individual planet data"""
    name: str
    sign: str
    degree: float
    house: int
    is_retrograde: bool = False


class BirthChartData(BaseModel):
    """Calculated birth chart data"""
    lagna: str
    lagna_hindi: str
    sun_sign: str
    sun_sign_hindi: str
    moon_sign: str
    moon_sign_hindi: str
    planets: List[Dict[str, Any]]
    houses: List[Dict[str, Any]]
    suggested_raag: str


class BirthChart(BaseModel):
    """Birth chart response schema"""
    id: str
    user_id: str
    birth_date: date
    birth_time: time
    birth_latitude: float
    birth_longitude: float
    birth_place: str
    timezone: str
    lagna: Optional[str]
    sun_sign: Optional[str]
    moon_sign: Optional[str]
    planets_data: Optional[Dict[str, Any]]
    houses_data: Optional[Dict[str, Any]]
    chart_data: Optional[Dict[str, Any]]
    calculated_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class BirthChartWithData(BirthChart):
    """Birth chart with parsed data"""
    parsed_data: Optional[BirthChartData] = None
