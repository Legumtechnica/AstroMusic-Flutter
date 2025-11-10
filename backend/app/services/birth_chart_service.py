"""
Birth Chart service
"""
from typing import Optional
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.birth_chart import BirthChart
from app.schemas.birth_chart import BirthChartCreate
from app.services.astrology_service import AstrologyService


class BirthChartService:
    """Service for birth chart operations"""

    @staticmethod
    async def get_by_user_id(db: AsyncSession, user_id: str) -> Optional[BirthChart]:
        """Get birth chart by user ID"""
        result = await db.execute(
            select(BirthChart).where(BirthChart.user_id == user_id)
        )
        return result.scalar_one_or_none()

    @staticmethod
    async def create_or_update(
        db: AsyncSession,
        user_id: str,
        chart_data: BirthChartCreate
    ) -> BirthChart:
        """Create or update birth chart for a user"""

        # Calculate chart using astrology service
        birth_datetime = datetime.combine(chart_data.birth_date, chart_data.birth_time)
        birth_time_str = chart_data.birth_time.strftime("%H:%M")

        calculated_data = AstrologyService.calculate_birth_chart(
            birth_date=birth_datetime,
            birth_time=birth_time_str,
            latitude=chart_data.birth_latitude,
            longitude=chart_data.birth_longitude,
            timezone=chart_data.timezone
        )

        # Check if chart exists
        existing_chart = await BirthChartService.get_by_user_id(db, user_id)

        if existing_chart:
            # Update existing chart
            existing_chart.birth_date = chart_data.birth_date
            existing_chart.birth_time = chart_data.birth_time
            existing_chart.birth_latitude = chart_data.birth_latitude
            existing_chart.birth_longitude = chart_data.birth_longitude
            existing_chart.birth_place = chart_data.birth_place
            existing_chart.timezone = chart_data.timezone
            existing_chart.lagna = calculated_data['lagna']
            existing_chart.sun_sign = calculated_data['sun_sign']
            existing_chart.moon_sign = calculated_data['moon_sign']
            existing_chart.planets_data = {
                'planets': calculated_data['planets'],
                'lagna_hindi': calculated_data['lagna_hindi'],
                'sun_sign_hindi': calculated_data['sun_sign_hindi'],
                'moon_sign_hindi': calculated_data['moon_sign_hindi'],
                'suggested_raag': calculated_data['suggested_raag'],
            }
            existing_chart.chart_data = {'raw_chart': calculated_data['chart_raw']}

            chart = existing_chart
        else:
            # Create new chart
            chart = BirthChart(
                user_id=user_id,
                birth_date=chart_data.birth_date,
                birth_time=chart_data.birth_time,
                birth_latitude=chart_data.birth_latitude,
                birth_longitude=chart_data.birth_longitude,
                birth_place=chart_data.birth_place,
                timezone=chart_data.timezone,
                lagna=calculated_data['lagna'],
                sun_sign=calculated_data['sun_sign'],
                moon_sign=calculated_data['moon_sign'],
                planets_data={
                    'planets': calculated_data['planets'],
                    'lagna_hindi': calculated_data['lagna_hindi'],
                    'sun_sign_hindi': calculated_data['sun_sign_hindi'],
                    'moon_sign_hindi': calculated_data['moon_sign_hindi'],
                    'suggested_raag': calculated_data['suggested_raag'],
                },
                chart_data={'raw_chart': calculated_data['chart_raw']},
            )
            db.add(chart)

        await db.commit()
        await db.refresh(chart)
        return chart

    @staticmethod
    async def delete(db: AsyncSession, chart: BirthChart) -> None:
        """Delete birth chart"""
        await db.delete(chart)
        await db.commit()
