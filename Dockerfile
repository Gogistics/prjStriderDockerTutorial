FROM ubuntu:14.04
MAINTAINER Alan Tai <gogistics@gogistics-tw.com>

# set environment variables
ENV SERVER_NAME http://strider.gogistics-tw.com
# replace [MY_GITHUB_APP_ID] with yours
ENV PLUGIN_GITHUB_APP_ID [MY_GITHUB_APP_ID]
# replace [PLUGIN_GITHUB_APP_SECRET] with yours
ENV PLUGIN_GITHUB_APP_SECRET [MY_GITHUB_APP_SECRET]
# replace [MY_SMTP_HOST] with yours
ENV SMTP_HOST [MY_SMTP_HOST]
# replace [MY_SMTP_PORT] with the port your smtp host provides
ENV SMTP_PORT [MY_SMTP_PORT]
# replace [MY_SMTP_USER] with your username/email
ENV SMTP_USER [MY_SMTP_USER]
# replace [MY_SMTP_PASS] with your smtp password
ENV SMTP_PASS [MY_SMTP_PASS]
ENV CONCURRENT_JOBS 3

# set locale & language
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# start to install required packages, modules, tools, etc.
# remember to upgrade nodejs, equal or greater v4, to avoid connect-mongo SyntaxError: Use of const in strict mode.
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

RUN mkdir -p /home/strider && \
    adduser --disabled-password --gecos "" --home /home/strider strider && \
    chown -R strider:strider /home/strider && \
    chown -R strider:strider /opt/strider && \
    ln -s /opt/strider/src/bin/strider /usr/local/bin/strider

USER strider
ENV HOME /home/strider
RUN cd /opt/strider/src && npm install && npm run build
COPY strider/ /opt/strider/src/
COPY start.sh /usr/local/bin/start.sh
COPY strider.conf /etc/supervisor/conf.d/strider.conf

EXPOSE 3000
USER root
CMD ["bash","/usr/local/bin/start.sh"]
