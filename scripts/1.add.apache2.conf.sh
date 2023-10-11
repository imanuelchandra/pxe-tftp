!/bin/bash

tftpd="/config/tftpd/tftpd-hpa"

if [ ! -r "$tftpd" ]; then
    echo "Please ensure '$tftpd' exists and is readable."
    exit 1
else
    sudo rm /etc/default/tftpd-hpa
    sudo cp $tftpd /etc/default/tftpd-hpa
    echo "===================================\n"
    echo "File /etc/default/tftpd-hpa\n"
    echo "===================================\n"
    sudo cat /etc/default/tftpd-hpa
    echo "\n"
fi