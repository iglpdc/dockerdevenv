FROM ubuntu:latest

MAINTAINER Ivan Gonzalez <iglpdc@gmail.com>

RUN apt-get update && apt-get install -y docker.io \
    ca-certificates curl unzip tar build-essential git-core cmake zsh stow clang ctags python-dev python-pip \
    i3 terminator feh dmenu tightvncserver software-properties-common

RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update && apt-get install -y neovim 
RUN easy_install supervisor

USER root
ENV user iglpdc 
RUN adduser $user && echo "$user:$user" | chpasswd && adduser $user sudo

ADD supervisord.conf /home/$user/supervisord.conf
ADD vncpasswd /home/$user/.vnc/passwd
ADD xstartup /home/$user/.vnc/xstartup
RUN chown $user:$user -R /home/$user/.vnc/
RUN chown $user:$user /home/$user/supervisord.conf
RUN chmod 400 /home/$user/.vnc/passwd

USER $user

ENV HOME /home/$user

WORKDIR /home/$user/
VOLUME /home/$user
RUN echo "exec i3 & xterm" > /home/$user/.bashrc
EXPOSE 5901
EXPOSE 5902

#for vnc
ENV USER $user
RUN chmod +x /home/$user/.vnc/xstartup

#ENTRYPOINT supervisord -n -c /home/$user/supervisord.conf
CMD /bin/bash
