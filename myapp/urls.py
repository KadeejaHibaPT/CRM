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
    path('sendreply_get/<id>', views.sendreply_get),
    path('sendreply_post/', views.sendreply_post),
    path('viewalluser_get/', views.viewalluser_get),
    path('viewcomplaints_get/', views.viewcomplaints_get),
    path('viewreview_get/', views.viewreview_get),
    path('viewsellers_get/', views.viewsellers_get),

    path('viewapprovedsellers_get/', views.viewapprovedsellers_get),
    path('viewrejectedsellers_get/', views.viewrejectedsellers_get),

    path('ahome_get/', views.ahome_get),
    path('forgotpassword_get/', views.forgotpassword_get),
    path('forgotpassword_post/', views.forgotpassword_post),
    path('approveseller_get/<id>', views.approveseller_get),
    path('rejectseller_get/<id>', views.rejectseller_get),




    #==========Seller============
    path('s_signup_get/', views.s_signup_get),
    path('s_signup_post/',views.s_signup_post),
    path('sellerviewprofile_get/',views.sellerviewprofile_get),
    path('sellerhome_get/',views.sellerhome_get),
    path('seller_editprofile_get/<id>',views.seller_editprofile_get),
    path('seller_editprofile_post/',views.seller_editprofile_post),
    path('addproducts_get/',views.addproducts_get),
    path('addproducts_post/',views.addproducts_post),
    path('viewallproducts_get/',views.viewallproducts_get),
    path('editproducts_get/<id>',views.editproducts_get),
    path('editproducts_post/',views.editproducts_post),
    path('deleteproducts_get/<id>',views.deleteproducts_get),
    path('addcoupon_get/',views.addcoupon_get),
    path('addcoupon_post/',views.addcoupon_post),
    path('viewcoupon_get/',views.viewcoupon_get),
    path('editcoupon_get/<id>',views.editcoupon_get),
    path('editcoupon_post/',views.editcoupon_post),
    path('deletecoupon_get/<id>',views.deletecoupon_get),
    path('viewordermain_get/',views.viewordermain_get),
    path('viewordersub_get/<id>',views.viewordersub_get),
    path('sellerviewreview_get/',views.sellerviewreview_get),
    path('sellerpassword_get/',views.sellerpassword_get),
    path('sellerchangepassword_post/',views.sellerchangepassword_post),
    path('app_login_post/',views.app_login_post),
    path('user_signup_post/',views.user_signup_post),
    path('user_viewprofile_post/',views.user_viewprofile_post),
    path('user_editprofile_post/',views.user_editprofile_post),
    path('user_viewproduct_post/',views.user_viewproduct_post),
    path('user_viewseller_post/',views.user_viewseller_post),
    path('user_addproductcart_post/',views.user_addproductcart_post),
    path('user_viewcart_post/',views.user_viewcart_post),
    path('user_changepassword_post/',views.user_changepassword_post),
    path('user_viewsellerinformation_post/',views.user_viewsellerinformation_post),
    path('user_place_order_post/',views.user_place_order_post),
    path('makepayment/',views.makepayment),
    path('user_view_orders_post/',views.user_view_orders_post),
    path('user_viewpaymenthistory_post/',views.user_viewpaymenthistory_post),
    path('user_sendcomplaint/',views.user_sendcomplaint),
    path('user_viewcomplaint/',views.user_viewcomplaint),
    path('user_receiveoffers/',views.user_receiveoffers),
    path('android_forget_password_post/',views.android_forget_password_post),
    path('user_deletecart_post/',views.user_deletecart_post),
    path('user_updatecartquantity_post/',views.user_updatecartquantity_post),
    path('viewprofilehomepage/',views.viewprofilehomepage),
    path('user_sendreview/',views.user_sendreview),
    path('user_viewordermain/',views.user_viewordermain),
    path('user_viewordersub/',views.user_viewordersub),







]
