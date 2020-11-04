from django.urls import path
from . import consumers

websocket_urlpatterns = [
    path('ws/chat-room/<int:id>', consumers.ChatRoomConsumer.as_asgi())
]