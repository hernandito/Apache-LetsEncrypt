#crontab /config/crons.conf
# May or may not have HOME set, and this drops stuff into ~/.local.
#export HOME="/root"
#export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ ! -f /usr/bin/certbot-auto ]; then
	wget https://dl.eff.org/certbot-auto /usr/bin/
	chmod a+x /usr/bin/certbot-auto
	apt-get update
fi

	certbot-auto --noninteractive --os-packages-only
	
	mkdir -p /etc/letsencrypt
	cp /config/cli.ini /etc/letsencrypt/cli.ini	
	certbot-auto certonly --noninteractive

