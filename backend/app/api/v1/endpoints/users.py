"""
User endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.user import User, UserUpdate, UserWithChartStatus
from app.services.user_service import UserService
from app.services.birth_chart_service import BirthChartService
from app.api.v1.dependencies.auth import get_current_active_user
from app.models.user_neo4j import User as UserModel

router = APIRouter()


@router.get("/me", response_model=UserWithChartStatus)
async def get_current_user_info(
    current_user: UserModel = Depends(get_current_active_user)
):
    """
    Get current user information

    Args:
        current_user: Current authenticated user

    Returns:
        User information with birth chart status
    """
    # Check if user has birth chart
    birth_chart = BirthChartService.get_by_user_id(current_user.uid)

    return UserWithChartStatus(
        **current_user.to_dict(),
        has_birth_chart=birth_chart is not None
    )


@router.put("/me", response_model=User)
async def update_current_user(
    user_data: UserUpdate,
    current_user: UserModel = Depends(get_current_active_user)
):
    """
    Update current user

    Args:
        user_data: User update data
        current_user: Current authenticated user

    Returns:
        Updated user
    """
    # If email is being updated, check if it's already taken
    if user_data.email and user_data.email != current_user.email:
        existing_user = UserService.get_by_email(user_data.email)
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already in use"
            )

    updated_user = UserService.update(current_user, user_data)
    return updated_user


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_current_user(
    current_user: UserModel = Depends(get_current_active_user)
):
    """
    Delete current user

    Args:
        current_user: Current authenticated user
    """
    UserService.delete(current_user)
