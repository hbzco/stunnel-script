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

display_menu() {
    clear
    echo -e "\e[1;32m********************************************\e[0m"
    echo -e "\e[1;32m*         Stunnel Configuration Menu       *\e[0m"
     echo -e "\e[1;32m*                  HBZ_CO                 *\e[0m"
    echo -e "\e[1;32m********************************************\e[0m"
    echo -e "1) \e[1;36mInstall and create port forwarder to external server\e[0m"
    echo -e "2) \e[1;36mAdd IranVPS port to forward to external server\e[0m"
    echo -e "3) \e[1;36mInstall and create secure connection to external server for connecting to Iranian server\e[0m"
    echo -e "4) \e[1;36mAdd a port on the foreign server to connect to the Iranian server\e[0m"
    echo -e "5) \e[1;34mVisit GitHub Repository\e[0m"
    echo -e "6) \e[1;33mHelp and Documentation\e[0m"
    echo -e "7) \e[1;33mUser Guide\e[0m"
    echo -e "0) \e[1;31mExit\e[0m"
    echo
    read -p "Please select an option: " choice

    case "$choice" in
        1) create_stunnel_iran_vps ;;
        2) add__stunnel_iran_vps ;;
        3) create_stunnel_khareji ;;
        4) add_stunnel_khareji ;;
        5) open_github_repository ;;
        6) about_script ;;
        7) show_user_guide ;;
        0) exit ;;
        *) echo -e "\e[1;31mInvalid choice. Please select a valid option.\e[0m" ;;
    esac
}


about_script() {

    echo -e "\e[1;32m********************************************\e[0m"
    echo -e "\e[1;32m           About Script                     \e[0m"
    echo -e "\e[1;32m********************************************\e[0m"
    echo
    echo -e  "Stunnel (Secure Tunnel) is an open-source software designed for establishing secure (SSL/TLS) connections between two servers or two clients. The primary uses of Stunnel include:

Secure Server Connections (Server-side SSL/TLS): Stunnel allows servers to easily accept and manage secure SSL/TLS connections. This is highly useful for protecting sensitive information transmitted to the server, such as passwords or financial data.

Secure Port Forwarding: With Stunnel, a regular port can be converted into a secure port, enabling a secure connection between two systems. This is valuable when there's a need for secure communication to transfer data from one system to another.

SSL/TLS Certificate Management: Stunnel provides the capability to manage SSL/TLS certificates. It allows servers to obtain and manage SSL/TLS certificates to ensure secure communications.

VPN Implementation (Virtual Private Network): Stunnel can be used as part of creating a Virtual Private Network (VPN) using SSL/TLS protocols. This enables users to securely access a network remotely.

In essence, Stunnel is a useful tool for enhancing the security of communications between two servers or two clients, and it is used as a fundamental technology for establishing secure communications in various networks. To use this script, follow these steps:

Save the Bash script in a file with the .sh extension, for example, stunnel_setup.sh.

Make the file executable with the following command:

chmod +x stunnel.sh

Run the script:

./stunnel.sh

Your script will start executing and, with the help of prompts and inputs it requests from you, will create the necessary secure tunnels.

As a recommendation, make sure to use this script in development and testing environments, and enter input details accurately to ensure the proper creation of secure tunnels and troubleshooting. Additionally, avoid using it in a production environment to connect to critical servers and make changes there to prevent any issues in a production environment."

   read -p "Press Enter to return to the main menu..." enter
   display_menu

}


open_github_repository() {

    clear
    echo -e "\e[1;32m********************************************\e[0m"
    echo -e "\e[1;32m              GitHup                        \e[0m"
    echo -e "\e[1;32m********************************************\e[0m"
    echo
    echo -e "https://github.com/hbzco/stunnel-script/tree/main"
	read -p "Press Enter to return to the main menu..." enter
   display_menu
}

show_user_guide() {
    clear
    echo -e "\e[1;32m********************************************\e[0m"
    echo -e "\e[1;32m              User Guide                     \e[0m"
    echo -e "\e[1;32m********************************************\e[0m"
    # Add your user guide content here
    echo "This is the user guide for the Stunnel script."
    echo "Please refer to the documentation for detailed instructions."
    echo
    read -p "Press Enter to return to the main menu..." enter
    display_menu
}
# Implement other functions (create_stunnel_iran_vps, open_github_repository, etc.) as needed
display_menu
