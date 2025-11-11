# AstroMusic Backend Deployment Guide

## Quick Start with Docker Compose

### Prerequisites
- Docker and Docker Compose installed
- Port 8080 available (or configure a different port)
- Ports 7474 and 7687 available for Neo4j

### Configuration

The application now uses **port 8080** by default (changed from 8000 to avoid conflicts).

To use a different port, create or edit `.env` file:
```env
API_PORT=9000  # or any other port
```

### Running the Application

1. **Start all services (Neo4j + API):**
   ```bash
   docker-compose up -d
   ```

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

- **API**: http://localhost:8080 (or your configured port)
- **API Docs**: http://localhost:8080/docs
- **Neo4j Browser**: http://localhost:7474
  - Username: `neo4j`
  - Password: `astromusic123`

### Port Configuration

The default ports are:
- API: 8080 (configurable via `API_PORT` env variable)
- Neo4j HTTP: 7474
- Neo4j Bolt: 7687

To change the API port, either:

**Option 1: Environment variable**
```bash
API_PORT=9000 docker-compose up -d
```

**Option 2: .env file**
```env
API_PORT=9000
```

**Option 3: Modify docker-compose.yml**
```yaml
ports:
  - "9000:9000"
environment:
  - PORT=9000
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
