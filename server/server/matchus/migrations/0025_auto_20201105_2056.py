# Generated by Django 3.1.2 on 2020-11-05 20:56

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('matchus', '0024_auto_20201105_1639'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='first_name',
        ),
        migrations.RemoveField(
            model_name='user',
            name='last_name',
        ),
    ]
