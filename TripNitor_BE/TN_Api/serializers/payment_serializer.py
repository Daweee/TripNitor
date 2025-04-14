from rest_framework import serializers

class PaymentProcessSerializer(serializers.Serializer):
    amount = serializers.FloatField()
    currency = serializers.CharField(default='php')