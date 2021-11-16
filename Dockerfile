FROM alpine:3.14

LABEL maintainer="didlich.apps@gmail.com"

RUN apk update && apk add --no-cache \
  openssh \
  openvpn \
  curl

RUN mkdir /var/run/sshd \
  && mkdir /vpn

RUN echo "root:root" | chpasswd
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin\ yes/' /etc/ssh/sshd_config
RUN sed -i 's/^AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config

COPY  entrypoint.sh /
EXPOSE 22

VOLUME ["/vpn"]

ENTRYPOINT ["/entrypoint.sh"]


