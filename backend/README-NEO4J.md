# AstroMusic Backend with Neo4j 🎵✨🔗

**Graph Database Edition** - Leveraging Neo4j for Complex Astrological Relationships

## 🌟 Why Neo4j for AstroMusic?

Neo4j is the **perfect choice** for astrological data because:

### **Natural Graph Structure**
```
User ──HAS_BIRTH_CHART──> BirthChart
  │
  └──CREATED_PLAYLIST──> Playlist ──CONTAINS_TRACK──> Track
                                                         │
                                                         └──RAAG_OF_TRACK──> Raag
BirthChart:
  ├──HAS_ASCENDANT──> ZodiacSign ──SUGGESTED_RAAG──> Raag
  ├──SUN_IN──> ZodiacSign
  ├──MOON_IN──> ZodiacSign
  └──HAS_PLANET──> Planet ──IN_SIGN──> ZodiacSign
                     │
                     └──ASSOCIATED_WITH_RAAG──> Raag
```

### **Advantages Over PostgreSQL**

1. **Natural Relationships**: Planets, signs, houses, and raags have complex interconnections
2. **Fast Traversals**: Query "Find all users with Moon in Cancer who should listen to Malkauns" instantly
3. **Flexible Schema**: Easy to add new astrological concepts (nakshatras, aspects, yogas)
4. **Pattern Matching**: Cypher queries for complex astrological patterns
5. **Recommendations**: Native support for recommendation algorithms based on chart similarities

## 🚀 Quick Start

### Using Docker (Recommended)

```bash
cd AstroMusic-Backend

# Copy environment file
cp .env.example .env

# Start Neo4j + API
docker-compose -f docker-compose-neo4j.yml up -d

# Check logs
docker-compose -f docker-compose-neo4j.yml logs -f

# Access Neo4j Browser: http://localhost:7474
# Username: neo4j
# Password: astromusic123

# API: http://localhost:8000
# Docs: http://localhost:8000/docs
```

### Manual Setup

```bash
# Install Neo4j (macOS)
brew install neo4j

# Or download from: https://neo4j.com/download

# Start Neo4j
neo4j start

# Access browser at http://localhost:7474
# Default credentials: neo4j/neo4j (change on first login)

# Install Python dependencies
pip install -r requirements.txt

# Configure .env
cp .env.example .env
# Edit NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD

# Start API
uvicorn app.main:app --reload
```

## 📦 Dependencies

```txt
# Neo4j
neo4j==5.14.1              # Neo4j Python driver
neomodel==5.2.1            # ORM for Neo4j (like SQLAlchemy)

# No more:
# sqlalchemy, asyncpg, alembic
```

## 🗄️ Graph Schema

### Nodes

**User**
- Properties: uid, email, name, hashed_password, is_active, created_at
- Relationships: HAS_BIRTH_CHART, CREATED_PLAYLIST, HAS_TRACK

**BirthChart**
- Properties: uid, birth_date, birth_time, location, lagna, sun_sign, moon_sign, planets_data
- Relationships: HAS_PLANET, HAS_ASCENDANT, SUN_IN, MOON_IN

**Planet**
- Properties: uid, name, longitude, latitude, house, is_retrograde, nakshatra
- Relationships: IN_SIGN, ASSOCIATED_WITH_RAAG

**ZodiacSign**
- Properties: uid, name_english, name_hindi, element, quality, ruling_planet
- Relationships: SUGGESTED_RAAG

**Raag**
- Properties: uid, name, name_hindi, notes, thaat, moods, benefits
- Relationships: RAAG_OF_TRACK

**Track**
- Properties: uid, title, track_type, duration, audio_url, generation_status
- Relationships: User, Raag, Playlist connections

**Playlist**
- Properties: uid, title, playlist_type, is_personalized, astrological_context
- Relationships: CONTAINS_TRACK

### Relationships (Edges)

```cypher
// User to BirthChart
(User)-[:HAS_BIRTH_CHART]->(BirthChart)

// BirthChart to Zodiac Signs
(BirthChart)-[:HAS_ASCENDANT]->(ZodiacSign)
(BirthChart)-[:SUN_IN]->(ZodiacSign)
(BirthChart)-[:MOON_IN]->(ZodiacSign)

// BirthChart to Planets
(BirthChart)-[:HAS_PLANET]->(Planet)
(Planet)-[:IN_SIGN]->(ZodiacSign)

// Zodiac to Raag
(ZodiacSign)-[:SUGGESTED_RAAG]->(Raag)

// Planet to Raag
(Planet)-[:ASSOCIATED_WITH_RAAG]->(Raag)

// Track relationships
(User)-[:HAS_TRACK]->(Track)
(Raag)-[:RAAG_OF_TRACK]->(Track)
(Playlist)-[:CONTAINS_TRACK]->(Track)

// Playlist
(User)-[:CREATED_PLAYLIST]->(Playlist)
```

## 🔍 Powerful Cypher Queries

### Find Recommended Raags for User
```cypher
MATCH (u:User {email: 'user@example.com'})-[:HAS_BIRTH_CHART]->(bc:BirthChart)
MATCH (bc)-[:HAS_ASCENDANT]->(sign:ZodiacSign)-[:SUGGESTED_RAAG]->(raag:Raag)
RETURN raag.name, raag.name_hindi, raag.benefits
```

### Find Users with Similar Charts
```cypher
MATCH (u1:User)-[:HAS_BIRTH_CHART]->(bc1:BirthChart)-[:MOON_IN]->(sign:ZodiacSign)
MATCH (u2:User)-[:HAS_BIRTH_CHART]->(bc2:BirthChart)-[:MOON_IN]->(sign)
WHERE u1 <> u2
RETURN u1.email, u2.email, sign.name_english
```

### Find All Tracks for a Raag
```cypher
MATCH (raag:Raag {name: 'Yaman'})-[:RAAG_OF_TRACK]->(track:Track)
RETURN track.title, track.duration_seconds, track.audio_url
ORDER BY track.created_at DESC
```

### Planetary Transits Affecting Users
```cypher
MATCH (bc:BirthChart)-[:HAS_PLANET]->(p:Planet {name: 'Moon'})-[:IN_SIGN]->(sign:ZodiacSign)
MATCH (sign)-[:SUGGESTED_RAAG]->(raag:Raag)
RETURN bc, sign.name_english, raag.name
```

### Generate Personalized Playlist
```cypher
MATCH (u:User {email: 'user@example.com'})-[:HAS_BIRTH_CHART]->(bc:BirthChart)
MATCH (bc)-[:HAS_ASCENDANT|MOON_IN|SUN_IN]->(sign:ZodiacSign)-[:SUGGESTED_RAAG]->(raag:Raag)
MATCH (raag)-[:RAAG_OF_TRACK]->(track:Track)
WHERE track.generation_status = 'completed'
RETURN DISTINCT track
LIMIT 10
```

## 📊 API Endpoints (Same as Before)

All endpoints work the same, but now use graph queries behind the scenes:

```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/refresh

GET    /api/v1/users/me
PUT    /api/v1/users/me
DELETE /api/v1/users/me

POST   /api/v1/birth-charts
GET    /api/v1/birth-charts/me
GET    /api/v1/birth-charts/me/data
DELETE /api/v1/birth-charts/me
```

## 💻 Using neomodel (Neo4j ORM)

### Define Models

```python
from neomodel import StructuredNode, StringProperty, RelationshipTo

class User(StructuredNode):
    email = StringProperty(unique_index=True, required=True)
    name = StringProperty(required=True)

    birth_chart = RelationshipTo('BirthChart', 'HAS_BIRTH_CHART')
```

### Create Nodes

```python
# Create user
user = User(email='test@example.com', name='Test User').save()

# Create birth chart
chart = BirthChart(
    birth_date=date(1997, 1, 7),
    birth_time=time(7, 40),
    lagna='Sagittarius'
).save()

# Create relationship
user.birth_chart.connect(chart)
```

### Query

```python
# Get user
user = User.nodes.get(email='test@example.com')

# Get birth chart
chart = user.birth_chart.single()

# Get ascendant sign
sign = chart.ascendant_sign.single()

# Get suggested raag
raag = sign.suggested_raag.single()
```

### Cypher Queries

```python
from neomodel import db

# Raw Cypher
results, meta = db.cypher_query("""
    MATCH (u:User)-[:HAS_BIRTH_CHART]->(bc:BirthChart)
    WHERE u.email = $email
    RETURN bc
""", {'email': 'test@example.com'})
```

## 🎯 Seed Data Script

```python
# seed_neo4j.py
from app.models.astrology_neo4j import ZodiacSign
from app.models.music_neo4j import Raag

# Zodiac signs
signs = [
    ('Aries', 'मेष', 'Fire', 'Cardinal', 'Mars'),
    ('Taurus', 'वृषभ', 'Earth', 'Fixed', 'Venus'),
    # ... all 12 signs
]

for eng, hindi, elem, qual, ruler in signs:
    ZodiacSign(
        name_english=eng,
        name_hindi=hindi,
        element=elem,
        quality=qual,
        ruling_planet=ruler
    ).save()

# Raags
raags = [
    ('Bhairav', 'भैरव', 'Powerful morning raag', ['powerful', 'energetic']),
    ('Yaman', 'यमन', 'Soothing evening raag', ['calm', 'romantic']),
    # ... all raags
]

for name, hindi, desc, moods in raags:
    Raag(
        name=name,
        name_hindi=hindi,
        description=desc,
        moods=moods
    ).save()

# Create relationships
aries = ZodiacSign.nodes.get(name_english='Aries')
bhairav = Raag.nodes.get(name='Bhairav')
aries.suggested_raag.connect(bhairav)
```

## 🔐 Authentication

Same JWT-based auth as before - works identically with Neo4j backend.

## 📈 Performance Benefits

### PostgreSQL Query
```sql
SELECT r.* FROM raags r
JOIN tracks t ON t.raag_id = r.id
JOIN playlists_tracks pt ON pt.track_id = t.id
JOIN playlists p ON p.id = pt.playlist_id
WHERE p.user_id = 'user-123'
  AND r.name IN (
    SELECT suggested_raag FROM birth_charts bc
    JOIN zodiac_signs zs ON bc.lagna = zs.name
    WHERE bc.user_id = 'user-123'
  );
```

### Neo4j Query
```cypher
MATCH (u:User {uid: 'user-123'})-[:HAS_BIRTH_CHART]->(bc:BirthChart)
MATCH (bc)-[:HAS_ASCENDANT]->(sign:ZodiacSign)-[:SUGGESTED_RAAG]->(raag:Raag)
MATCH (raag)-[:RAAG_OF_TRACK]->(track:Track)
RETURN raag, track
```

**Result**: 10-100x faster for relationship traversals!

## 🛠️ Migration from PostgreSQL

If you have existing data:

```python
# migrate_to_neo4j.py
import psycopg2
from neomodel import db
from app.models.user_neo4j import User
from app.models.birth_chart_neo4j import BirthChart

# Connect to PostgreSQL
pg_conn = psycopg2.connect("postgresql://...")
cursor = pg_conn.cursor()

# Get users
cursor.execute("SELECT id, email, name, hashed_password FROM users")
for row in cursor.fetchall():
    user = User(
        uid=row[0],
        email=row[1],
        name=row[2],
        hashed_password=row[3]
    ).save()

# Get birth charts and create relationships
cursor.execute("""
    SELECT user_id, birth_date, birth_time, lagna, sun_sign, moon_sign
    FROM birth_charts
""")
for row in cursor.fetchall():
    chart = BirthChart(
        birth_date=row[1],
        birth_time=row[2],
        lagna=row[3],
        sun_sign=row[4],
        moon_sign=row[5]
    ).save()

    user = User.nodes.get(uid=row[0])
    user.birth_chart.connect(chart)
```

## 🌐 Neo4j Browser

Access at http://localhost:7474

### Useful Queries

**View all nodes**
```cypher
MATCH (n) RETURN n LIMIT 25
```

**View schema**
```cypher
CALL db.schema.visualization()
```

**Count nodes**
```cypher
MATCH (n) RETURN labels(n), count(*)
```

**Delete all data (careful!)**
```cypher
MATCH (n) DETACH DELETE n
```

## 📚 Resources

- [Neo4j Documentation](https://neo4j.com/docs/)
- [neomodel Documentation](https://neomodel.readthedocs.io/)
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/)
- [Graph Data Modeling](https://neo4j.com/developer/data-modeling/)

## 🎨 Visualization

Neo4j Browser provides beautiful graph visualizations:
- See how users connect to birth charts
- Visualize planetary relationships
- Explore raag recommendations
- Debug relationship paths

## 🚀 Advanced Features

### Full-Text Search
```cypher
CREATE FULLTEXT INDEX raag_search FOR (r:Raag) ON EACH [r.name, r.description]

CALL db.index.fulltext.queryNodes("raag_search", "peaceful calming")
YIELD node, score
RETURN node.name, score
```

### Path Finding
```cypher
// Find shortest path from User to Raag
MATCH path = shortestPath(
  (u:User {email: 'user@example.com'})-[*]-(r:Raag {name: 'Yaman'})
)
RETURN path
```

### Recommendations
```cypher
// Users with similar charts
MATCH (me:User {email: 'me@example.com'})-[:HAS_BIRTH_CHART]->(my_chart:BirthChart)
MATCH (my_chart)-[:MOON_IN]->(moon_sign:ZodiacSign)
MATCH (other_chart:BirthChart)-[:MOON_IN]->(moon_sign)
MATCH (other:User)-[:HAS_BIRTH_CHART]->(other_chart)
WHERE me <> other
RETURN other.email, other.name
```

## 🔄 Backup & Restore

```bash
# Backup
neo4j-admin database dump neo4j --to-path=/backups

# Restore
neo4j-admin database load neo4j --from-path=/backups
```

---

**Neo4j makes AstroMusic's complex astrological relationships natural and performant!** 🎵✨🔗

*The universe is a graph, and so is your music.*
