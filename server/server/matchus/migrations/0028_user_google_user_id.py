# Generated by Django 3.1.2 on 2020-11-10 19:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchus', '0027_auto_20201110_0229'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='google_user_id',
            field=models.CharField(default='', max_length=128),
        ),
    ]