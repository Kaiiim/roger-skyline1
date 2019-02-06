#!/bin/bash

if [ -e /root/crontab_save_check ]
then
	md5sum /etc/crontab > /tmp/crontab_check
	diff -q /tmp/crontab_check /root/crontab_save_check
	if [ $? -ne 0 ]
	then
		echo 'Le fichier /etc/crontab a ete modifie' | senmail root
		md5sum /etc/crontab >> /root/crontab_save_check
	fi
else
	md5sum /etc/crontab > /root/crontab_save_check
fi
