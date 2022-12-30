FROM ubuntu

ARG PASSWORD=123456
ARG REGION=sa
ARG NGROKTOKEN=1wZ6GCecP9FjjpUzrfIq2Xa5wFY_Q9tPN7WbuqbtXZpHycST
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    ssh wget unzip vim curl nano git
RUN wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /ngrok-stable-linux-amd64.zip\
    && cd / && unzip ngrok-stable-linux-amd64.zip \
    && chmod +x ngrok
RUN apt install sudo
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000
RUN sudo ssh-keygen -A
RUN sudo service ssh start
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN echo root:${PASSWORD}|chpasswd
RUN /ngrok tcp --authtoken ${NGROKTOKEN} --region ${REGION} 22 & /usr/sbin/sshd -D
