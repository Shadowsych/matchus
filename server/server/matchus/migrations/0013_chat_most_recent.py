# Generated by Django 3.1.2 on 2020-11-04 02:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchus', '0012_auto_20201104_0145'),
    ]

    operations = [
        migrations.AddField(
            model_name='chat',
            name='most_recent',
            field=models.BooleanField(default=True),
        ),
    ]
