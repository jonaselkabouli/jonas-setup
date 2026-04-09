# Bike + Train Route Planner

Find the fastest route combining cycling and train in Denmark. Enter your origin and destination, and the app finds nearby train stations, calculates bike routes to/from stations, and shows the optimal combined journey.

Built for the Copenhagen / Charlottenlund area but works anywhere with OpenStreetMap data.

## How it works

1. Enter origin and destination (with autocomplete)
2. Finds train stations near both locations (via Overpass/OpenStreetMap)
3. Calculates bike routes to/from stations (via OSRM)
4. Shows the best combined bike + train + bike route on the map

## Tech

Single HTML file, no build step, no API keys needed:
- **Leaflet.js** — interactive map
- **OSRM** — bike routing
- **Overpass API** — train station lookup
- **Nominatim** — geocoding/autocomplete

## Run locally

Just open `index.html` in a browser.
