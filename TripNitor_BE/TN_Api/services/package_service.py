from ..models.gas_model import Gas
from django.db.models import Min
from decimal import Decimal

class PackageService:
    @staticmethod
    def calculate_fare(total_distance):
        lowest_gas_price = Gas.objects.aggregate(Min('gas_price'))['gas_price__min']
        if lowest_gas_price is not None:
            price_per_km = Decimal(lowest_gas_price) / Decimal('10')
            distance_cost = price_per_km * Decimal(str(total_distance))
            return distance_cost.quantize(Decimal('0.01'))
        return Decimal('0') 
      
    