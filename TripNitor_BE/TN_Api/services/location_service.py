from django.contrib.gis.geos import GEOSGeometry, Point
from django.conf import settings
import json
import os
from typing import Dict, Optional, List, Tuple

class LocationService:
    _boundary = None

    REGION_FILES = {
        'NORTH': 'northern-cebu-province.geojson',
        'SOUTH': 'southern-cebu-province.geojson',
        'CITY': 'central-cebu-province.geojson',
        None: 'cebu-province.geojson' 
    }

    def __init__(self):
        self._boundaries = {}
        self._geojson_dir = os.path.join(settings.STATICFILES_DIRS[0], 'geojson')

    def get_region_filename(self, region):
        """Get the corresponding filename for a region."""
        return self.REGION_FILES.get(region)

    def _load_geojson(self, filename):
        """Load and process a GeoJSON file into a GEOS geometry."""
        filepath = os.path.join(self._geojson_dir, filename)
        try:
            with open(filepath) as f:
                geojson_data = json.load(f)
                
            geometries = [feature['geometry'] for feature in geojson_data['features']]
            
            multi_polygon = {
                "type": "MultiPolygon",
                "coordinates": []
            }
            
            for geom in geometries:
                if geom['type'] == 'Polygon':
                    multi_polygon['coordinates'].append(geom['coordinates'])
                elif geom['type'] == 'MultiPolygon':
                    multi_polygon['coordinates'].extend(geom['coordinates'])
            
            return GEOSGeometry(json.dumps(multi_polygon), srid=4326)
                
        except Exception as e:
            raise ValueError(f"Failed to load boundary data from {filename}: {str(e)}")

    def get_boundary(self, region):
        """Get the boundary for a specific region, loading it if necessary."""
        filename = self.get_region_filename(region)
        if not filename:
            raise ValueError(f"Invalid region specified: {region}")
        
        if filename not in self._boundaries:
            if os.path.exists(os.path.join(self._geojson_dir, filename)):
                self._boundaries[filename] = self._load_geojson(filename)
            else:
                raise ValueError(f"Boundary file not found: {filename}")
        return self._boundaries[filename]

    def is_point_within_boundary(self, lat, lng, region=None):
        """
        Check if a point is within the specified region's boundary.
        If no region is specified, checks against the default boundary (cebu-province.geojson).
        """
        boundary = self.get_boundary(region)
        point = Point(lng, lat, srid=4326)
        return boundary.contains(point)

    def list_available_regions(self):
        """List all available regions (excluding the default None case)."""
        return [region for region in self.REGION_FILES.keys() if region is not None]
    
    def are_points_within_boundary(self, coordinates, region=None):
        """Check if multiple points are within the specified region's boundary."""
        boundary = self.get_boundary(region)
        
        for lat, lng in coordinates:
            point = Point(lng, lat, srid=4326)
            if not boundary.contains(point):
                return False
        return True