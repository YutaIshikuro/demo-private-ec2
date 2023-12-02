#!/bin/bash

useradd  dev-user
usermod -aG wheel dev-user
passwd -d dev-user

sed -i /etc/ssh/sshd_config -e 's/^PermitEmptyPasswords.*$/PermitEmptyPasswords yes/g'
sed -i /etc/ssh/sshd_config -e 's/^PasswordAuthentication no$/#PasswordAuthentication no/g'
sed -i /etc/ssh/sshd_config -e 's/^UsePAM yes$/#UsePAM yes/g'
systemctl reload sshd