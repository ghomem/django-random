from django.db import models
from django.utils import timezone

import random

def gen_random_number():
    return int(random.random()*1000000)

class Number(models.Model):

    # the default argument is a reference to a function, not a function call
    # without this we would not get unique values
    number   = models.IntegerField(default=gen_random_number)
    gen_date = models.DateTimeField(default=timezone.now)
