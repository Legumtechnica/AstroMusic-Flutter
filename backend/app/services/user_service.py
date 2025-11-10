"""
User service for CRUD operations using Neo4j
"""
from typing import Optional
from app.models.user_neo4j import User
from app.schemas.user import UserCreate, UserUpdate
from app.core.security import get_password_hash, verify_password


class UserService:
    """Service for user operations with Neo4j"""

    @staticmethod
    def get_by_id(user_id: str) -> Optional[User]:
        """Get user by ID (uid)"""
        try:
            return User.nodes.get(uid=user_id)
        except User.DoesNotExist:
            return None

    @staticmethod
    def get_by_email(email: str) -> Optional[User]:
        """Get user by email"""
        try:
            return User.nodes.get(email=email)
        except User.DoesNotExist:
            return None

    @staticmethod
    def create(user_data: UserCreate) -> User:
        """Create a new user"""
        user = User(
            email=user_data.email,
            name=user_data.name,
            hashed_password=get_password_hash(user_data.password)
        )
        user.save()
        return user

    @staticmethod
    def update(user: User, user_data: UserUpdate) -> User:
        """Update user"""
        update_data = user_data.model_dump(exclude_unset=True)

        if 'password' in update_data:
            user.hashed_password = get_password_hash(update_data.pop('password'))

        for field, value in update_data.items():
            if hasattr(user, field):
                setattr(user, field, value)

        user.save()
        return user

    @staticmethod
    def authenticate(email: str, password: str) -> Optional[User]:
        """Authenticate user with email and password"""
        user = UserService.get_by_email(email)
        if not user:
            return None
        if not verify_password(password, user.hashed_password):
            return None
        return user

    @staticmethod
    def delete(user: User) -> None:
        """Delete user"""
        user.delete()
