FROM yamada28go/docker-x-japanese-vscode-base:ubuntu_18.04-lts
MAINTAINER yamada28go

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN apt-get update && apt-get upgrade -qy  &&  apt-get install -qy build-essential libssl-dev git man curl

USER dev
ENV HOME /home/dev

# install nvm
RUN rm -rf $HOME/.nvm &&\
    mkdir $HOME/.nvm

ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION 12.13.1

WORKDIR $HOME
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bash_profile &&\
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> $HOME/.bash_profile 

# 開発用にChreomをインストール
USER root
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get update &&\
    apt-get install -qy google-chrome-stable

# docker内部ではオプションをつけないと動作しないのでオプションを設定する
# [オプションの意味]
# no-sandbox : サンドボックス機能はdockerの機能と被るのではずす。
# disable-dev-shm-usage : dockerのデフォルト共有メモリは少ないので/tempを使用するように設定する
# [参考]
# Chromeの--disable-dev-shm-usageオプションについて
# https://qiita.com/yoshi10321/items/8b7e6ed2c2c15c3344c6
# 起動オプション
# http://chrome.half-moon.org/43.html#c776272a
#
USER dev
RUN echo 'alias chrome="google-chrome-stable --no-sandbox --disable-dev-shm-usage"' >> $HOME/.bash_profile

# APTコマンドをクリーンする
USER root
RUN rm -rf /var/lib/apt/lists/* &&\
    apt-get clean   

EXPOSE 22

USER root
CMD ["/usr/sbin/sshd", "-D"]
