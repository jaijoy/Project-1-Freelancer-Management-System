from django.db import models
from django.contrib.auth.models import User
# Create your models here.

class Tbl_client(models.Model):
    LOGIN=models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    gmail= models.CharField(max_length=50)
    phone=models.BigIntegerField()
    gender=models.CharField(max_length=50)
    dob=models.DateField()
    photo=models.ImageField()
    place=models.CharField(max_length=50)
    post=models.CharField(max_length=50)
    pin=models.CharField(max_length=50)
    status=models.CharField(max_length=50)
    district=models.CharField(max_length=50)

class Tbl_freelancers(models.Model):
    LOGIN=models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    gmail = models.CharField(max_length=50)
    phone = models.BigIntegerField()
    qualification = models.CharField(max_length=100)
    skills=models.CharField(max_length=50)
    photo=models.ImageField()
    dob=models.DateField()
    gender=models.CharField(max_length=50)
    place=models.CharField(max_length=50)
    post = models.CharField(max_length=50)
    pin = models.CharField(max_length=50)
    status=models.CharField(max_length=50)
    district = models.CharField(max_length=50)

class Tbl_job(models.Model):
    title= models.CharField(max_length=100)
    discription= models.CharField(max_length=500)
    experience=models.CharField(max_length=100)
    date=models.DateField()
    status=models.CharField(max_length=50)
    CLIENT=models.ForeignKey(Tbl_client, on_delete=models.CASCADE )


class Tbl_job_request(models.Model):
    FREELANCER=models.ForeignKey(Tbl_freelancers, on_delete=models.CASCADE)
    JOB=models.ForeignKey(Tbl_job, on_delete=models.CASCADE)
    date=models.DateField()
    status=models.CharField(max_length=50)
    cost=models.BigIntegerField()


class Tbl_chat(models.Model):
    FROM_ID=models.ForeignKey(User, on_delete=models.CASCADE,related_name='from_id')
    TO_ID=models.ForeignKey(User, on_delete=models.CASCADE,related_name='to_id')
    date=models.DateField()
    message=models.CharField(max_length=100)

class Tbl_complaint(models.Model):
    LOGIN=models.ForeignKey(User, on_delete=models.CASCADE)
    date=models.DateField()
    complaint=models.CharField(max_length=100)
    reply=models.CharField(max_length=100)

class Tbl_review(models.Model):
    FREELANCER=models.ForeignKey(Tbl_freelancers, on_delete=models.CASCADE)
    CLIENT=models.ForeignKey(Tbl_client,on_delete=models.CASCADE)
    review=models.CharField(max_length=100)
    rating=models.CharField(max_length=100)

class Tbl_daily_report(models.Model):
    JOB_REQUEST=models.ForeignKey(Tbl_job_request, on_delete=models.CASCADE)
    amount= models.BigIntegerField()
    date=models.DateField()
    status=models.CharField(max_length=50)
    report_status=models.CharField(max_length=500)


class Tbl_payment_table(models.Model):
    JOB_REQUEST=models.ForeignKey(Tbl_job_request, on_delete=models.CASCADE)
    amount=models.BigIntegerField()
    date=models.DateField()
    status=models.CharField(max_length=50,default='pending')












