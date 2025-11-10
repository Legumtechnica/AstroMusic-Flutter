"""
Astrology API endpoints for Flutter app
Provides birth chart, transits, and cosmic influence calculations
"""
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Dict, Any, Optional
from app.services.astrology_service import AstrologyService

router = APIRouter()


# Request/Response Models
class BirthChartRequest(BaseModel):
    """Birth chart calculation request"""
    birth_date: str = Field(..., description="ISO 8601 datetime string")
    birth_time: str = Field(..., description="Time in HH:MM format")
    birth_latitude: float = Field(..., description="Birth latitude")
    birth_longitude: float = Field(..., description="Birth longitude")
    timezone: str = Field(default="Asia/Kolkata", description="Timezone")


class PlanetData(BaseModel):
    """Planet position data"""
    name: str
    sign: Optional[str] = None
    degree: Optional[float] = None
    house: Optional[int] = None
    nakshatra: Optional[str] = None
    pada: Optional[int] = None


class BirthChartResponse(BaseModel):
    """Birth chart calculation response"""
    lagna: str
    lagna_hindi: str
    sun_sign: str
    sun_sign_hindi: str
    moon_sign: str
    moon_sign_hindi: str
    planets: List[PlanetData]
    suggested_raag: str
    ascendant_degree: float = 0.0  # Placeholder
    house_positions: List[int] = []  # Placeholder


class TransitPlanet(BaseModel):
    """Current planetary transit"""
    planet: str
    current_sign: str
    description: str
    influence: str
    intensity: float


class CosmicInfluenceRequest(BaseModel):
    """Cosmic influence request"""
    user_id: str
    birth_chart: Dict[str, Any]
    date: str


class CosmicInfluenceResponse(BaseModel):
    """Cosmic influence response"""
    user_id: str
    date: str
    energy_level: str
    dominant_moods: List[str]
    overall_description: str
    recommendations: List[str]
    active_transits: List[TransitPlanet]
    lucky_raag: Optional[str] = None
    overall_score: float


@router.post("/birth-chart", response_model=BirthChartResponse)
def calculate_birth_chart(request: BirthChartRequest):
    """
    Calculate Vedic birth chart

    This endpoint calculates the birth chart including:
    - Lagna (Ascendant)
    - Sun Sign and Moon Sign
    - Planetary positions
    - Raag recommendations

    Args:
        request: Birth chart request with date, time, and location

    Returns:
        Complete birth chart data
    """
    try:
        # Parse birth date
        birth_date = datetime.fromisoformat(request.birth_date.replace('Z', '+00:00'))

        # Calculate birth chart using AstrologyService
        chart_data = AstrologyService.calculate_birth_chart(
            birth_date=birth_date,
            birth_time=request.birth_time,
            latitude=request.birth_latitude,
            longitude=request.birth_longitude,
            timezone=request.timezone
        )

        # Convert to response format
        planets = [PlanetData(**planet) for planet in chart_data['planets']]

        # Extract ascendant degree (first planet in list should be Asc)
        ascendant_degree = 0.0
        for planet in chart_data['planets']:
            if planet['name'].lower() == 'asc' and planet['degree']:
                ascendant_degree = planet['degree']
                break

        return BirthChartResponse(
            lagna=chart_data['lagna'],
            lagna_hindi=chart_data['lagna_hindi'],
            sun_sign=chart_data['sun_sign'],
            sun_sign_hindi=chart_data['sun_sign_hindi'],
            moon_sign=chart_data['moon_sign'],
            moon_sign_hindi=chart_data['moon_sign_hindi'],
            planets=planets,
            suggested_raag=chart_data['suggested_raag'],
            ascendant_degree=ascendant_degree,
            house_positions=list(range(1, 13))  # Houses 1-12
        )

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid date format: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error calculating birth chart: {str(e)}"
        )


@router.get("/transits", response_model=List[TransitPlanet])
def get_current_transits():
    """
    Get current planetary transits

    Returns current positions of all major planets and their influences.

    Returns:
        List of current planetary transits
    """
    try:
        # Calculate transits for current time
        now = datetime.now()

        # Use current location (can be made configurable)
        # Using Delhi coordinates as default
        chart_data = AstrologyService.calculate_birth_chart(
            birth_date=now,
            birth_time=now.strftime("%H:%M"),
            latitude=28.7041,
            longitude=77.1025,
            timezone="Asia/Kolkata"
        )

        transits = []
        for planet in chart_data['planets']:
            if planet['name'].lower() not in ['asc', 'mc']:  # Exclude angles
                transits.append(TransitPlanet(
                    planet=planet['name'],
                    current_sign=planet['sign'] or "Unknown",
                    description=f"{planet['name']} in {planet['sign']}",
                    influence="Neutral",  # Can be enhanced with aspects
                    intensity=0.5
                ))

        return transits

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error calculating transits: {str(e)}"
        )


@router.post("/cosmic-influence", response_model=CosmicInfluenceResponse)
def calculate_cosmic_influence(request: CosmicInfluenceRequest):
    """
    Calculate today's cosmic influence

    Analyzes current transits against birth chart to determine:
    - Energy levels
    - Dominant moods
    - Recommendations
    - Lucky raag for the day

    Args:
        request: Cosmic influence request with user and birth chart data

    Returns:
        Cosmic influence analysis
    """
    try:
        # Get current transits
        transits = get_current_transits()

        # Extract birth chart info
        sun_sign = request.birth_chart.get('sun_sign', '')
        moon_sign = request.birth_chart.get('moon_sign', '')
        ascendant = request.birth_chart.get('ascendant', '')

        # Get raag recommendations
        raags = AstrologyService.get_recommended_raags(
            lagna=ascendant,
            moon_sign=moon_sign
        )
        lucky_raag = raags[0] if raags else None

        # Generate cosmic influence analysis
        return CosmicInfluenceResponse(
            user_id=request.user_id,
            date=request.date,
            energy_level="Moderate",  # Can be enhanced with actual transit analysis
            dominant_moods=["Calm", "Focused"],
            overall_description=f"Today's cosmic energy is favorable for introspection and creative pursuits. "
                              f"Your {ascendant} ascendant is well-supported by current planetary positions.",
            recommendations=[
                f"Listen to {lucky_raag} to harmonize with cosmic energies",
                "Practice meditation during sunset",
                "Focus on creative projects today"
            ],
            active_transits=transits,
            lucky_raag=lucky_raag,
            overall_score=75.0
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error calculating cosmic influence: {str(e)}"
        )


@router.get("/zodiac/{sign}")
def get_zodiac_info(sign: str):
    """
    Get zodiac sign information

    Args:
        sign: Zodiac sign name (e.g., "Aries", "Taurus")

    Returns:
        Zodiac sign information including Hindi name and raag
    """
    try:
        info = AstrologyService.get_zodiac_info(sign)
        return info
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Zodiac sign not found: {sign}"
        )
