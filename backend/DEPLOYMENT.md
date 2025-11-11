# AstroMusic Backend Deployment Guide

## Quick Start with Docker Compose

### Prerequisites
- Docker and Docker Compose installed
- Port 8001 available for API (or configure a different port)
- Either:
  - **Option A**: Existing Neo4j instance running on ports 7474/7687
  - **Option B**: Available ports for Neo4j container (defaults: 7475/7688)

### Configuration

The application now uses **port 8001** by default (changed from 8000/8080 to avoid conflicts with other services).

**Important**: The configuration defaults to using your **existing Neo4j instance** on the host machine.

### Running the Application

#### Option 1: Use Your Existing Neo4j (Recommended)

If you already have Neo4j running on ports 7474/7687:

1. **Update credentials in `.env` file:**
   ```bash
   cd backend
   # Edit .env and set your Neo4j password
   NEO4J_PASSWORD=your-actual-password
   ```

2. **Start only the API:**
   ```bash
   docker-compose up -d
   ```

The API will connect to `bolt://host.docker.internal:7687` (your host Neo4j).

#### Option 2: Start New Neo4j Container

If you want to use a separate Neo4j instance for this project:

1. **Ensure ports are available:**
   ```bash
   # Check if ports are free
   lsof -i :7475
   lsof -i :7688
   ```

2. **Start with Neo4j:**
   ```bash
   docker-compose --profile with-neo4j up -d
   ```

This will start Neo4j on ports 7475 (HTTP) and 7688 (Bolt) to avoid conflicts.

2. **View logs:**
   ```bash
   docker-compose logs -f api
   ```

3. **Stop services:**
   ```bash
   docker-compose down
   ```

4. **Rebuild after code changes:**
   ```bash
   docker-compose up -d --build
   ```

### Accessing the Services

- **API**: http://localhost:8001 (or your configured port)
- **API Docs**: http://localhost:8001/docs
- **Neo4j Browser**:
  - If using existing Neo4j: http://localhost:7474
  - If using Docker Neo4j: http://localhost:7475
  - Username: `neo4j`
  - Password: `astromusic123` (or your configured password)

### Port Configuration

**Default Configuration (uses existing Neo4j):**
- API: 8001 (configurable via `API_PORT`)
- Neo4j: Uses your existing instance on 7474/7687

**Docker Neo4j Configuration:**
- Neo4j HTTP: 7475 (configurable via `NEO4J_HTTP_PORT`)
- Neo4j Bolt: 7688 (configurable via `NEO4J_BOLT_PORT`)

**Changing Ports:**

**API Port:**
```env
# In .env file
API_PORT=9000
```

**Neo4j Connection (for existing Neo4j):**
```env
# In .env file
NEO4J_URI=bolt://host.docker.internal:7687
NEO4J_PASSWORD=your-password
```

**Neo4j Docker Ports (if using Docker Neo4j):**
```env
# In .env file
NEO4J_URI=bolt://neo4j:7687
NEO4J_HTTP_PORT=7475
NEO4J_BOLT_PORT=7688
```

### Database: Neo4j

The application uses Neo4j (graph database) instead of PostgreSQL for:
- User relationships
- Birth chart data
- Raag recommendations
- Music preferences

Neo4j credentials:
- URI: `bolt://neo4j:7687`
- Username: `neo4j`
- Password: `astromusic123`

### Production Deployment

For production deployment (e.g., api.astromusic.in):

1. **Update environment variables:**
   ```env
   DEBUG=False
   ENVIRONMENT=production
   SECRET_KEY=<generate-a-secure-32-char-key>
   ```

2. **Configure CORS:**
   ```env
   CORS_ORIGINS=["https://astromusic.in", "https://www.astromusic.in"]
   ```

3. **Use Nginx reverse proxy:**
   ```nginx
   server {
       listen 80;
       server_name api.astromusic.in;

       location / {
           proxy_pass http://localhost:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

4. **Enable SSL with Let's Encrypt:**
   ```bash
   certbot --nginx -d api.astromusic.in
   ```

### Troubleshooting

**Port already in use:**
```bash
# Change the port in .env file
API_PORT=8081

# Or find and stop the service using the port
lsof -i :8080
kill <PID>
```

**Neo4j connection issues:**
```bash
# Check Neo4j logs
docker-compose logs neo4j

# Ensure Neo4j is healthy
docker-compose ps
```

**Build failures:**
```bash
# Clean rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### Development Mode

For local development without Docker:

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run Neo4j separately:**
   ```bash
   docker run -d \
     --name neo4j \
     -p 7474:7474 -p 7687:7687 \
     -e NEO4J_AUTH=neo4j/astromusic123 \
     neo4j:5.14-community
   ```

3. **Run the API:**
   ```bash
   uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
   ```

### API Endpoints

Key endpoints:
- `POST /api/v1/astrology/birth-chart` - Calculate birth chart
- `GET /api/v1/astrology/transits` - Current planetary transits
- `POST /api/v1/astrology/cosmic-influence` - Daily cosmic influence
- `GET /api/v1/astrology/zodiac/{sign}` - Zodiac information

Full documentation: http://localhost:8080/docs
