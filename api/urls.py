from django.urls import path
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def ping_view(request):
    return Response({"ping": "Pong!"})

urlpatterns = [
    path('ping/', ping_view, name='ping'),
]