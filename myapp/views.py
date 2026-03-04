import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from django.contrib.auth import authenticate, logout, login
from django.contrib.auth.hashers import make_password
from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse
from django.shortcuts import render, redirect
from  django.contrib.auth.models import User, Group

# Create your views here.
from django.views.decorators.csrf import csrf_exempt
from sympy.integrals.meijerint_doc import category

from myapp.models import *


def login_get(request):
    return render(request,'index.html')


def login_post(request):
    username = request.POST['username']
    password = request.POST['pass']
    ll = authenticate(username = username,password = password)
    if ll is not None:
        login(request,ll)
        if ll.groups.filter(name = "Admin"):
            return redirect('/myapp/ahome_get/')
        elif ll.groups.filter(name = "Seller"):
            return redirect('/myapp/sellerhome_get/')

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
            logout(request)
            return redirect('/myapp/login_get/')

        else:
            return redirect('/myapp/password_get/')
    else:
        return redirect('/myapp/password_get/')
#
# g = User.objects.get(username='admin@gmail.com')
# g.set_password('12345')
# g.save()
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
    a = Seller.objects.filter(status="pending")
    return render(request, 'Admin/viewsellers.html',{'data':a})

def viewapprovedsellers_get(request):
    a = Seller.objects.filter(status="approved")
    return render(request, 'Admin/viewapprovedsellers.html',{'data':a})

def viewrejectedsellers_get(request):
    a = Seller.objects.filter(status="rejected")
    return render(request, 'Admin/viewrejectedsellers.html',{'data':a})

def approveseller_get(request,id):
    Seller.objects.filter(id=id).update(status="approved")
    return redirect('/myapp/viewsellers_get/')


def rejectseller_get(request,id):
    Seller.objects.filter(id=id).update(status="rejected")
    return redirect('/myapp/viewsellers_get/')


def forgotpassword_get(request):
    return render(request,'forgotpassword.html')

def forgotpassword_post(request):
    email = request.POST['email']
    return




#================Seller===========

def sellerhome_get(request):
    return render(request,'Seller/home_index.html')
def s_signup_get(request):
    return render(request,'Seller/signup.html')



def s_signup_post(request):
    name = request.POST['name']
    email = request.POST['email']
    logo = request.FILES['logo']
    from datetime import datetime
    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"
    fs = FileSystemStorage()
    fs.save(date,logo)
    path = fs.url(date)
    phone = request.POST['phone']
    license = request.POST['license']
    since = request.POST['since']
    district = request.POST['district']
    place = request.POST['place']
    pin = request.POST['pin']
    password = request.POST['password']
    confirmpassword = request.POST['confirmpassword']

    u = User.objects.create_user(username=email,password=confirmpassword)
    u.groups.add(Group.objects.get(name ='Seller'))
    u.save()

    s = Seller()
    s.name = name
    s.email = email
    s.logo = path
    s.phone = phone
    s.license = license
    s.since = since
    s.place = place
    s.district = district
    s.pin = pin
    s.status = 'pending'
    s.USER = u
    s.save()
    return redirect('/myapp/login_get/')

def sellerviewprofile_get(request):
    data = Seller.objects.get(USER=request.user)
    return render(request,'Seller/viewprofile.html',{'data':data})

def seller_editprofile_get(request,id):
    data = Seller.objects.get(id=id)
    return render(request, 'Seller/editprofile.html',{'data':data})

def seller_editprofile_post(request):
    name = request.POST['name']
    email = request.POST['email']




    phone = request.POST['phone']
    license = request.POST['license']
    since = request.POST['since']
    district = request.POST['district']
    place = request.POST['place']
    pin = request.POST['pin']
    id = request.POST['id']


    s = Seller.objects.get(id=id)

    if "logo" in request.FILES:
        logo = request.FILES['logo']
        from datetime import datetime
        date = datetime.now().strftime("%Y%m%d-%H%M%S") + ".jpg"
        fs = FileSystemStorage()
        fs.save(date, logo)
        path = fs.url(date)
        s.logo = path
        s.save()
    su=s.USER
    su.username=email
    su.save()

    s.name = name
    s.email = email
    s.phone = phone
    s.license = license
    s.since = since
    s.place = place
    s.district = district
    s.pin = pin
    s.status = 'pending'
    s.USER = su
    s.save()
    return redirect('/myapp/sellerviewprofile_get/')

def addproducts_get(request):
    return render(request,'Seller/addproducts.html')


def addproducts_post(request):
    name = request.POST['name']
    category = request.POST['category']
    photo = request.FILES['photo']
    from datetime import datetime
    date = datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"

    fs = FileSystemStorage()
    fs.save(date,photo)
    path = fs.url(date)

    description = request.POST['description']
    price = request.POST['price']

    p = Product()
    p.name = name
    p.category = category
    p.photo = path
    p.description = description
    p.price = price
    p.SELLER = Seller.objects.get(USER=request.user)
    p.save()
    return redirect('/myapp/addproducts_get/')

def viewallproducts_get(request):
    a = Product.objects.filter(SELLER__USER_id=request.user.id)
    return render(request, 'Seller/viewallproducts.html',{'data':a})


def editproducts_get(request,id):
    a=Product.objects.get(id=id)
    return render(request, 'Seller/editproducts.html',{'data':a})


def editproducts_post(request):
    name = request.POST['name']
    description = request.POST['description']
    category = request.POST['category']
    price = request.POST['price']
    id = request.POST['id']

    p = Product.objects.get(id=id)

    if "photo" in request.FILES:
        photo = request.FILES['photo']
        from datetime import datetime
        date = datetime.now().strftime("%Y%m%d-%H%M%S") + ".jpg"
        fs = FileSystemStorage()
        fs.save(date, photo)
        path = fs.url(date)
        p.photo = path
        p.save()


    p.name = name
    p.description = description
    p.price = price
    p.category = category
    p.save()
    return redirect('/myapp/viewallproducts_get/#a')

def deleteproducts_get(request,id):
    Product.objects.get(id=id).delete()
    return redirect('/myapp/viewallproducts_get/')


def addcoupon_get(request):
    # p = Product.objects.filter(SELLER__USER=request.user)
    return render(request,'Seller/addcoupon.html')

def addcoupon_post(request):
    amount = request.POST['amount']
    couponcode = request.POST['couponcode']
    validupto = request.POST['validupto']
    # product = request.POST['product']

    c = Coupon()
    c.amount = amount
    c.couponcode= couponcode
    c.validateupto= validupto
    c.status = 'Valid'
    c.SELLER = Seller.objects.get(USER=request.user)
    c.save()
    return redirect('/myapp/addcoupon_get/')

def viewcoupon_get(request):
    a = Coupon.objects.filter(SELLER__USER=request.user)
    return render(request, 'Seller/viewcoupon.html',{'data':a})


def editcoupon_get(request,id):
    p = Coupon.objects.get(id=id)
    return render(request,'Seller/editcoupon.html',{'data':p})

def editcoupon_post(request):
    id = request.POST['id']
    amount = request.POST['amount']
    couponcode = request.POST['couponcode']
    validupto = request.POST['validupto']
    # product = request.POST['product']

    c = Coupon.objects.get(id=id)
    c.amount = amount
    c.couponcode= couponcode
    c.validateupto= validupto
    # c.status = 'Valid'
    c.SELLER = Seller.objects.get(USER=request.user)
    c.save()
    return redirect('/myapp/viewcoupon_get/')

def deletecoupon_get(request,id):
    Coupon.objects.get(id=id).delete()
    return redirect('/myapp/viewcoupon_get/')

def viewordermain_get(request):
    a = Ordermain.objects.filter(SELLER__USER=request.user)
    return render(request, 'Seller/vieworders.html',{'data':a})

def viewordersub_get(request,id):
    a = Ordersub.objects.filter(ORDERMAIN_id=id)
    return render(request, 'Seller/ordersub.html',{'data':a})

def sellerviewreview_get(request):
    a = Review.objects.filter(PRODUCT__SELLER__USER=request.user)
    return render(request, 'Seller/sellerviewreview.html', {'data':a})

def sellerpassword_get(request):
    return render(request, 'Seller/password.html')


def sellerchangepassword_post(request):
    currentpassword = request.POST['currentpassword']
    NewPassword = request.POST['NewPassword']
    ConfirmPassword = request.POST['ConfirmPassword']

    user = request.user
    if user.check_password(currentpassword):
        if NewPassword == ConfirmPassword:
            user.set_password(NewPassword)
            user.save()
            logout(request)
        else:
            return redirect('/myapp/sellerpassword_get/')
    else:
        return redirect('/myapp/sellerpassword_get/')




#User
@csrf_exempt
def app_login_post(request):
    username = request.POST['Username']
    password = request.POST['Password']
    ll = authenticate(username = username,password = password)
    if ll is not None:
        login(request,ll)
        if ll.groups.filter(name = "User"):
            return JsonResponse({'status':'ok','lid':str(ll.id)})

        else:
            return JsonResponse({'status':'no'})
    else:
        return JsonResponse({'status': 'no'})

@csrf_exempt
def user_signup_post(request):
    username = request.POST['uname']
    email = request.POST['uemail']
    phone = request.POST['uphoneno']
    dob = request.POST['udob']
    place = request.POST['uplace']
    gender = request.POST['ugender']
    district = request.POST['udistrict']
    password = request.POST['upassword']
    pin = request.POST['upin']
    photo = request.FILES['photo']
    from datetime import datetime
    date = datetime.now().strftime("%Y%m%d-%H%M%S") + ".jpg"
    fs = FileSystemStorage()
    fs.save(date, photo)
    path = fs.url(date)

    b = User.objects.create_user(username=email, password=password)
    b.groups.add(Group.objects.get(name='User'))
    b.save()

    u = Users()
    u.name = username
    u.email = email
    u.phone = phone
    u.gender = gender
    u.dob = dob
    u.place = place
    u.district = district
    u.pin = pin
    u.photo = path
    u.USER = b
    u.save()

    p = Loyalty()
    p.points = 0
    p.USERS_id = u.id
    p.save()

    return JsonResponse({'status': 'ok'})

@csrf_exempt
def user_viewprofile_post(request):
    lid=request.POST['lid']
    data = Users.objects.get(USER=lid)
    return JsonResponse({'status':'ok','id':data.id,'name':data.name,
                         'email':data.email,'phone': data.phone,
                         'gender':data.gender,'dob':data.dob,
                         'place':data.place,'district':data.district,
                         'pin':data.pin,'photo':data.photo})

@csrf_exempt
def user_editprofile_post(request):
    username = request.POST['uname']
    email = request.POST['uemail']
    phone = request.POST['uphoneno']
    dob = request.POST['udob']
    place = request.POST['uplace']
    print(place,'unmjyu')
    gender = request.POST['ugender']
    district = request.POST['udistrict']
    pin = request.POST['upin']
    lid = request.POST['lid']
    u = Users.objects.get(USER=lid)


    if 'photo' in request.FILES :
        photo = request.FILES['photo']
        from datetime import datetime
        date = datetime.now().strftime("%Y%m%d-%H%M%S") + ".jpg"
        fs = FileSystemStorage()
        fs.save(date, photo)
        path = fs.url(date)
        u.photo = path
        u.save()

    u.name = username
    u.email = email
    u.phone = phone
    u.gender = gender
    u.dob = dob
    u.place = place
    u.district = district
    u.pin = pin
    u.save()

    return JsonResponse({'status': 'ok'})

@csrf_exempt
def user_viewproduct_post(request):
    data = Product.objects.all()
    l=[]
    for i in data:
        l.append({
            'id' : i.id,
            'name' : i.name,
            'photo' : i.photo,
            'description' : i.description,
            'price' : i.price,
            'sid': i.SELLER.id,
            'category': i.category

        })

    return JsonResponse({'status': 'ok','data':l})

@csrf_exempt
def user_viewseller_post(request):
    data = Seller.objects.filter(status='approved')
    l=[]
    for i in data:
        l.append({
            'id':i.id,
            'name':i.name,
            'email':i.email,
            'logo':i.logo,
            'phone':i.phone,
            'license':i.license,
            'since':i.since,
            'place':i.place,
            'district':i.district,
            'pin':i.pin,
        })

    return JsonResponse({'status': 'ok', 'data': l})



@csrf_exempt
def user_viewsellerinformation_post(request):
    id = request.POST['id']
    product = Product.objects.get(id=id).SELLER
    sellerid=product.id
    print(product,'sjdhfsgdsah')
    seller=Seller.objects.get(id=sellerid)
    return JsonResponse({
        'status':'ok',
        'id': seller.id,
        'name': seller.name,
        'email': seller.email,
        'logo': seller.logo,
        'phone': seller.phone,
        'license': seller.license,
        'since': seller.since,
        'place': seller.place,
        'district': seller.district,
        'pin': seller.pin,
    })

@csrf_exempt
def user_addproductcart_post(request):
    pid = request.POST['pid']
    lid = request.POST['lid']
    quantity = request.POST['quantity']

    c = Cart()
    c.PRODUCT=Product.objects.get(id=pid)
    c.quantity=quantity
    c.USERS=Users.objects.get(USER_id=lid)
    c.save()

    return JsonResponse({'status': 'ok'})

@csrf_exempt
def user_viewcart_post(request):
    lid = request.POST['lid']
    data = Cart.objects.filter(USERS__USER_id=lid)
    l=[]

    for i in data:
        l.append({
            'id': i.id,
            'name':i.PRODUCT.name,
            'photo':i.PRODUCT.photo,
            'description':i.PRODUCT.description,
            'price':i.PRODUCT.price,
            'quantity':i.quantity,
            'sellerid':i.PRODUCT.SELLER.id

        })
    return JsonResponse({'status': 'ok', 'data': l})

def user_deletecart_post(request):
    id = request.POST['id']
    Cart.objects.filter(id=id).delete()
    return JsonResponse({'status': 'ok'})



#
# user=User.objects.get(username="nala@gmail.com")
# user.set_password('123456')
# user.save()
@csrf_exempt
def user_changepassword_post(request):
    id = request.POST['lid']
    currentpassword = request.POST['Currentpassword']
    NewPassword = request.POST['NewPassword']
    ConfirmPassword = request.POST['ConfirmPassword']

    user = User.objects.get(id=id)
    if user.check_password(currentpassword):
        if NewPassword == ConfirmPassword:
            user.set_password(NewPassword)
            user.save()
            return JsonResponse({'status': 'ok'})
        else:
            return JsonResponse({'status': 'no'})
    else:
        return JsonResponse({'status': 'no'})




from datetime import date

@csrf_exempt
def user_place_order_post(request):
    lid = request.POST['lid']
    seller_id = request.POST['seller_id']
    total_amount = request.POST['amount']

    user = Users.objects.get(USER_id=lid)
    seller = Seller.objects.get(id=seller_id)
    print(seller)

    order = Ordermain.objects.create(
        USERS=user,
        date=date.today(),
        amount=total_amount,
        status="pending",
        SELLER=seller
    )

    cart_items = Cart.objects.filter(USERS=user)

    for c in cart_items:
        Ordersub.objects.create(
            ORDERMAIN=order,
            PRODUCT=c.PRODUCT,
            quantity=c.quantity
        )

    cart_items.delete()

    return JsonResponse({
        'status': 'ok',
        'order_id': order.id,
        'amount': total_amount
    })


@csrf_exempt
def makepayment(request):
    order_id = request.POST['vid']
    amount = request.POST['amount']
    lid = request.POST['lid']
    coupon_id = request.POST['coupon_id']

    print(coupon_id,'---')

    order = Ordermain.objects.get(id=order_id)

    Payment.objects.create(
        ORDERMAIN=order,
        date=date.today(),
        status="paid"
    )

    order.status = "paid"
    order.save()

    points = int(int(amount) * 0.10)
    user = Users.objects.get(USER_id=lid)

    p, created = Loyalty.objects.get_or_create(
        USERS=user,
        defaults={'points': 0}
    )

    p.points += points
    p.save()

    Coupon.objects.filter(id=coupon_id).update(status='used')

    return JsonResponse({'status': 'ok'})


@csrf_exempt
def user_view_orders_post(request):
    lid = request.POST['lid']
    orders = Ordermain.objects.filter(USERS__USER_id=lid)

    data = []
    for o in orders:
        data.append({
            'id': o.id,
            'date': o.date,
            'amount': o.amount,
            'status': o.status,
            'seller': o.SELLER.name
        })

    return JsonResponse({'status': 'ok', 'data': data})


@csrf_exempt
def user_viewpaymenthistory_post(request):
    id =  request.POST['lid']
    a= Payment.objects.filter(ORDERMAIN__USERS__USER_id=id)
    l=[]
    for i in a:
        l.append({
            'id':i.id,
            'date':i.date,
            'status':i.status,
            'amount':i.ORDERMAIN.amount,
        })
    return JsonResponse({'status': 'ok', 'data': l})

from datetime import datetime
def user_sendcomplaint(request):
     id =request.POST['lid']
     complaint=request.POST['complaint']
     obj=Complaint()
     obj.date=datetime.now().today()
     obj.complaint=complaint
     obj.reply= 'pending'
     obj.status='pending'
     obj.USERS=Users.objects.get(USER_id=id)
     obj.save()
     return JsonResponse({'status': 'ok'})




def user_viewcomplaint(request):
    id=request.POST['lid']
    a=Complaint.objects.filter(USERS__USER_id=id)
    l=[]
    for i in a:
        l.append({
            'date':i.date,
            'complaint':i.complaint,
            'reply':i.reply,
            'status':i.status,
        })
    return JsonResponse({'status': 'ok', 'data': l})

# views.py
import random
from django.http import JsonResponse
from django.utils import timezone

def user_receiveoffers(request):
    lid = request.POST.get('lid')
    print(lid,'lid')
    seller_id = request.POST.get('seller_id')
    print(seller_id,'seller_id')
    amount = int(request.POST.get('amount', 0))
    print(amount,'amount')


    if not lid or not seller_id:
        print(1)
        return JsonResponse({'status': 'error', 'message': 'Invalid session'})

    # Only show offer if total >= 3000
    if amount < 3000:
        print(2)
        return JsonResponse({
            'status': 'no_offer',
            'message': 'No offers available for this amount'
        })

    coupons = Coupon.objects.filter(
        SELLER_id=seller_id,
        status='Valid',
        validateupto__gte=datetime.now().date()
    )


    if not coupons.exists():
        print(3)
        return JsonResponse({
            'status': 'no_offer',
            'message': 'No valid offers for this seller'
        })

    coupon = random.choice(list(coupons))
    print(coupon,'coupon')

    return JsonResponse({
        'status': 'ok',
        'data': {
            'id': coupon.id,
            'amount': coupon.amount,
            'couponcode': coupon.couponcode,
            'validateupto': coupon.validateupto,
        }
    })


# def user_receiveoffers(request):
#     a=Coupon.objects.all()
#     l=[]
#     for i in a:
#         l.append({
#             'id':i.id,
#             'amount':i.amount,
#             'couponcode':i.couponcode,
#             'validateupto':i.validateupto,
#             'seller_name':i.SELLER.name,
#             'seller_email':i.SELLER.email,
#             'seller_phone':i.SELLER.phone,
#             'status':i.status,
#         })
#     return JsonResponse({'status': 'ok', 'data': l})

def android_forget_password_post(request):
    email = request.POST.get('email')
    if not email:
        return JsonResponse({'status': 'error', 'message': 'Email is required'})

    try:
        user = User.objects.get(username=email)
        print(email)
        import random

        # Generate new password
        new_pass = str(random.randint(1000, 9999))
        user.password = make_password(str(new_pass))
        user.save()

        # Email configuration
        smtp_server = "smtp.gmail.com"
        smtp_port = 587
        sender_email = "trainingstarted@gmail.com"
        app_password = "nlxasujxgazlbmgz"

        subject = "Your New Password"
        body = f"Your new password is: {new_pass}"
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = email
        message["Subject"] = subject
        message.attach(MIMEText(body, "plain"))

        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(sender_email, app_password)
        server.send_message(message)
        server.quit()

        return JsonResponse({'status': 'ok', 'message': 'Password sent to your email'})

    except User.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Email not found'})

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'Email send error: {str(e)}'})



from django.shortcuts import get_object_or_404

def user_updatecartquantity_post(request):

    try:
        # Parse POST data
        lid = request.POST.get('lid')
        cart_id = request.POST.get('cart_id')
        quantity_str = request.POST.get('quantity')

        if not all([lid, cart_id, quantity_str]):
            return JsonResponse({
                'status': 'error',
                'message': 'Missing required fields'
            }, status=400)

        try:
            quantity = int(quantity_str)
            if quantity < 1:
                return JsonResponse({
                    'status': 'error',
                    'message': 'Quantity must be at least 1'
                }, status=400)
        except ValueError:
            return JsonResponse({
                'status': 'error',
                'message': 'Invalid quantity value'
            }, status=400)

        # Security: verify that the cart belongs to this user
        cart = Cart.objects.get(id=cart_id, USERS__USER_id=lid)

        # Update quantity
        cart.quantity = quantity
        cart.save()

        return JsonResponse({
            'status': 'ok',
            'message': 'Quantity updated successfully',
            'new_quantity': cart.quantity
        })

    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'message': str(e)
        }, status=500)

def viewprofilehomepage(request):
    lid = request.POST['lid']
    data = Users.objects.get(USER=lid)
    data1 = Loyalty.objects.get(USERS__USER_id=lid)
    print(data1.points,"ffffffffffff")
    return JsonResponse({'status': 'ok', 'id': data.id, 'name': data.name,
                          'photo': data.photo,'points': data1.points})

def user_sendreview(request):
    rating = request.POST['rating']
    review = request.POST['review']
    lid = request.POST['lid']
    product_id = request.POST['product_id']

    a = Review()
    a.rating = rating
    a.review = review
    a.USERS = Users.objects.get(USER=lid)
    a.PRODUCT = Product.objects.get(id=product_id)
    a.date = datetime.now().today()
    a.save()
    return JsonResponse({'status': 'ok',})

def user_viewordermain(request):
    lid=request.POST['lid']
    a=Ordermain.objects.filter(USERS__USER_id=lid)
    l=[]
    for i in a:
        l.append({
            'id':i.id,
            'date':i.date,
            'amount':i.amount,
            'status':i.status,
            'seller_name':i.SELLER.name,
            # 'seller_email':i.SELLER.email,
            # 'seller_phone':i.SELLER.phone,

        })
    return JsonResponse({'status': 'ok', 'data': l})


def user_viewordersub(request):
    mid=request.POST['mid']
    a=Ordersub.objects.filter(ORDERMAIN_id=mid)
    l=[]
    for i in a:
        l.append({
            'quantity':i.quantity,
            'product_name':i.PRODUCT.name,
            'product_id':i.PRODUCT.id,

        })
    return JsonResponse({'status': 'ok', 'data': l})



def chatbot(request):

    chat=request.POST["chat"]

    print("chat ",chat)

    from transformers import pipeline

    # Load Question Answering pipeline
    qa_model = pipeline(
        "question-answering",
        model="distilbert-base-cased-distilled-squad"
    )

    # Context (knowledge base)
    context = """
    You are a smart, friendly sales assistant for crm.
    Your goal is to help customers discover premium products and guide them toward the current special offer on purchases over 3000.
    Ask a few quick questions to understand what they’re shopping for and their priorities (quality, warranty, delivery speed, budget range).
    Highlight premium benefits (quality, durability, warranty, after-sales support).
    Clearly mention the exclusive offer for orders over 3000 when relevant (discount, free gift, extended warranty, free shipping, or installment plan).
    Reduce hesitation by emphasizing value, trust, and risk-free perks.
    Gently guide users toward checkout or speaking with a human advisor for big purchases.
    """

    # User query
    question = chat

    # Get answer
    result = qa_model(question=question, context=context)

    print("Question:", question)
    print("Answer:", result["answer"])
    print("Confidence Score:", result["score"])

    return  JsonResponse(
        {
            'status':'ok',
            'data':result['answer']
        }
    )