# Generated by Django 3.1.2 on 2020-11-04 01:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchus', '0009_auto_20201104_0031'),
    ]

    operations = [
        migrations.AlterField(
            model_name='chat',
            name='created',
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]