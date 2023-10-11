FROM debian:bullseye

MAINTAINER Chandra Lefta <lefta.chandra@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get install -y iproute2 sudo nfs-common fuse bindfs \
                       tftpd-hpa
RUN apt clean

RUN groupadd -g 6565 pxeadmin
RUN useradd -d /home/pxeadmin -ms /bin/bash pxeadmin -u 6565 -g 6565
RUN usermod -aG tftp pxeadmin
RUN usermod -aG sudo pxeadmin
RUN passwd -d pxeadmin
RUN echo 'pxeadmin ALL=(ALL) ALL' >> /etc/sudoers 

ARG A_TFTPD_EXTRA_ARGS
ENV TFTPD_EXTRA_ARGS=A_TFTPD_EXTRA_ARGS

ARG A_TFTP_DIRECTORY
ENV TFTP_DIRECTORY=A_TFTP_DIRECTORY

EXPOSE 80

ADD tftpd.sh /tftpd.sh
RUN chmod +x /tftpd.sh

ENTRYPOINT ["/tftpd.sh"]
CMD ["eth0"]