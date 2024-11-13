from django.urls import path
from django.conf import settings
from . import views

urlpatterns = [
    path("",               views.index,      name=settings.APP_NAME),
    path("get_number",     views.get_number, name="get_number"),
    path("review",         views.review,     name="review"),
    path("delete_history", views.delete_history, name="delete_history"),
]
