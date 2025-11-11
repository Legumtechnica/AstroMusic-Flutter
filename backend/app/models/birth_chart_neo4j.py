"""
Birth Chart Neo4j model
"""
from neomodel import (
    StructuredNode,
    StringProperty,
    FloatProperty,
    DateTimeProperty,
    DateProperty,
    JSONProperty,
    UniqueIdProperty,
    RelationshipFrom,
    RelationshipTo,
    One
)
from datetime import datetime


class BirthChart(StructuredNode):
    """Birth Chart node in Neo4j"""

    # Properties
    uid = UniqueIdProperty()

    # Birth Details
    birth_date = DateProperty(required=True)
    birth_time = StringProperty(required=True)  # Store as "HH:MM" string
    birth_latitude = FloatProperty(required=True)
    birth_longitude = FloatProperty(required=True)
    birth_place = StringProperty(required=True)
    timezone = StringProperty(required=True)

    # Calculated Data
    lagna = StringProperty()  # Ascendant sign
    sun_sign = StringProperty()
    moon_sign = StringProperty()
    planets_data = JSONProperty()  # All planet positions
    houses_data = JSONProperty()  # House positions
    chart_data = JSONProperty()  # Full chart data

    # Metadata
    calculated_at = DateTimeProperty(default=datetime.utcnow)
    updated_at = DateTimeProperty(default=datetime.utcnow)

    # Relationships
    user = RelationshipFrom('User', 'HAS_BIRTH_CHART', cardinality=One)
    planets = RelationshipTo('Planet', 'HAS_PLANET')
    ascendant_sign = RelationshipTo('ZodiacSign', 'HAS_ASCENDANT', cardinality=One)
    sun_in_sign = RelationshipTo('ZodiacSign', 'SUN_IN', cardinality=One)
    moon_in_sign = RelationshipTo('ZodiacSign', 'MOON_IN', cardinality=One)

    def __str__(self):
        return f"<BirthChart: {self.lagna} Ascendant>"

    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': self.uid,
            'birth_date': self.birth_date.isoformat() if self.birth_date else None,
            'birth_time': self.birth_time,  # Already a string
            'birth_latitude': self.birth_latitude,
            'birth_longitude': self.birth_longitude,
            'birth_place': self.birth_place,
            'timezone': self.timezone,
            'lagna': self.lagna,
            'sun_sign': self.sun_sign,
            'moon_sign': self.moon_sign,
            'planets_data': self.planets_data,
            'houses_data': self.houses_data,
            'chart_data': self.chart_data,
            'calculated_at': self.calculated_at.isoformat() if self.calculated_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
