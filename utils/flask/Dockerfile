FROM centos:7
WORKDIR /project
ADD . /project
RUN yum install epel-release -y
#RUN yum install wget -y
#RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#RUN rpm -ivh epel-release-7-5.noarch.rpm
RUN yum update -y
RUN yum install python3 -y
RUN yum install python3-pip  -y
RUN yum install mysql  -y
RUN yum install mysql-devel  -y
#RUN yum install mysql-common  -y
RUN yum install mysql-libs  -y
RUN yum install gcc  -y
RUN yum install python3-devel  -y
RUN pip3 install -r requirements.txt
RUN export $(grep -v '^#' ./env/development.env | xargs)
CMD ["sh","entrypoint.sh"]
