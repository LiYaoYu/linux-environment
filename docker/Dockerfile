FROM archlinux/base

RUN pacman -Syu sudo openssh git vim man-db man-pages --noconfirm --needed
RUN pacman -Scc --noconfirm

RUN rm -f /etc/ssh/ssh_*_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -A
RUN sed -i "s/#*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config
RUN echo "ServerAliveInterval 30" >> /etc/ssh/ssh_config

CMD ["/usr/bin/sshd", "-D"]

# TODO: modify the running command by docker-compose.yml instead
# After docker image built, run docker container with command below
# docker run -d -p 3721:22 -h test -v /etc/localtime:/etc/localtime:ro --name test archlinux-dev:test
