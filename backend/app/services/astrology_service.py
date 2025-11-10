"""
Vedic Astrology Service using vedicastro library
"""
from datetime import datetime
from typing import Dict, Any, Optional, List
from vedicastro.VedicAstro import VedicHoroscopeData


class AstrologyService:
    """Service for Vedic astrology calculations"""

    # English-Hindi zodiac mapping
    ZODIAC_SIGNS_HINDI = {
        "Aries": "मेष",
        "Taurus": "वृषभ",
        "Gemini": "मिथुन",
        "Cancer": "कर्क",
        "Leo": "सिंह",
        "Virgo": "कन्या",
        "Libra": "तुला",
        "Scorpio": "वृश्चिक",
        "Sagittarius": "धनु",
        "Capricorn": "मकर",
        "Aquarius": "कुंभ",
        "Pisces": "मीन"
    }

    # Zodiac to Raag mapping
    ZODIAC_RAAGAS = {
        'Aries': 'Bhairav',
        'Taurus': 'Bhairavi',
        'Gemini': 'Desh',
        'Cancer': 'Malkauns',
        'Leo': 'Khamaj',
        'Virgo': 'Yaman',
        'Libra': 'Darbari Kanada',
        'Scorpio': 'Kafi',
        'Sagittarius': 'Basant',
        'Capricorn': 'Marwa',
        'Aquarius': 'Shree',
        'Pisces': 'Todi'
    }

    @classmethod
    def calculate_birth_chart(
        cls,
        birth_date: datetime,
        birth_time: str,  # Format: "HH:MM"
        latitude: float,
        longitude: float,
        timezone: str
    ) -> Dict[str, Any]:
        """
        Calculate Vedic birth chart

        Args:
            birth_date: Date of birth
            birth_time: Time of birth in HH:MM format
            latitude: Birth latitude
            longitude: Birth longitude
            timezone: Timezone string (e.g., 'Asia/Kolkata')

        Returns:
            Dictionary containing birth chart data
        """
        # Parse birth time
        time_parts = birth_time.split(':')
        hour = int(time_parts[0])
        minute = int(time_parts[1])

        # Create horoscope data
        my_chart = VedicHoroscopeData(
            year=birth_date.year,
            month=birth_date.month,
            day=birth_date.day,
            hour=hour,
            minute=minute,
            second=0,
            latitude=latitude,
            longitude=longitude,
            tz=timezone
        )

        # Generate chart and planet data
        chart = my_chart.generate_chart()
        planets_data = my_chart.get_planets_data_from_chart(chart)

        # Extract Lagna, Sun sign, Moon sign
        lagna = None
        sun_sign = None
        moon_sign = None
        planets_list = []

        for obj in planets_data:
            if hasattr(obj, 'Object'):
                planet_data = {
                    'name': obj.Object,
                    'sign': obj.Rasi if hasattr(obj, 'Rasi') else None,
                    'degree': obj.Degree if hasattr(obj, 'Degree') else None,
                    'house': obj.House if hasattr(obj, 'House') else None,
                    'nakshatra': obj.Nakshatra if hasattr(obj, 'Nakshatra') else None,
                    'pada': obj.Pada if hasattr(obj, 'Pada') else None,
                }

                planets_list.append(planet_data)

                # Extract specific signs
                if obj.Object.lower() == "asc":
                    lagna = obj.Rasi
                elif obj.Object.lower() == "sun":
                    sun_sign = obj.Rasi
                elif obj.Object.lower() == "moon":
                    moon_sign = obj.Rasi

        # Get suggested raag
        suggested_raag = cls.ZODIAC_RAAGAS.get(lagna, "Unknown")

        return {
            'lagna': lagna,
            'lagna_hindi': cls.ZODIAC_SIGNS_HINDI.get(lagna, ''),
            'sun_sign': sun_sign,
            'sun_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get(sun_sign, ''),
            'moon_sign': moon_sign,
            'moon_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get(moon_sign, ''),
            'planets': planets_list,
            'chart_raw': str(chart),  # Raw chart data
            'suggested_raag': suggested_raag,
        }

    @classmethod
    def get_recommended_raags(cls, lagna: str, moon_sign: str) -> List[str]:
        """
        Get recommended raags based on lagna and moon sign

        Args:
            lagna: Ascendant sign
            moon_sign: Moon sign

        Returns:
            List of recommended raag names
        """
        raags = []

        # Primary recommendation from lagna
        if lagna in cls.ZODIAC_RAAGAS:
            raags.append(cls.ZODIAC_RAAGAS[lagna])

        # Secondary recommendation from moon sign
        if moon_sign in cls.ZODIAC_RAAGAS and moon_sign != lagna:
            raags.append(cls.ZODIAC_RAAGAS[moon_sign])

        return raags

    @classmethod
    def get_zodiac_info(cls, sign: str) -> Dict[str, Any]:
        """
        Get zodiac sign information

        Args:
            sign: Zodiac sign name

        Returns:
            Dictionary with sign information
        """
        return {
            'english': sign,
            'hindi': cls.ZODIAC_SIGNS_HINDI.get(sign, ''),
            'suggested_raag': cls.ZODIAC_RAAGAS.get(sign, 'Unknown')
        }
