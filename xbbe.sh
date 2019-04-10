#!/usr/bin/env bash

set -xe

# Check for rsync, less and parted, install if needed:
hash less 2>/dev/null || sudo apt-get install -yyq less
hash parted 2>/dev/null || sudo apt-get install -yyq parted
hash rsync 2>/dev/null || sudo apt-get install -yyq rsync

# setup constants
XBTDRIVE=/media/"$USER"/XBT_Drive/
BACKUPDRIVE=$XBTDRIVE/XBT_Backups/
HOSTDIR=$BACKUPDRIVE/"$HOSTNAME"/
HOMEBACKUPDIR=$HOSTDIR/Home_Backup/
ETCBACKUPDIR=$HOSTDIR/Etc_Backup/
RSYNC="sudo rsync -aHv --delete --progress"
DATETIME="$(date)"

function help() {
clear
less << _EOF_
XBT -- External Backup Tool -- Help
(v. 3.0)
Press "q" to exit this Help page and return to Main Menu.
Commands:
xbt = Starts XBT program with menu options.
xbt --backup = Fully backs up host's /etc and /home directories to XBT_Drive.
xbt --restore = Fully restores host machine's /home directory from XBT_Drive.
xbt --help = Prints this help information.
xbt --log = Prints log from XBT drive in interactive viewer. ("q" to exit.)
_EOF_
# Exit if running from command line:
if [ "$mode" == "CLI" ]; then
    exit
fi
}

function log() {
# XBT Log Viewer. Shows the log file with less.
# Check for valid media and log file:
if [ ! -f $LOGFILE ]; then
    # Check for log file and return to Main Menu with error if not found:
    clear
    echo $'\n'$"XBT Log Viewer"
    echo "XBT Error: No log file found. Make sure XBT_Drive USB is connected."
    echo "Note: The log is generated during the first XBT Backup."
fi
# Load log file into less:
# "less +G" opens file and scrolls to end."
less +G $LOGFILE
clear
# Exit if running from command line:
if [ "$mode" == "CLI" ]; then
    exit
fi
}
#main loop
while :
do
    clear
    cat << _EOF_
XBT -- External Backup Tool (Version 3.0)
Main Menu: What would you like to do?
Press the number of your choice:
    1 - Backup.
    2 - Restore.
    3 - Setup XBT Drive.
    4 - Help
    5 - View Log. ('q' exits.)
    0 - Exit XBT.
_EOF_
read -r -n 1 -s choice;
    case "$choice" in
        1) backup;;
        2) restore;;
        3) setup_drive;;
        4) help;;
        5) log;;
        0) clear;echo $'\n'$"Exiting XBT... Goodbye!";sleep 2;tput cnorm;exit;;
        *) echo "Not a valid choice: Please try again.";;
    esac
    sleep 1
done
