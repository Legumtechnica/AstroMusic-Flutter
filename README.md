# AstroMusic – Where the Universe Meets Melody 🎵✨

**Monorepo** containing both Flutter mobile app and FastAPI backend with Neo4j

---

## 📁 Repository Structure

```
AstroMusic/
├── flutter/              # Flutter mobile application
│   ├── lib/              # Dart source code
│   ├── android/          # Android platform files
│   ├── ios/              # iOS platform files
│   ├── assets/           # Images, fonts, icons
│   └── pubspec.yaml      # Flutter dependencies
│
└── backend/              # FastAPI backend with Neo4j
    ├── app/              # Python source code
    │   ├── api/          # API endpoints
    │   ├── models/       # Neo4j graph models
    │   ├── services/     # Business logic
    │   └── main.py       # FastAPI app
    ├── docker-compose-neo4j.yml  # Docker setup
    └── requirements.txt  # Python dependencies
```

---

## 🚀 Quick Start

### Flutter App

```bash
cd flutter

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

**See [flutter/README.md](flutter/README.md) for detailed Flutter setup**

### Backend API

```bash
cd backend

# Start with Docker (recommended)
docker-compose -f docker-compose-neo4j.yml up -d

# Access API: http://localhost:8000
# API Docs: http://localhost:8000/docs
# Neo4j Browser: http://localhost:7474
```

**See [backend/README-NEO4J.md](backend/README-NEO4J.md) for detailed backend setup**

---

## 🌟 What is AstroMusic?

AstroMusic blends **Vedic astrology** with **AI-generated Indian classical music** to create personalized soundscapes that resonate with your cosmic energy.

### Key Features

🪷 **Personalized Raag Therapy** - Music tailored to your birth chart
🔮 **Astro-Aligned Playlists** - Daily recommendations based on planetary transits
🎼 **AI-Composed Music** - Original Indian classical compositions
🧘 **Meditation & Sleep Modes** - Cosmic rhythm-synced sessions
📅 **Live Cosmic Dashboard** - Real-time astrological insights

---

## 🏗️ Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter 2.15.1+
- **State Management**: Provider + GetIt
- **Architecture**: MVVM
- **Astrology**: Swiss Ephemeris (sweph)
- **Audio**: just_audio
- **Storage**: Hive + SharedPreferences

### Backend (FastAPI + Neo4j)
- **Framework**: FastAPI 0.104+
- **Database**: Neo4j 5.14 (Graph Database)
- **ORM**: neomodel
- **Auth**: JWT (access + refresh tokens)
- **Astrology**: vedicastro
- **Deployment**: Docker + Docker Compose

---

## 🔗 Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile UI)    │
└────────┬────────┘
         │ HTTP/REST
         ▼
┌─────────────────┐
│  FastAPI        │
│  (Backend API)  │
└────────┬────────┘
         │ Bolt Protocol
         ▼
┌─────────────────┐
│  Neo4j          │
│  (Graph DB)     │
└─────────────────┘

Graph Structure:
User ─HAS_BIRTH_CHART─> BirthChart ─HAS_PLANET─> Planet ─IN_SIGN─> ZodiacSign
                          │                                            │
                          └───────────────────────────────────> SUGGESTED_RAAG ──> Raag
                                                                                     │
User ─CREATED_PLAYLIST─> Playlist ─CONTAINS_TRACK─> Track <─RAAG_OF_TRACK─────────┘
```

---

## 🎯 API Integration

Flutter app connects to backend API:

```dart
// In Flutter (lib/provider/getit.dart)
getIt.registerLazySingleton(() => MusicGenerationService(
  apiBaseUrl: 'http://localhost:8000/api/v1',  // Or production URL
));
```

**API Endpoints:**
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/birth-charts` - Create birth chart
- `GET /api/v1/birth-charts/me` - Get my chart
- And more...

---

## 📊 Graph Database Benefits

Neo4j is perfect for astrological data:

- **Natural relationships** between planets, signs, and raags
- **10-100x faster** queries for complex astrological patterns
- **Flexible schema** - easily add yogas, aspects, nakshatras
- **Beautiful visualizations** in Neo4j Browser
- **Recommendation algorithms** for similar birth charts

---

## 🧪 Development

### Run Both Services

**Terminal 1 - Backend:**
```bash
cd backend
docker-compose -f docker-compose-neo4j.yml up
```

**Terminal 2 - Flutter:**
```bash
cd flutter
flutter run
```

### Environment Configuration

**Backend** - Create `backend/.env`:
```env
NEO4J_URI=bolt://neo4j:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=astromusic123
SECRET_KEY=your-secret-key-min-32-chars
```

**Flutter** - Update API URL in `lib/provider/getit.dart`

---

## 📖 Documentation

- **Flutter App**: [flutter/README.md](flutter/README.md)
- **Backend API**: [backend/README.md](backend/README.md)
- **Neo4j Guide**: [backend/README-NEO4J.md](backend/README-NEO4J.md)
- **API Docs**: http://localhost:8000/docs (when running)

---

## 🤝 Contributing

See [flutter/Contributing.md](flutter/Contributing.md) for coding standards and guidelines.

---

## 📄 License

See [LICENSE](flutter/LICENSE)

---

## 🗺️ Roadmap

### Phase 1 (Completed) ✅
- [x] Flutter app with Vedic astrology integration
- [x] User onboarding with birth details
- [x] Birth chart calculation
- [x] Cosmic Dashboard UI
- [x] FastAPI backend with Neo4j
- [x] JWT authentication
- [x] Graph-based data modeling

### Phase 2 (Next)
- [ ] Real-time AI music generation
- [ ] Audio player implementation
- [ ] Playlist management
- [ ] Social features
- [ ] Cloud deployment

### Phase 3 (Future)
- [ ] Live astrological consultations
- [ ] Community features
- [ ] Premium subscriptions
- [ ] Multi-language support

---

**Made with ❤️ and ✨ cosmic energy**

*AstroMusic - Because every note you hear should reflect the universe within you.*
