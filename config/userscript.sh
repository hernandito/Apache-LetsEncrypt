crontab /config/crons.conf

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ ! -f /usr/bin/certbot-auto ]; then
	cd /usr/bin/
	wget https://dl.eff.org/certbot-auto
	chmod a+x /usr/bin/certbot-auto
	apt-get update
	apt-get install -y mc
	certbot-auto --noninteractive --os-packages-only
	certbot-auto certonly --noninteractive --agree-tos
fi
