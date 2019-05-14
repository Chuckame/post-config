#!/usr/bin/env bash
#
# Post-installation Configuration Scripts
#
# OVH-specific actions for Debian based hosts
# - Fix locales
# - Fix domain
# - Install base packages
# - Set cool root prompt
# - Set sshd config (set port & force pubkey connection > only root authorized)


TIME_ZONE=Europe/Paris

fix_locales () {
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
  
  cat <<EOF > /etc/default/locale
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
EOF
  
  dpkg-reconfigure --frontend=noninteractive locales
  
  rm /etc/localtime
  ln -s /usr/share/zoneinfo/$TIME_ZONE /etc/localtime
  dpkg-reconfigure --frontend noninteractive tzdata
}


SSH_PORT=7777

do_upgrade () {
  apt-get --assume-yes update
  apt-get --assume-yes upgrade
  apt-get --assume-yes dist-upgrade
}


install_base_packages () {
  apt-get --assume-yes install sudo tmux bash-completion ca-certificates
  apt-get --assume-yes install git lm-sensors nano
}

set_prompt () {
  cat >> /root/.bashrc <<EOF
PS1="\n\
┌ \e[0;91m\${?}\e[0m ─ \e[0;31m\t\e[0m ─ \e[0;32m\u\e[0m@\e[0;94m\h\e[0m\n\
│\e[0;33m\${PWD}\e[0m\n\
└ "
PS2="\
└ "
alias rm='rm -I'
alias l='ls -la --color=always -p --time-style="+%Y:%m:%d-%H%M%S%-:::z"'
alias upd='apt-get update'
alias upg='apt-get upgrade && apt-get dist-upgrade'
alias upda='upd && upg'
alias ..='cd ..'
EOF
}

set_sshd_conf () {
  cat > /etc/ssh/sshd_config <<EOF
PermitRootLogin without-password
#  Turn on privilege separation
UsePrivilegeSeparation yes
# Prevent the use of insecure home directory and key file permissions
StrictModes yes
# Do you need port forwarding?
AllowTcpForwarding no
X11Forwarding no
#  Specifies whether password authentication is allowed.  The default is yes.
PasswordAuthentication no
UsePAM yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
AllowUsers root
HostbasedAuthentication no
Port $SSH_PORT
Protocol 2
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
ClientAliveInterval 30
ClientAliveCountMax 0
IgnoreRhosts yes
PermitEmptyPasswords no
PubkeyAuthentication yes
PrintMotd no
PrintLastLog yes
Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160
KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1
EOF

	service sshd restart
}

main () {
  fix_locales
	do_upgrade
	install_base_packages
	set_prompt
	set_sshd_conf
  touch minimal_install_done
}

main
