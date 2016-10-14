#!/bin/bash

export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"


if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "Setting the correct time"
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/fpm/php.ini
  sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php5/cli/php.ini
fi

#ln -s /root/userscript.sh /config/userscript.sh
cp /root/userscript.sh /config/userscript.sh
#chmod +x /config/userscript.sh

./config/userscript.sh


#if [ ! -f /root/userscript.sh ]; then
#	mv /root/userscript.sh /config/userscript.sh
#	mv /root/crons.conf /config/crons.conf	
#	bash /config/userscript.sh
#fi
#crontab /config/crons.conf
#crontab -l

	
	


