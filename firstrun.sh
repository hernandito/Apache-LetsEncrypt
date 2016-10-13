#!/bin/bash

export HOME="/root"


if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "Setting the correct time"
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/fpm/php.ini
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/cli/php.ini
fi

cp /root/userscript.sh /config/userscript.sh

cd /config
userscript.sh


#if [ ! -f /root/userscript.sh ]; then
#	mv /root/userscript.sh /config/userscript.sh
#	mv /root/crons.conf /config/crons.conf	
#	bash /config/userscript.sh
#fi
#crontab /config/crons.conf
#crontab -l

	
	


