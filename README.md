Project Title
=====================
This project is intended to provision infrastructure on AWS, Azure and GCP.

* Plugins
```
Mask Passwords
CloudBees Credentials
CloudBees AWS Credentials
File parameter
```
* Softwares to be installed
```
sudo yum install python3-pip
sudo pip3 install boto3
```

Pre-Requisites
============================
* Step 1: Download terraform utility
```
https://www.terraform.io/downloads) -> unzip file -> terraform.exe
```
* Step 2: Edit the system environment variables
```
System variables -> click on Path -> enter terraform.exe file path -> New -> Ok 
```
AWS
======
Execution Flow
=====================
* Step 1: Authentication to AWS 
```
export AWS_ACCESS_KEY_ID="" && export AWS_SECRET_ACCESS_KEY=""
```
* Step 2: clone repo
```
git clone https://github.com/fullstack2025/CSF.git && cd CSF
```
* Step 3: required changes in aws_dev_cluster.json
```
vi clutser-templates/aws_dev_cluster.json
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
* Step 4: Provision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/aws_dev_cluster.json --action provision
```
* Step 5: Post provision steps
```
login to bastionhost
eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A centos@PUBLIC_IP
login to appserver
sudo su -l && sudo yum install python3-pip -y && sudo pip3 install gunicorn && sudo pip3 install django
sudo vi /usr/local/lib64/python3.6/site-packages/django/db/backends/sqlite3/base.py (line 67 replace > with ==)
sudo yum install git -y && sudo git clone https://github.com/devops2023q2/webapp.git && cd webapp && sudo pip3 install -r requirements.txt
gunicorn main.wsgi --bind 0.0.0.0:8000
```
* Step 6: Deprovision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/aws_dev_cluster.json --action deprovision
```

Azure
=======
Execution Flow
=====================
* Step 1: Authentication to Azure
```
Service principal creation=>Azure active directory => App registrations => New registration -> Name : mysp(any name we can give) -> Register -> Certificates & secrets -> Client secrets -> New client secret -> Add -> copy client secret value

Assiging Permission for the above service princiap mysp to create resources in Azure => Subscription => IAM => Add -> add role assignment -> Role => Privileged administrator roles=> contributor -> members -> select members => select: <<mysp>> => click on Review + assign

export ARM_TENANT_ID="" && export ARM_SUBSCRIPTION_ID="" && export ARM_CLIENT_ID="" && export ARM_CLIENT_SECRET=""
```
* Step 2: Clone repo
```
git clone https://github.com/fullstack2025/CSF.git && cd CSF
```
* Step 3: Modify variables in cluster-templates/azure_dev_cluster.json file
```
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
* Step 4: Provision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/azure_dev_cluster.json --action provision
```
* Step 5: Post provision steps
```
login to bastionhost
eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A azure-user@PUBLIC_IP
login to webapp server
ssh azure-user@private_ip
or
Use browser based Bastionhost from portal to webapp server
sudo yum install python3-pip -y && sudo pip3 install gunicorn && sudo pip3 install django
sudo vi /usr/local/lib64/python3.6/site-packages/django/db/backends/sqlite3/base.py (line 67 replace > with ==)
sudo yum install git -y && sudo git clone https://github.com/devops2023q2/webapp.git && cd webapp && sudo pip3 install -r requirements.txt
gunicorn main.wsgi --bind 0.0.0.0:8000
```
* Step 6: Deprovision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/azure_dev_cluster.json --action deprovision
```
GCP
=======
Execution Flow
=====================
 * Step 1: Authentication to GCP
 ```
Service account creation=> IAM -> Service accounts -> create service account -> service account name : mysa -> click on CREATE AND CONTINUE ->  select a role -> Basic : owner -> continue -> done -> click on service account -> keys -> add key 

Create project=>(till now I am unable to create project using terraform due to permission issue)

Permission to authenticate GCP APIs => APIs & Services: enabled APIs & Services => click on ENABLE APIS AND SERVICES => Compute Engine API and Cloud SQL Admin API

export GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/gcp_cred.json
 ```
* Step 2: clone repo
```
git clone https://github.com/fullstack2025/CSF.git && cd CSF
```
* Step 3: required changes in gcp_dev_cluster.json
```
vi clutser-templates/gcp_dev_cluster.json
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
* Step 4: provision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/gcp_dev_cluster.json --action provision
```
* Step 5: Post provision steps
```
login to bastionhost
eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A gcp-user@PUBLIC_IP
login to appserver
sudo su -l
sudo yum install python3-pip -y && sudo pip3 install gunicorn && sudo pip3 install django
sudo vi /usr/local/lib64/python3.6/site-packages/django/db/backends/sqlite3/base.py (line 67 replace > with ==)
sudo yum install git -y && sudo git clone https://github.com/devops2023q2/webapp.git && cd webapp && sudo pip3 install -r requirements.txt
gunicorn main.wsgi --bind 0.0.0.0:8000
```
* Step 6: Deprovision infra
```
python3 csf_gateway.py --cluster_data cluster-templates/azure_dev_cluster.json --action deprovision
```
