#!/bin/bash

# Create a new user and set password
sudo adduser user --gecos "Github User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo 'user:password' | sudo chpasswd

# Add user 'abdullah' to the sudo group
sudo usermod -aG sudo,adm user

# Update and install required packages
sudo apt update 
sudo apt install -y xfce4 xfce4-goodies xfonts-base xubuntu-icon-theme xubuntu-wallpapers gnome-icon-theme x11-apps x11-common x11-session-utils x11-utils x11-xserver-utils x11-xkb-utils dbus-user-session dbus-x11 gnome-system-monitor gnome-control-center libpam0g libxt6 libxext6 jq
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt -f install

# Install TurboVNC
wget https://ufpr.dl.sourceforge.net/project/turbovnc/2.2.5/turbovnc_2.2.5_amd64.deb
sudo dpkg -i turbovnc_2.2.5_amd64.deb

# Switch to the new user in the subshell
sudo -u user bash << EOF

# Prepare VNC environment
mkdir ~/.vnc

# Create the xstartup script
echo '#!/bin/bash' > ~/.vnc/xstartup.turbovnc
echo 'dbus-launch /usr/bin/startxfce4 &' >> ~/.vnc/xstartup.turbovnc
chmod +x ~/.vnc/xstartup.turbovnc

# Set the VNC password
echo password | /opt/TurboVNC/bin/vncpasswd -f > ~/.vnc/passwd
chmod 0600 ~/.vnc/passwd

# Start the VNC server
/opt/TurboVNC/bin/vncserver :1 -geometry 1280x720 -depth 16 -rfbport 7582

EOF
