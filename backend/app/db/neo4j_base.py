"""
Neo4j database setup and connection management
"""
from neomodel import config as neomodel_config, db
from app.core.config import settings

def init_neo4j():
    """Initialize Neo4j connection"""
    # Set up neomodel connection
    neomodel_config.DATABASE_URL = f"{settings.NEO4J_URI}"
    neomodel_config.DATABASE_URL = f"bolt://{settings.NEO4J_USER}:{settings.NEO4J_PASSWORD}@{settings.NEO4J_URI.replace('bolt://', '')}"

    # Test connection
    try:
        db.cypher_query("RETURN 1")
        print("✅ Neo4j connection successful!")
    except Exception as e:
        print(f"❌ Neo4j connection failed: {e}")
        raise


def close_neo4j():
    """Close Neo4j connection"""
    db.close_connection()
