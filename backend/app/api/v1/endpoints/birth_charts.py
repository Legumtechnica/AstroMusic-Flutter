"""
Birth Chart endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.base import get_db
from app.schemas.birth_chart import BirthChart, BirthChartCreate, BirthChartData
from app.services.birth_chart_service import BirthChartService
from app.api.v1.dependencies.auth import get_current_active_user
from app.models.user import User

router = APIRouter()


@router.post("", response_model=BirthChart, status_code=status.HTTP_201_CREATED)
async def create_birth_chart(
    chart_data: BirthChartCreate,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Create or update birth chart for current user

    Args:
        chart_data: Birth chart data
        current_user: Current authenticated user
        db: Database session

    Returns:
        Created/updated birth chart
    """
    chart = await BirthChartService.create_or_update(db, current_user.id, chart_data)
    return chart


@router.get("/me", response_model=BirthChart)
async def get_my_birth_chart(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get birth chart for current user

    Args:
        current_user: Current authenticated user
        db: Database session

    Returns:
        Birth chart

    Raises:
        HTTPException: If birth chart not found
    """
    chart = await BirthChartService.get_by_user_id(db, current_user.id)

    if not chart:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Birth chart not found. Please create one first."
        )

    return chart


@router.get("/me/data", response_model=BirthChartData)
async def get_my_birth_chart_data(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get parsed birth chart data for current user

    Args:
        current_user: Current authenticated user
        db: Database session

    Returns:
        Parsed birth chart data

    Raises:
        HTTPException: If birth chart not found
    """
    chart = await BirthChartService.get_by_user_id(db, current_user.id)

    if not chart:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Birth chart not found. Please create one first."
        )

    # Parse and return structured data
    planets_data_dict = chart.planets_data or {}

    return BirthChartData(
        lagna=chart.lagna or "",
        lagna_hindi=planets_data_dict.get('lagna_hindi', ''),
        sun_sign=chart.sun_sign or "",
        sun_sign_hindi=planets_data_dict.get('sun_sign_hindi', ''),
        moon_sign=chart.moon_sign or "",
        moon_sign_hindi=planets_data_dict.get('moon_sign_hindi', ''),
        planets=planets_data_dict.get('planets', []),
        houses=[],  # Can be extended
        suggested_raag=planets_data_dict.get('suggested_raag', '')
    )


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_my_birth_chart(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Delete birth chart for current user

    Args:
        current_user: Current authenticated user
        db: Database session

    Raises:
        HTTPException: If birth chart not found
    """
    chart = await BirthChartService.get_by_user_id(db, current_user.id)

    if not chart:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Birth chart not found"
        )

    await BirthChartService.delete(db, chart)
    return None
