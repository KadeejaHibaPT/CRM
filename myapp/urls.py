"""
URL configuration for crm project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

from myapp import views

urlpatterns = [
    path('login_get/', views.login_get),
    path('login_post/', views.login_post),
    path('password_get/', views.password_get),
    path('changepassword_post/', views.changepassword_post),
    path('sendreply_get/', views.sendreply_get),
    path('viewalluser_get/', views.viewalluser_get),
    path('viewcomplaints_get/', views.viewcomplaints_get),
    path('viewreview_get/', views.viewreview_get),
    path('viewsellers_get/', views.viewsellers_get),
    path('ahome_get/', views.ahome_get),
    path('forgotpassword_get/', views.forgotpassword_get),
    path('forgotpassword_post/', views.forgotpassword_post),




    #==========Seller============
    path('s_signup_get/', views.s_signup_get),


]
