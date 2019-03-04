FROM tbaltrushaitis/ubuntu-nodejs:v6.9.1
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libzmq3-dev

ADD https://github.com/qtumproject/qtum/releases/download/mainnet-ignition-v0.17.2/qtum-0.17.2-x86_64-linux-gnu.tar.gz /tmp/
RUN tar -xvf /tmp/qtum-*.tar.gz -C /tmp/
RUN cp /tmp/qtum*/bin/*  /usr/local/bin
RUN rm -rf /tmp/qtum*

ENV APP_HOME /home/node/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN npm -g config set user root
RUN npm i -g https://github.com/qtumproject/qtumcore-node.git#master
RUN qtumcore-node create qtumNode
WORKDIR $APP_HOME/qtumNode
RUN qtumcore-node install https://github.com/qtumproject/insight-api.git#master
RUN qtumcore-node install https://github.com/qtumproject/qtum-explorer.git#master

COPY qtumNode/data/qtum.conf ./data/qtum.conf
COPY qtumNode/qtumcore-node.json ./qtumcore-node.json

EXPOSE 8332 3001 28332

ENTRYPOINT qtumcore-node start