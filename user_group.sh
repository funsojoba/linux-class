#!/bin/bash


# create three groups, admin, support & engineering and add the admin group to sudoers.
# Create a user in each of the groups.
# Generate SSH keys for the user in the admin group

root_user="root"



groupadd admin
groupadd support
groupadd engineering

usermod -G sudo admin


useradd admin_user:admin
useradd support_user:support
useradd engineering_user:engineering


# generate SSH key for admin_user
sudo -u admin_user ssh-keygen
