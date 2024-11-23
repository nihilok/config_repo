#!/usr/bin/env python3

import os
import sys


ADD_OR_REPLACE = """\
#!/bin/bash

file="/etc/ssh/sshd_config"

# Function to add or replace a pattern
add_or_replace() {
    local pattern="$1"
    local replacement="$2"
    if grep -q "^${pattern}" "$file"; then
        sudo sed -i "s/^${pattern}.*/${replacement}/" "$file"
    else
        echo "$replacement" | sudo tee -a "$file" > /dev/null
    fi
}

add_or_replace "UsePAM" "UsePAM no"
add_or_replace "ChallengeResponseAuthentication" "ChallengeResponseAuthentication no"
add_or_replace "PasswordAuthentication" "PasswordAuthentication no"
add_or_replace "PermitRootLogin" "PermitRootLogin no"
"""


def disable_password_authentication():
    print("Disabling password authentication...")
    backup_file = "/etc/ssh/sshd_config.bak"
    os.system(f"sudo cp /etc/ssh/sshd_config {backup_file}")
    with open("add_or_replace.sh", "w") as f:
        f.write(ADD_OR_REPLACE)
    os.system("sudo chmod +x add_or_replace.sh")
    os.system("sudo ./add_or_replace.sh")
    os.remove("add_or_replace.sh")
    os.system("sudo systemctl restart sshd")
    os.system("sudo systemctl restart ssh")
    print("Password authentication disabled. Old sshd_config file backed up to", backup_file)


def server_setup():
    print("Setting up server...")
    os.system("sudo apt-get update")
    os.system("sudo apt-get install -y python3-venv")
    os.system("sudo apt-get install -y git")
    os.system("sudo apt-get install -y nginx")
    os.system("sudo rm /etc/nginx/sites-enabled/default")
    os.system("sudo rm /etc/nginx/sites-available/default")
    with open("/etc/nginx/sites-available/default", "w") as f:
        f.write("""\
server {
    listen 80;
    server_name app.com;
    root /var/www/app.com;

    location / {
        try_files $uri $uri/ =404;
    }
}

server {
    listen 80;
    server_name api.com
    location / {
        proxy_pass http://localhost:8000;
        include /etc/nginx/proxy_params;        
        proxy_redirect off;
    }
}
""")
    os.system("sudo apt-get install -y certbot")
    os.system("sudo apt-get install -y ufw")
    os.system("sudo ufw allow OpenSSH")
    os.system("sudo ufw allow 'Nginx Full'")
    os.system("sudo ufw enable")
    os.system("sudo systemctl start nginx")
    os.system("sudo systemctl enable nginx")
    os.system("sudo apt-get install -y fail2ban")
    os.system("sudo systemctl start fail2ban")
    os.system("sudo systemctl enable fail2ban")

    if input("Disable password authentication for SSH? (y/N): ").lower() == "y":
        disable_password_authentication()
    print("Server setup complete.")

if __name__ == "__main__":
    server_setup()
