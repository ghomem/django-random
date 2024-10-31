from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User

import random


def gen_random_number():
    return int(random.random() * 1000000)


class Number(models.Model):

    # the default argument is a reference to a function, not a function call
    # without this we would not get unique values
    number = models.IntegerField(default=gen_random_number)
    gen_date = models.DateTimeField(default=timezone.now)
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='generated_numbers', null=True)

    # this is what is shown in the list of objects in /admin
    # unless it is overriden by the NumberAdmin class (see admin.py)
    def __str__(self):
        return f"{self.number} - {self.author.username}"
