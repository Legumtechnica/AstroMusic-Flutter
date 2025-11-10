# AstroMusic – Where the Universe Meets Melody 🎵✨

![AstroMusic Banner](assets/images/splash_1000.png)

## 🌟 Overview

AstroMusic is a revolutionary Flutter application that blends the timeless wisdom of Vedic astrology with the creative power of AI-generated Indian classical music to craft melodies that resonate with your soul's unique vibration.

**Discover the sound of your stars.**

## ✨ Key Features

### 🪷 Personalized Raag Therapy
Experience original compositions in Indian raags tailored to your birth chart and current planetary transits. Each raag is carefully selected based on your astrological profile to bring balance and harmony to your life.

### 🔮 Astro-Aligned Playlists
Get daily or weekly music recommendations that balance your energy and mood:
- **Calm the Mind** - Soothing raags for stress relief
- **Ignite Creativity** - Energizing compositions for inspiration
- **Restore Focus** - Meditative tracks for concentration

### 🎼 AI-Composed Music
Each track is freshly composed by AstroMusic's intelligent engine using:
- Authentic MIDI-based classical structures
- Traditional Indian instruments (Sitar, Tabla, Bansuri, Tanpura)
- Modern sound design for contemporary appeal

### 🧘 Meditation & Sleep Mode
Enter immersive sessions that sync with your astrological rhythm:
- **Meditation Sessions** - Deep focus with binaural beats
- **Sleep Therapy** - 30-minute compositions for restful sleep
- **Breathing Exercises** - Synchronized with cosmic rhythms

### 📅 Live Cosmic Influence Dashboard
Stay in tune with your day with personalized insights:
- Current planetary positions and transits
- Energy level tracking (Very Low to Very High)
- Mood analysis based on celestial alignments
- Personalized recommendations for the day
- Lucky raag suggestions

## 🏗️ Architecture

AstroMusic follows a clean MVVM (Model-View-ViewModel) architecture with dependency injection:

```
lib/
├── models/              # Data models
│   ├── user_profile.dart
│   ├── birth_chart.dart
│   ├── planet.dart
│   ├── raag.dart
│   ├── music_track.dart
│   ├── playlist.dart
│   └── cosmic_influence.dart
├── services/            # Business logic
│   ├── storage_service.dart
│   ├── astrology/
│   │   ├── astrology_service.dart
│   │   └── raag_mapping_service.dart
│   └── music/
│       └── music_generation_service.dart
├── view/                # ViewModels
├── src/
│   ├── screens/         # UI screens
│   └── widgets/         # Reusable widgets
├── provider/            # State management
└── config/              # App configuration
```

## 🔧 Technology Stack

### Core Framework
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language (SDK >=2.15.1 <3.0.0)

### State Management & DI
- **Provider** - State management
- **GetIt** - Dependency injection

### Astrology & Astronomy
- **Swiss Ephemeris (sweph)** - Precise planetary calculations
- **Timezone** - Accurate birth time calculations
- **Geolocator** - Location services

### Audio & Music
- **just_audio** - High-performance audio playback
- **audio_session** - Audio session management

### Storage
- **Hive** - Fast, local NoSQL database
- **shared_preferences** - Simple key-value storage

### Networking
- **Dio** - HTTP client for API calls
- **http** - Backup HTTP library

### UI/UX
- **glassmorphism** - Modern frosted-glass effects
- **flutter_svg** - SVG rendering

### Utilities
- **intl** - Internationalization
- **equatable** - Value equality
- **json_annotation** - JSON serialization
- **uuid** - Unique ID generation

## 🚀 Getting Started

### Prerequisites

```bash
# Install Flutter SDK (version 2.15.1 or higher)
# https://docs.flutter.dev/get-started/install

# Verify installation
flutter doctor
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Legumtechnica/AstroMusic-Flutter.git
cd AstroMusic-Flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code (for JSON serialization)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For a specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## 📱 App Flow

### 1. Splash Screen
Beautiful animated introduction to AstroMusic with key features highlighted.

### 2. Onboarding
Step-by-step collection of birth details:
- **Step 1**: Welcome & feature overview
- **Step 2**: Name and email (optional)
- **Step 3**: Birth date and time
- **Step 4**: Birth location (with GPS support)

### 3. Birth Chart Calculation
Automatic calculation of your Vedic birth chart using Swiss Ephemeris:
- Planetary positions
- Houses and cusps
- Ascendant (Lagna)
- Moon sign (Rashi) and Sun sign

### 4. Cosmic Dashboard
Your personalized astrological hub:
- Today's cosmic influence
- Energy level meter
- Active planetary transits
- Personalized recommendations
- Daily cosmic playlist

### 5. Music Generation
AI-powered track generation:
- Raag selection based on your chart
- Mood-based compositions
- Personalized meditation tracks
- Sleep therapy sessions

### 6. Home Screen
Browse and explore:
- Quick access to Cosmic Dashboard
- Featured playlists
- Recent tracks
- Bottom navigation for all sections

## 🎨 UI/UX Design

### Color Palette
- **Primary**: `#E94560` (Pink/Red)
- **Background Gradient**: `#1A1A2E` → `#16213E` → `#0F3460`
- **Glass Effects**: White with 0.1-0.2 opacity
- **Text**: White with varying opacity

### Typography
- **SF Pro Display** - Headers and titles
- **SF Pro Text** - Body text

### Design Patterns
- **Glassmorphism** - Frosted glass containers
- **Dark Theme** - Purple/blue gradient backgrounds
- **Rounded Corners** - 15-20px radius
- **Gradient Buttons** - Pink to light pink gradient

## 🗺️ Raag-to-Astrology Mapping

AstroMusic uses traditional Vedic associations between planets, signs, and raags:

| Planet | Raag | Mood | Benefits |
|--------|------|------|----------|
| Sun (Surya) | Bhairav | Powerful, Energetic | Confidence, Leadership |
| Moon (Chandra) | Yaman | Calm, Romantic | Emotional Balance, Peace |
| Mars (Mangala) | Darbari Kanada | Powerful, Contemplative | Courage, Determination |
| Mercury (Budha) | Bihag | Joyful, Calm | Mental Clarity, Communication |
| Jupiter (Guru) | Bhupali | Devotional, Calm | Wisdom, Spiritual Growth |
| Venus (Shukra) | Kafi | Romantic, Joyful | Love, Creativity |
| Saturn (Shani) | Bageshri | Contemplative, Calm | Patience, Discipline |
| Rahu | Marwa | Contemplative, Powerful | Transformation |
| Ketu | Todi | Devotional, Contemplative | Enlightenment, Spirituality |

## 🔌 API Integration

The music generation service is designed to integrate with your AI music generation backend:

```dart
final musicService = MusicGenerationService(
  apiBaseUrl: 'https://api.astromusic.app',
);
```

### Expected API Endpoints

**POST /generate**
```json
{
  "raag_id": "yaman",
  "raag_name": "Yaman",
  "notes": ["Sa", "Re", "Ga", "Ma tivra", "Pa", "Dha", "Ni"],
  "thaat": "Kalyan",
  "moods": ["calm", "romantic"],
  "duration_seconds": 300,
  "tempo": 90,
  "birth_chart": {
    "sun_sign": "leo",
    "moon_sign": "cancer",
    "ascendant": "aries"
  },
  "track_type": "raag_therapy"
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 🔐 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to calculate your birth chart accurately</string>
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Code Style**: Follow the existing code conventions
2. **Dependencies**: Keep alphabetically sorted in `pubspec.yaml`
3. **State Management**: Use GetIt for DI, no setState
4. **Responsive Design**: Use SizeConfig utilities
5. **Component-Based**: Break down code into reusable components

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Swiss Ephemeris** - Astronomical calculations
- **Indian Classical Music Theory** - Raag associations
- **Vedic Astrology** - Planetary interpretations
- **Flutter Community** - Amazing framework and packages

## 🗺️ Roadmap

### Phase 1 (Completed) ✅
- [x] User onboarding with birth details
- [x] Vedic birth chart calculation
- [x] Raag-to-astrology mapping
- [x] Cosmic influence dashboard
- [x] AI music service integration

### Phase 2 (Next)
- [ ] Real-time music generation
- [ ] Audio player with visualizations
- [ ] Favorites and library management
- [ ] Share tracks with friends
- [ ] Social features

### Phase 3 (Future)
- [ ] Live concerts with astrologers
- [ ] Community forums
- [ ] Astrological consultations
- [ ] Premium subscription tier
- [ ] Multi-language support

---

**Made with ❤️ and ✨ cosmic energy**

*AstroMusic - Because every note you hear should reflect the universe within you.*