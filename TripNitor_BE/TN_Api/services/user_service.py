class UserService:
    
    @staticmethod
    def get_admin_user():
        from TN_Api.models import User
        try:
            return User.objects.get(role=User.Role.ADMIN)
        except User.DoesNotExist:
            return None
    
    @staticmethod
    def is_admin_exists():
        from TN_Api.models import User
        return User.objects.filter(role=User.Role.ADMIN).exists()
    
    @staticmethod
    def get_admin_details():
        admin = UserService.get_admin_user()
        if admin:
            return {
                'id': admin.id,
                'username': admin.username,
                'email': admin.email,
                'name': admin.name,
                'phone_number': admin.phone_number,
                'role': admin.role,
                'is_active': admin.is_active,
                'created_at': admin.created_at,
                'updated_at': admin.updated_at
            }
        return None
    
    @staticmethod
    def verify_admin_credentials(username, password):
        from TN_Api.models import User
        from django.contrib.auth import authenticate
        
        try:    
            admin = User.objects.get(username=username, role=User.Role.ADMIN)
            user = authenticate(username=username, password=password)
            if user and user.pk == admin.pk:
                return admin
        except User.DoesNotExist:
            pass
        return None