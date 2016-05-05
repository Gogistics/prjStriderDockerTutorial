FROM ubuntu:14.04
MAINTAINER Alan Tai <gogistics@gogistics-tw.com>

# set environment variables
ENV SERVER_NAME http://strider.gogistics-tw.com
ENV PLUGIN_GITHUB_APP_ID 3d8b3f176a46ab566f90
ENV PLUGIN_GITHUB_APP_SECRET fcb63d76a3dd790120bf36f18ac2d54d44e418db
ENV CONCURRENT_JOBS 3

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# remember to upgrade nodejs, equal or greater v4, to avoid SyntaxError: Use of const in strict mode.
RUN apt-get update && \
    apt-get install -y git supervisor python-pip curl apt-utils && \
    curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get install -y nodejs git git-core build-essential && \
    pip install supervisor-stdout && \
    sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf && \
    npm cache clean -f && npm install -g n && n stable && node -v && \
    apt-get update && \
    apt-get clean

ADD sv_stdout.conf /etc/supervisor/conf.d/
VOLUME /home/strider/.strider
COPY strider/ /opt/strider/src/

RUN mkdir -p /home/strider
RUN adduser --disabled-password --gecos "" --home /home/strider strider
RUN chown -R strider:strider /home/strider
RUN chown -R strider:strider /opt/strider
RUN ln -s /opt/strider/src/bin/strider /usr/local/bin/strider

USER strider
ENV HOME /home/strider
RUN cd /opt/strider/src && npm install && npm run build
COPY strider/ /opt/strider/src/
COPY start.sh /usr/local/bin/start.sh
COPY strider.conf /etc/supervisor/conf.d/strider.conf

EXPOSE 3000
USER root
CMD ["bash","/usr/local/bin/start.sh"]
