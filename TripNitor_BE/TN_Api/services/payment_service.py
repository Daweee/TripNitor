import stripe
from django.conf import settings
from rest_framework.exceptions import ValidationError
from ..models import Booking

stripe.api_key = settings.STRIPE_SECRET_KEY

class PaymentService:
    def process_booking_payment(self, amount, currency, user):
        try:
            # Create a payment intent
            payment_intent = stripe.PaymentIntent.create(
                amount=int(amount * 100), 
                currency=currency,
                automatic_payment_methods={
                    "enabled": True,
                    "allow_redirects": "never"  
                },
                metadata={
                    'user_id': user.id
                }
            )

            # For any non-error state, return a success response with the client secret
            # This includes "requires_payment_method" which is the expected initial state
            return {
                'success': True,
                'client_secret': payment_intent.client_secret,
                'payment_intent_id': payment_intent.id,
                'status': payment_intent.status
            }
                
        except stripe.error.CardError as e:
            return {
                'success': False,
                'error': str(e.error.message),
                'status': 'Payment failed: card error'
            }
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'status': 'Payment failed: system error'
            }