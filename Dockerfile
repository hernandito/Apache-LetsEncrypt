FROM linuxserver/baseimage.apache
MAINTAINER smdion <me@seandion.com>

# copy sources.list
COPY sources.list /etc/apt/

ENV APTLIST="libapache2-mod-php5 wget inotify-tools mc php5-gd php5-sqlite php5-mcrypt php5-tidy php5-mysql libapache2-mod-proxy-html"

# install main packages
RUN apt-get update -q && \
apt-get install $APTLIST -qy && \

# cleanup
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add some files
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/service/*/finish /etc/my_init.d/*.sh

# Update apache configuration with this one
RUN a2enmod proxy proxy_http proxy_ajp rewrite deflate substitute headers proxy_balancer proxy_connect proxy_html xml2enc authnz_ldap

#ADD firstrun.sh /etc/my_init.d/firstrun.sh
#RUN chmod +x /etc/my_init.d/firstrun.sh

RUN mkdir -p /etc/letsencrypt
COPY createcli.sh /config/createcli.sh
RUN chmod a+x /config/createcli.sh
RUN bash /config/createcli.sh

RUN wget -P /usr/bin https://dl.eff.org/certbot-auto
RUN chmod a+x /usr/bin/certbot-auto


RUN	apt-get update
RUN	/usr/bin/certbot-auto --noninteractive --os-packages-only





#COPY cli.ini /etc/letsencrypt/cli.ini	
COPY crons.conf /config/crons.conf
COPY firstrun.sh /config/firstrun.sh
RUN chmod a+x /config/firstrun.sh
RUN bash /config/firstrun.sh
RUN crontab -l
#RUN /usr/bin/certbot-auto certonly --noninteractive --agree-tos

# ports and volumes
EXPOSE 80 443
VOLUME /config
VOLUME /etc/letsencrypt
ENV YOUR_EMAIL=
ENV YOUR_DOMAIN=
