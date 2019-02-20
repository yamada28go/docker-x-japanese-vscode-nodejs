FROM yamada28go/docker-x-japanese-vscode-base
MAINTAINER yamada28go

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN apt-get update &&  apt-get install -qy build-essential libssl-dev git man curl

USER dev
ENV HOME /home/dev

# install nvm
RUN rm -rf $HOME/.nvm &&\
	mkdir $HOME/.nvm

ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION 10.15.1

WORKDIR $HOME
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bash_profile &&\
	echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> $HOME/.bash_profile 

EXPOSE 22

USER root
CMD ["/usr/sbin/sshd", "-D"]
