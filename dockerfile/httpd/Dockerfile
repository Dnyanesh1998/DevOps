FROM ubuntu
RUN apt-get update -y && apt-get install apache2 -y
RUN service apache2 start
MAINTAINER  Dnyanesh
COPY index.html /var/www/html/
CMD [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]

