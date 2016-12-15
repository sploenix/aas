#!/bin/bash

# load arch specific functions
source $FunctionsDir/arch_functions.sh

# script must not be run as root
requireNonRoot

SysConfDir=/etc/aas
AasPkgConfDir=$SysConfDir/packageConfiguration

# create AAS package configuration directory
[ ! -d $AasPkgConfDir ] && {
	sysMessage "Creating directory $AasPkgConfDir"
	sudo mkdir $AasPkgConfDir
	[ ! -d $AasPkgConfDir ] && {
		error "Could not create directory $AasPkgConfDir"
		exit 1
	}
}

# copy base package setup
for file in `ls $BaseDir/samplePackageConfigurations`
do
	[ ! -f $AasPkgConfDir/$file ] && sudo cp $BaseDir/samplePackageConfigurations/$file $AasPkgConfDir
done

# handle script parameters
for (( i=1; i<=$#; i++))
do
	# show help
	case ${!i} in
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
		*)
			error "No such parameter ${!i}"
	esac
done

# check if reflector is installed
[ ! -f /usr/bin/reflector ] && {
	sysMessage "Installing packages reflector and rsync..."
	archInstallAsNeeded reflector rsync
	# check if installation was successful
	[ -f "/usr/bin/reflector" ] && okMessage "Installation OK" || error "Installation Failed"
}

# new mirror list is only created if it is older than one day
fileIsRecent /etc/pacman.d/mirrorlist && {
	# generate new pacman mirror list
	sysMessage "Getting new mirrorlist..."
	sudo reflector --country 'Germany' -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
}

# verify that pacaur is installed
! pkgIsInstalled pacaur && $ScriptDir/install_pacaur.sh

# only run if updates are pending
[ -n "`checkupdates`" ] && {
	# check if grub or kernel can be updated, as this requires updating the boot loader
	if [ -n "`checkupdates | grep 'grub '`" ] || [ -n "`checkupdates | grep 'linux '`" ]; then
		sysMessage "Need to reinstall boot loader after system update..."
		UPDATE_GRUB=true
	fi

	# update package lists and upgrade system (official repos)
	sysMessage "Getting new package lists and upgrading system..."
	sudo pacman -Syu --noconfirm --color always

	[ "$UPDATE_GRUB" ] && $ScriptDir/setupGrub.sh
}

# check if package checkupdates-aur is installed
! pkgIsInstalled checkupdates-aur && {
	sysMessage -n "Installing package checkupdates-aur ... "
	archInstallAsNeeded "checkupdates-aur"
	# recheck installation status
	pkgIsInstalled checkupdates-aur && okMessage "OK" || error "Failed"
}

# only run if updates are pending
[ -n "`checkupdates-aur`" ] && {
	# update package lists and upgrade system
	sysMessage "Upgrading AUR packages..."
	pacaur -Syu --aur --noconfirm --noedit --silent
	# recheck pending updates
	# some packages have pgp verification issues, these packages will be build manually
	[ -n "`checkupdates-aur`" ] && {
		PKGLIST=`checkupdates-aur | awk '{print $1}'`
		for i in $PKGLIST; do
			manualBuildFromAUR $i
		done
	}
}

# install missing packages from official repositories
sysMessage "Installing missing packages from official repositories..."
archInstallAsNeeded $AasPkgConfDir/base_pkg_official.txt

# install missing packages from AUR
[ -n "`cat $AasPkgConfDir/base_pkg_aur.txt`" ] && {
	sysMessage "Compiling missing packages from AUR..."
	! archInstallAsNeeded $AasPkgConfDir/base_pkg_aur.txt && error "MIST"
}

[ ! "$NOX" ] && {
	sysMessage "Installing missing packages for GNOME environment..."
	archInstallAsNeeded $AasPkgConfDir/gnome_environment.txt
}

# reload systemd scripts
sysMessage "Reloading systemd scripts..."
sudo systemctl daemon-reload

# update spamassassin rules
sysMessage "Updating Spamassassin rules..."
sudo sa-update

exit 0
