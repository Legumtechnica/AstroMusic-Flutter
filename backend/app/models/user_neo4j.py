"""
User Neo4j model
"""
from neomodel import (
    StructuredNode,
    StringProperty,
    BooleanProperty,
    DateTimeProperty,
    UniqueIdProperty,
    RelationshipTo,
    One
)
from datetime import datetime


class User(StructuredNode):
    """User node in Neo4j"""

    # Properties
    uid = UniqueIdProperty()
    email = StringProperty(unique_index=True, required=True)
    name = StringProperty(required=True)
    hashed_password = StringProperty(required=True)
    is_active = BooleanProperty(default=True)
    is_superuser = BooleanProperty(default=False)
    created_at = DateTimeProperty(default=datetime.utcnow)
    updated_at = DateTimeProperty(default=datetime.utcnow)

    # Relationships
    birth_chart = RelationshipTo('BirthChart', 'HAS_BIRTH_CHART', cardinality=One)
    playlists = RelationshipTo('Playlist', 'CREATED_PLAYLIST')
    tracks = RelationshipTo('Track', 'HAS_TRACK')

    def __str__(self):
        return f"<User: {self.email}>"

    @property
    def id(self):
        """Get node ID"""
        return self.uid

    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': self.uid,
            'email': self.email,
            'name': self.name,
            'is_active': self.is_active,
            'is_superuser': self.is_superuser,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
