from django.db import models
from  django.contrib.auth.models import User

# Create your models here.

class Users(models.Model):
    name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    gender = models.CharField(max_length=200)
    dob = models.DateField(max_length=200)
    place = models.CharField(max_length=200)
    district = models.CharField(max_length=200)
    pin = models.CharField(max_length=200)
    photo = models.CharField(max_length=200)
    USER=models.OneToOneField(User,on_delete=models.CASCADE)


class Seller(models.Model):
    name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    logo = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    license = models.CharField(max_length=200)
    since = models.CharField(max_length=200)
    place = models.CharField(max_length=200)
    district = models.CharField(max_length=200)
    pin = models.CharField(max_length=200)
    status = models.CharField(max_length=200)
    USER = models.OneToOneField(User, on_delete=models.CASCADE)

class Product(models.Model):
    name = models.CharField(max_length=200)
    photo = models.CharField(max_length=200)
    description = models.CharField(max_length=200)
    price = models.CharField(max_length=200)
    SELLER = models.ForeignKey(Seller, on_delete=models.CASCADE)

class Cart(models.Model):
    PRODUCT = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.CharField(max_length=200)
    USERS = models.ForeignKey(Users, on_delete=models.CASCADE)

class Ordermain(models.Model):
    USERS = models.ForeignKey(Users, on_delete=models.CASCADE)
    date = models.DateField(max_length=200)
    amount = models.CharField(max_length=200)
    status = models.CharField(max_length=200)
    SELLER = models.ForeignKey(Seller, on_delete=models.CASCADE)

class Ordersub(models.Model):
    ORDERMAIN = models.ForeignKey(Ordermain, on_delete=models.CASCADE)
    PRODUCT = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.CharField(max_length=200)

class Payment(models.Model):
    date = models.DateField(max_length=200)
    status = models.CharField(max_length=200)
    ORDERMAIN = models.ForeignKey(Ordermain, on_delete=models.CASCADE)

class Coupon(models.Model):
    SELLER = models.ForeignKey(Seller, on_delete=models.CASCADE)
    amount = models.CharField(max_length=200)
    couponcode = models.CharField(max_length=200)
    status = models.CharField(max_length=200)
    validateupto = models.DateField(max_length=200)

class Review(models.Model):
    date = models.DateField(max_length=200)
    USERS = models.ForeignKey(Users, on_delete=models.CASCADE)
    PRODUCT = models.ForeignKey(Product, on_delete=models.CASCADE)
    review = models.CharField(max_length=200)
    rating = models.CharField(max_length=200)

class Complaint(models.Model):
    date = models.DateField(max_length=200)
    complaint = models.CharField(max_length=200)
    reply = models.CharField(max_length=200)
    status = models.CharField(max_length=200)
    USERS = models.ForeignKey(Users, on_delete=models.CASCADE)

