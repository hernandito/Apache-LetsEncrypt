#!/bin/bash
#crontab /config/crons.conf

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

#if [ ! -f /usr/bin/certbot-auto ]; then

	
#	wget -p /usr/bin/ https://dl.eff.org/certbot-auto
#	chmod a+x /usr/bin/certbot-auto
	apt-get update
	echo "====================================="		
	echo " Getting LetsEncrypt Dependencies..."
	echo "====================================="	
	/usr/bin/certbot-auto --noninteractive --os-packages-only

	mkdir -p /etc/letsencrypt

# Obtain cert.
	echo "=========================================="		
	echo " Installing LetsEncrypt Certificates..."
	echo "=========================================="		
	/usr/bin/certbot-auto certonly --non-interactive --renew-by-default --standalone --standalone-supported-challenges tls-sni-01 --rsa-key-size 4096 --email $YOUR_EMAIL --agree-tos $YOUR_EMAIL
#fi
