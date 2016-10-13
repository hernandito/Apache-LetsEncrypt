#!/bin/bash
crontab /config/crons.conf

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ ! -f /usr/bin/certbot-auto ]; then

	
	wget -p /usr/bin/ https://dl.eff.org/certbot-auto
	chmod a+x /usr/bin/certbot-auto
	apt-get update
	apt-get install -y mc
	chmod a+x /config/dl.eff.org/certbot-auto
	/config/dl.eff.org/certbot-auto --noninteractive --os-packages-only

mkdir -p /etc/letsencrypt
cat > /etc/letsencrypt/cli.ini <<EOF
# Uncomment to use the staging/testing server - avoids rate limiting.
# server = https://acme-staging.api.letsencrypt.org/directory
 
# Use a 4096 bit RSA key instead of 2048.
rsa-key-size = 4096
 
# Set email and domains.
email = "$YOUR_EMAIL"
domains = "$YOUR_DOMAIN"
 
# Text interface.
text = True
# No prompts.
non-interactive = True
# Suppress the Terms of Service agreement interaction.
agree-tos = True
 
# Use the webroot authenticator.
authenticator = webroot
webroot-path = /var/www/html
EOF
 
# Obtain cert.
	/config/dl.eff.org/certbot-auto certonly --noninteractive --agree-tos
fi
