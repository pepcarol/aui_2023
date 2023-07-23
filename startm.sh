#!/bin/bash
# FIX THIS ISSUES | NON-ACUTE
#shellcheck disable=SC1001,SC1091,SC2001,SC2010,SC2015,SC2034,SC2104,SC2154
#shellcheck disable=SC2154,SC2153,SC2155,SC2165,SC2167,SC2181,SC2207

: 'ATTENTION!:
--------------------------------------------------
|  Created by helmuthdu <helmuthdu@gmail.com>    |
|  Contributed by flexiondotorg                  |
|  Shellchecked by uniminin <uniminin@zoho.com>  |
|  Formatted by molese <molese@protonmail.com>   |
--------------------------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------
Run this script after your first boot with archlinux (as root)
'

if [[ -f $(pwd)/sharedfuncs ]]; then
	source sharedfuncs
else
	echo "missing file: sharedfuncs"
	exit 1
fi

#ARCHLINUX U INSTALL {{{
#WELCOME {{{
welcome() {
	clear
	echo -e "${Bold}Welcome to the Archlinux U Install script by helmuthdu${White}"
	print_line
	echo "Requirements:"
	echo "-> Archlinux installation"
	echo "-> Run script as root user"
	echo "-> Working internet connection"
	print_line
	echo "Script can be cancelled at any time with CTRL+C"
	print_line
	echo "http://www.github.com/helmuthdu/aui"
	print_line
	echo -e "\nBackups:"
	print_line
	# backup old configs
	[[ ! -f /etc/pacman.conf.aui ]] && cp -v /etc/pacman.conf /etc/pacman.conf.aui || echo "/etc/pacman.conf.aui"
	[[ -f /etc/ssh/sshd_config.aui ]] && echo "/etc/ssh/sshd_conf.aui"
	[[ -f /etc/sudoers.aui ]] && echo "/etc/sudoers.aui"
	pause_function
	echo ""
}
#}}}
#LOCALE SELECTOR {{{
language_selector() {
	#AUTOMATICALLY DETECTS THE SYSTEM LOCALE {{{
	#automatically detects the system language based on your locale
	LOCALE=$(locale | grep LANG | sed 's/LANG=//' | cut -c1-5)
	#KDE #{{{
	if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == zh_CN ]]; then
		LOCALE_KDE=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]')
	else
		LOCALE_KDE=$(echo "$LOCALE" | cut -d\_ -f1)
	fi
	#}}}
	#FIREFOX #{{{
	if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == es_AR || $LOCALE == es_CL || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
		LOCALE_FF=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
	else
		LOCALE_FF=$(echo "$LOCALE" | cut -d\_ -f1)
	fi
	#}}}
	#HUNSPELL #{{{
	if [[ $LOCALE == pt_BR ]]; then
		LOCALE_HS=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
	elif [[ $LOCALE == pt_PT ]]; then
		LOCALE_HS="pt_pt"
	else
		LOCALE_HS=$(echo "$LOCALE" | cut -d\_ -f1)
	fi
	#}}}
	#ASPELL #{{{
	LOCALE_AS=$(echo "$LOCALE" | cut -d\_ -f1)
	#}}}
	#LIBREOFFICE #{{{
	if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == zh_CN ]]; then
		LOCALE_LO=$(echo "$LOCALE" | sed 's/_/-/')
	else
		LOCALE_LO=$(echo "$LOCALE" | cut -d\_ -f1)
	fi
	#}}}
	#}}}
	print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
	print_info "Locales are used in Linux to define which language the user uses. As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
	printf "%s" "Default system language: \"$LOCALE\" [Y/n]: "
	read -r OPTION
	case "$OPTION" in
	"n")
		while [[ $OPTION != y ]]; do
			setlocale
			read_input_text "Confirm locale ($LOCALE)"
		done
		sed -i '/'"${LOCALE}"'/s/^#//' /etc/locale.gen
		locale-gen
		localectl set-locale LANG="${LOCALE_UTF8}"
		#KDE #{{{
		if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == zh_CN ]]; then
			LOCALE_KDE=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]')
		else
			LOCALE_KDE=$(echo "$LOCALE" | cut -d\_ -f1)
		fi
		#}}}
		#FIREFOX #{{{
		if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == es_AR || $LOCALE == es_CL || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
			LOCALE_FF=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
		else
			LOCALE_FF=$(echo "$LOCALE" | cut -d\_ -f1)
		fi
		#}}}
		#HUNSPELL #{{{
		if [[ $LOCALE == pt_BR ]]; then
			LOCALE_HS=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
		elif [[ $LOCALE == pt_PT ]]; then
			LOCALE_HS="pt_pt"
		else
			LOCALE_HS=$(echo "$LOCALE" | cut -d\_ -f1)
		fi
		#}}}
		#ASPELL #{{{
		LOCALE_AS=$(echo "$LOCALE" | cut -d\_ -f1)
		#}}}
		#LIBREOFFICE #{{{
		if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == zh_CN ]]; then
			LOCALE_LO=$(echo "$LOCALE" | sed 's/_/-/')
		else
			LOCALE_LO=$(echo "$LOCALE" | cut -d\_ -f1)
		fi
		#}}}
		;;
	*) ;;

	esac
}
#}}}
#AUR HELPER {{{
choose_aurhelper() {
	print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
	print_info "AUR Helpers are written to make using the Arch User Repository more comfortable."
	print_warning "\tNone of these tools are officially supported by Arch devs."
	aurhelper=("trizen" "yay" "aurman" "aura" "pikaur")
	PS3="$prompt1"
	echo -e "Choose your default AUR helper to install\n"
	select OPT in "${aurhelper[@]}"; do
		case "$REPLY" in
		1)
			if ! is_package_installed "trizen"; then
				package_install "base-devel git perl"
				aui_download_packages "trizen"
				if ! is_package_installed "trizen"; then
					echo "trizen not installed. EXIT now"
					pause_function
					exit 0
				fi
			fi
			AUR_PKG_MANAGER="trizen"
			;;
		2)
			if ! is_package_installed "yay"; then
				package_install "base-devel git go"
				pacman -D --asdeps go
				aui_download_packages "yay"
				if ! is_package_installed "yay"; then
					echo "yay not installed. EXIT now"
					pause_function
					exit 0
				fi
			fi
			AUR_PKG_MANAGER="yay"
			;;
		3)
			if ! is_package_installed "aurman"; then
				package_install "base-devel git expac python pyalpm python-requests python-feedparser python-regex python-dateutil"
				git clone https://github.com/polygamma/aurman.git
				python3 aurman/setup.py install
				rm -rf aurman
				if ! is_package_installed "aurman"; then
					echo "aurman not installed. EXIT now"
					pause_function
					exit 0
				fi
			fi
			AUR_PKG_MANAGER="aurman"
			;;
		4)
			if ! is_package_installed "aura"; then
				package_install "base-devel git stack"
				git clone https://github.com/fosskers/aura.git
				(
					cd aura || exit
					stack install -- aura
				)
				rm -rf aura
				if ! is_package_installed "aura"; then
					echo "aura not installed. EXIT now"
					pause_function
					exit 0
				fi
			fi
			AUR_PKG_MANAGER="aura"
			;;
		5)
			if ! is_package_installed "pikaur"; then
				package_install "base-devel git"
				git clone https://aur.archlinux.org/pikaur.git
				(
					cd pikaur || exit
					makepkg -fsri
				)
				rm -rf pikaur
				if ! is_package_installed "pikaur"; then
					echo "pikaur not installed. EXIT now"
					pause_function
					exit 0
				fi
			fi
			AUR_PKG_MANAGER="pikaur"
			;;
		*)
			invalid_option
			;;
		esac
		[[ -n $OPT ]] && break
	done
	pause_function
}
#}}}
#BASIC SETUP {{{
install_basic_setup() {
	print_title "Instalant programes bàsics"
	package_install "bc rsync mlocate bash-completion pkgstats arch-wiki-lite zip unzip unrar p7zip lzop cpio dosfstools exfat-utils f2fs-tools fuse fuse-exfat mtpfs fzf bat exa lsd gnome-software gnome-tweak-tools gnome-browser-connection nodejs visual-studio-code-bin geany geany-plugins libreoffice-fresh libreoffice-fresh-ca hunspell hunspell-ca aspell aspell-ca btop icoutils wine wine_gecko wine-mono winetricks gimp element-desktop skypeforlinux-stable-bin discord handbrake vlc lollypop gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav libdvdnav libdvdcss cdrdao cdrtools ffmpeg ffmpegthumbnailer ffmpegthumbs steam lutris openra ttf-hack wqy-microhei"
	pause_function
}
# remove gnome games
remove_games_gnome() {
	print_title "Borran jocs Gnome"
	package_remove "aisleriot atomix four-in-a-row five-or-more gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff tali"
	pause_function
}
#Altres
install_java() {
	print_title "Desinstal·lant OpenJDK"
	package_remove "jre{7,8,9,10}-openjdk"
	package_remove "jdk{7,8,9,10}-openjdk"
	aur_package_install "jdk"
	pause_function
}
install_aur_pakages() {
	aur_package_install "dropbox ttf-mac-fonts ttf-ms-fonts"
	pause_function
}
#}}}
#SSH {{{
install_ssh() {
	print_title "SSH - https://wiki.archlinux.org/index.php/Ssh"
	print_info "Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers."
	read_input_text "Install ssh" "$SSH"
	if [[ $OPTION == y ]]; then
		package_install "openssh"
		system_ctl enable sshd
		[[ ! -f /etc/ssh/sshd_config.aui ]] && cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.aui
		#CONFIGURE SSHD_CONF #{{{
		sed -i '/Port 22/s/^#//' /etc/ssh/sshd_config
		sed -i '/Protocol 2/s/^#//' /etc/ssh/sshd_config
		sed -i '/HostKey \/etc\/ssh\/ssh_host_rsa_key/s/^#//' /etc/ssh/sshd_config
		sed -i '/HostKey \/etc\/ssh\/ssh_host_dsa_key/s/^#//' /etc/ssh/sshd_config
		sed -i '/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/s/^#//' /etc/ssh/sshd_config
		sed -i '/KeyRegenerationInterval/s/^#//' /etc/ssh/sshd_config
		sed -i '/ServerKeyBits/s/^#//' /etc/ssh/sshd_config
		sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
		sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
		sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
		sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
		sed -i '/HostbasedAuthentication no/s/^#//' /etc/ssh/sshd_config
		sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
		sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
		sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
		sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
		sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
		sed -i '/AllowTcpForwarding/s/^#//' /etc/ssh/sshd_config
		sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
		sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
		sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
		sed -i -e '/\tX11Forwarding yes/d' /etc/ssh/sshd_config
		sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
		sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
		sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
		sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
		sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
		sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
		sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
		sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
		#}}}
		pause_function
	fi
}
#}}}
#ZSH {{{
install_zsh() {
	print_title "ZSH - https://wiki.archlinux.org/index.php/Zsh"
	print_info "Zsh is a powerful shell that operates as both an interactive shell and as a scripting language interpreter. "
	read_input_text "Install zsh" "$ZSH"
	if [[ $OPTION == y ]]; then
		package_install "zsh"
		read_input_text "Install oh-my-zsh" "$OH_MY_ZSH"
		if [[ $OPTION == y ]]; then
			if [[ -f /home/${username}/.zshrc ]]; then
				read_input_text "Replace current .zshrc file"
				if [[ $OPTION == y ]]; then
					run_as_user "mv /home/${username}/.zshrc /home/${username}/.zshrc.bkp"
					run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
					run_as_user "$EDITOR /home/${username}/.zshrc"
				fi
			else
				run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
				run_as_user "$EDITOR /home/${username}/.zshrc"
			fi
		fi
		pause_function
	fi
}
#}}}
#ZRAM {{{
install_zram() {
	print_title "ZRAM - https://wiki.archlinux.org/index.php/Maximizing_Performance"
	print_info "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
	read_input_text "Install Zram" "$ZRAM"
	if [[ $OPTION == y ]]; then
		aur_package_install "zramswap"
		system_ctl enable zramswap
		pause_function
	fi
}
#}}}
#VIDEO CARDS {{{
create_ramdisk_environment() {
	if [ "$(ls /boot | grep hardened -c)" -gt "0" ]; then
		mkinitcpio -p linux-hardened
	elif [ "$(ls /boot | grep lts -c)" -gt "0" ]; then
		mkinitcpio -p linux-lts
	elif [ "$(ls /boot | grep zen -c)" -gt "0" ]; then
		mkinitcpio -p linux-zen
	else
		mkinitcpio -p linux
	fi
}
install_video_cards() {
	package_install "dmidecode"
	print_title "VIDEO CARD"
	check_vga
	#Virtualbox {{{
	if [[ ${VIDEO_DRIVER} == virtualbox ]]; then
		if [ "$(lspci | grep 'VMware SVGA' -c)" -gt "0" ]; then
			package_install "xf86-video-vmware"
		fi
		if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ] || [ "$(ls /boot | grep zen -c)" -gt "0" ]; then
			package_install "virtualbox-guest-utils mesa-libgl"
		else
			package_install "virtualbox-guest-utils mesa-libgl"
		fi
		add_module "vboxguest vboxsf vboxvideo" "virtualbox-guest"
		add_user_to_group "${username}" vboxsf
		system_ctl enable vboxservice
		create_ramdisk_environment
	#}}}
	#VMware {{{
	elif [[ ${VIDEO_DRIVER} == vmware ]]; then
		package_install "xf86-video-vmware xf86-input-vmmouse"
		if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ] || [ "$(ls /boot | grep zen -c)" -gt "0" ]; then
			aur_package_install "open-vm-tools-dkms"
		else
			package_install "open-vm-tools"
		fi
		cat /proc/version >/etc/arch-release
		system_ctl enable vmtoolsd
		create_ramdisk_environment
	#}}}
	#Optimus {{{
	elif [[ ${VIDEO_DRIVER} == optimus ]]; then
		XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
		[[ -n $XF86_DRIVERS ]] && pacman -Rcsn "$XF86_DRIVERS"
		read_input_text "Use NVIDIA PRIME Render Offload instead of Bumblebee?" "$BUMBLEBEE"
		if [[ $OPTION == y ]]; then
			package_install "nvidia nvidia-utils libglvnd nvidia-prime"
			package_install "mesa mesa-libgl libvdpau-va-gl"
			[[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-virtualgl lib32-nvidia-utils
			replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
			replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
			create_ramdisk_environment
		else
			pacman -S --needed xf86-video-intel bumblebee nvidia
			[[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-virtualgl lib32-nvidia-utils
			replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
			replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
			create_ramdisk_environment
			add_user_to_group "${username}" bumblebee
		fi
	#}}}
	#NVIDIA {{{
	elif [[ ${VIDEO_DRIVER} == nvidia ]]; then
		XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
		[[ -n $XF86_DRIVERS ]] && pacman -Rcsn "$XF86_DRIVERS"
		if [ "$(ls /boot | grep hardened -c)" -gt "0" ] || [ "$(ls /boot | grep lts -c)" -gt "0" ] || [ "$(ls /boot | grep zen -c)" -gt "0" ]; then
			package_install "nvidia-dkms nvidia-utils libglvnd"
			echo "Do not forget to make a mkinitcpio every time you updated the nvidia driver!"
		else
			package_install "nvidia nvidia-utils libglvnd"
		fi
		[[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-nvidia-utils
		replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
		replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
		create_ramdisk_environment
		nvidia-xconfig --add-argb-glx-visuals --allow-glx-with-composite --composite --render-accel -o /etc/X11/xorg.conf.d/20-nvidia.conf
	#}}}
	#Nouveau [NVIDIA] {{{
	elif [[ ${VIDEO_DRIVER} == nouveau ]]; then
		is_package_installed "nvidia" && pacman -Rdds --noconfirm nvidia{,-utils}
		[[ ${ARCHI} == x86_64 ]] && is_package_installed "lib32-nvidia-utils" && pacman -Rdds --noconfirm lib32-nvidia-utils
		[[ -f /etc/X11/xorg.conf.d/20-nvidia.conf ]] && rm /etc/X11/xorg.conf.d/20-nvidia.conf
		package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
		replace_line '#*options nouveau modeset=1' 'options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
		replace_line '#*MODULES="nouveau"' 'MODULES="nouveau"' /etc/mkinitcpio.conf
		create_ramdisk_environment
	#}}}
	#ATI {{{
	elif [[ ${VIDEO_DRIVER} == ati ]]; then
		[[ -f /etc/X11/xorg.conf.d/20-radeon.conf ]] && rm /etc/X11/xorg.conf.d/20-radeon.conf
		[[ -f /etc/X11/xorg.conf ]] && rm /etc/X11/xorg.conf
		package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl mesa-vdpau libvdpau-va-gl"
		add_module "radeon" "ati"
		create_ramdisk_environment
	#}}}
	#AMDGPU {{{
	elif [[ ${VIDEO_DRIVER} == amdgpu ]]; then
		[[ -f /etc/X11/xorg.conf.d/20-radeon.conf ]] && rm /etc/X11/xorg.conf.d/20-radeon.conf
		[[ -f /etc/X11/xorg.conf ]] && rm /etc/X11/xorg.conf
		package_install "xf86-video-${VIDEO_DRIVER} vulkan-radeon mesa-libgl mesa-vdpau libvdpau-va-gl"
		add_module "amdgpu radeon" "ati"
		create_ramdisk_environment
	#}}}
	#Intel {{{
	elif [[ ${VIDEO_DRIVER} == intel ]]; then
		package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
	#}}}
	#Vesa {{{
	else
		package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
	fi
	#}}}
	if [[ ${ARCHI} == x86_64 ]]; then
		is_package_installed "mesa-libgl" && package_install "lib32-mesa-libgl"
		is_package_installed "mesa-vdpau" && package_install "lib32-mesa-vdpau"
	fi
	if is_package_installed "libvdpau-va-gl"; then
		add_line "export VDPAU_DRIVER=va_gl" "/etc/profile"
	fi
	pause_function
}
#}}}
#CUPS {{{
install_cups() {
	print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
	print_info "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS X and other UNIX-like operating systems."
	read_input_text "Install CUPS (aka Common Unix Printing System)" "$CUPS"
	if [[ $OPTION == y ]]; then
		package_install "cups cups-pdf"
		package_install "gutenprint ghostscript gsfonts foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds"
		system_ctl enable org.cups.cupsd.service
		pause_function
	fi
}	#COMMON PKGS {{{
	#MTP SUPPORT {{{
	if is_package_installed "libmtp"; then
		package_install "gvfs-mtp"
	fi
	#}}}
	if [[ ${KDE} -eq 0 ]]; then
		package_install "gvfs gvfs-goa gvfs-afc gvfs-mtp gvfs-google"
		package_install "xdg-user-dirs-gtk"
		package_install "pavucontrol"
		package_install "ttf-bitstream-vera ttf-dejavu"
		is_package_installed "cups" && package_install "system-config-printer gtk3-print-backends"
		is_package_installed "samba" && package_install "gvfs-smb"
	fi
	#}}}
	#COMMON CONFIG {{{
	# speed up application startup
	mkdir -p ~/.compose-cache
	# D-Bus interface for user account query and manipulation
	system_ctl enable accounts-daemon
	# Improvements
	add_line "fs.inotify.max_user_watches = 524288" "/etc/sysctl.d/99-sysctl.conf"
	#}}}
}
#}}}
#CONNMAN/NETWORKMANAGER/WICD {{{
install_nm_wicd() {
	print_title "NETWORK MANAGER"
	echo " 1) Networkmanager"
	echo " 2) Wicd"
	echo " 3) ConnMan"
	echo ""
	echo " n) NONE"
	echo ""
	read_input "$NETWORKMANAGER"
	case "$OPTION" in
	1)
		print_title "NETWORKMANAGER - https://wiki.archlinux.org/index.php/Networkmanager"
		print_info "NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
		package_install "networkmanager dnsmasq networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc"
		if [[ ${KDE} -eq 1 ]]; then
			package_install "plasma-nm"
		elif [[ ${GNOME} -eq 0 ]]; then
			package_install "network-manager-applet nm-connection-editor gnome-keyring"
		fi
		# network management daemon
		system_ctl enable NetworkManager.service
		pause_function
		;;
	2)
		print_title "WICD - https://wiki.archlinux.org/index.php/Wicd"
		print_info "Wicd is a network connection manager that can manage wireless and wired interfaces, similar and an alternative to NetworkManager."
		if [[ ${KDE} -eq 1 ]]; then
			echo "KDE unsupported. Installing CLI and curses versions only."
			package_install "wicd"
		else
			package_install "wicd wicd-gtk"
		fi
		# WICD daemon
		system_ctl enable wicd.service
		pause_function
		;;
	3)
		print_title "CONNMAN - https://wiki.archlinux.org/index.php/Connman"
		print_info "ConnMan is an alternative to NetworkManager and Wicd and was created by Intel and the Moblin project for use with embedded devices."
		package_install "connman"
		# ConnMan daemon
		system_ctl enable connman.service
		pause_function
		;;
	esac
}
#}}}
#BLUETOOTH {{{
install_bluetooth() {
	print_title "BLUETOOTH - https://wiki.archlinux.org/index.php/Bluetooth"
	print_info "Bluetooth is a standard for the short-range wireless interconnection of cellular phones, computers, and other electronic devices. In Linux, the canonical implementation of the Bluetooth protocol stack is BlueZ"
	read_input_text "Install bluetooth support" "$BLUETOOTH"
	if [[ $OPTION == y ]]; then
		package_install "bluez bluez-utils"
		system_ctl enable bluetooth.service
		pause_function
	fi
}
#}}}
#FINISH {{{
finish() {
	print_title "WARNING: PACKAGES INSTALLED FROM AUR"
	print_danger "List of packages not officially supported that may kill your cat:"
	pause_function
	AUR_PKG_LIST="${AUI_DIR}/aur_pkg_list.log"
	pacman -Qm | awk '{print $1}' >"$AUR_PKG_LIST"
	less "$AUR_PKG_LIST"
	print_title "INSTALL COMPLETED"
	echo -e "Thanks for using the Archlinux Ultimate Install script by helmuthdu\n"
	#REBOOT
	printf "%s" "Reboot your system [y/N]: "
	read -r OPTION
	[[ $OPTION == y ]] && reboot
	exit 0
}
#}}}

welcome
check_root
check_archlinux
check_hostname
check_connection
check_pacman_blocked
check_multilib
pacman_key
system_update
language_selector
configure_sudo
select_user
choose_aurhelper
automatic_mode

if is_package_installed "kdebase-workspace"; then KDE=1; fi

while true; do
	print_title "ARCHLINUX INSTALL - https://github.com/helmuthdu/aui"
	print_warning "USERNAME: ${username}"
	echo " 1) $(mainmenu_item "${checklist[1]}" "Basic Setup")"
	echo " 2) $(mainmenu_item "${checklist[2]}" "Desktop Environment|Window Manager")"
	echo " 3) $(mainmenu_item "${checklist[3]}" "Accessories Apps")"
	echo " 4) $(mainmenu_item "${checklist[4]}" "Development Apps")"
	echo " 5) $(mainmenu_item "${checklist[5]}" "Office Apps")"
	echo " 6) $(mainmenu_item "${checklist[6]}" "System Apps")"
	echo " 7) $(mainmenu_item "${checklist[7]}" "Graphics Apps")"
	echo " 8) $(mainmenu_item "${checklist[8]}" "Internet Apps")"
	echo " 9) $(mainmenu_item "${checklist[9]}" "Audio Apps")"
	echo "10) $(mainmenu_item "${checklist[10]}" "Video Apps")"
	echo "11) $(mainmenu_item "${checklist[11]}" "Games")"
	echo "12) $(mainmenu_item "${checklist[12]}" "Web server")"
	echo "13) $(mainmenu_item "${checklist[13]}" "Fonts")"
	echo "14) $(mainmenu_item "${checklist[14]}" "Internationalization")"
	echo "15) $(mainmenu_item "${checklist[15]}" "Extra")"
	echo "16) $(mainmenu_item "${checklist[16]}" "Clean Orphan Packages")"
	echo "17) $(mainmenu_item "${checklist[17]}" "Reconfigure System")"
	echo ""
	echo " q) Quit"
	echo ""
	MAINMENU+=" q"
	read_input_options "$MAINMENU"
	for OPT in "${OPTIONS[@]}"; do
		case "$OPT" in
		1)
			add_custom_repositories
			install_basic_setup
			install_zsh
			install_fish
			install_ssh
			install_nfs
			install_samba
			install_tlp
			enable_readahead
			install_zram
			install_video_cards
			install_xorg
			install_wayland
			font_config
			install_cups
			install_additional_firmwares
			checklist[1]=1
			;;
		2)
			if [[ checklist[1] -eq 0 ]]; then
				print_danger "\nWARNING: YOU MUST RUN THE BASIC SETUP FIRST"
				read_input_text "Are you sure you want to continue?"
				[[ $OPTION != y ]] && continue
			fi
			install_desktop_environment
			install_nm_wicd
			install_usb_modem
			install_bluetooth
			checklist[2]=1
			;;
		3)
			install_accessories_apps
			checklist[3]=1
			;;
		4)
			install_development_apps
			checklist[4]=1
			;;
		5)
			install_office_apps
			checklist[5]=1
			;;
		6)
			install_system_apps
			checklist[6]=1
			;;
		7)
			install_graphics_apps
			checklist[7]=1
			;;
		8)
			install_internet_apps
			checklist[8]=1
			;;
		9)
			install_audio_apps
			checklist[9]=1
			;;
		10)
			install_video_apps
			checklist[10]=1
			;;
		11)
			install_games
			checklist[11]=1
			;;
		12)
			install_web_server
			checklist[12]=1
			;;
		13)
			install_fonts
			checklist[13]=1
			;;
		14)
			choose_ime_m17n
			checklist[14]=1
			;;
		15)
			install_extra
			checklist[15]=1
			;;
		16)
			clean_orphan_packages
			checklist[16]=1
			;;
		17)
			print_danger "\nWARNING: THIS OPTION WILL RECONFIGURE THINGS LIKE HOSTNAME, TIMEZONE, CLOCK..."
			read_input_text "Are you sure you want to continue?"
			[[ $OPTION != y ]] && continue
			reconfigure_system
			checklist[17]=1
			;;
		"q")
			finish
			;;
		*)
			invalid_option
			;;
		esac
	done
done
#}}}