"""
User service for CRUD operations
"""
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from app.core.security import get_password_hash, verify_password


class UserService:
    """Service for user operations"""

    @staticmethod
    async def get_by_id(db: AsyncSession, user_id: str) -> Optional[User]:
        """Get user by ID"""
        result = await db.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()

    @staticmethod
    async def get_by_email(db: AsyncSession, email: str) -> Optional[User]:
        """Get user by email"""
        result = await db.execute(select(User).where(User.email == email))
        return result.scalar_one_or_none()

    @staticmethod
    async def create(db: AsyncSession, user_data: UserCreate) -> User:
        """Create a new user"""
        user = User(
            email=user_data.email,
            name=user_data.name,
            hashed_password=get_password_hash(user_data.password)
        )
        db.add(user)
        await db.commit()
        await db.refresh(user)
        return user

    @staticmethod
    async def update(db: AsyncSession, user: User, user_data: UserUpdate) -> User:
        """Update user"""
        update_data = user_data.model_dump(exclude_unset=True)

        if 'password' in update_data:
            update_data['hashed_password'] = get_password_hash(update_data.pop('password'))

        for field, value in update_data.items():
            setattr(user, field, value)

        await db.commit()
        await db.refresh(user)
        return user

    @staticmethod
    async def authenticate(db: AsyncSession, email: str, password: str) -> Optional[User]:
        """Authenticate user with email and password"""
        user = await UserService.get_by_email(db, email)
        if not user:
            return None
        if not verify_password(password, user.hashed_password):
            return None
        return user

    @staticmethod
    async def delete(db: AsyncSession, user: User) -> None:
        """Delete user"""
        await db.delete(user)
        await db.commit()
