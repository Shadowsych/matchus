from rest_framework import serializers
from .models import default_photo, default_profile_photo, ChatRoom, Photo, User
from notebook.matchus import similarity

class UserSerializer(serializers.ModelSerializer):
    oauth = serializers.SerializerMethodField('get_oauth')

    class Meta:
        model = User
        fields = ['id', 'oauth', 'email', 'name', 'location', 'biography', 'interests', 'profile_photo']

    def get_oauth(self, obj):
        user = User.objects.get(id=obj.id)

        # return if this user is using an OAuth account
        return bool(user.google_user_id)

    class AnonymousSerializer(serializers.ModelSerializer):
        anonymous = serializers.SerializerMethodField('get_anonymous')
        name = serializers.SerializerMethodField('get_name')
        profile_photo = serializers.SerializerMethodField('get_profile_photo')

        class Meta:
            model = User
            fields = ['id', 'anonymous', 'name', 'profile_photo']

        def get_anonymous(self, obj):
            anonymous = self.context.get("anonymous")
            return bool(anonymous)

        def get_name(self, obj):
            anonymous = bool(self.context.get("anonymous"))
            return "Anonymous" if anonymous else obj.name

        def get_profile_photo(self, obj):
            anonymous = bool(self.context.get("anonymous"))
            return "/" + default_profile_photo if anonymous else "/" + obj.profile_photo.name

    class MatchSerializer(serializers.ModelSerializer):
        match = serializers.SerializerMethodField('get_match')
        photo = serializers.SerializerMethodField('get_photo')

        class Meta:
            model = User
            fields = ['id', 'match', 'name', 'biography', 'interests', 'profile_photo', 'photo']

        def get_match(self, obj):
            user = self.context.get("user")

            # receive the similarity between this user and the other user
            match = similarity(obj.interests, user.interests)

            return match

        def get_photo(self, obj):
            user = User.objects.get(id=obj.id)
            photo = Photo.objects.filter(user=user).first()
            
            # serialize this photo
            photo_serializer = PhotoSerializer(photo)

            return photo_serializer.data["photo"] if photo else "/" + default_photo

class PhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Photo
        fields = ['photo']

class ChatRoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatRoom
        fields = ['id']