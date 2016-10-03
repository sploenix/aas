#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

requireNonRoot
requireIsArch

# handle script parameters
for (( i=1; i<=$#; i++))
do
	# show help
	case ${!i} in
		"-h"|"--help")
			echo -e "${BGreen}$0 - System management script for arch linux${COff}\n"
			echo -e "How to use this script:"
			echo -e "$0 [option1] [option2] [...]\n"
			echo -e "  -h, --help  : Print this help"
			echo -e "  -a, --auto  : Automatic mode - no questions"
			echo -e "  -nx, --nox  : Manage text mode installation"
			echo -e "  -t, --tet \"additional parameters\"\n              : Enable special scripts for TET and give additional parameters (optional)"
			kill -s TERM $TOP_PID
			;;
		# automatic mode, no user interaction
		"-a"|"--auto")
			AUTORUN=true
			sysMessage "Running in automatic mode..."
			;;
		# Manage text mode installation
		"-nx"|"--nox")
			NOX=true
			sysMessage "Ignoring graphics specific parts of script..."
			;;
		# special flag for running TET-specific script
		"-t"|"--tet")
			TET=true
			sysMessage "Enabling extra parts for tet..."
			j=$((i+1))
			TET_PARAMS=${!j}
			;;
		*)
			error "No such parameter ${!i}"
	esac
done

[ ! "$NOX" ] && {
	# call script to setup package system
	$SCRIPTPATH/setup_package_system.sh

	# Setup printing system
	! systemdIsRunning org.cups.cupsd && {
		sysMessage "Installing and enabling printing system..."
		$SCRIPTPATH/setup_printing.sh
	}

	# Enable GDM
	! systemdIsRunning gdm && {
		sysMessage "Enabling autostart of GDM (Gnome Display Manager)..."
		systemdEnable gdm
	}
} || $SCRIPTPATH/setup_package_system.sh --nox

# Enable rc.local compatibility
[ ! -f /etc/rc.local ] && {
	sysMessage "Enabling rc.local compatibility"
	sudo touch /etc/rc.local
	echo -e "#!/bin/sh\n\n# put your local startup scripts after this comment" | sudo tee -a /etc/rc.local
	sudo chmod +x /etc/rc.local
}
CFG=/etc/systemd/system/rc-local.service
[[ ! -f $CFG || -n `diff $CFG $BASEDIR$CFG` ]] && {
	sysMessage "Creating/Updating systemd service file for rc.local compatibility..."
	sudo cp -f $BASEDIR$CFG $CFG
	sudo chmod +x $CFG
	sudo systemctl daemon-reload
}
systemdEnable rc-local

exit
#[ -z "`cat $PAMLOGINFILE | grep 'pam_mkhomedir'`" ] && {
#	sysMessage "Enabling automatic creation of home directory..."
#  echo "session    required   pam_mkhomedir.so skel=/etc/skel umask=0022" >> $PAMLOGINFILE
#}

[ -n "$TET" ] && {
	sysMessage "Running TET script..."
	$BASEDIR/TET/scripts/manage-system-tet.sh GO $TET_PARAMS
}
