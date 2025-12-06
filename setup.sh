#!/bin/bash
 
# Install Telethon (optional for future bot use)
pip install telethon &>/dev/null &
 
# Set debconf for Postfix
echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections
echo "postfix postfix/mailname string localhost" | sudo debconf-set-selections
 
# Update & install Postfix
sudo apt-get update -yqq
sudo apt-get install -y postfix mailutils nano
 
# Remove default config
sudo rm -f /etc/postfix/main.cf
 
sudo tee /etc/postfix/main.cf > /dev/null <<'EOL'
# Force external delivery
inet_interfaces = loopback-only
myhostname = localhost
mydomain = localdomain
myorigin = $myhostname
 
# NEVER accept local mail
mydestination = 
 
# Allow relay for all
relayhost =
local_transport = error:local delivery disabled
unknown_local_recipient_reject_code = 550
 
# Queue & performance
queue_directory = /var/spool/postfix
command_directory = /usr/sbin
daemon_directory = /usr/lib/postfix/sbin
mailbox_size_limit = 0
recipient_delimiter = +
EOL
 
# Restart Postfix
sudo service postfix restart
echo "✅ Postfix configured and running"

