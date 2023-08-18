#! bin/bash

sudo useradd -e $(date -d "+2 weeks" +%Y-%m-%d) -p '*' -g altschool -m -c "Alternative School User" altschool_user
sudo passwd -e altschool_user

sudo visudo


%altschool ALL=(ALL) /bin/cat /etc/*


sudo useradd -M -s /bin/bash -c "No Home User" no_home_user
