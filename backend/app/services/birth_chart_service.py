"""
Birth Chart service using Neo4j
"""
from typing import Optional
from datetime import datetime, time
from app.models.birth_chart_neo4j import BirthChart
from app.models.user_neo4j import User
from app.models.astrology_neo4j import ZodiacSign
from app.schemas.birth_chart import BirthChartCreate
from app.services.astrology_service import AstrologyService


class BirthChartService:
    """Service for birth chart operations with Neo4j"""

    @staticmethod
    def get_by_user(user: User) -> Optional[BirthChart]:
        """Get birth chart for a user using relationship"""
        try:
            chart = user.birth_chart.single()
            return chart
        except Exception:
            return None

    @staticmethod
    def get_by_user_id(user_id: str) -> Optional[BirthChart]:
        """Get birth chart by user ID"""
        try:
            user = User.nodes.get(uid=user_id)
            return BirthChartService.get_by_user(user)
        except User.DoesNotExist:
            return None

    @staticmethod
    def _format_birth_time(birth_time_input) -> str:
        """Convert birth time to HH:MM string format"""
        if isinstance(birth_time_input, str):
            # Already a string, ensure format
            if ':' in birth_time_input:
                return birth_time_input
            # Try to parse and reformat
            return birth_time_input
        elif isinstance(birth_time_input, time):
            # Python time object
            return birth_time_input.strftime("%H:%M")
        else:
            raise ValueError(f"Invalid birth_time format: {type(birth_time_input)}")

    @staticmethod
    def create_or_update(
        user: User,
        chart_data: BirthChartCreate
    ) -> BirthChart:
        """Create or update birth chart for a user"""

        # Format birth time as string
        birth_time_str = BirthChartService._format_birth_time(chart_data.birth_time)

        # Create datetime for calculation
        if isinstance(chart_data.birth_date, str):
            from datetime import datetime
            birth_datetime = datetime.fromisoformat(chart_data.birth_date.replace('Z', '+00:00'))
        else:
            birth_datetime = datetime.combine(chart_data.birth_date, time(0, 0))

        # Calculate chart using astrology service
        try:
            calculated_data = AstrologyService.calculate_birth_chart(
                birth_date=birth_datetime,
                birth_time=birth_time_str,
                latitude=chart_data.birth_latitude,
                longitude=chart_data.birth_longitude,
                timezone=chart_data.timezone
            )
        except Exception as e:
            # If vedicastro fails, provide default values
            print(f"Warning: Astrology calculation failed: {e}")
            calculated_data = {
                'lagna': 'Unknown',
                'lagna_hindi': '',
                'sun_sign': 'Unknown',
                'sun_sign_hindi': '',
                'moon_sign': 'Unknown',
                'moon_sign_hindi': '',
                'planets': [],
                'chart_raw': '',
                'suggested_raag': 'Yaman',
            }

        # Check if chart exists
        existing_chart = BirthChartService.get_by_user(user)

        if existing_chart:
            # Update existing chart
            existing_chart.birth_date = chart_data.birth_date
            existing_chart.birth_time = birth_time_str  # Store as string
            existing_chart.birth_latitude = chart_data.birth_latitude
            existing_chart.birth_longitude = chart_data.birth_longitude
            existing_chart.birth_place = chart_data.birth_place
            existing_chart.timezone = chart_data.timezone
            existing_chart.lagna = calculated_data.get('lagna')
            existing_chart.sun_sign = calculated_data.get('sun_sign')
            existing_chart.moon_sign = calculated_data.get('moon_sign')
            existing_chart.planets_data = {
                'planets': calculated_data.get('planets', []),
                'lagna_hindi': calculated_data.get('lagna_hindi', ''),
                'sun_sign_hindi': calculated_data.get('sun_sign_hindi', ''),
                'moon_sign_hindi': calculated_data.get('moon_sign_hindi', ''),
                'suggested_raag': calculated_data.get('suggested_raag', ''),
            }
            existing_chart.chart_data = {'raw_chart': calculated_data.get('chart_raw', '')}
            existing_chart.updated_at = datetime.utcnow()
            existing_chart.save()

            chart = existing_chart
        else:
            # Create new chart
            chart = BirthChart(
                birth_date=chart_data.birth_date,
                birth_time=birth_time_str,  # Store as string
                birth_latitude=chart_data.birth_latitude,
                birth_longitude=chart_data.birth_longitude,
                birth_place=chart_data.birth_place,
                timezone=chart_data.timezone,
                lagna=calculated_data.get('lagna'),
                sun_sign=calculated_data.get('sun_sign'),
                moon_sign=calculated_data.get('moon_sign'),
                planets_data={
                    'planets': calculated_data.get('planets', []),
                    'lagna_hindi': calculated_data.get('lagna_hindi', ''),
                    'sun_sign_hindi': calculated_data.get('sun_sign_hindi', ''),
                    'moon_sign_hindi': calculated_data.get('moon_sign_hindi', ''),
                    'suggested_raag': calculated_data.get('suggested_raag', ''),
                },
                chart_data={'raw_chart': calculated_data.get('chart_raw', '')},
            )
            chart.save()

            # Create relationship between user and birth chart
            user.birth_chart.connect(chart)

        # Connect to zodiac signs if they exist (optional enhancement)
        BirthChartService._connect_zodiac_signs(chart, calculated_data)

        return chart

    @staticmethod
    def _connect_zodiac_signs(chart: BirthChart, calculated_data: dict):
        """Connect birth chart to zodiac sign nodes"""
        try:
            if calculated_data.get('lagna'):
                ascendant_sign = ZodiacSign.nodes.get(name_english=calculated_data['lagna'])
                if not chart.ascendant_sign.is_connected(ascendant_sign):
                    chart.ascendant_sign.connect(ascendant_sign)
        except (ZodiacSign.DoesNotExist, Exception):
            pass  # Sign node doesn't exist yet

        try:
            if calculated_data.get('sun_sign'):
                sun_sign_node = ZodiacSign.nodes.get(name_english=calculated_data['sun_sign'])
                if not chart.sun_in_sign.is_connected(sun_sign_node):
                    chart.sun_in_sign.connect(sun_sign_node)
        except (ZodiacSign.DoesNotExist, Exception):
            pass

        try:
            if calculated_data.get('moon_sign'):
                moon_sign_node = ZodiacSign.nodes.get(name_english=calculated_data['moon_sign'])
                if not chart.moon_in_sign.is_connected(moon_sign_node):
                    chart.moon_in_sign.connect(moon_sign_node)
        except (ZodiacSign.DoesNotExist, Exception):
            pass

    @staticmethod
    def delete(chart: BirthChart) -> None:
        """Delete birth chart"""
        try:
            # Disconnect all relationships first
            for rel in chart.planets.all():
                chart.planets.disconnect(rel)

            # Delete the node
            chart.delete()
        except Exception as e:
            print(f"Error deleting birth chart: {e}")
            raise
