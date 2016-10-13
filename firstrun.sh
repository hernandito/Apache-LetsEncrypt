#!/bin/bash
if [ ! -f /root/userscript.sh ]; then
	mv /root/userscript.sh /config/userscript.sh
	mv /root/crons.conf /config/crons.conf	
	bash /config/userscript.sh
fi
crontab /config/crons.conf
crontab -l

	
	


