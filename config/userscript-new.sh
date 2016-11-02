#!/bin/bash

appendconf="donotupdate"

if [ ! -f /config/apache/site-confs/dont-erase.txt ]; then

echo "================================================"
echo " Temporary default.conf file w/ user Domain"

confcontent="
ServerName $SINGLE_DOMAIN
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
	ServerName $SINGLE_DOMAIN
    SSLEngine on
    SSLCertificateFile \"/config/keys/cert.crt\"
    SSLCertificateKeyFile \"/config/keys/cert.key\"
  DocumentRoot /config/www/

    <Directory \"/config/www/\">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
            Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>

"

    echo "$confcontent" > /config/apache/site-confs/default.conf
	echo "File Created" > /config/apache/site-confs/dont-erase.txt
	
	appendconf="updateme"

echo " Done"
echo "================================================"
fi


# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ ! -f /usr/bin/certbot-auto ]; then

	echo "================================================"
	echo " Getting Necessary LetEncrypt Dependencies"
	echo "================================================"
	cd /usr/bin/
	wget https://dl.eff.org/certbot-auto
	chmod a+x /usr/bin/certbot-auto
	apt-get update
	certbot-auto --noninteractive --os-packages-only
	
	echo "================================================"
	echo " FINISHED! Getting LetEncrypt Dependencies"
	echo "================================================"
fi

if [ ! -f /etc/letsencrypt/cli.ini ]; then
	echo "================================================"
	echo " Creating cli.ini file w/ user Domain"

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
authenticator = apache
#webroot-path = /config/www

	"
	echo "$clicontent" > /etc/letsencrypt/cli.ini
	

	echo " Done"
	echo "================================================" 
fi

echo " "
echo "======================================================="
echo " Generating/Renewing SSL Certificates from LetEncrypt"
echo "    domain(s): $YOUR_DOMAIN "
echo "    email: $YOUR_EMAIL "
echo "======================================================="
echo " "

certbot-auto certonly --noninteractive --agree-tos
chmod -R 777 /etc/letsencrypt/

if [ "$appendconf" = "updateme" ]; then
echo " "
echo "======================================================="
echo " FINAL! Appending default.conf w/ proper certificates"
finalconf="
ServerName $SINGLE_DOMAIN
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
    ServerName $SINGLE_DOMAIN
	
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
	echo "$finalconf" > /config/apache/site-confs/default.conf
	appendconf="donotupdate"
	echo " Done"
	echo "======================================================="	
fi

if [ ! -f /config/crons.conf ]; then

	echo " "
	echo "========================================="
	echo " No existing Cron file found. "
	echo " Adding file and creating cron job"
	echo "========================================="
	cp /root/crons.conf /config/crons.conf
	cp /root/sample-default.conf /config/sample-default.conf
	crontab /config/crons.conf
	crontab -l
	echo "========================================="
	echo " "
else
	echo " "
	echo "========================================="
	echo " Crontab file found. Adding cron job"
	echo "========================================="
	crontab /config/crons.conf
	crontab -l
	echo "========================================="
	echo " "
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