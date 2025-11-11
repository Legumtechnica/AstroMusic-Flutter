"""
Vedic Astrology Service using vedicastro library
"""
from datetime import datetime
from typing import Dict, Any, Optional, List


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
        try:
            # Lazy import to avoid issues if vedicastro has dependency problems
            from vedicastro.VedicAstro import VedicHoroscopeData

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
                        'name': str(obj.Object) if hasattr(obj, 'Object') else 'Unknown',
                        'sign': str(obj.Rasi) if hasattr(obj, 'Rasi') else None,
                        'degree': float(obj.Degree) if hasattr(obj, 'Degree') else None,
                        'house': int(obj.House) if hasattr(obj, 'House') else None,
                        'nakshatra': str(obj.Nakshatra) if hasattr(obj, 'Nakshatra') else None,
                        'pada': int(obj.Pada) if hasattr(obj, 'Pada') else None,
                    }

                    planets_list.append(planet_data)

                    # Extract specific signs
                    obj_name = str(obj.Object).lower() if hasattr(obj, 'Object') else ''
                    if obj_name == "asc":
                        lagna = str(obj.Rasi) if hasattr(obj, 'Rasi') else None
                    elif obj_name == "sun":
                        sun_sign = str(obj.Rasi) if hasattr(obj, 'Rasi') else None
                    elif obj_name == "moon":
                        moon_sign = str(obj.Rasi) if hasattr(obj, 'Rasi') else None

            # Get suggested raag
            suggested_raag = cls.ZODIAC_RAAGAS.get(lagna, "Yaman")

            return {
                'lagna': lagna or "Unknown",
                'lagna_hindi': cls.ZODIAC_SIGNS_HINDI.get(lagna, ''),
                'sun_sign': sun_sign or "Unknown",
                'sun_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get(sun_sign, ''),
                'moon_sign': moon_sign or "Unknown",
                'moon_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get(moon_sign, ''),
                'planets': planets_list,
                'chart_raw': str(chart),  # Raw chart data
                'suggested_raag': suggested_raag,
            }

        except ImportError as e:
            print(f"Warning: vedicastro import failed: {e}")
            # Return default values if vedicastro is not available
            return cls._get_default_chart_data()
        except Exception as e:
            print(f"Error calculating birth chart: {e}")
            return cls._get_default_chart_data()

    @classmethod
    def _get_default_chart_data(cls) -> Dict[str, Any]:
        """Return default chart data when calculation fails"""
        return {
            'lagna': "Aries",
            'lagna_hindi': cls.ZODIAC_SIGNS_HINDI.get("Aries", ''),
            'sun_sign': "Aries",
            'sun_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get("Aries", ''),
            'moon_sign': "Cancer",
            'moon_sign_hindi': cls.ZODIAC_SIGNS_HINDI.get("Cancer", ''),
            'planets': [],
            'chart_raw': '',
            'suggested_raag': 'Yaman',
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
        if lagna and lagna in cls.ZODIAC_RAAGAS:
            raags.append(cls.ZODIAC_RAAGAS[lagna])

        # Secondary recommendation from moon sign
        if moon_sign and moon_sign in cls.ZODIAC_RAAGAS and moon_sign != lagna:
            raags.append(cls.ZODIAC_RAAGAS[moon_sign])

        # Default if none found
        if not raags:
            raags.append('Yaman')

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
            'suggested_raag': cls.ZODIAC_RAAGAS.get(sign, 'Yaman')
        }
