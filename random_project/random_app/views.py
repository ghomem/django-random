import random

from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import Number


@login_required
def index(request):
    return render(request, 'index.html', locals())

@login_required
def get_number(request):

    obj_number = Number()
    obj_number.save()
    
    number = obj_number.number
    print(Number, number, obj_number.gen_date)

    return render(request, 'number.html', locals())

@login_required
def review(request):

    number_list = Number.objects.all()

    return render(request, 'review.html', locals())
