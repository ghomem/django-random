import random

from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.shortcuts import render, redirect
from django.conf import settings
from django.db.models import Max, Min, Sum

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


@login_required
def user_statistics(request):
    user_numbers = Number.objects.filter(author=request.user)

    total_numbers = user_numbers.count()
    max_number = user_numbers.aggregate(Max('number'))[
        'number__max'] if total_numbers > 0 else None
    min_number = user_numbers.aggregate(Min('number'))[
        'number__min'] if total_numbers > 0 else None
    sum_numbers = user_numbers.aggregate(Sum('number'))['number__sum']
    average_number = round(sum_numbers / total_numbers,
                           2) if total_numbers > 0 else None
    first_generated = user_numbers.earliest(
        'gen_date').gen_date if total_numbers > 0 else None
    last_generated = user_numbers.latest(
        'gen_date').gen_date if total_numbers > 0 else None

    context = {
        'total_numbers': total_numbers,
        'max_number': max_number,
        'min_number': min_number,
        'average_number': average_number,
        'first_generated': first_generated,
        'last_generated': last_generated,
    }

    return render(request, 'user_statistics.html', context)
