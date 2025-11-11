"""
Music Neo4j models (Raag, Track, Playlist)
"""
from neomodel import (
    StructuredNode,
    StringProperty,
    IntegerProperty,
    FloatProperty,
    BooleanProperty,
    DateTimeProperty,
    JSONProperty,
    UniqueIdProperty,
    RelationshipTo,
    RelationshipFrom
)
from datetime import datetime


class Raag(StructuredNode):
    """Raag node in Neo4j"""

    uid = UniqueIdProperty()
    name = StringProperty(required=True, unique_index=True)
    name_hindi = StringProperty()
    description = StringProperty()

    # Musical Properties
    notes = JSONProperty()  # List of notes (Sa, Re, Ga, etc.)
    thaat = StringProperty()  # Parent scale
    moods = JSONProperty()  # List of moods
    time_of_day = StringProperty()  # Preferred time

    # Astrological Associations
    associated_planets = JSONProperty()  # List of planet names
    associated_signs = JSONProperty()  # List of zodiac signs
    benefits = JSONProperty()  # Healing properties

    # Relationships
    zodiac_signs = RelationshipFrom('ZodiacSign', 'SUGGESTED_RAAG')
    planets = RelationshipFrom('Planet', 'ASSOCIATED_WITH_RAAG')
    tracks = RelationshipTo('Track', 'RAAG_OF_TRACK')

    def __str__(self):
        return f"<Raag: {self.name}>"

    def to_dict(self):
        return {
            'id': self.uid,
            'name': self.name,
            'name_hindi': self.name_hindi,
            'description': self.description,
            'notes': self.notes,
            'thaat': self.thaat,
            'moods': self.moods,
            'time_of_day': self.time_of_day,
            'associated_planets': self.associated_planets,
            'associated_signs': self.associated_signs,
            'benefits': self.benefits,
        }


class Track(StructuredNode):
    """Music Track node in Neo4j"""

    uid = UniqueIdProperty()
    title = StringProperty(required=True)
    subtitle = StringProperty()

    # Track Properties
    track_type = StringProperty(required=True)  # raag_therapy, meditation, sleep, etc.
    duration_seconds = IntegerProperty(required=True)
    audio_url = StringProperty()
    cover_image_url = StringProperty()

    # Generation
    generation_status = StringProperty(default='pending')
    instruments = StringProperty()  # Comma-separated
    tempo = IntegerProperty(default=120)

    # Metadata
    description = StringProperty()
    tags = StringProperty()  # Comma-separated
    is_premium = BooleanProperty(default=False)
    play_count = IntegerProperty(default=0)
    user_rating = FloatProperty()

    # Timestamps
    created_at = DateTimeProperty(default=datetime.utcnow)
    updated_at = DateTimeProperty(default=datetime.utcnow)

    # Relationships
    user = RelationshipFrom('User', 'HAS_TRACK')
    raag = RelationshipFrom('Raag', 'RAAG_OF_TRACK')
    playlists = RelationshipFrom('Playlist', 'CONTAINS_TRACK')

    def __str__(self):
        return f"<Track: {self.title}>"

    @property
    def formatted_duration(self):
        minutes = self.duration_seconds // 60
        seconds = self.duration_seconds % 60
        return f"{minutes:02d}:{seconds:02d}"

    def to_dict(self):
        return {
            'id': self.uid,
            'title': self.title,
            'subtitle': self.subtitle,
            'track_type': self.track_type,
            'duration_seconds': self.duration_seconds,
            'audio_url': self.audio_url,
            'cover_image_url': self.cover_image_url,
            'generation_status': self.generation_status,
            'instruments': self.instruments,
            'tempo': self.tempo,
            'description': self.description,
            'tags': self.tags,
            'is_premium': self.is_premium,
            'play_count': self.play_count,
            'user_rating': self.user_rating,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }


class Playlist(StructuredNode):
    """Playlist node in Neo4j"""

    uid = UniqueIdProperty()
    title = StringProperty(required=True)
    description = StringProperty()
    playlist_type = StringProperty(required=True)  # daily, weekly, custom, etc.

    # Metadata
    cover_image_url = StringProperty()
    is_personalized = BooleanProperty(default=False)
    tags = StringProperty()  # Comma-separated
    astrological_context = JSONProperty()  # Planet positions, transits, etc.

    # Expiration (for daily/weekly playlists)
    expires_at = DateTimeProperty()

    # Timestamps
    created_at = DateTimeProperty(default=datetime.utcnow)
    updated_at = DateTimeProperty(default=datetime.utcnow)

    # Relationships
    user = RelationshipFrom('User', 'CREATED_PLAYLIST')
    tracks = RelationshipTo('Track', 'CONTAINS_TRACK')

    def __str__(self):
        return f"<Playlist: {self.title}>"

    @property
    def is_expired(self):
        if not self.expires_at:
            return False
        return datetime.utcnow() > self.expires_at

    def to_dict(self):
        return {
            'id': self.uid,
            'title': self.title,
            'description': self.description,
            'playlist_type': self.playlist_type,
            'cover_image_url': self.cover_image_url,
            'is_personalized': self.is_personalized,
            'tags': self.tags,
            'astrological_context': self.astrological_context,
            'expires_at': self.expires_at.isoformat() if self.expires_at else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
