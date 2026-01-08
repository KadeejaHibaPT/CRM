from django.contrib.auth import authenticate, logout
from django.core.files.storage import FileSystemStorage
from django.shortcuts import render, redirect


# Create your views here.
from myapp.models import Users, Complaint, Seller, Review


def login_get(request):
    return render(request,'index.html')


def login_post(request):
    username = request.POST['username']
    password = request.POST['pass']
    ll = authenticate(username = username,password = password)
    if ll is not None:
        if ll.groups.filter(name = "Admin"):
            return redirect('/myapp/ahome_get/')
        else:
            return redirect('/myapp/login_get/')
    else:
        return redirect('/myapp/login_get/')


def ahome_get(request):
    return render(request, 'Admin/home_index.html')


def password_get(request):
    return render(request, 'Admin/password.html')


def changepassword_post(request):
    currentpassword = request.POST['currentpassword']
    NewPassword = request.POST['NewPassword']
    ConfirmPassword = request.POST['ConfirmPassword']

    user = request.user
    if user.check_password(currentpassword):
        if NewPassword == ConfirmPassword:
            user.set_password(NewPassword)
            user.save()
            logout()
        else:
            return redirect('myapp/password_get/')
    else:
        return redirect(request, 'Admin/password.html')


def sendreply_get(request,id):
    a = Complaint.objects.get(id=id)
    return render(request, 'Admin/sendreply.html',{'data':a})


def sendreply_post(request):
    reply = request.POST['reply']
    id = request.POST['id']

    a = Complaint.objects.get(id=id)
    a.reply= reply
    a.status= "replied"
    a.save()
    return redirect('/myapp/viewcomplaints_get/')

def viewalluser_get(request):
    a = Users.objects.all()
    return render(request, 'Admin/viewalluser.html',{'data':a})

def viewcomplaints_get(request):
    a = Complaint.objects.all()
    return render(request, 'Admin/viewcomplaint.html',{'data':a})

def viewreview_get(request):
    a = Review.objects.all()
    return render(request, 'Admin/viewreview.html', {'data':a})

def viewsellers_get(request):
    a = Seller.objects.all()
    return render(request, 'Admin/viewsellers.html',{'data':a})


def forgotpassword_get(request):
    return render(request,'forgotpassword.html')

def forgotpassword_post(request):
    email = request.POST['email']
    return




#================Seller===========
def s_signup_get(request):
    return render(request,'Seller/signup.html')


def s_signup_post(request):
    name = request.POST['name']
    email = request.POST['email']
    logo = request.FILES['logo']
    from datetime import datetime
    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"
    fs = FileSystemStorage
    phone = request.POST['phone']
    license = request.POST['license']
    since = request.POST['since']
    district = request.POST['district']
    pin = request.POST['pin']

    return