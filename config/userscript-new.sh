if [ ! -f /config/apache/site-confs/dont-erase.txt ]; then

echo "================================================"
echo " Creating default.conf file w/ user Domain"
echo "================================================"
confcontent1="
<VirtualHost *:80>
    DocumentRoot /config/www/

    <Directory \"/config/www/\">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
            Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>

<VirtualHost *:443>
"
confcontent2="
SSLEngine on
	SSLProtocol All -SSLv2 -SSLv3
	SSLCipherSuite AES128+EECDH:AES128+EDH
	SSLCertificateFile /config/keys/ssl.crt
	SSLCertificateKeyFile /config/keys/decrypted.ssl.key
	SSLCertificateChainFile /config/keys/sub.class1.server.ca.pem
	SSLProxyEngine On
	SSLProxyVerify none 
	SSLProxyCheckPeerCN off
	SSLProxyCheckPeerName off
	SSLProxyCheckPeerExpire off 
ProxyRequests off

    <Directory /config/www/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
            Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
"

    echo "$confcontent1" > /config/apache/site-confs/default.conf
    echo "ServerName $YOUR_DOMAIN" >> /config/apache/site-confs/default.conf
    echo "$confcontent2" >> /config/apache/site-confs/default.conf
	echo "File Created" > /config/apache/site-confs/dont-erase.txt
	
	appendconf="yes"
	
fi




#!/bin/bash
crontab /config/crons.conf

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ ! -f /usr/bin/certbot-auto ]; then

	echo "================================================"
	echo " Getting LetEncrypt Dependencies"
	echo "================================================"
	cd /usr/bin/
	wget https://dl.eff.org/certbot-auto
	chmod a+x /usr/bin/certbot-auto
	apt-get update
	apt-get install -y mc
	certbot-auto --noninteractive --os-packages-only
fi

if [ ! -f /etc/letsencrypt/cli.ini ]; then
	echo "================================================"
	echo " Creating cli.ini file w/ user Domain"
	echo "================================================"
	clicontent="
	# Use a 4096 bit RSA key instead of 2048.
	rsa-key-size = 4096
	 
	# Set email and domains.
	email = $YOUR_EMAIL
	domains = $YOUR_DOMAIN
	 
	# Text interface.
	text = True
	# No prompts.
	non-interactive = True
	# Suppress the Terms of Service agreement interaction.
	agree-tos = True
	 
	# Use the webroot authenticator.
	authenticator = webroot
	webroot-path = /config/www

	"
	 echo "$clicontent" > /etc/letsencrypt/cli.ini
fi

certbot-auto certonly --noninteractive --agree-tos

if [ "$appendconf" -eq "yes" ]; then
echo "================================================"
echo " Appending default.conf w/ proper certificates"
echo "================================================"
finalconf="
<VirtualHost *:80>
    DocumentRoot /config/www/

    <Directory \"/config/www/\">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
            Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>

<VirtualHost *:443>
    ServerName $YOUR_DOMAIN
	
SSLEngine on
	SSLProtocol All -SSLv2 -SSLv3
	SSLCipherSuite AES128+EECDH:AES128+EDH
	SSLCertificateFile /etc/letsencrypt/live/$YOUR_DOMAIN/cert.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/$YOUR_DOMAIN/privkey.pem
	SSLCertificateChainFile /etc/letsencrypt/live/$YOUR_DOMAIN/chain.pem
	SSLProxyEngine On
	SSLProxyVerify none 
	SSLProxyCheckPeerCN off
	SSLProxyCheckPeerName off
	SSLProxyCheckPeerExpire off 
ProxyRequests off

    <Directory \"/config/www/\">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
            Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>

"
	appendconf="no"
fi



#if [ ! -f /config/kodi-alexa/kodi.py ]; then
#	apt-get install -y git
#	cd /config
#	git clone https://github.com/m0ngr31/kodi-alexa.git
#	cd /config/kodi-alexa
#fi

#echo "=================="
#echo " Installing Ruby"
#echo "=================="
#apt-get install -y ruby
#cd /config
#wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#echo "====================================="
#heroku --version
#echo "====================================="