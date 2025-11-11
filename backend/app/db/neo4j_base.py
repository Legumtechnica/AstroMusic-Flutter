"""
Neo4j database configuration
"""
from neomodel import config, db
from app.core.config import settings


def init_neo4j():
    """Initialize Neo4j connection"""
    # Set Neo4j connection
    config.DATABASE_URL = settings.NEO4J_URI

    # Set credentials if provided
    if settings.NEO4J_USER and settings.NEO4J_PASSWORD:
        config.DATABASE_URL = config.DATABASE_URL.replace(
            "bolt://",
            f"bolt://{settings.NEO4J_USER}:{settings.NEO4J_PASSWORD}@"
        )

    print(f"📊 Connected to Neo4j at {settings.NEO4J_URI}")


def close_neo4j():
    """Close Neo4j connection"""
    # Neomodel handles connection pooling automatically
    print("📊 Neo4j connection closed")


def get_neo4j_driver():
    """Get Neo4j driver instance"""
    return db
