from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _
from django.db import models
from .managers import UserManager

class User(AbstractUser):
    """
    Extends Django's base User model to implement custom fields and authentication.
    """

    # sets the email (instead of the username) as the unique identifier for the user model
    username = None
    email = models.EmailField(_('email address'), unique=True)
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    name = models.CharField(default="No Name", max_length=128)
    location = models.CharField(default="", max_length=128)
    interests = models.JSONField(default=list)
    profile_photo = models.ImageField(upload_to='media')

    # helper methods for the User class
    objects = UserManager()

class Photo(models.Model):
    photo = models.ImageField(upload_to='media')
    user = models.ForeignKey(User, on_delete=models.CASCADE)