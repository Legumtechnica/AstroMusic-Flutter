"""
Astrology Neo4j models (Planets, Signs, etc.)
"""
from neomodel import (
    StructuredNode,
    StringProperty,
    FloatProperty,
    BooleanProperty,
    IntegerProperty,
    JSONProperty,
    UniqueIdProperty,
    RelationshipTo,
    RelationshipFrom
)


class Planet(StructuredNode):
    """Planet node in Neo4j"""

    uid = UniqueIdProperty()
    name = StringProperty(required=True, unique_index=True)
    longitude = FloatProperty()  # Degrees (0-360)
    latitude = FloatProperty()
    house = IntegerProperty()  # House number (1-12)
    is_retrograde = BooleanProperty(default=False)
    nakshatra = StringProperty()  # Vedic lunar mansion
    nakshatra_pada = IntegerProperty()  # Pada (1-4)
    degree = FloatProperty()

    # Relationships
    in_sign = RelationshipTo('ZodiacSign', 'IN_SIGN')
    birth_charts = RelationshipFrom('BirthChart', 'HAS_PLANET')
    associated_raags = RelationshipTo('Raag', 'ASSOCIATED_WITH_RAAG')

    def __str__(self):
        return f"<Planet: {self.name}>"

    @property
    def id(self):
        return self.uid

    def to_dict(self):
        return {
            'id': self.uid,
            'name': self.name,
            'longitude': self.longitude,
            'latitude': self.latitude,
            'house': self.house,
            'is_retrograde': self.is_retrograde,
            'nakshatra': self.nakshatra,
            'nakshatra_pada': self.nakshatra_pada,
            'degree': self.degree,
        }


class ZodiacSign(StructuredNode):
    """Zodiac Sign node in Neo4j"""

    uid = UniqueIdProperty()
    name_english = StringProperty(required=True, unique_index=True)
    name_hindi = StringProperty()
    element = StringProperty()  # Fire, Earth, Air, Water
    quality = StringProperty()  # Cardinal, Fixed, Mutable
    ruling_planet = StringProperty()

    # Relationships
    birth_charts_ascendant = RelationshipFrom('BirthChart', 'HAS_ASCENDANT')
    birth_charts_sun = RelationshipFrom('BirthChart', 'SUN_IN')
    birth_charts_moon = RelationshipFrom('BirthChart', 'MOON_IN')
    planets = RelationshipFrom('Planet', 'IN_SIGN')
    suggested_raag = RelationshipTo('Raag', 'SUGGESTED_RAAG')

    def __str__(self):
        return f"<ZodiacSign: {self.name_english}>"

    @property
    def id(self):
        return self.uid

    def to_dict(self):
        return {
            'id': self.uid,
            'name_english': self.name_english,
            'name_hindi': self.name_hindi,
            'element': self.element,
            'quality': self.quality,
            'ruling_planet': self.ruling_planet,
        }


class Nakshatra(StructuredNode):
    """Nakshatra (Lunar Mansion) node"""

    uid = UniqueIdProperty()
    name = StringProperty(required=True, unique_index=True)
    name_hindi = StringProperty()
    number = IntegerProperty()  # 1-27
    ruling_deity = StringProperty()
    symbol = StringProperty()
    characteristics = JSONProperty()

    # Relationships
    ruling_planet_rel = RelationshipTo('Planet', 'RULED_BY')

    def __str__(self):
        return f"<Nakshatra: {self.name}>"

    @property
    def id(self):
        return self.uid

    def to_dict(self):
        return {
            'id': self.uid,
            'name': self.name,
            'name_hindi': self.name_hindi,
            'number': self.number,
            'ruling_deity': self.ruling_deity,
            'symbol': self.symbol,
            'characteristics': self.characteristics,
        }
