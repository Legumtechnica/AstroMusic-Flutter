"""
Birth Chart service using Neo4j
"""
from typing import Optional
from datetime import datetime
from app.models.birth_chart_neo4j import BirthChart
from app.models.user_neo4j import User
from app.models.astrology_neo4j import ZodiacSign, Planet
from app.schemas.birth_chart import BirthChartCreate
from app.services.astrology_service import AstrologyService


class BirthChartService:
    """Service for birth chart operations with Neo4j"""

    @staticmethod
    def get_by_user(user: User) -> Optional[BirthChart]:
        """Get birth chart for a user using relationship"""
        chart = user.birth_chart.single()
        return chart

    @staticmethod
    def create_or_update(
        user: User,
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
        existing_chart = BirthChartService.get_by_user(user)

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
            existing_chart.updated_at = datetime.utcnow()
            existing_chart.save()

            chart = existing_chart
        else:
            # Create new chart
            chart = BirthChart(
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
            chart.save()

            # Create relationship between user and birth chart
            user.birth_chart.connect(chart)

        # Connect to zodiac signs if they exist
        # This is optional enhancement - create relationships to ZodiacSign nodes
        try:
            ascendant_sign = ZodiacSign.nodes.get(name_english=calculated_data['lagna'])
            if not chart.ascendant_sign.is_connected(ascendant_sign):
                chart.ascendant_sign.connect(ascendant_sign)
        except ZodiacSign.DoesNotExist:
            pass  # Sign node doesn't exist yet

        try:
            sun_sign_node = ZodiacSign.nodes.get(name_english=calculated_data['sun_sign'])
            if not chart.sun_in_sign.is_connected(sun_sign_node):
                chart.sun_in_sign.connect(sun_sign_node)
        except ZodiacSign.DoesNotExist:
            pass

        try:
            moon_sign_node = ZodiacSign.nodes.get(name_english=calculated_data['moon_sign'])
            if not chart.moon_in_sign.is_connected(moon_sign_node):
                chart.moon_in_sign.connect(moon_sign_node)
        except ZodiacSign.DoesNotExist:
            pass

        return chart

    @staticmethod
    def delete(chart: BirthChart) -> None:
        """Delete birth chart"""
        # Disconnect all relationships first
        for rel in chart.planets.all():
            chart.planets.disconnect(rel)

        # Delete the node
        chart.delete()
