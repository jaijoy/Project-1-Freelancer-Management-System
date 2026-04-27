
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [
    path('login/',views.login_page),
    path('logoutss/',views.logoutss),
    path('login_page_post',views.login_page_post),
    path('admin_changepassword/',views.admin_changepassword),
    path('admin_changepassword_post/',views.admin_changepassword_post),

    path('admin_index/', views.admin_index),
    path('admin_verify_clients/', views.admin_verify_clients),
    path('admin_verify_clients_approved/<id>',views.admin_verify_clients_approved),
    path('admin_veryfy_clients_rejected/<id>',views.admin_veryfy_clients_rejected),
    path('admin_verify_clients_approved_view/',views.admin_verify_clients_approved_view),


    path('admin_verify_freelancers/',views.admin_verify_freelancers),
    path('admin_verify_freelancers_approved/<id>',views.admin_verify_freelancers_approved),
    path('admin_verify_freelancers_rejected/<id>', views.admin_verify_freelancers_rejected),
    path('admin_verify_freelancers_approved_view/',views.admin_verify_freelancers_approved_view),

    path('admin_complaints/',views.admin_complaints),
    path('admin_replay_complaint',views.admin_replay_complaint),

    path('admin_freelancers_review/',views.admin_freelancers_review),


    path('client_registration/',views.client_registration),
    path('client_changepassword/',views.client_changepassword),
    path('client_changepassword_POST/',views.client_changepassword_POST),
    path('client_index/',views.client_index),
    path('client_registration_POST',views.client_registration_POST),

    path('client_manage_jobs/',views.client_manage_jobs),
    path('client_manage_jobs_POST',views.client_manage_jobs_POST),
    path('client_manage_jobs_delete/<id>',views.client_manage_jobs_delete),
    path('client_manage_jobs_edit/<id>',views.client_manage_jobs_edit),
    path('client_manage_jobs_edit_POST',views.client_manage_jobs_edit_POST),

    path('client_manage_jobs_view/',views.client_manage_jobs_view),
    path('client_profile/',views.client_profile),
    path('client_profile_edit/<id>', views.client_profile_edit),
    path('client_profile_edit_POST',views.client_profile_edit_POST),

    path('client_job_requests/', views.client_job_requests),
    path('client_job_requests_approved/<id>',views.client_job_requests_approved),
    path('client_job_requests_rejected/<id>',views.client_job_requests_rejected),

    path('client_view_work_freelancer/<id>',views.client_view_work_freelancer),
    # path('client_chat/<id>',views.client_chat),
    # path('client_raz_pay/<id>/<id>/',views.client_raz_pay),
    path('package_user_pay_proceed/<id>/<amt>',views.package_user_pay_proceed),
    path('on_payment_success',views.on_payment_success),
    path('client_review/<id>',views.client_review),
    path('client_review_POST/', views.client_review_POST),
    path('client_freelancers_review_view',views.client_freelancers_review_view),
    path('freelancers_review_delete/<id>',views.freelancers_review_delete),

    path('android_login/', views.android_login),
    path('freelancers_registration/', views.freelancers_registration),
    path('freelancers_complaint/', views.freelancers_complaint),
    path('freelancers_complaint_view/', views.freelancers_complaint_view),
    path('freelancers_job_view/',views.freelancers_job_view),
    path('freelancers_job_requests_POST/',views.freelancers_job_requests_POST),

    path('freelancers_job_request_status_view/',views.freelancers_job_request_status_view),
    path('freelancer_job_report/',views.freelancer_job_report),
    path('freelancer_review/',views.freelancer_review),
    path('freelancer_view_payment_details/', views.freelancer_view_payment_details),

    path('freelancer_viewchat/',views.freelancer_viewchat),
    path('freelancer_sendchat/',views.freelancer_sendchat),
    path('view_report/',views.view_report),


    path('chat_send/<msg>', views.chat_send),
    path('client_chat_to_freelancer/<id>', views.client_chat_to_freelancer),
    path('chat_view/', views.chat_view),
]
