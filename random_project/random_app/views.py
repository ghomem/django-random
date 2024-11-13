import random

from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.shortcuts import render, redirect
from django.conf import settings

from .models import Number


def app_logout(request):

    logout(request)

    return redirect(settings.APP_NAME)


@login_required
def index(request):
    return render(request, 'index.html', locals())


@login_required
def get_number(request):

    obj_number = Number(author=request.user)
    obj_number.save()

    number = obj_number.number
    print(Number, number, obj_number.gen_date)

    return render(request, 'number.html', locals())


@login_required
def review(request):

    number_list = Number.objects.all()

    return render(request, 'review.html', locals())


@login_required
def delete_history(request):
    Number.objects.filter(author=request.user).delete()

    return redirect('review')
