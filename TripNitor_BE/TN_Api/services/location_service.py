from django.contrib.gis.geos import GEOSGeometry, Point
from django.conf import settings
import json
import os

class LocationService:
    _boundary = None

    @property
    def boundary(self):
        if self._boundary is None:
            geojson_path = os.path.join(settings.STATICFILES_DIRS[0], 'geojson', 'cebu-province.geojson')
            try:
                with open(geojson_path) as f:
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
                    
                    self._boundary = GEOSGeometry(json.dumps(multi_polygon), srid=4326)
                    
            except Exception as e:
                raise ValueError(f"Failed to load boundary data: {str(e)}")
        return self._boundary

    def is_point_within_boundary(self, lat, lng):
        point = Point(lng, lat, srid=4326)
        result = self.boundary.contains(point)
        return result