ret_path=`pwd` && cd ~/.remmina && ls -t `grep -li "username=USER@DOMAIN.COM" *.remmina` | grep -m 2 "^.*$" | xargs sed -nr 's/(password=)(.*)/\2/p' | xargs bash -c 'sed -i s/$1/$0/ *.remmina' && cd $ret_pat

#How to use: 
#1. Put your username in place of USER@DOMAIN.COM 
#2. Change a password in the one connection profile. 
#3. Run the one-liner.
#
# How it works? The command set sorts by modification time .remmina files with USER@DOMAIN.COM, 
# takes passwords from last updated .remmina connection profile and from another old one, 
# then replaces old passwords with a new one in .remmina files.
