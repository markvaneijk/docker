FROM arm64v8/ubuntu:22.04
MAINTAINER Mark van Eijk <m@rkvaneijk.nl>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server sed nano rsync sudo bc curl dnsmasq gawk gcc git jq libpcre3-dev libpng-dev locate lsb-releaze make ncdu npm pngquant sshpass ufw unzip wget zip

RUN mkdir /var/run/sshd

RUN echo "root:root" | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?SyslogFacility AUTH/SyslogFacility AUTH/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?LogLevel INFO/LogLevel INFO/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
