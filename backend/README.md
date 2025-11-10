# AstroMusic Backend API 🎵✨

**Where the Universe Meets Melody** - Backend API for AstroMusic Flutter application

## 🌟 Overview

FastAPI-based backend that provides RESTful APIs for:
- **User Authentication** (JWT-based)
- **Vedic Birth Chart Calculations** (using vedicastro)
- **Raag-to-Astrology Mapping**
- **Music Track & Playlist Management**
- Ready for AI Music Generation Integration

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- OR Python 3.11+ and PostgreSQL

### Using Docker (Recommended)

```bash
# Clone and navigate
cd AstroMusic-Backend

# Copy environment file
cp .env.example .env

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f api

# API will be available at http://localhost:8000
# Docs at http://localhost:8000/docs
```

### Manual Setup

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Setup PostgreSQL
createdb astromusic_db

# Configure .env
cp .env.example .env
# Edit .env with your database credentials

# Run migrations
alembic upgrade head

# Start server
uvicorn app.main:app --reload

# API at http://localhost:8000
```

## 📁 Project Structure

```
AstroMusic-Backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── endpoints/          # API route handlers
│   │       │   ├── auth.py         # Authentication endpoints
│   │       │   ├── users.py        # User endpoints
│   │       │   └── birth_charts.py # Birth chart endpoints
│   │       ├── dependencies/       # Shared dependencies
│   │       └── api.py              # API router
│   ├── core/
│   │   ├── config.py               # App configuration
│   │   └── security.py             # JWT & password hashing
│   ├── db/
│   │   └── base.py                 # Database setup
│   ├── models/                     # SQLAlchemy models
│   │   ├── user.py
│   │   ├── birth_chart.py
│   │   ├── raag.py
│   │   ├── track.py
│   │   └── playlist.py
│   ├── schemas/                    # Pydantic schemas
│   │   ├── user.py
│   │   ├── auth.py
│   │   └── birth_chart.py
│   ├── services/                   # Business logic
│   │   ├── astrology_service.py    # Vedic astrology calculations
│   │   ├── user_service.py         # User CRUD
│   │   └── birth_chart_service.py  # Birth chart CRUD
│   └── main.py                     # FastAPI app
├── alembic/                        # Database migrations
├── tests/                          # Unit tests
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── README.md
```

## 🔌 API Endpoints

### Authentication

```
POST   /api/v1/auth/register      - Register new user
POST   /api/v1/auth/login         - Login & get tokens
POST   /api/v1/auth/refresh       - Refresh access token
```

### Users

```
GET    /api/v1/users/me           - Get current user info
PUT    /api/v1/users/me           - Update current user
DELETE /api/v1/users/me           - Delete current user
```

### Birth Charts

```
POST   /api/v1/birth-charts       - Create/update birth chart
GET    /api/v1/birth-charts/me    - Get my birth chart
GET    /api/v1/birth-charts/me/data - Get parsed chart data
DELETE /api/v1/birth-charts/me    - Delete my birth chart
```

## 🧪 API Examples

### 1. Register User

```bash
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "name": "John Doe",
    "password": "securepassword123"
  }'
```

### 2. Login

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123"
  }'
```

Response:
```json
{
  "access_token": "eyJhbGciOiJIUzI1...",
  "refresh_token": "eyJhbGciOiJIUzI1...",
  "token_type": "bearer"
}
```

### 3. Create Birth Chart

```bash
curl -X POST "http://localhost:8000/api/v1/birth-charts" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "birth_date": "1997-01-07",
    "birth_time": "07:40:00",
    "birth_latitude": 28.9845,
    "birth_longitude": 77.7064,
    "birth_place": "New Delhi, India",
    "timezone": "Asia/Kolkata"
  }'
```

Response:
```json
{
  "id": "uuid",
  "user_id": "user-uuid",
  "lagna": "Sagittarius",
  "sun_sign": "Capricorn",
  "moon_sign": "Scorpio",
  "planets_data": {
    "lagna_hindi": "धनु",
    "suggested_raag": "Basant",
    "planets": [...]
  },
  "calculated_at": "2025-11-10T14:30:00"
}
```

### 4. Get Chart Data

```bash
curl -X GET "http://localhost:8000/api/v1/birth-charts/me/data" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 🔧 Configuration

Edit `.env` file:

```env
# Database
DATABASE_URL=postgresql+asyncpg://astromusic:password@localhost/astromusic_db

# Security
SECRET_KEY=your-secret-key-min-32-characters
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS
CORS_ORIGINS=["http://localhost:3000","http://localhost:*"]
```

## 🗄️ Database Schema

### Users
- id, email, name, hashed_password
- is_active, is_superuser
- created_at, updated_at

### Birth Charts
- id, user_id (FK)
- birth_date, birth_time, location, timezone
- lagna, sun_sign, moon_sign
- planets_data (JSON), houses_data (JSON)
- calculated_at

### Raags (for future)
- id, name, name_hindi
- notes, thaat, moods
- associated_planets, associated_signs
- benefits

### Tracks (for future AI music)
- id, title, raag_id (FK), user_id (FK)
- track_type, duration, audio_url
- generation_status

### Playlists (for future)
- id, title, user_id (FK), playlist_type
- track_ids (JSON), astrological_context (JSON)

## 📊 Database Migrations

```bash
# Create new migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

## 🧪 Testing

```bash
# Run tests
pytest

# With coverage
pytest --cov=app tests/

# Watch mode
pytest-watch
```

## 🔐 Authentication Flow

1. **Register**: POST `/api/v1/auth/register` → Get user
2. **Login**: POST `/api/v1/auth/login` → Get access + refresh tokens
3. **Use Access Token**: Add `Authorization: Bearer <token>` header
4. **Token Expires**: POST `/api/v1/auth/refresh` with refresh token
5. **Get New Tokens**: Use new access token

**Token Lifetimes:**
- Access Token: 30 minutes
- Refresh Token: 7 days

## 🎼 Raag-to-Zodiac Mapping

| Lagna (Ascendant) | Suggested Raag | Mood |
|-------------------|----------------|------|
| Aries (मेष) | Bhairav | Powerful, Energetic |
| Taurus (वृषभ) | Bhairavi | Devotional, Romantic |
| Gemini (मिथुन) | Desh | Joyful, Light |
| Cancer (कर्क) | Malkauns | Calm, Deep |
| Leo (सिंह) | Khamaj | Energetic, Royal |
| Virgo (कन्या) | Yaman | Peaceful, Balanced |
| Libra (तुला) | Darbari Kanada | Powerful, Balanced |
| Scorpio (वृश्चिक) | Kafi | Passionate, Intense |
| Sagittarius (धनु) | Basant | Joyful, Expansive |
| Capricorn (मकर) | Marwa | Disciplined, Focused |
| Aquarius (कुंभ) | Shree | Innovative, Unique |
| Pisces (मीन) | Todi | Spiritual, Mystical |

## 🔮 Vedic Astrology Service

Uses `vedicastro` library for accurate calculations:

```python
from app.services.astrology_service import AstrologyService

chart_data = AstrologyService.calculate_birth_chart(
    birth_date=datetime(1997, 1, 7),
    birth_time="07:40",
    latitude=28.9845,
    longitude=77.7064,
    timezone="Asia/Kolkata"
)
```

Returns:
- Lagna (Ascendant) with Hindi name
- Sun Sign & Moon Sign
- All planet positions with nakshatras
- Suggested raag based on lagna

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | Async PostgreSQL URL | Required |
| `SECRET_KEY` | JWT secret key (32+ chars) | Required |
| `DEBUG` | Debug mode | True |
| `ENVIRONMENT` | Environment (dev/prod) | development |
| `CORS_ORIGINS` | Allowed CORS origins | ["http://localhost:*"] |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Access token lifetime | 30 |
| `REFRESH_TOKEN_EXPIRE_DAYS` | Refresh token lifetime | 7 |

## 🐳 Docker Commands

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild
docker-compose up -d --build

# Run migrations
docker-compose exec api alembic upgrade head

# Access database
docker-compose exec postgres psql -U astromusic -d astromusic_db
```

## 🚧 Future Enhancements

- [ ] AI Music Generation Integration
- [ ] Raag database seeding
- [ ] Track playback endpoints
- [ ] Playlist generation algorithms
- [ ] WebSocket for real-time updates
- [ ] S3/Cloud storage for audio files
- [ ] Redis caching
- [ ] Rate limiting
- [ ] Admin panel endpoints

## 📚 API Documentation

Once running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

## 🤝 Integration with Flutter

Update Flutter app's `getit.dart`:

```dart
getIt.registerLazySingleton(() => MusicGenerationService(
  apiBaseUrl: 'http://localhost:8000/api/v1', // Or production URL
));
```

## 📄 License

MIT License

## 🙏 Acknowledgments

- **FastAPI** - Modern Python web framework
- **vedicastro** - Vedic astrology calculations
- **SQLAlchemy** - Database ORM
- **Alembic** - Database migrations
- **PostgreSQL** - Database

---

**Made with ❤️ and ✨ cosmic energy**

*AstroMusic Backend - Powering the universe of personalized music*
