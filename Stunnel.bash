#!/bin/bash

installing() {

iterations=10
sleep_duration=0.5
animation_chars="|/-\\"
installing_message="Installing"

for ((i = 0; i < iterations; i++)); do

    index=$((i % ${#animation_chars}))
    char="${animation_chars:index:1}"
    printf "\r[%s] %s " "$char" "$installing_message"
    sleep $sleep_duration
done

printf "\r\033[K"
echo "Installation complete!"
}

create_stunnel_khareji() {

read -p "Enter Name stunnel: " Name
read -p "Enter inbund Port From IranVps: " inbund
read -p "Forwad inbund Port To In Server: " forward_port
read -p "Enter Hostname Server: " Hostname

sudo apt install stunnel4 openssl certbot  -y

echo "cert = /etc/stunnel/stunnel.pem
pid = /etc/stunnel/stunnel.pid
output = /etc/stunnel/stunnel.log

["$Name"]
accept = "$inbund"
connect = 0.0.0.0:"$forward_port" " > /etc/stunnel/stunnel.conf

 certbot certonly --standalone -d "$Hostname" --staple-ocsp -m info@"$Hostname" --agree-tos

 cd /etc/letsencrypt/live/$Hostname/
 cat privkey.pem fullchain.pem >> /etc/stunnel/stunnel.pem

 sudo chmod 0400 /etc/stunnel/stunnel.pem

echo "[Unit]
Description=SSL tunnel for network daemons
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
Alias=stunnel.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel /etc/stunnel/stunnel.conf
ExecStop=/usr/bin/pkill stunnel

# Give up if ping don't get an answer
TimeoutSec=600

Restart=always
PrivateTmp=false " > /usr/lib/systemd/system/stunnel.service

        sudo systemctl start stunnel.service
        sudo systemctl enable stunnel.service
        installing
        echo "Create Stunnel $Name With $inbound port From IranVps  With Port $forward_port . :)"
        sleep 3
        display_menu
}

add_stunnel_khareji() {

read -p "Enter Name stunnel: " Name
read -p "Enter inbund Port From IranVps: " inbound
read -p "Forwad inbund Port To In Server: " forward_port

cat << EOF >> /etc/stunnel/stunnel.conf

["$Name"]
accept = "$inbound"
connect = 0.0.0.0:"$forward_port"

EOF
        sudo systemctl restart stunnel.service
        installing
        echo "Add Stunnel $Name With $inbound Port From IranVps  With Port $forward_port . :)"
        sleep 3
        display_menu

}

create_stunnel_iran_vps() {

        read -p "Enter Name stunnel: " Name
        read -p "Enter InBound Port To Server: " inbound
        read -p "Enter Hostname To stunnel Server: " hostname_khareji
        read -p "Enter The Port onnect between Two Server: " port_connect

        sudo apt install stunnel4 openssl certbot -y

echo "pid = /etc/stunnel/stunnel.pid
client = yes
output = /etc/stunnel/stunnel.log

["$Name"]
accept = "$inbound"
connect = "$hostname_khareji":"$port_connect" " > /etc/stunnel/stunnel.conf

echo "[Unit]
Description=SSL tunnel for network daemons
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
Alias=stunnel.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel /etc/stunnel/stunnel.conf
ExecStop=/usr/bin/pkill stunnel

# Give up if ping don't get an answer
TimeoutSec=600

Restart=always
PrivateTmp=false " > /usr/lib/systemd/system/stunnel.service

        sudo systemctl start stunnel.service
        sudo systemctl enable stunnel.service
        installing
        echo "Create Port Forwarder $Name With $inbound port To $hostname_khareji Server With Port $port_connect . :)"
        sleep 3
        display_menu
}

add__stunnel_iran_vps() {


        read -p "Enter Name stunnel: " Name
        read -p "Enter InBound Port To Server: " inbound
        read -p "Enter External Hostname To stunnel Server: " hostname_khareji
        read -p "Enter The Port onnect between Two Server: " port_connect

cat << EOF >> /etc/stunnel/stunnel.conf

["$Name"]
accept = "$inbound"
connect = "$hostname_khareji":"$port_connect"
EOF

        sudo systemctl restart stunnel.service
        installing
        echo "Add Port Forwarder $Name With $inbound port To $hostname_khareji Server With Port $port_connect . :)"
        sleep 3
        display_menu
}
#displaying Menu
display_menu() {
    clear
    echo "Create Stunnel In to IranVps And KharegiVps :)"
    echo "1) Installation and creation of port forwarder to external server "
    echo "2) Add port IranVps to forward to external server "
    echo "3) Install and create stunnel external server to connect to Iranian server "
        echo "4) Add a port on the foreign server to connect to the Iranian server"
        echo "0) Exit"
    echo
    read -p "Enter your choice: " choice

    case "$choice" in
        1) create_stunnel_iran_vps ;;
        2) add__stunnel_iran_vps ;;
                3) create_stunnel_khareji ;;
                4) add_stunnel_khareji ;;
        0) display_menu ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
}

# Start the script by displaying the main menu
display_menu
