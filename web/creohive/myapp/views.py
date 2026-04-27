

from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth import logout
from django.contrib.auth.hashers import check_password
import datetime
from django.db.models import Q
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.hashers import make_password, check_password
from django.core.files.storage import FileSystemStorage

from django.http import JsonResponse, HttpResponse
from django.shortcuts import render, redirect


# Create your views here.
from myapp.models import *
from django.contrib.auth.models import User, Group


def logoutss(request):
    logout(request)
    return redirect('/myapp/login')

def login_page(request):
    return render(request, 'login.html')

def login_page_post(request):
    username = request.POST['username']
    password = request.POST['pass']

    user = authenticate(request, username=username, password=password)


    if user is not None:

        if user.groups.filter(name="Admin").exists():
            print("admin")
            login(request, user)
            return redirect('/myapp/admin_index/')

        # elif user.groups.filter(name="Freelancers").exists():
        #     ob = Tbl_freelancers.objects.get(LOGIN_id=user.id)
        #     if ob.status == "Freelancers":
        #         print("admin")
        #         login(request, user)
        #         return redirect('/myapp/freelancer_home')

        elif user.groups.filter(name="Clients").exists():
            ob = Tbl_client.objects.get(LOGIN_id=user.id)

            if ob.status == "Approved":
                print("admin")
                login(request, user)
                return redirect('/myapp/client_index')
            else:
                messages.warning(request, "invalid.user")
                return redirect('/myapp/login')
        else:
            messages.warning(request, "invalid.user")
            return redirect('/myapp/login')
    else:
        messages.warning(request, "invalid username and password")
        return redirect('/myapp/login')




def admin_index(request):
    return render(request,'admin/adminindex.html')


@login_required(login_url='/myapp/login')
def admin_verify_clients(request):
    obj=Tbl_client.objects.all()
    return render(request, 'admin/verify_clients.html', {'data':obj})


@login_required(login_url='/myapp/login')
def admin_verify_clients_approved(request,id):
    obj=Tbl_client.objects.get(id=id)
    obj.status='Approved'
    obj.save()
    return redirect('/myapp/admin_verify_clients')

@login_required(login_url='/myapp/login')
def admin_verify_clients_approved_view(request):
    obj=Tbl_client.objects.filter(status="Approved")
    return render(request,'admin/verified_clients_view.html', {'data':obj})

@login_required(login_url='/myapp/login')
def admin_veryfy_clients_rejected(request,id):
    obj=Tbl_client.objects.get(id=id)
    obj.status='Rejected'
    obj.save()
    return redirect('/myapp/admin_verify_clients')



@login_required(login_url='/myapp/login')
def admin_verify_freelancers(request):
    obj=Tbl_freelancers.objects.all()
    return render(request, 'admin/verify_freelancers.html', {'data':obj} )

@login_required(login_url='/myapp/login')
def admin_verify_freelancers_approved(request,id):
    obj=Tbl_freelancers.objects.get(id=id)
    obj.status="Approved"
    obj.save()
    return redirect('/myapp/admin_verify_freelancers')

@login_required(login_url='/myapp/login')
def admin_verify_freelancers_rejected(request, id):
    obj=Tbl_freelancers.objects.get(id=id)
    obj.status="Rejected"
    obj.save()
    return redirect('/myapp/admin_verify_freelancers')

@login_required(login_url='/myapp/login')
def admin_verify_freelancers_approved_view(request):
    obj=Tbl_freelancers.objects.filter(status="Approved")
    return render(request, 'admin/verified_freelancers_view.html', {'data':obj} )


@login_required(login_url='/myapp/login')
def admin_complaints(request):
    obj=Tbl_complaint.objects.all()
    return render(request, 'admin/complaints.html',{'data':obj})

@login_required(login_url='/myapp/login')
def admin_replay_complaint(request):
    id=request.POST["complaint_id"]
    replay=request.POST["reply"]

    obj = Tbl_complaint.objects.get(id=id)
    obj.reply=replay
    obj.save()
    return redirect('/myapp/admin_complaints')


@login_required(login_url='/myapp/login')
def admin_freelancers_review(request):
    obj=Tbl_review.objects.all()
    return render(request, 'admin/freelancers_review.html', {'data':obj})




def client_registration(request):
    return render(request, 'client/registration.html')

@login_required(login_url='/myapp/login/')
def client_index(request):
    return render(request, 'client/client_index.html')

from django.contrib import messages
from django.shortcuts import redirect, render
from django.contrib.auth.models import User, Group
from django.contrib.auth.hashers import make_password
from django.core.files.storage import FileSystemStorage

def client_registration_POST(request):
    name = request.POST["name"]
    gmail = request.POST["gmail"]
    phone = request.POST["phone"]
    gender = request.POST["gender"]
    dob = request.POST["dob"]
    photo = request.FILES["photo"]

    fs = FileSystemStorage()
    img = fs.save(photo.name, photo)

    place = request.POST["place"]
    post = request.POST["post"]
    pin = request.POST["pin"]
    district = request.POST["district"]
    username = request.POST["username"]
    password = request.POST["password"]


    if User.objects.filter(username=username).exists():
        messages.error(request, "Username already exists. Please choose another one.")
        return redirect('/myapp/client_registration')

    if User.objects.filter(email=gmail).exists():
        messages.error(request, "Email already registered. Please use another email.")
        return redirect('/myapp/client_registration')


    user = User.objects.create(
        username=username,
        password=make_password(password),
        first_name=name,
        email=gmail
    )
    user.groups.add(Group.objects.get(name='Clients'))

    obj = Tbl_client()
    obj.LOGIN = user
    obj.name = name
    obj.gmail = gmail
    obj.phone = phone
    obj.gender = gender
    obj.dob = dob
    obj.photo = img
    obj.place = place
    obj.post = post
    obj.pin = pin
    obj.district = district
    obj.status = 'pending'
    obj.save()

    messages.success(request, "Registration successful! Please wait for approval.")
    return redirect('/myapp/login')


@login_required(login_url='/myapp/login/')
def client_changepassword(request):
    return render(request, 'client/change_password.html')


@login_required(login_url='/myapp/login/')
def client_changepassword_POST(request):
    currentpassword = request.POST["currentpassword"]
    newpassword = request.POST["newpassword"]
    confirmpassword = request.POST["confirmpassword"]

    user = request.user
    p = check_password(currentpassword, user.password)
    if p:
        if newpassword == confirmpassword:
            user.set_password(newpassword)
            user.save()
            logoutss(request)
            return redirect('/myapp/login/')
        else:
            return redirect('/myapp/client_changepassword/')
    else:
        return redirect('/myapp/client_changepassword/')


@login_required(login_url='/myapp/login/')
def client_profile(request):
    obj=Tbl_client.objects.get(LOGIN_id = request.user)
    return render(request, 'client/profile.html',{'client':obj})


@login_required(login_url='/myapp/login')
def client_profile_edit(request,id):
    obj=Tbl_client.objects.get(id=id)
    return render(request,'client/profile_edit.html', {'client':obj })

@login_required(login_url='/myapp/login')
def client_profile_edit_POST(request):
    name = request.POST["name"]
    gmail = request.POST["gmail"]
    phone = request.POST["phone"]
    gender = request.POST["gender"]
    dob = request.POST["dob"]
    place = request.POST["place"]
    post = request.POST["post"]
    pin = request.POST["pin"]
    district = request.POST["district"]

    obj=Tbl_client.objects.get(LOGIN_id = request.user)

    if 'photo' in request.FILES:
        photo = request.FILES["photo"]
        fs = FileSystemStorage()
        img = fs.save(photo.name, photo)
        obj.photo = img

    obj.name = name
    obj.gmail = gmail
    obj.phone = phone
    obj.gender = gender
    obj.dob = dob
    obj.place = place
    obj.post = post
    obj.pin = pin
    obj.district = district

    obj.save()
    return redirect('/myapp/client_profile#a')

@login_required(login_url='/myapp/login/')
def client_manage_jobs(request):
    return render(request, 'client/manage_jobs.html')

def client_manage_jobs_POST(request):
    title=request.POST["title"]
    discription=request.POST["discription"]
    experience=request.POST["experience"]
    obj=Tbl_job()
    obj.title=title
    obj.discription=discription
    obj.experience=experience
    obj.date=datetime.datetime.now().today().date()
    obj.status='open'
    obj.CLIENT=Tbl_client.objects.get(LOGIN_id=request.user)
    obj.save()
    return redirect('/myapp/client_manage_jobs#a')

@login_required(login_url='/myapp/login/')
def client_manage_jobs_view(request):
    client = Tbl_client.objects.get(LOGIN_id=request.user)
    obj = Tbl_job.objects.filter(CLIENT=client)
    return render(request, 'client/manage_jobs_view.html',{'data':obj})

@login_required(login_url='/myapp/login/')
def client_manage_jobs_delete(request,id):
    Tbl_job.objects.get(id=id).delete()
    return redirect('/myapp/client_manage_jobs_view' )

@login_required(login_url='/myapp/login/')
def client_manage_jobs_edit(request,id):
    obj=Tbl_job.objects.get(id=id)
    return render(request,'client/manage_job_edit.html',{'data':obj} )

@login_required(login_url='/myapp/login/')
def client_manage_jobs_edit_POST(request):
    title = request.POST["title"]
    discription = request.POST["discription"]
    experience = request.POST["experience"]
    # date = request.POST["date"]
    # status = request.POST["status"]

    id=request.POST["id"]
    obj=Tbl_job.objects.get(id=id)

    obj.title = title
    obj.discription = discription
    obj.experience = experience
    obj.date = datetime.datetime.now().today().date()
    obj.status = 'open'
    obj.CLIENT = Tbl_client.objects.get(LOGIN_id=request.user)
    obj.save()
    return redirect('/myapp/client_manage_jobs_view#a')

@login_required(login_url='/myapp/login/')
def client_job_requests(request):
    # client = Tbl_client.objects.get(LOGIN_id=request.user)
    # jobs = Tbl_job.objects.filter(CLIENT=client)
    # data = Tbl_job_request.objects.filter(JOB__in=jobs).select_related('FREELANCER', 'JOB')
    data = Tbl_job_request.objects.filter(JOB__CLIENT__LOGIN_id=request.user.id)

    return render(request, 'client/job_requests.html',{'data': data})

def client_job_requests_approved(request,id):
    obj = Tbl_job_request.objects.get(id=id)
    obj.status="Approved"
    obj.save()
    return redirect('/myapp/client_job_requests')

def client_job_requests_rejected(request,id):
    obj = Tbl_job_request.objects.get(id=id)
    obj.status="Rejected"
    obj.save()
    return redirect('/myapp/client_job_requests')

@login_required(login_url='/myapp/login')
def client_view_work_freelancer(request,id):
    data=Tbl_daily_report.objects.filter(JOB_REQUEST_id=id)
    return render(request, 'client/freelancer_work_status.html', {'data':data})

def client_review(request,id):
    obj = Tbl_job_request.objects.get(id=id)
    freelacer_id= obj.FREELANCER_id
    client_id = obj.JOB.CLIENT_id

    data = {
        'freelancer_id' : freelacer_id,
        'client_id': client_id,
        'obj' : obj
    }
    return render(request, 'client/review.html', {'data':data})

def client_review_POST(request):
    client_id=request.POST["client_id"]
    freelancer_id=request.POST["freelancer_id"]
    review=request.POST["review"]
    rating=request.POST["rating"]

    i = Tbl_review.objects.filter(CLIENT_id=client_id,FREELANCER_id=freelancer_id)
    if i:
        obj = Tbl_review.objects.get(CLIENT=client_id, FREELANCER=freelancer_id)
        obj.FREELANCER_id = freelancer_id
        obj.CLIENT_id = client_id
        obj.review = review
        obj.rating = rating
        obj.save()
        return redirect('/myapp/client_index/')
    obj = Tbl_review()
    obj.FREELANCER_id = freelancer_id
    obj.CLIENT_id = client_id
    obj.review = review
    obj.rating = rating
    obj.save()
    return redirect('/myapp/client_index')

    # client = Tbl_client.objects.get(id=client_id)
    # freelancer = Tbl_freelancers.objects.get(id=freelancer_id)

    # if Tbl_review.objects.get(CLIENT=client, FREELANCER=freelancer).exists():
    #     obj = Tbl_review.objects.get(CLIENT=client, FREELANCER=freelancer)
    #     obj.FREELANCER = freelancer
    #     obj.CLIENT = client
    #     obj.review = review
    #     obj.rating = rating
    #     obj.save()
    # else:
    #     obj=Tbl_review()
    #     obj.FREELANCER=freelancer
    #     obj.CLIENT=client
    #     obj.review=review
    #     obj.rating=rating
    #     obj.save()
    #     return redirect('/myapp/client_index')

def client_freelancers_review_view(request):
    obj = Tbl_review.objects.all()
    return render(request, 'client/freelancers_review_view.html', {'data': obj})

def freelancers_review_delete(request,id):
    Tbl_review.objects.get(id=id).delete()
    redirect('/myapp/client_freelancers_review_view')

# def client_chat(request, id):
#     return render(request, 'client/chat.html')






# android_login


from django.shortcuts import render
import razorpay

def package_user_pay_proceed(request,id,amt):
    request.session['rid'] = id
    request.session['amt'] = amt

    print(id,amt,'======amount===id=======')
    print(request.session['rid'],'=====request.session=======')
    print(request.session['amt'],'=====request.amount=======',amt)


    request.session['pay_amount'] = str(amt).split(".")[0]
    client = razorpay.Client(auth=("rzp_test_edrzdb8Gbx5U5M", "XgwjnFvJQNG6cS7Q13aHKDJj"))
    print(client)
    payment = client.order.create({'amount': request.session['pay_amount']+"00", 'currency': "INR", 'payment_capture': '1'})
    res=Tbl_client.objects.get(LOGIN__id=request.user.id)
    # print(res.name,'clinet name===================')
    # print(res.LOGIN.id,'clinet name===================')
    # print(res.name,'clinet name===================')

    # ob=Tbl_job_request.objects.get(id=request.session['rid'])
    # ob.status='Paid'
    # ob.save()
    return render(request,'client/pakage_UserPayProceed.html',{'p':payment,'val':res,"lid":request.user.id,"id":request.session['rid']})




def on_payment_success(request):
    request.session['rid'] = request.GET['id']
    request.session['lid'] = request.GET['lid']
    # var = auth.authenticate(username='admin', password='admin')
    # if var is not None:
    #     auth.login(request, var)
    # amt = request.session['pay_amount']
    obb = Tbl_job_request.objects.get(id=request.session['rid'])
    obb.status='Paid'
    obb.save()
    ob=Tbl_payment_table()
    ob.date=datetime.datetime.now().today().date()
    ob.amount=request.session['amt']
    ob.JOB_REQUEST=Tbl_job_request.objects.get(id=request.session['rid'])
    ob.status='paid'
    ob.save()
    return HttpResponse('''
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@10">
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        Swal.fire({
                            icon: 'success',
                            title: 'Payment Successfull... !',
                            confirmButtonText: 'OK',
                            reverseButtons: true
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location = '/myapp/client_job_requests/#a';
                            }
                        });
                    });
                </script>
            ''')




    # return HttpResponse('''<script>alert("Success! Thank you for your Contribution");window.location="/userhome"</script>''')




def android_login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(request, username=username, password=password)
    if user is not None:

        if user.groups.filter(name="Freelancers").exists():
            free=Tbl_freelancers.objects.get(LOGIN_id=user.id)
            if free.status == 'Approved':

                print("Freelancers")

                return JsonResponse({'status':'ok',
                                     'lid':str(user.id),
                                     'name': free.name,
                                     'email': free.gmail,
                                     'photo':free.photo.url,
                                     'type':'Freelancers'})

            else:
                return JsonResponse({'status': 'Not ok', })


        else:
            return JsonResponse({'status':'Not ok',})
    else:
        return JsonResponse({'status': 'Not ok', })



def freelancers_registration(request):
    name=request.POST["name"]
    email=request.POST["email"]
    gender=request.POST["gender"]
    phone=request.POST["phone"]
    qualification=request.POST["qualification"]
    skills=request.POST["skill"]
    dob = request.POST["dob"]
    place = request.POST["place"]
    post = request.POST["post"]
    pin = request.POST["pin"]
    district = request.POST["district"]

    photo=request.FILES["photo"]
    fs = FileSystemStorage()
    img = fs.save(photo.name, photo)

    username = request.POST["username"]
    password = request.POST["password"]

    if User.objects.filter(username=username).exists():
        return JsonResponse({'status': 'Not ok'})

    user = User.objects.create(username=username, password=make_password(password), first_name=name, email=email)
    user.save()
    user.groups.add(Group.objects.get(name='Freelancers'))

    obj=Tbl_freelancers()
    obj.LOGIN=user
    obj.name=name
    obj.gmail=email
    obj.photo=img
    obj.gender=gender
    obj.phone=phone
    obj.qualification=qualification
    obj.skills=skills
    obj.dob=dob
    obj.place=place
    obj.post=post
    obj.pin=pin
    obj.district=district
    obj.status='pending'
    obj.save()
    return JsonResponse({'status': 'ok', 'lid': str(user.id), 'type': 'Freelancers'})

def freelancers_complaint(request):

    complaint = request.POST["complaint"]
    lid = request.POST["lid"]
    obj=Tbl_complaint()
    obj.LOGIN=User.objects.get(id=lid)
    obj.complaint=complaint
    obj.date = datetime.datetime.now().today().date()
    obj.reply="pending"
    obj.save()
    return JsonResponse({'status': 'ok'})

def freelancers_complaint_view(request):
    lid=request.POST['lid']
    data = Tbl_complaint.objects.filter(LOGIN_id=lid)
    l=[]
    for i in data:
        l.append({
           'id': i.id,
           'date': str(i.date),
           'complaint': str(i.complaint),
            'reply': str(i.reply)
           })

    return JsonResponse({'status': 'ok','data':l})

def freelancers_job_view(request):
    data = Tbl_job.objects.all()
    l=[]
    for i in data:
        l.append({
            'id' : i.id,
            'title': str(i.title),
            'discription':str(i.discription),
            'experience':str(i.experience),
            'date':str(i.date),
            'status':str(i.status),
            'c_name':str(i.CLIENT.name),
            'c_email':str(i.CLIENT.gmail),
            'c_phone':str(i.CLIENT.phone),
            'c_photo':str(i.CLIENT.photo.url)

        })
    return JsonResponse({'status': 'ok','data':l})


def freelancers_job_requests_POST(request):
     fid = request.POST["lid"]
     job_id = request.POST["job_id"]

     freelancer = Tbl_freelancers.objects.get(LOGIN_id=fid)
     job = Tbl_job.objects.get(id=job_id)

     # Check if already sent
     if Tbl_job_request.objects.filter(FREELANCER_id=freelancer, JOB=job).exists():
         return JsonResponse({'status': 'exists'})

     obj=Tbl_job_request()
     obj.FREELANCER=freelancer
     obj.JOB=job
     obj.date=datetime.datetime.now().today().date()
     obj.status="Pending"
     obj.cost=0
     obj.save()
     return JsonResponse({'status': 'ok', })

def freelancers_job_request_status_view(request):
    fid = request.POST["lid"]
    freelancer = Tbl_freelancers.objects.get(LOGIN_id=fid)
    # report_data = Tbl_daily_report
    data= Tbl_job_request.objects.filter(FREELANCER=freelancer )
    l=[]
    for i in data:
        l.append({

            'job_id':str(i.id),
            'client_id':str(i.JOB.CLIENT.LOGIN.id),
            'job_title': str(i.JOB.title),
            'job_discription': str(i.JOB.discription),
            'job_experience': str(i.JOB.experience),
            'job_posted_date': str(i.JOB.date),
            'client_name': str(i.JOB.CLIENT.name),
            'client_email': str(i.JOB.CLIENT.gmail),
            'client_phone': str(i.JOB.CLIENT.phone),
            'client_photo': str(i.JOB.CLIENT.photo.url),
            'job_requested_date': str(i.date),
            'job_request_status':str(i.status)


        }
        )
    print(l)
    return JsonResponse({'status': 'ok','data':l})


def freelancer_job_report(request):
    job_req_id = request.POST.get("job_id")
    report = request.POST.get("report")
    amount = request.POST.get("amount")
    status = request.POST.get("status")

    print(request.POST, 'postttttt')


    job_request = Tbl_job_request.objects.get(id=job_req_id)

    # if Tbl_daily_report.objects.filter(JOB_REQUEST=job_request, report_status='Inompleted'):
    #     amount=0

    if Tbl_daily_report.objects.filter(JOB_REQUEST=job_request, report_status='Completed').exists():
        return JsonResponse({'status': 'not ok'})

    if Tbl_daily_report.objects.filter(JOB_REQUEST=job_request, report_status ='Incompleted').exists():
        job_request.status = status
        job_request.save()

    job_request.status = status
    job_request.save()

    # # Update the job request status
    # job_request.status = status
    # job_request.save()

    obj = Tbl_daily_report()
    obj.JOB_REQUEST = job_request
    obj.date = datetime.datetime.now().date()
    obj.status = report

    obj.amount = amount
    obj.report_status = status
    obj.save()

    return JsonResponse({'status': 'ok'})





def freelancer_review(request):
    fid = request.POST["lid"]
    freelancer_id = Tbl_freelancers.objects.get(LOGIN_id=fid)
    data=Tbl_review.objects.filter(FREELANCER=freelancer_id)
    l=[]
    for i in data:
        l.append(
            {
                'client_name' : str(i.CLIENT.name),
                'client_email ' : str(i.CLIENT.gmail),
                'client_image' : str(i.CLIENT.photo.url),
                'review':str(i.review),
                'rating':str(i.rating)
            }
        )
    return JsonResponse({'status': 'ok','data':l})



def freelancer_view_payment_details(request):
    fid = request.POST["lid"]
    freelancer = Tbl_freelancers.objects.get(LOGIN_id=fid)
    data = Tbl_payment_table.objects.filter(JOB_REQUEST__FREELANCER=freelancer)

    l=[]

    for i in data:
        l.append({
            "client_name":i.JOB_REQUEST.JOB.CLIENT.name,
            'job' : i.JOB_REQUEST.JOB.title,
            "amount":i.amount,
            "date":i.date,
            "status" : i.status
        })

    return JsonResponse({'status': 'ok','data':l})


# chat


def client_chat_to_freelancer(request, id):
    request.session["userid"] = id
    cid = str(request.session["userid"])
    request.session["new"] = cid
    qry = Tbl_freelancers.objects.get(LOGIN=cid)
    print(qry.LOGIN.id,'login----------')

    return render(request, "client/Chat.html", { 'name': qry.name, 'toid': cid})


def chat_send(request, msg):
    lid = request.user.id
    toid = request.session["userid"]
    message = msg

    import datetime
    d = datetime.datetime.now().date()
    chatobt = Tbl_chat()
    chatobt.message = message
    chatobt.TO_ID_id = toid
    chatobt.FROM_ID_id = lid
    chatobt.date = d
    chatobt.save()
    return JsonResponse({"status": "ok"})

def chat_view(request):
    fromid = request.user.id
    toid = request.session["userid"]
    qry = Tbl_freelancers.objects.get(LOGIN_id=request.session["userid"])

    from django.db.models import Q

    res = Tbl_chat.objects.filter(Q(FROM_ID_id=fromid, TO_ID_id=toid) | Q(FROM_ID_id=toid, TO_ID_id=fromid)).order_by('id')
    l = []
    # print(qry.name,'userssssssssss')

    for i in res:
        l.append({"id": i.id, "message": i.message, "to": i.TO_ID_id, "date": i.date, "from": i.FROM_ID_id})

    # return JsonResponse({'photo': qry.image, "data": l, 'name': qry.name, 'toid': request.session["userid"]})
    return JsonResponse({ "data": l, 'name': qry.name, 'toid': request.session["userid"]})


#flutter-freelancer
def freelancer_viewchat(request):
        if request.method == 'POST':
            fromid = request.POST.get('from_id')
            toid = request.POST.get('to_id')

            from_user = User.objects.get(id=fromid)
            to_user = User.objects.get(id=toid)

            res = Tbl_chat.objects.filter(Q(FROM_ID=from_user, TO_ID=to_user) |Q(FROM_ID=to_user, TO_ID=from_user)).order_by("id")

            chat_list = []
            for chat in res:
                chat_list.append({
                    "id": chat.id,
                    "msg": chat.message,
                    "from": chat.FROM_ID.id,
                    "to": chat.TO_ID.id,
                    "date": chat.date
                })

            return JsonResponse({"status": "ok", "data": chat_list})


def freelancer_sendchat(request):
        if request.method == 'POST':
            freelancer_id = request.POST.get('lid')
            client_id = request.POST.get('toid')
            msg = request.POST.get('message')

            from_user = User.objects.get(id=freelancer_id)
            to_user = User.objects.get(id=client_id)

            Tbl_chat.objects.create(
                FROM_ID=from_user,
                TO_ID=to_user,
                message=msg,
                date=datetime.datetime.now().date()
            )

            return JsonResponse({'status':'ok'})



def view_report(request):
    job_req_id= request.POST["job_id"]
    obj_report= Tbl_daily_report.objects.filter(JOB_REQUEST_id=job_req_id)

    list=[]
    for i in obj_report:
        list.append({
            'date': str(i.date),
            'work_report_status': str(i.status),
            'status' :str(i.report_status),
            'amount' :str(i.amount),
        }
        )
    print(list,'reports================')
    print(list,'reports================')
    print(list,'reports================')
    print(list,'reports================')
    return JsonResponse({'status': 'ok','data':list })



# def freelancer_viewchat(request):
#     fromid = request.POST["from_id"]
#     toid = request.POST["to_id"]
#     from django.db.models import Q
#     res = Tbl_chat.objects.filter(Q(FROM_ID=fromid, TO_ID=toid) | Q(FROM_ID=toid, TO_ID=fromid)).order_by("id")
#     l = []
#
#     for i in res:
#         l.append({"id": i.id, "msg": i.message, "from": i.FROM_ID, "date": i.date, "to": i.TO_ID})
#
#     return JsonResponse({"status":"ok",'data':l})
#
#
# def freelancer_sendchat(request):
#     FROM_id=request.POST['from_id']
#     TOID_id=request.POST['to_id']
#     print(FROM_id)
#     print(TOID_id)
#     msg=request.POST['message']
#
#     from  datetime import datetime
#     c=Tbl_chat()
#     c.FROM_ID=FROM_id
#     c.TO_ID=TOID_id
#     c.message=msg
#     c.date=datetime.now()
#     c.save()
#     return JsonResponse({'status':"ok"})











@login_required(login_url='/myapp/login/')
def admin_changepassword(request):
    return render(request, 'admin/change_password.html')


def admin_changepassword_post(request):
    currentpassword = request.POST["currentpassword"]
    newpassword = request.POST["newpassword"]
    confirmpassword = request.POST["confirmpassword"]
    user = request.user
    print("wwwwwwwwwwwwwwwwwwwwww")
    if check_password(currentpassword, user.password):
        if newpassword == confirmpassword:
            user.set_password(newpassword)
            user.save()
            logout(request)
            # messages.success(request, "Password changed successfully. Please log in again.")
            return redirect('/myapp/login/')
        else:
            # messages.warning(request, "New password and confirm password do not match.")
            return redirect('/myapp/admin_changepassword/')
    else:
        # messages.warning(request, "Current password is incorrect.")
        return redirect('/myapp/admin_changepassword/')