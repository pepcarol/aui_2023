#!/bin/bash
# FIX THIS ISSUES | NON-ACUTE
#shellcheck disable=SC1001,SC1091,SC2001,SC2010,SC2015,SC2034,SC2104,SC2154
#shellcheck disable=SC2154,SC2153,SC2155,SC2165,SC2167,SC2181,SC2207

: 'ATTENTION!: This is a personal modification of the original script for my personal use in my installations. The creators are:
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
	#THUNDERBIRD #{{{
	if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_US || $LOCALE == en_GB || $LOCALE == es_AR || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
		LOCALE_TB=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
	elif [[ $LOCALE == es_CL ]]; then
		LOCALE_TB="es-es"
	else
		LOCALE_TB=$(echo "$LOCALE" | cut -d\_ -f1)
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
		#THUNDERBIRD #{{{
		if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_US || $LOCALE == en_GB || $LOCALE == es_AR || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
			LOCALE_TB=$(echo "$LOCALE" | tr '[:upper:]' '[:lower:]' | sed 's/_/-/')
		elif [[ $LOCALE == es_CL ]]; then
			LOCALE_TB="es-es"
		else
			LOCALE_TB=$(echo "$LOCALE" | cut -d\_ -f1)
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
#SELECT/CREATE USER {{{
select_user() {
	#CREATE NEW USER {{{
	create_new_user() {
		printf "%s" "Username: "
		read -r username
		username=$(echo "$username" | tr '[:upper:]' '[:lower:]')
		useradd -m -g users -G wheel -s /bin/bash "${username}"
		chfn "${username}"
		passwd "${username}"
		while [[ $? -ne 0 ]]; do
			passwd "${username}"
		done
		pause_function
		configure_user_account
	}
	#}}}
	#CONFIGURE USER ACCOUNT {{{
	configure_user_account() {
		#BASHRC {{{
		print_title "BASHRC - https://wiki.archlinux.org/index.php/Bashrc"
		bashrc_list=("Get helmuthdu .bashrc from github" "Vanilla .bashrc" "Get personal .bashrc from github")
		PS3="$prompt1"
		echo -e "Choose your .bashrc\n"
		select OPT in "${bashrc_list[@]}"; do
			case "$REPLY" in
			1)
				package_install "git"
				package_install "colordiff"
				git clone https://github.com/helmuthdu/dotfiles
				cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc dotfiles/.yaourtrc ~/
				cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc dotfiles/.yaourtrc /home/"${username}"/
				rm -fr dotfiles
				;;
			2)
				cp /etc/skel/.bashrc /home/"${username}"
				;;
			3)
				package_install "git"
				printf "%s" "Enter your github username [ex: helmuthdu]: "
				read -r GITHUB_USER
				printf "%s" "Enter your github repository [ex: aui]: "
				read -r GITHUB_REPO
				git clone https://github.com/"$GITHUB_USER"/"$GITHUB_REPO"
				cp -R "$GITHUB_REPO"/.* /home/"${username}"/
				rm -fr "$GITHUB_REPO"
				;;
			*)
				invalid_option
				;;
			esac
			[[ -n $OPT ]] && break
		done
		#}}}
		#EDITOR {{{
		print_title "DEFAULT EDITOR"
		editors_list=("emacs" "nano" "vi" "vim" "neovim" "zile")
		PS3="$prompt1"
		echo -e "Select editor\n"
		select EDITOR in "${editors_list[@]}"; do
			if contains_element "$EDITOR" "${editors_list[@]}"; then
				if [[ $EDITOR == vim || $EDITOR == neovim ]]; then
					[[ $EDITOR == vim ]] && (! is_package_installed "gvim" && package_install "vim ctags") || package_install "neovim python2-neovim python-neovim xclip"
					#VIMRC {{{
					if [[ ! -f /home/${username}/.vimrc ]]; then
						vimrc_list=("Get helmuthdu .vimrc from github" "Vanilla .vimrc" "Get personal .vimrc from github")
						PS3="$prompt1"
						echo -e "Choose your .vimrc\n"
						select OPT in "${vimrc_list[@]}"; do
							case "$REPLY" in
							1)
								package_install "git"
								git clone https://github.com/helmuthdu/vim /home/"${username}"/.vim
								ln -sf /home/"${username}"/.vim/vimrc /home/"${username}"/.vimrc
								cp -R vim /home/"${username}"/.vim/fonts /home/"${username}"/.fonts
								mkdir /home/"${username}"/.vim/colors
								curl -fsSL -o /home/"${username}"/.vim/colors/tender.vim https://raw.githubusercontent.com/jacoborus/tender.vim/master/colors/tender.vim
								GRUVBOX_NEEDED=1
								;;
							3)
								package_install "git"
								printf "%s" "Enter your github username [ex: helmuthdu]: "
								read -r GITHUB_USER
								printf "%s" "Enter your github repository [ex: vim]: "
								read -r GITHUB_REPO
								git clone https://github.com/"$GITHUB_USER"/"$GITHUB_REPO"
								cp -R "$GITHUB_REPO"/.vim /home/"${username}"/
								if [[ -f $GITHUB_REPO/vimrc ]]; then
									ln -sf /home/"${username}"/.vim/vimrc /home/"${username}"/.vimrc
								else
									ln -sf /home/"${username}"/.vim/.vimrc /home/"${username}"/.vimrc
								fi
								rm -fr "$GITHUB_REPO"
								;;
							2)
								echo "Nothing to do..."
								;;
							*)
								invalid_option
								;;
							esac
							[[ -n $OPT ]] && break
						done
					fi
					if [[ $EDITOR == neovim && ! -f /home/${username}/.config/nvim ]]; then
						mkdir ~/.config
						ln -s ~/.vim ~/.config/nvim
						ln -s ~/.vimrc ~/.config/nvim/init.vim
					fi
					#}}}
				elif [[ $EDITOR == emacs ]]; then
					package_install "emacs"
					#.emacs.d{{{
					if [[ ! -d /home/${username}/.emacs.d && ! -f /home/${username}/.emacs ]]; then
						emacsd_list=("Spacemacs" "Centaur Emacs" "Vanilla .emacs.d" "Get personal .emacs.d from github")
						PS3="$prompt1"
						echo -e "Choose your .emacs.d\n"
						select OPT in "${emacsd_list[@]}"; do
							case "$REPLY" in
							1)
								package_install "git"
								git clone https://github.com/syl20bnr/spacemacs /home/"${username}"/.emacs.d
								;;
							2)
								package_install "git"
								git clone --depth 1 https://github.com/seagle0128/.emacs.d.git /home/"${username}"/.emacs.d
								;;
							3)
								package_install "git"
								printf "%s" "Enter your github username [ex: helmuthdu]: "
								read -r GITHUB_USER
								printf "%s" "Enter your github repository [ex: vim]: "
								read -r GITHUB_REPO
								git clone https://github.com/"$GITHUB_USER"/"$GITHUB_REPO" /home/"${username}"/.emacs.d
								;;
							4)
								echo "Nothing to do..."
								;;
							*)
								invalid_option
								;;
							esac
							[[ -n $OPT ]] && break
						done
					fi
					#}}}
				else
					package_install "$EDITOR"
				fi
				break
			else
				invalid_option
			fi
		done
		#}}}
		chown -R "${username}":users /home/"${username}"
	}
	#}}}
	print_title "SELECT/CREATE USER - https://wiki.archlinux.org/index.php/Users_and_Groups"
	users_list=($(grep "/home" /etc/passwd | cut -d: -f1))
	PS3="$prompt1"
	echo "Avaliable Users:"
	if [[ $((${#users_list[@]})) -gt 0 ]]; then
		print_warning "WARNING: THE SELECTED USER MUST HAVE SUDO PRIVILEGES"
	else
		echo ""
	fi
	select OPT in "${users_list[@]}" "Create new user"; do
		if [[ $OPT == "Create new user" ]]; then
			create_new_user
		elif contains_element "$OPT" "${users_list[@]}"; then
			username=$OPT
		else
			invalid_option
		fi
		[[ -n $OPT ]] && break
	done
	[[ ! -f /home/${username}/.bashrc ]] && configure_user_account
	if [[ -n "$http_proxy" ]]; then
		echo "proxy = $http_proxy" >/home/"${username}"/.curlrc
		chown "${username}":users /home/"${username}"/.curlrc
	fi
}
#}}}
#CONFIGURE SUDO {{{
configure_sudo() {
	if ! is_package_installed "sudo"; then
		print_title "SUDO - https://wiki.archlinux.org/index.php/Sudo"
		package_install "sudo"
	fi
	#CONFIGURE SUDOERS {{{
	if [[ ! -f /etc/sudoers.aui ]]; then
		cp -v /etc/sudoers /etc/sudoers.aui
		## Uncomment to allow members of group wheel to execute any command
		sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
		## Same thing without a password (not secure)
		#sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers

		#This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
		{
			echo ""
			echo 'Defaults !requiretty, !tty_tickets, !umask'
			echo 'Defaults visiblepw, path_info, insults, lecture=always'
			echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth'
			echo 'Defaults passwd_tries=3, passwd_timeout=1'
			echo 'Defaults env_reset, always_set_home, set_home, set_logname'
			echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"'
			echo 'Defaults timestamp_timeout=15'
			echo 'Defaults passprompt="[sudo] password for %u: "'
			echo 'Defaults lecture=never'
		} >>/etc/sudoers
	fi
	#}}}
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
#AUTOMODE {{{
automatic_mode() {
	print_title "AUTOMODE"
	print_info "Create a custom install with all options pre-selected.\nUse this option with care."
	print_danger "\tUse this mode only if you already know all the option.\n\tYou won't be able to select anything later."
	read_input_text "Enable Automatic Mode"
	if [[ $OPTION == y ]]; then
		$EDITOR "${AUI_DIR}"/lilo.automode
		# shellcheck source=/root/aui/lilo.automode
		source "${AUI_DIR}"/lilo.automode
		echo -e "The installation will start now."
		pause_function
		AUTOMATIC_MODE=1
	fi
}
#}}}
#CUSTOM REPOSITORIES {{{
add_custom_repositories() {
	print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
	read_input_text "Add custom repositories" "$CUSTOMREPO"
	if [[ $OPTION == y ]]; then
		while true; do
			print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
			echo " 1) \"Add new repository\""
			echo ""
			echo " d) DONE"
			echo ""
			printf "%s" "$prompt1" OPTION
			case $OPTION in
			1)
				printf "%s" "Repository Name [ex: custom]: "
				read -r repository_name
				printf "%s" "Repository Address [ex: file:///media/backup/Archlinux]: "
				read -r repository_addr
				add_repository "${repository_name}" "${repository_addr}" "Never"
				pause_function
				;;
			"d")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
	fi
}
#}}}
#BASIC SETUP {{{
install_basic_setup() {
	print_title "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
	package_install "bc rsync mlocate bash-completion pkgstats arch-wiki-lite"
	pause_function
	print_title "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
	package_install "zip unzip unrar p7zip lzop cpio"
	pause_function
	print_title "AVAHI - https://wiki.archlinux.org/index.php/Avahi"
	print_info "Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD discovery. It allows programs to publish and discovers services and hosts running on a local network with no specific configuration."
	package_install "avahi nss-mdns"
	is_package_installed "avahi" && system_ctl enable avahi-daemon.service
	pause_function
	print_title "ALSA - https://wiki.archlinux.org/index.php/Alsa"
	print_info "The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."
	package_install "alsa-utils alsa-plugins"
	pause_function
	print_title "PULSEAUDIO - https://wiki.archlinux.org/index.php/Pulseaudio"
	print_info "PulseAudio is the default sound server that serves as a proxy to sound applications using existing kernel sound components like ALSA or OSS"
	package_install "pulseaudio pulseaudio-alsa"
	pause_function
	print_title "FAT/exFAT/F2FS - https://wiki.archlinux.org/index.php/File_Systems"
	print_info "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
	package_install "dosfstools exfat-utils f2fs-tools fuse fuse-exfat mtpfs"
	pause_function
	print_title "SYSTEMD-TIMESYNCD - https://wiki.archlinux.org/index.php/Systemd-timesyncd"
	print_info "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
	timedatectl set-ntp true
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
#NFS {{{
install_nfs() {
	print_title "NFS - https://wiki.archlinux.org/index.php/Nfs"
	print_info "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
	read_input_text "Install nfs" "$NFS"
	if [[ $OPTION == y ]]; then
		package_install "nfs-utils"
		system_ctl enable rpcbind
		system_ctl enable nfs-client.target
		system_ctl enable remote-fs.target
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
#FISH {{{
install_fish() {
	print_title "fish - https://wiki.archlinux.org/index.php/fish"
	print_info "fish is a friendly interactive shell and a commandline shell intended to be interactive and user-friendly. "
	read_input_text "Install fish" "$FISH"
	if [[ $OPTION == y ]]; then
		package_install "fish"
		read_input_text "Install oh-my-fish" "$OH_MY_FISH"
		if [[ $OPTION == y ]]; then
			run_as_user "curl -L https://get.oh-my.fish | fish"
		fi
		pause_function
	fi
}
#}}}
#SAMBA {{{
install_samba() {
	print_title "SAMBA - https://wiki.archlinux.org/index.php/Samba"
	print_info "Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
	read_input_text "Install Samba" "$SAMBA"
	if [[ $OPTION == y ]]; then
		package_install "wget samba smbnetfs"
		[[ ! -f /etc/samba/smb.conf ]] && wget -q -O /etc/samba/smb.conf "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD"
		local CONFIG_SAMBA=$(grep usershare /etc/samba/smb.conf)
		if [[ -z $CONFIG_SAMBA ]]; then
			# configure usershare
			export USERSHARES_DIR="/var/lib/samba/usershare"
			export USERSHARES_GROUP="sambashare"
			mkdir -p ${USERSHARES_DIR}
			groupadd ${USERSHARES_GROUP}
			chown root:${USERSHARES_GROUP} ${USERSHARES_DIR}
			chmod 1770 ${USERSHARES_DIR}
			sed -i -e '/\[global\]/a\\n   usershare path = /var/lib/samba/usershare\n   usershare max shares = 100\n   usershare allow guests = yes\n   usershare owner only = False' /etc/samba/smb.conf
			sed -i -e '/\[global\]/a\\n   socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE\n   write cache size = 2097152\n   use sendfile = yes\n' /etc/samba/smb.conf
			usermod -a -G ${USERSHARES_GROUP} "${username}"
			sed -i '/user_allow_other/s/^#//' /etc/fuse.conf
			modprobe fuse
		fi
		echo "Enter your new samba account password:"
		pdbedit -a -u "${username}"
		while [[ $? -ne 0 ]]; do
			pdbedit -a -u "${username}"
		done
		# enable services
		system_ctl enable smb.service
		system_ctl enable nmb.service
		pause_function
	fi
}
#}}}
#READAHEAD {{{
enable_readahead() {
	print_title "Readahead - https://wiki.archlinux.org/index.php/Improve_Boot_Performance"
	print_info "Systemd comes with its own readahead implementation, this should in principle improve boot time. However, depending on your kernel version and the type of your hard drive, your mileage may vary (i.e. it might be slower)."
	read_input_text "Enable Readahead" "$READAHEAD"
	if [[ $OPTION == y ]]; then
		system_ctl enable systemd-readahead-collect
		system_ctl enable systemd-readahead-replay
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
#TLP {{{
install_tlp() {
	print_title "TLP - https://wiki.archlinux.org/index.php/Tlp"
	print_info "TLP is an advanced power management tool for Linux. It is a pure command line tool with automated background tasks and does not contain a GUI."
	read_input_text "Install TLP" "$TLP"
	if [[ $OPTION == y ]]; then
		package_install "tlp"
		system_ctl enable tlp.service
		system_ctl enable tlp-sleep.service
		system_ctl mask systemd-rfkill.service
		system_ctl mask systemd-rfkill.socket
		tlp start
		pause_function
	fi
}
#}}}
#XORG {{{
install_xorg() {
	print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
	print_info "Xorg is the public, open-source implementation of the X window system version 11."
	echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
	package_install "xorg-server xorg-apps xorg-xinit xorg-xkill xorg-xinput xf86-input-libinput"
	package_install "mesa"
	modprobe uinput
	pause_function
}
#}}}
#WAYLAND {{{
install_wayland() {
	print_title "WAYLAND - https://wiki.archlinux.org/index.php/Wayland"
	print_info "Wayland is a protocol for a compositing window manager to talk to its clients, as well as a library implementing the protocol. "
	package_install "weston xorg-server-xwayland"
	pause_function
}
#}}}
#FONT CONFIGURATION {{{
font_config() {
	print_title "FONTS CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
	print_info "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
	pacman -S --asdeps --needed cairo fontconfig freetype2
	pause_function
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
}
#}}}
#ADDITIONAL FIRMWARE {{{
install_additional_firmwares() {
	print_title "INSTALL ADDITIONAL FIRMWARES"
	read_input_text "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" "$FIRMWARE"
	if [[ $OPTION == y ]]; then
		while true; do
			print_title "INSTALL ADDITIONAL FIRMWARES"
			echo " 1) $(menu_item "aic94xx-firmware") $AUR"
			echo " 2) $(menu_item "alsa-firmware")"
			echo " 3) $(menu_item "b43-firmware") $AUR"
			echo " 4) $(menu_item "b43-firmware-legacy") $AUR"
			echo " 5) $(menu_item "bluez-firmware") [Broadcom BCM203x/STLC2300 Bluetooth]"
			echo " 6) $(menu_item "broadcom-wl-dkms")"
			echo " 7) $(menu_item "ipw2100-fw")"
			echo " 8) $(menu_item "ipw2200-fw")"
			echo " 9) $(menu_item "libffado") [Fireware Audio Devices]"
			echo "10) $(menu_item "libmtp") [Android Devices]"
			echo "11) $(menu_item "libraw1394") [IEEE1394 Driver]"
			echo "12) $(menu_item "wd719x-firmware") $AUR"
			echo "13) $(menu_item "upd72020x-fw") [Renesas USB3.0 Driver] $AUR"
			echo ""
			echo " d) DONE"
			echo ""
			FIRMWARE_OPTIONS+=" d"
			read_input_options "$FIRMWARE_OPTIONS"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					aur_package_install "aic94xx-firmware"
					;;
				2)
					package_install "alsa-firmware"
					;;
				3)
					aur_package_install "b43-firmware"
					;;
				4)
					aur_package_install "b43-firmware-legacy"
					;;
				5)
					package_install "bluez-firmware"
					;;
				6)
					package_install "broadcom-wl-dkms"
					;;
				7)
					package_install "ipw2100-fw"
					;;
				8)
					package_install "ipw2200-fw"
					;;
				9)
					package_install "libffado"
					;;
				10)
					package_install "libmtp"
					package_install "android-udev"
					;;
				11)
					package_install "libraw1394"
					;;
				12)
					aur_package_install "wd719x-firmware"
					;;
				13)
					aur_package_install "upd72020x-fw"
					;;
				"d")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
			create_ramdisk_environment
		done
	fi
}
#}}}
#DESKTOP ENVIRONMENT {{{
install_desktop_environment() {
	install_icon_theme() { #{{{
		while true; do
			print_title "GNOME ICONS"
			echo " 1) $(menu_item "arc-icon-theme")"
			echo " 2) $(menu_item "adwaita-icon-theme-git") $AUR"
			echo " 3) $(menu_item "emerald-icon-theme-git") $AUR"
			echo " 4) $(menu_item "la-capitaine-icon-theme-git") $AUR"
			echo " 5) $(menu_item "numix-icon-theme-git") $AUR"
			echo " 6) $(menu_item "paper-icon-theme-git") $AUR"
			echo " 7) $(menu_item "papirus-icon-theme-git") $AUR"
			echo " 8) $(menu_item "pop-icon-theme-git") $AUR"
			echo " 9) $(menu_item "solus-icon-theme-git") $AUR"
			echo "10) $(menu_item "yaru-icon-theme-git") $AUR"
			echo ""
			echo " b) BACK"
			echo ""
			ICONS_THEMES+=" b"
			read_input_options "$ICONS_THEMES"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					package_install "arc-icon-theme elementary-icon-theme"
					;;
				2)
					aur_package_install "adwaita-icon-theme-git"
					;;
				3)
					aur_package_install "emerald-icon-theme-git"
					;;
				4)
					aur_package_install "la-capitaine-icon-theme-git"
					;;
				5)
					aur_package_install "numix-icon-theme-git numix-circle-icon-theme-git"
					;;
				6)
					aur_package_install "paper-icon-theme-git"
					;;
				7)
					aur_package_install "papirus-icon-theme-git"
					;;
				8)
					aur_package_install "pop-icon-theme-git"
					;;
				9)
					aur_package_install "solus-icon-theme-git"
					;;
				10)
					aur_package_install "yaru-icon-theme-git"
					;;
				"b")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
	}                     #}}}
	install_gtk_theme() { #{{{
		while true; do
			print_title "GTK2/GTK3 THEMES"
			echo " 1) $(menu_item "arc-gtk-theme")"
			echo " 2) $(menu_item "abrus-gtk-theme-git") $AUR"
			echo " 3) $(menu_item "acid-gtk-theme") $AUR"
			echo " 4) $(menu_item "adapta-gtk-theme-git") $AUR"
			echo " 5) $(menu_item "amber-theme-git") $AUR"
			echo " 6) $(menu_item "candy-gtk-theme") $AUR"
			echo " 7) $(menu_item "evopop-gtk-theme-git") $AUR"
			echo " 8) $(menu_item "flat-remix-gtk") $AUR"
			echo " 9) $(menu_item "zuki-themes-git") $AUR"
			echo "10) $(menu_item "zukitwo-themes-git") $AUR"
			echo ""
			echo " b) BACK"
			echo ""
			GTK_THEMES+=" b"
			read_input_options "$GTK_THEMES"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					package_install "arc-gtk-theme"
					;;
				2)
					aur_package_install "abrus-gtk-theme-git"
					;;
				3)
					aur_package_install "acid-gtk-theme"
					;;
				4)
					aur_package_install "adapta-gtk-theme-git"
					;;
				5)
					aur_package_install "amber-theme-git"
					;;
				6)
					aur_package_install "candy-gtk-theme"
					;;
				7)
					aur_package_install "evopop-gtk-theme-git"
					;;
				8)
					aur_package_install "flat-remix-gtk"
					;;
				9)
					aur_package_install "zuki-themes-git"
					;;
				10)
					aur_package_install "zukitwo-themes-git"
					;;
				"b")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
	}                           #}}}
	install_display_manager() { #{{{
		while true; do
			print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
			print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
			echo " 1) $(menu_item "entrance-git" "Entrance") $AUR"
			echo " 2) $(menu_item "gdm" "GDM")"
			echo " 3) $(menu_item "lightdm" "LightDM")"
			echo " 4) $(menu_item "sddm" "SDDM")"
			echo " 5) $(menu_item "slim" "Slim")"
			echo " 6) $(menu_item "lxdm" "lxdm")"
			echo " 7) $(menu_item "lxdm-gtk3" "lxdm-gtk3")"
			echo ""
			echo " b) BACK|SKIP"
			echo ""
			DISPLAY_MANAGER+=" b"
			read_input_options "$DISPLAY_MANAGER"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					aur_package_install "entrance-git"
					system_ctl enable entrance
					;;
				2)
					package_install "gdm"
					system_ctl enable gdm
					;;
				3)
					if [[ ${KDE} -eq 1 ]]; then
						package_install "lightdm lightdm-kde-greeter"
					else
						package_install "lightdm lightdm-gtk-greeter"
					fi
					system_ctl enable lightdm
					;;
				4)
					package_install "sddm sddm-kcm"
					system_ctl enable sddm
					sddm --example-config >/etc/sddm.conf
					sed -i 's/Current=/Current=breeze/' /etc/sddm.conf
					sed -i 's/CursorTheme=/CursorTheme=breeze_cursors/' /etc/sddm.conf
					sed -i 's/Numlock=none/Numlock=on/' /etc/sddm.conf
					;;
				5)
					package_install "slim"
					system_ctl enable slim
					;;
				6)
					package_install "lxdm"
					system_ctl enable lxdm
					;;
				7)
					package_install "lxdm-gtk3"
					system_ctl enable lxdm
					;;
				"b")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
	}                  #}}}
	install_themes() { #{{{
		while true; do
			print_title "$1 THEMES"
			echo " 1) $(menu_item "arc-icon-theme" "Icons Themes")"
			echo " 2) $(menu_item "arc-gtk-theme" "GTK Themes")"
			echo ""
			echo " d) DONE"
			echo ""
			THEMES_OPTIONS+=" d"
			read_input_options "$THEMES_OPTIONS"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					install_icon_theme
					OPT=1
					;;
				2)
					install_gtk_theme
					OPT=2
					;;
				"d")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
	}                     #}}}
	install_misc_apps() { #{{{
		while true; do
			print_title "$1 ESSENTIAL APPS"
			echo " 1) $(menu_item "entrance-git gdm lightdm sddm" "Display Manager") $AUR"
			echo " 2) $(menu_item "dmenu")"
			echo " 3) $(menu_item "viewnior")"
			echo " 4) $(menu_item "gmrun")"
			echo " 5) $(menu_item "rxvt-unicode")"
			echo " 6) $(menu_item "squeeze-git") $AUR"
			echo " 7) $(menu_item "thunar")"
			echo " 8) $(menu_item "tint2")"
			echo " 9) $(menu_item "volwheel")"
			echo "10) $(menu_item "xfburn")"
			echo "11) $(menu_item "xcompmgr")"
			echo "12) $(menu_item "zathura")"
			echo "13) $(menu_item "speedtest-cli")"
			echo ""
			echo " d) DONE"
			echo ""
			MISCAPPS+=" d"
			read_input_options "$MISCAPPS"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					install_display_manager
					OPT=1
					;;
				2)
					package_install "dmenu"
					;;
				3)
					package_install "viewnior"
					;;
				4)
					package_install "gmrun"
					;;
				5)
					package_install "rxvt-unicode"
					;;
				6)
					aur_package_install "squeeze-git"
					;;
				7)
					package_install "thunar tumbler"
					;;
				8)
					package_install "tint2"
					;;
				9)
					package_install "volwheel"
					;;
				10)
					package_install "xfburn"
					;;
				11)
					package_install "xcompmgr transset-df"
					;;
				12)
					package_install "zathura"
					;;
				13)
					package_install "speedtest-cli"
					;;
				"d")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
	} #}}}

	print_title "DESKTOP ENVIRONMENT|WINDOW MANAGER"
	print_info "A DE provide a complete GUI for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries.\n\nA window manager is one component of a system's graphical user interface."

	echo -e "Select your DE or WM:\n"
	echo " --- DE ---         --- WM ---"
	echo " 1) Cinnamon        12) Awesome"
	echo " 2) Deepin          13) Fluxbox"
	echo " 3) Enlightenment   14) i3"
	echo " 4) GNOME           15) i3-Gaps"
	echo " 5) KDE             16) OpenBox"
	echo " 6) LXQT            17) Xmonad"
	echo " 7) Mate"
	echo " 8) XFCE"
	echo " 9) Budgie"
	echo " 10) UKUI"
	echo " 11) Pantheon"
	echo ""
	echo " b) BACK"
	read_input "$DESKTOPENV"
	case "$OPTION" in
	1)
		#CINNAMON {{{
		print_title "CINNAMON - https://wiki.archlinux.org/index.php/Cinnamon"
		print_info "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
		package_install "cinnamon nemo-fileroller nemo-preview"
		# Cinnamon does not include the following: a screenshot utility, editor, terminal... Hence installing some default choices explicitly.
		package_install "gnome-screenshot gedit gnome-terminal gnome-control-center gnome-system-monitor gnome-power-manager"
		# Suggested by https://bbs.archlinux.org/viewtopic.php?id=185123
		aur_package_install "mintlocale"
		# config xinitrc
		config_xinitrc "cinnamon-session"
		CINNAMON=1
		pause_function
		install_display_manager
		install_themes "CINNAMON"
		;;
		#}}}
	2)
		#DEEPIN {{{
		print_title "DEEPIN - https://wiki.archlinux.org/index.php/Deepin_Desktop_Environment"
		print_info "The desktop interface and apps feature an intuitive and elegant design. Moving around, sharing and searching etc. has become simply a joyful experience."
		package_install "deepin deepin-extra lightdm-gtk-greeter"
		# config xinitrc
		config_xinitrc "startdde"
		#Tweaks
		pause_function
		system_ctl enable lightdm
		sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/' /etc/lightdm/lightdm.conf
		;;
		#}}}
	3)
		#ENLIGHTENMENT {{{
		print_title "ENLIGHTENMENT - http://wiki.archlinux.org/index.php/Enlightenment"
		print_info "Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
		package_install "enlightenment terminology"
		package_install "leafpad epdfview"
		package_install "lxappearance"
		# config xinitrc
		config_xinitrc "enlightenment_start"
		pause_function
		install_misc_apps "Enlightenment"
		install_themes "Enlightenment"
		;;
		#}}}
	4)
		#GNOME {{{
		print_title "GNOME - https://wiki.archlinux.org/index.php/GNOME"
		print_info "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
		package_install "gnome gnome-extra gnome-software gnome-initial-setup"
		package_install "deja-dup gedit-plugins gpaste gnome-tweak-tool gnome-power-manager"
		package_install "nautilus-share"
		# remove gnome games
		package_remove "aisleriot atomix four-in-a-row five-or-more gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff tali"
		# config xinitrc
		config_xinitrc "gnome-session"
		GNOME=1
		pause_function
		install_themes "GNOME"
		#Gnome Display Manager (a reimplementation of xdm)
		system_ctl enable gdm
		;;
		#}}}
	5)
		#KDE {{{
		print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
		print_info "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
		package_install "plasma kf5 sddm"
		package_install "ark dolphin dolphin-plugins kaccounts-providers kio-extras kdeconnect sshfs quota-tools gwenview kipi-plugins kwrite kcalc konsole spectacle okular sweeper kwalletmanager packagekit-qt5"
		is_package_installed "cups" && package_install "print-manager"
		[[ $LOCALE != en_US ]] && package_install "kde-l10n-$LOCALE_KDE"
		# config xinitrc
		config_xinitrc "startkde"
		pause_function
		#KDE CUSTOMIZATION {{{
		while true; do
			print_title "KDE CUSTOMIZATION"
			echo " 1) $(menu_item "choqok")"
			echo " 2) $(menu_item "digikam")"
			echo " 3) $(menu_item "k3b")"
			echo " 4) $(menu_item "kvantum") $AUR"
			echo " 5) $(menu_item "latte-dock")"
			echo " 6) $(menu_item "skrooge")"
			echo " 7) $(menu_item "yakuake")"
			echo ""
			echo " d) DONE"
			echo ""
			KDE_OPTIONS+=" d"
			read_input_options "$KDE_OPTIONS"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					package_install "choqok"
					;;
				2)
					package_install "digikam"
					;;
				3)
					package_install "k3b cdrdao dvd+rw-tools"
					;;
				4)
					aur_package_install "kvantum-qt5-git"
					;;
				5)
					package_install "latte-dock"
					;;
				6)
					package_install "skrooge"
					;;
				7)
					package_install "yakuake"
					;;
				"d")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
		#}}}
		system_ctl enable sddm
		sddm --example-config >/etc/sddm.conf
		sed -i 's/Current=/Current=breeze/' /etc/sddm.conf
		sed -i 's/CursorTheme=/CursorTheme=breeze_cursors/' /etc/sddm.conf
		sed -i 's/Numlock=none/Numlock=on/' /etc/sddm.conf
		KDE=1
		;;
		#}}}
	6)
		#LXQT {{{
		print_title "LXQT - http://wiki.archlinux.org/index.php/lxqt"
		print_info "LXQt is the Qt port and the upcoming version of LXDE, the Lightweight Desktop Environment. It is the product of the merge between the LXDE-Qt and the Razor-qt projects: A lightweight, modular, blazing-fast and user-friendly desktop environment."
		package_install "lxqt openbox breeze-icons"
		package_install "leafpad epdfview"
		mkdir -p /home/"${username}"/.config/lxqt
		cp /etc/xdg/lxqt/* /home/"${username}"/.config/lxqt
		mkdir -p /home/"${username}"/.config/openbox/
		cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} /home/"${username}"/.config/openbox/
		chown -R "${username}":users /home/"${username}"/.config
		# config xinitrc
		config_xinitrc "startlxqt"
		pause_function
		install_misc_apps "LXQT"
		install_themes "LXQT"
		KDE=1
		;;
		#}}}
	7)
		#MATE {{{
		print_title "MATE - https://wiki.archlinux.org/index.php/Mate"
		print_info "The MATE Desktop Environment is a fork of GNOME 2 that aims to provide an attractive and intuitive desktop to Linux users using traditional metaphors."
		package_install "mate mate-extra"
		# config xinitrc
		config_xinitrc "mate-session"
		pause_function
		install_display_manager
		install_themes "MATE"
		;;
		#}}}
	8)
		#XFCE {{{
		print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
		print_info "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
		package_install "xfce4 xfce4-goodies xarchiver mupdf"
		# config xinitrc
		config_xinitrc "startxfce4"
		pause_function
		install_display_manager
		install_themes "XFCE"
		;;
		#}}}
	9)
		#BUDGIE {{{
		print_title "BUDGIE - https://wiki.archlinux.org/index.php/Budgie_Desktop"
		print_info "Budgie is the default desktop of Solus Operating System, written from scratch. Besides a more modern design, Budgie can emulate the look and feel of the GNOME 2 desktop."
		package_install "gnome gnome-extra gnome-software gnome-initial-setup telepathy"
		package_install "deja-dup gedit-plugins gpaste gnome-tweak-tool gnome-power-manager"
		package_install "budgie-desktop"
		package_install "nautilus-share"
		# remove gnome games
		package_remove "aisleriot atomix four-in-a-row five-or-more gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff"
		# config xinitrc
		config_xinitrc "export XDG_CURRENT_DESKTOP=Budgie:GNOME \n budgie-desktop"
		GNOME=1
		pause_function
		install_themes "GNOME"
		#Gnome Display Manager (a reimplementation of xdm)
		system_ctl enable gdm
		;;
		#}}}
	10)
		#UKUI {{{
		print_title "UKUI - https://wiki.archlinux.org/index.php/UKUI"
		print_info "UKUI is a lightweight Linux desktop environment, developed based on GTK and Qt. UKUI is the default desktop environment for Ubuntu kylin."
		package_install "ukui xorg-server"
		# config xinitrc
		config_xinitrc "ukui-session"
		pause_function
		#Light Display Manager
		system_ctl enable lightdm
		;;
		#}}}
	11)
		#Pantheon {{{
		print_title "Pantheon - https://wiki.archlinux.org/title/Pantheon"
		print_info "Pantheon is the desktop environment of elementary OS. It is written in Vala, using GTK 3 and Granite."
		package_install "pantheon pantheon-print xorg-server"
		aur_package_install "switchboard-plug-pantheon-tweaks-git"
		# config xinitrc
		config_xinitrc "io.elementary.wingpanel & \n plank & \n exec gala"
		pause_function
		#Light Display Manager
		system_ctl enable lightdm
		sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-pantheon-greeter/' /etc/lightdm/lightdm.conf
		;;
		#}}}
	12)
		#AWESOME {{{
		print_title "AWESOME - http://wiki.archlinux.org/index.php/Awesome"
		print_info "awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
		package_install "awesome"
		package_install "lxappearance"
		package_install "leafpad epdfview nitrogen"
		if [[ ! -d /home/${username}/.config/awesome/ ]]; then
			mkdir -p /home/"${username}"/.config/awesome/
			cp /etc/xdg/awesome/rc.lua /home/"${username}"/.config/awesome/
			chown -R "${username}":users /home/"${username}"/.config
		fi
		# config xinitrc
		config_xinitrc "awesome"
		pause_function
		install_misc_apps "AWESOME"
		install_themes "AWESOME"
		;;
		#}}}
	13)
		#FLUXBOX {{{
		print_title "FLUXBOX - http://wiki.archlinux.org/index.php/Fluxbox"
		print_info "Fluxbox is yet another window manager for X11. It is based on the (now abandoned) Blackbox 0.61.1 code, but with significant enhancements and continued development. Fluxbox is very light on resources and fast, yet provides interesting window management tools such as tabbing and grouping."
		package_install "fluxbox menumaker"
		package_install "lxappearance"
		package_install "leafpad epdfview"
		# config xinitrc
		config_xinitrc "startfluxbox"
		install_misc_apps "FLUXBOX"
		install_themes "FLUXBOX"
		pause_function
		;;
		#}}}
	14)
		#I3 {{{
		print_title "i3 - https://wiki.archlinux.org/index.php/I3"
		print_info "i3 is a dynamic tiling window manager inspired by wmii that is primarily targeted at developers and advanced users. The stated goals for i3 include clear documentation, proper multi-monitor support, a tree structure for windows, and different modes like in vim."
		package_install "i3-wm"
		package_install "dmenu"
		# config xinitrc
		config_xinitrc "i3"
		pause_function
		install_misc_apps "i3"
		install_themes "i3"
		;;
		#}}}
	15)
		#I3-Gaps {{{
		print_title "i3 - https://wiki.archlinux.org/index.php/I3"
		print_info "i3-gaps is a fork of i3wm, a tiling window manager for X11 with more features, such as gaps between windows."
		package_install "i3-gaps"
		install_misc_apps "i3"
		install_themes "i3"
		# config xinitrc
		config_xinitrc "i3"
		pause_function
		#i3-GAPS CUSTOMIZATION {{{
		while true; do
			print_title "i3-GAPS CUSTOMIZATION"
			echo " 1) $(menu_item "arandr")"
			echo " 2) $(menu_item "bashtop")"
			echo " 3) $(menu_item "cava") $AUR"
			echo " 4) $(menu_item "cmus")"
			echo " 5) $(menu_item "dmenu")"
			echo " 6) $(menu_item "dunst")"
			echo " 7) $(menu_item "excalibar") $AUR"
			echo " 8) $(menu_item "feh")"
			echo " 9) $(menu_item "picom")"
			echo "10) $(menu_item "polybar") $AUR"
			echo "11) $(menu_item "qutebrowser")"
			echo "12) $(menu_item "ranger")"
			echo "13) $(menu_item "rofi")"
			echo "14) $(menu_item "rxvt-unicode")"
			echo ""
			echo " d) DONE"
			echo ""
			GAPS_OPTIONS+=" d"
			read_input_options "$GAPS_OPTIONS"
			for OPT in "${OPTIONS[@]}"; do
				case "$OPT" in
				1)
					package_install "arandr"
					;;
				2)
					package_install "bashtop"
					;;
				3)
					aur_package_install "cava"
					;;
				4)
					package_install "cmus"
					;;
				5)
					package_install "dmenu"
					;;
				6)
					package_install "dunst"
					;;
				7)
					aur_package_install "excalibar-git"
					;;
				8)
					package_install "feh"
					;;
				9)
					package_install "picom"
					;;
				10)
					aur_package_install "polybar"
					;;
				11)
					package_install "qutebrowser"
					;;
				12)
					package_install "ranger"
					;;
				13)
					package_install "rofi"
					;;
				14)
					package_install "rxvt-unicode"
					;;
				"d")
					break
					;;
				*)
					invalid_option
					;;
				esac
			done
			source sharedfuncs_elihw
		done
		;;
		#}}}
	16)
		#OPENBOX {{{
		print_title "OPENBOX - http://wiki.archlinux.org/index.php/Openbox"
		print_info "Openbox is a lightweight and highly configurable window manager with extensive standards support."
		package_install "openbox obconf obmenu menumaker"
		package_install "lxappearance"
		package_install "leafpad epdfview nitrogen"
		mkdir -p /home/"${username}"/.config/openbox/
		cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} /home/"${username}"/.config/openbox/
		chown -R "${username}":users /home/"${username}"/.config
		# config xinitrc
		config_xinitrc "openbox-session"
		pause_function
		install_misc_apps "OPENBOX"
		install_themes "OPENBOX"
		;;
		#}}}
	17)
		#XMONAD {{{
		print_title "XMONAD - http://wiki.archlinux.org/index.php/Xmonad"
		print_info "xmonad is a tiling window manager for X. Windows are arranged automatically to tile the screen without gaps or overlap, maximizing screen use. Window manager features are accessible from the keyboard: a mouse is optional."
		package_install "xmonad xmonad-contrib"
		# config xinitrc
		config_xinitrc "xmonad"
		pause_function
		install_misc_apps "XMONAD"
		install_themes "XMONAD"
		;;
		#}}}
	"b") ;;

	*)
		invalid_option
		install_desktop_environment
		;;
	esac
	#COMMON PKGS {{{
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
		aur_package_install "gnome-defaults-list"
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
#USB 3G MODEM {{{
install_usb_modem() {
	print_title "USB 3G MODEM - https://wiki.archlinux.org/index.php/USB_3G_Modem"
	print_info "A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device."
	read_input_text "Install usb 3G modem support" "$USBMODEM"
	if [[ $OPTION == y ]]; then
		package_install "usbutils usb_modeswitch"
		if is_package_installed "networkmanager"; then
			package_install "modemmanager"
			[[ ${KDE} -eq 1 ]] && package_install "modemmanager-qt"
			system_ctl enable ModemManager.service
		else
			package_install "wvdial"
		fi
		pause_function
	fi
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
#ACCESSORIES {{{
install_accessories_apps() {
	while true; do
		print_title "ACCESSORIES APPS"
		echo " 1) $(menu_item "albert")"
		echo " 2) $(menu_item "catfish")"
		echo " 3) $(menu_item "conky-lua") $AUR"
		echo " 4) $(menu_item "enpass-bin") $AUR"
		echo " 5) $(menu_item "flameshot")"
		echo " 6) $(menu_item "keepass")"
		echo " 7) $(menu_item "pamac-aur" "Pamac") $AUR"
		echo " 8) $(menu_item "shutter hotshots" "$([[ ${KDE} -eq 1 ]] && echo "Hotshots" || echo "Shutter")")"
		echo " 9) $(menu_item "synapse")"
		echo "10) $(menu_item "terminator")"
		echo "11) $(menu_item "tilix-bin") $AUR"
		echo ""
		echo " b) BACK"
		echo ""
		ACCESSORIES_OPTIONS+=" b"
		read_input_options "$ACCESSORIES_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "albert"
				;;
			2)
				package_install "catfish"
				;;
			3)
				aur_package_install "conky-lua"
				package_install "lm_sensors"
				sensors-detect --auto
				;;
			4)
				aur_package_install "enpass-bin"
				;;
			5)
				package_install "flameshot"
				;;
			6)
				package_install "keepass"
				;;
			7)
				aur_package_install "pamac-aur"
				;;
			8)
				if [[ ${KDE} -eq 1 ]]; then
					aur_package_install "hotshots"
				else
					aur_package_install "shutter"
				fi
				;;
			9)
				package_install "synapse"
				;;
			10)
				package_install "terminator"
				;;
			11)
				aur_package_install "tilix-bin"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#DEVELOPEMENT {{{
install_development_apps() {
	while true; do
		print_title "DEVELOPMENT APPS"
		echo " 1) $(menu_item "atom" "Atom")"
		echo " 2) $(menu_item "emacs")"
		echo " 3) $(menu_item "gvim")"
		echo " 4) $(menu_item "meld")"
		echo " 5) $(menu_item "sublime-merge") $AUR"
		echo " 6) $(menu_item "sublime-text2" "Sublime Text 2") $AUR"
		echo " 7) $(menu_item "sublime-text-dev" "Sublime Text 3") $AUR"
		echo " 8) $(menu_item "android-studio" "Android Studio") $AUR"
		echo " 9) $(menu_item "jetbrains-toolbox" "Jetbrains Toolbox") $AUR"
		echo "10) $(menu_item "intellij-idea-community-edition" "IntelliJ IDEA Community Edition")"
		echo "11) $(menu_item "intellij-idea-ultimate-edition" "IntelliJ IDEA Ultimate Edition") $AUR"
		echo "12) $(menu_item "micro") $AUR"
		echo "13) $(menu_item "monodevelop")"
		echo "14) $(menu_item "qtcreator")"
		echo "15) $(menu_item "mysql-workbench" "MySQL Workbench") $AUR"
		echo "16) $(menu_item "jdk8-openjdk" "OpenJDK 8")"
		echo "17) $(menu_item "jdk9-openjdk" "OpenJDK 9")"
		echo "18) $(menu_item "jdk10-openjdk" "OpenJDK 10")"
		echo "19) $(menu_item "jdk" "Oracle JDK") $AUR"
		echo "20) $(menu_item "nodejs")"
		echo "21) $(menu_item "visual-studio-code-bin" "Visual Studio Code") $AUR"
		echo "22) $(menu_item "gitg")"
		echo "23) $(menu_item "kdiff3")"
		echo "24) $(menu_item "regexxer")"
		echo "25) $(menu_item "postman-bin" "Postman") $AUR"
		echo "26) $(menu_item "gitkraken" "Gitkraken") $AUR"
		echo "27) $(menu_item "freecad" "FreeCad") $AUR"
		echo ""
		echo " b) BACK"
		echo ""
		DEVELOPMENT_OPTIONS+=" b"
		read_input_options "$DEVELOPMENT_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "atom"
				;;
			2)
				package_install "emacs"
				;;
			3)
				package_remove "vim"
				package_install "gvim ctags"
				;;
			4)
				package_install "meld"
				;;
			5)
				aur_package_install "sublime-merge"
				;;
			6)
				aur_package_install "sublime-text2"
				;;
			7)
				aur_package_install "sublime-text-dev"
				;;
			8)
				aur_package_install "android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform"
				add_user_to_group "${username}" sdkusers
				chown -R :sdkusers /opt/android-sdk/
				chmod -R g+w /opt/android-sdk/
				add_line "export ANDROID_HOME=/opt/android-sdk" "/home/${username}/.bashrc"
				aur_package_install "android-studio"
				;;
			9)
				aur_package_install "jetbrains-toolbox"
				;;
			10)
				package_install "intellij-idea-community-edition"
				;;
			11)
				aur_package_install "intellij-idea-ultimate-edition"
				;;
			12)
				aur_package_install "micro"
				;;
			13)
				package_install "monodevelop monodevelop-debugger-gdb"
				;;
			14)
				package_install "qtcreator"
				;;
			15)
				aur_package_install "mysql-workbench"
				;;
			16)
				package_remove "jdk"
				package_install "jdk8-openjdk"
				;;
			17)
				package_remove "jdk"
				package_install "jdk9-openjdk"
				;;
			18)
				package_remove "jdk"
				package_install "jdk10-openjdk"
				;;
			19)
				package_remove "jre{7,8,9,10}-openjdk"
				package_remove "jdk{7,8,9,10}-openjdk"
				aur_package_install "jdk"
				;;
			20)
				package_install "nodejs"
				;;
			21)
				aur_package_install "visual-studio-code-bin"
				;;
			22)
				aur_package_install "gitg"
				aur_package_install "qgit"
				;;
			23)
				aur_package_install "kdiff3"
				;;
			24)
				aur_package_install "regexxer"
				;;
			25)
				aur_package_install "postman-bin"
				;;
			26)
				aur_package_install "gitkraken"
				;;
			27)
				aur_package_install "freecad"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#OFFICE {{{
install_office_apps() {
	while true; do
		print_title "OFFICE APPS"
		echo " 1) $(menu_item "goffice calligra-libs" "$([[ ${KDE} -eq 1 ]] && echo "Caligra" || echo "Abiword + Gnumeric")")"
		echo " 2) $(menu_item "calibre")"
		echo " 3) $(menu_item "goldendict")"
		echo " 4) $(menu_item "homebank")"
		echo " 5) $(menu_item "texlive-core" "latex")"
		echo " 6) $(menu_item "libreoffice-fresh" "LibreOffice")"
		echo " 7) $(menu_item "lyx")"
		echo " 8) $(menu_item "ocrfeeder")"
		echo " 9) $(menu_item "tellico")"
		echo "10) $(menu_item "typora")"
		echo "11) $(menu_item "xmind")"
		echo ""
		echo " b) BACK"
		echo ""
		OFFICE_OPTIONS+=" b"
		read_input_options "$OFFICE_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				if [[ ${KDE} -eq 1 ]]; then
					package_install "calligra"
				else
					package_install "gnumeric abiword abiword-plugins"
				fi
				package_install "hunspell hunspell-$LOCALE_HS"
				package_install "aspell aspell-$LOCALE_AS"
				;;
			2)
				package_install "calibre"
				;;
			3)
				package_install "goldendict"
				;;
			4)
				package_install "homebank"
				;;
			5)
				package_install "texlive-most"
				if [[ $LOCALE == pt_BR ]]; then
					aur_package_install "abntex"
				fi
				;;
			6)
				print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
				package_install "libreoffice-fresh"
				[[ $LOCALE != en_US ]] && package_install "libreoffice-fresh-$LOCALE_LO"
				package_install "hunspell hunspell-$LOCALE_HS"
				package_install "aspell aspell-$LOCALE_AS"
				;;
			7)
				package_install "lyx"
				;;
			8)
				package_install "ocrfeeder tesseract gocr"
				package_install "aspell aspell-$LOCALE_AS"
				;;
			9)
				package_install "tellico"
				;;
			10)
				package_install "typora"
				;;
			11)
				package_install "xmind"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#SYSTEM TOOLS {{{
install_system_apps() {
	while true; do
		print_title "SYSTEM TOOLS APPS"
		echo " 1) $(menu_item "clamav" "Clamav Antivirus")"
		echo " 2) $(menu_item "cockpit") $AUR"
		echo " 3) $(menu_item "webmin") $AUR"
		echo " 4) $(menu_item "docker")"
		echo " 5) $(menu_item "firewalld")"
		echo " 6) $(menu_item "gparted")"
		echo " 7) $(menu_item "grsync")"
		echo " 8) $(menu_item "hosts-update") $AUR"
		echo " 9) $(menu_item "htop")"
		echo "10) $(menu_item "stacer") $AUR"
		echo "11) $(menu_item "gotop") $AUR"
		echo "12) $(menu_item "ufw")"
		echo "13) $(menu_item "unified-remote-server" "Unified Remote") $AUR"
		echo "14) $(menu_item "virtualbox")"
		echo "15) $(menu_item "wine")"
		echo "16) $(menu_item "netdata")"
		echo "17) $(menu_item "nload")"
		echo "18) $(menu_item "vmware-workstation12" "VMware Workstation 12") $AUR"
		echo ""
		echo " b) BACK"
		echo ""
		SYSTEMTOOLS_OPTIONS+=" b"
		read_input_options "$SYSTEMTOOLS_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "clamav"
				cp /etc/clamav/clamd.conf.sample /etc/clamav/clamd.conf
				cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf
				sed -i '/Example/d' /etc/clamav/freshclam.conf
				sed -i '/Example/d' /etc/clamav/clamd.conf
				system_ctl enable clamd
				freshclam
				;;
			2)
				aur_package_install "cockpit storaged linux-user-chroot ostree"
				;;
			3)
				aur_package_install "webmin"
				;;
			4)
				package_install "docker"
				add_user_to_group "${username}" docker
				;;
			5)
				is_package_installed "ufw" && package_remove "ufw"
				is_package_installed "firewalld" && package_remove "firewalld"
				package_install "firewalld"
				system_ctl enable firewalld
				;;
			6)
				package_install "gparted"
				;;
			7)
				package_install "grsync"
				;;
			8)
				aur_package_install "hosts-update"
				hosts-update
				;;
			9)
				package_install "htop"
				;;
			10)
				aur_package_install "stacer"
				;;
			11)
				aur_package_install "gotop-bin"
				;;
			12)
				print_title "UFW - https://wiki.archlinux.org/index.php/Ufw"
				print_info "Ufw stands for Uncomplicated Firewall, and is a program for managing a netfilter firewall. It provides a command line interface and aims to be uncomplicated and easy to use."
				is_package_installed "firewalld" && package_remove "firewalld"
				package_install "ufw gufw"
				system_ctl enable ufw.service
				;;
			13)
				aur_package_install "unified-remote-server"
				system_ctl enable urserver.service
				;;
			14)
				#Make sure we are not a VirtualBox Guest
				VIRTUALBOX_GUEST=$(dmidecode --type 1 | grep VirtualBox)
				if [[ -z ${VIRTUALBOX_GUEST} ]]; then
					package_install "virtualbox virtualbox-host-dkms virtualbox-guest-iso linux-headers"
					aur_package_install "virtualbox-ext-oracle"
					add_user_to_group "${username}" vboxusers
					modprobe vboxdrv vboxnetflt
				else
					cecho "${BBlue}[${Reset}${Bold}!${BBlue}]${Reset} VirtualBox was not installed as we are a VirtualBox guest."
				fi
				;;
			15)
				package_install "icoutils wine wine_gecko wine-mono winetricks"
				;;
			16)
				package_install "netdata"
				system_ctl enable netdata.service
				;;
			17)
				package_install "nload"
				;;
			18)
				aur_package_install "vmware-workstation12"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#GRAPHICS {{{
install_graphics_apps() {
	while true; do
		print_title "GRAPHICS APPS"
		echo " 1) $(menu_item "blender")"
		echo " 2) $(menu_item "gimp")"
		echo " 3) $(menu_item "gthumb")"
		echo " 4) $(menu_item "inkscape")"
		echo " 5) $(menu_item "krita")"
		echo " 6) $(menu_item "mcomix")"
		echo " 7) $(menu_item "mypaint")"
		echo " 8) $(menu_item "pencil" "Pencil Prototyping Tool") $AUR"
		echo " 9) $(menu_item "scribus")"
		echo "10) $(menu_item "shotwell")"
		echo "11) $(menu_item "simple-scan")"
		echo "12) $(menu_item "yacreader")"
		echo ""
		echo " b) BACK"
		echo ""
		GRAPHICS_OPTIONS+=" b"
		read_input_options "$GRAPHICS_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "blender"
				;;
			2)
				package_install "gimp"
				;;
			3)
				package_install "gthumb"
				;;
			4)
				package_install "inkscape python2-numpy python-lxml"
				;;
			5)
				package_install "krita"
				;;
			6)
				package_install "mcomix"
				;;
			7)
				package_install "mypaint"
				;;
			8)
				aur_package_install "pencil"
				;;
			9)
				package_install "scribus"
				;;
			10)
				package_install "shotwell"
				;;
			11)
				package_install "simple-scan"
				;;
			12)
				package_install "yacreader"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#INTERNET {{{
install_internet_apps() {
	while true; do
		print_title "INTERNET APPS"
		echo " 1) Browser"
		echo " 2) Download|Fileshare"
		echo " 3) Email|RSS"
		echo " 4) Instant Messaging|IRC"
		echo " 5) Mapping Tools"
		echo " 6) VNC|Desktop Share"
		echo ""
		echo " b) BACK"
		echo ""
		INTERNET_OPTIONS+=" b"
		read_input_options "$INTERNET_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				#BROWSER {{{
				while true; do
					print_title "BROWSER"
					echo " 1) $(menu_item "google-chrome" "Chrome") $AUR"
					echo " 2) $(menu_item "chromium")"
					echo " 3) $(menu_item "firefox")"
					echo " 4) $(menu_item "midori konqueror" "$([[ ${KDE} -eq 1 ]] && echo "Konqueror" || echo "Midori")")"
					echo " 5) $(menu_item "opera")"
					echo " 6) $(menu_item "vivaldi") $AUR"
					echo " 7) $(menu_item "tor browser") $AUR"
					echo " 8) $(menu_item "brave browser") $AUR"
					echo ""
					echo " b) BACK"
					echo ""
					BROWSERS_OPTIONS+=" b"
					read_input_options "$BROWSERS_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							aur_package_install "google-chrome"
							;;
						2)
							package_install "chromium"
							;;
						3)
							package_install "firefox firefox-i18n-$LOCALE_FF"
							;;
						4)
							if [[ ${KDE} -eq 1 ]]; then
								package_install "konqueror"
							else
								package_install "midori"
							fi
							;;
						5)
							package_install "opera"
							;;
						6)
							aur_package_install "vivaldi"
							;;
						7)
							aur_package_install "tor-browser"
							;;
						8)
							aur_package_install "brave-browser"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=1
				;;
			2)
				#DOWNLOAD|FILESHARE {{{
				while true; do
					print_title "DOWNLOAD|FILESHARE"
					echo " 1) $(menu_item "deluge")"
					echo " 2) $(menu_item "dropbox") $AUR"
					echo " 3) $(menu_item "flareget") $AUR"
					echo " 4) $(menu_item "freedownloadmanager") $AUR"
					echo " 5) $(menu_item "google-drive-ocamlfuse", "Google Drive OCamlFuse") $AUR"
					echo " 6) $(menu_item "jdownloader") $AUR"
					echo " 7) $(menu_item "qbittorrent")"
					echo " 8) $(menu_item "nitroshare") $AUR"
					echo " 9) $(menu_item "rslsync" "Resilio Sync") $AUR"
					echo "10) $(menu_item "sparkleshare")"
					echo "11) $(menu_item "spideroak-one") $AUR"
					echo "12) $(menu_item "tixati") $AUR"
					echo "13) $(menu_item "transmission-qt transmission-gtk" "Transmission")"
					echo "14) $(menu_item "uget")"
					echo "15) $(menu_item "youtube-dl")"
					echo "16) $(menu_item "megasync")"
					echo "17) $(menu_item "extreme download manager") $AUR"
					echo ""
					echo " b) BACK"
					echo ""
					DOWNLOAD_OPTIONS+=" b"
					read_input_options "$DOWNLOAD_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							package_install "deluge"
							;;
						2)
							aur_package_install "dropbox"
							;;
						3)
							aur_package_install "flareget"
							;;
						4)
							aur_package_install "freedownloadmanager"
							;;
						5)
							aur_package_install "google-drive-ocamlfuse"
							;;
						6)
							aur_package_install "jdownloader"
							;;
						7)
							package_install "qbittorrent"
							;;
						8)
							package_install "nitroshare"
							;;
						9)
							aur_package_install "rslsync"
							;;
						10)
							package_install "sparkleshare"
							;;
						11)
							aur_package_install "spideroak"
							;;
						12)
							aur_package_install "tixati"
							;;
						13)
							if [[ ${KDE} -eq 1 ]]; then
								package_install "transmission-qt"
							else
								package_install "transmission-gtk"
							fi
							if [[ -f /home/${username}/.config/transmission/settings.json ]]; then
								replace_line '"blocklist-enabled": false' '"blocklist-enabled": true' /home/"${username}"/.config/transmission/settings.json
								replace_line "www\.example\.com\/blocklist" "list\.iblocklist\.com\/\?list=bt_level1&fileformat=p2p&archiveformat=gz" /home/"${username}"/.config/transmission/settings.json
							fi
							;;
						14)
							package_install "uget"
							;;
						15)
							package_install "youtube-dl"
							;;
						16)
							aur_package_install "megasync"
							;;
						17)
							aur_package_install "xdman"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=2
				;;
			3)
				#EMAIL {{{
				while true; do
					print_title "EMAIL|RSS"
					echo " 1) $(menu_item "liferea")"
					echo " 2) $(menu_item "thunderbird")"
					echo ""
					echo " b) BACK"
					echo ""
					EMAIL_OPTIONS+=" b"
					read_input_options "$EMAIL_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							package_install "liferea"
							;;
						2)
							package_install "thunderbird"
							[[ "$LOCALE_TB" != en_US ]] && package_install "thunderbird-i18n-$LOCALE_TB"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=3
				;;
			4)
				#IM|IRC {{{
				while true; do
					print_title "IM - INSTANT MESSAGING"
					echo " 1) $(menu_item "hexchat konversation" "$([[ ${KDE} -eq 1 ]] && echo "Konversation" || echo "Hexchat")")"
					echo " 2) $(menu_item "irssi")"
					echo " 3) $(menu_item "pidgin")"
					echo " 4) $(menu_item "element-desktop")"
					echo " 5) $(menu_item "skypeforlinux-stable-bin" "Skype Stable") $AUR"
					echo " 6) $(menu_item "skypeforlinux-preview-bin" "Skype Preview") $AUR"
					echo " 7) $(menu_item "teamspeak3")"
					echo " 8) $(menu_item "viber") $AUR"
					echo " 9) $(menu_item "telegram-desktop")"
					echo "10) $(menu_item "qtox")"
					echo "11) $(menu_item "discord")"
					echo "12) $(menu_item "slack") $AUR"
					echo "13) $(menu_item "vk-messenger") $AUR"
					echo "14) $(menu_item "zoom") $AUR"
					echo ""
					echo " b) BACK"
					echo ""
					IM_OPTIONS+=" b"
					read_input_options "$IM_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							if [[ ${KDE} -eq 1 ]]; then
								package_install "konversation"
							else
								package_install "hexchat"
							fi
							;;
						2)
							package_install "irssi"
							;;
						3)
							package_install "pidgin"
							;;
						4)
							package_install "element-desktop"
							;;
						5)
							aur_package_install "skypeforlinux-stable-bin"
							;;
						6)
							aur_package_install "skypeforlinux-preview-bin"
							;;
						7)
							package_install "teamspeak3"
							;;
						8)
							aur_package_install "viber"
							;;
						9)
							package_install "telegram-desktop"
							;;
						10)
							package_install "qtox"
							;;
						11)
							package_install "discord"
							;;
						12)
							aur_package_install "slack-desktop"
							;;
						13)
							aur_package_install "vk-messanger"
							;;
						14)
							aur_package_install "zoom"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=4
				;;
			5)
				#MAPPING {{{
				while true; do
					print_title "MAPPING TOOLS"
					echo " 1) $(menu_item "google-earth") $AUR"
					echo " 2) $(menu_item "qgis" "QGIS") $AUR"
					echo ""
					echo " b) BACK"
					echo ""
					MAPPING_OPTIONS+=" b"
					read_input_options "$MAPPING_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							aur_package_install "google-earth"
							;;
						2)
							aur_package_install "qgis"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=5
				;;
			6)
				#DESKTOP SHARE {{{
				while true; do
					print_title "DESKTOP SHARE"
					echo " 1) $(menu_item "anydesk") $AUR"
					echo " 2) $(menu_item "remmina")"
					echo " 3) $(menu_item "teamviewer") $AUR"
					echo ""
					echo " b) BACK"
					echo ""
					VNC_OPTIONS+=" b"
					read_input_options "$VNC_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							aur_package_install "anydesk"
							;;
						2)
							package_install "remmina"
							;;
						3)
							aur_package_install "teamviewer"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=6
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#AUDIO {{{
install_audio_apps() {
	while true; do
		print_title "AUDIO APPS"
		echo " 1) Players"
		echo " 2) Editors|Tools"
		echo " 3) Codecs"
		echo ""
		echo " b) BACK"
		echo ""
		AUDIO_OPTIONS+=" b"
		read_input_options "$AUDIO_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				#PLAYERS {{{
				while true; do
					print_title "AUDIO PLAYERS"
					echo " 1) $(menu_item "amarok")"
					echo " 2) $(menu_item "audacious")"
					echo " 3) $(menu_item "clementine")"
					echo " 4) $(menu_item "deadbeef")"
					echo " 5) $(menu_item "guayadeque") $AUR"
					echo " 6) $(menu_item "lollypop") $AUR"
					echo " 7) $(menu_item "musique") $AUR"
					echo " 8) $(menu_item "pragha")"
					echo " 9) $(menu_item "rhythmbox")"
					echo "10) $(menu_item "spotify") $AUR"
					echo "11) $(menu_item "timidity++") $AUR"
					echo "12) $(menu_item "quodlibet")"
					echo ""
					echo " b) BACK"
					echo ""
					AUDIO_PLAYER_OPTIONS+=" b"
					read_input_options "$AUDIO_PLAYER_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							package_install "amarok"
							;;
						2)
							package_install "audacious audacious-plugins"
							;;
						3)
							package_install "clementine"
							;;
						4)
							package_install "deadbeef"
							;;
						5)
							aur_package_install "guayadeque"
							;;
						6)
							aur_package_install "lollypop"
							;;
						7)
							aur_package_install "musique"
							;;
						8)
							package_install "pragha"
							;;
						9)
							package_install "rhythmbox grilo grilo-plugins libgpod libdmapsharing gnome-python python-mako"
							;;
						10)
							aur_package_install "spotify ffmpeg-compat ffmpeg-compat-57"
							;;
						11)
							aur_package_install "timidity++ fluidr3"
							echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >>/etc/timidity++/timidity.cfg
							;;
						12)
							package_install "quodlibet"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=1
				;;
			2)
				#EDITORS {{{
				while true; do
					print_title "AUDIO EDITORS|TOOLS"
					echo " 1) $(menu_item "audacity")"
					echo " 2) $(menu_item "easytag")"
					echo " 3) $(menu_item "ocenaudio-bin") $AUR"
					echo " 4) $(menu_item "soundconverter soundkonverter" "$([[ ${KDE} -eq 1 ]] && echo "Soundkonverter" || echo "Soundconverter")")"
					echo ""
					echo " b) BACK"
					echo ""
					AUDIO_EDITOR_OPTIONS+=" b"
					read_input_options "$AUDIO_EDITOR_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							package_install "audacity"
							;;
						2)
							package_install "easytag"
							;;
						3)
							aur_package_install "ocenaudio-bin"
							;;
						4)
							if [[ ${KDE} -eq 1 ]]; then
								package_install "soundkonverter"
							else
								package_install "soundconverter"
							fi
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=2
				;;
			3)
				package_install "gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav"
				[[ ${KDE} -eq 1 ]] && package_install "phonon-qt5-gstreamer"
				# Use the 'standard' preset by default. This preset should generally be
				# transparent to most people on most music and is already quite high in quality.
				# The resulting bitrate should be in the 170-210kbps range, according to music
				# complexity.
				run_as_user "gconftool-2 --type string --set /system/gstreamer/0.10/audio/profiles/mp3/pipeline \audio/x-raw-int,rate=44100,channels=2 ! lame name=enc preset=1001 ! id3v2mux\""
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#VIDEO {{{
install_video_apps() {
	while true; do
		print_title "VIDEO APPS"
		echo " 1) Players"
		echo " 2) Editors|Tools"
		echo " 3) Codecs"
		echo ""
		echo " b) BACK"
		echo ""
		VIDEO_OPTIONS+=" b"
		read_input_options "$VIDEO_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				#PLAYERS {{{
				while true; do
					print_title "VIDEO PLAYERS"
					echo "  1) $(menu_item "gnome-mplayer")"
					echo "  2) $(menu_item "livestreamer")"
					echo "  3) $(menu_item "minitube")"
					echo "  4) $(menu_item "mpv")"
					echo "  5) $(menu_item "smplayer")"
					echo "  6) $(menu_item "parole")"
					echo "  7) $(menu_item "plex-media-server" "Plex") $AUR"
					echo "  8) $(menu_item "popcorntime-ce") $AUR"
					echo "  9) $(menu_item "vlc")"
					echo " 10) $(menu_item "kodi")"
					echo ""
					echo " b) BACK"
					echo ""
					VIDEO_PLAYER_OPTIONS+=" b"
					read_input_options "$VIDEO_PLAYER_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							package_install "gnome-mplayer"
							;;
						2)
							package_install "livestreamer"
							;;
						3)
							package_install "minitube"
							;;
						4)
							package_install "mpv"
							;;
						5)
							package_install "smplayer"
							;;
						6)
							package_install "parole"
							;;
						7)
							aur_package_install "plex-media-server"
							system_ctl enable plexmediaserver.service
							;;
						8)
							aur_package_install "popcorntime-ce"
							;;
						9)
							package_install "vlc"
							;;
						10)
							package_install "kodi"
							add_user_to_group "${username}" kodi
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=1
				;;
			2)
				#EDITORS {{{
				while true; do
					print_title "VIDEO EDITORS|TOOLS"
					echo " 1) $(menu_item "arista") $AUR"
					echo " 2) $(menu_item "avidemux-gtk avidemux-qt" "Avidemux")"
					echo " 3) $(menu_item "filebot") $AUR"
					echo " 4) $(menu_item "handbrake")"
					echo " 5) $(menu_item "kdenlive")"
					echo " 6) $(menu_item "lwks" "Lightworks") $AUR"
					echo " 7) $(menu_item "openshot")"
					echo " 8) $(menu_item "pitivi")"
					echo " 9) $(menu_item "transmageddon")"
					echo ""
					echo " b) BACK"
					echo ""
					VIDEO_EDITOR_OPTIONS+=" b"
					read_input_options "$VIDEO_EDITOR_OPTIONS"
					for OPT in "${OPTIONS[@]}"; do
						case "$OPT" in
						1)
							aur_package_install "arista"
							;;
						2)
							if [[ ${KDE} -eq 1 ]]; then
								package_install "avidemux-qt"
							else
								package_install "avidemux-gtk"
							fi
							;;
						3)
							aur_package_install "filebot"
							;;
						4)
							package_install "handbrake"
							;;
						5)
							package_install "kdenlive"
							;;
						6)
							aur_package_install "lwks"
							;;
						7)
							package_install "openshot"
							;;
						8)
							package_install "pitivi frei0r-plugins"
							;;
						9)
							package_install "transmageddon"
							;;
						"b")
							break
							;;
						*)
							invalid_option
							;;
						esac
					done
					source sharedfuncs_elihw
				done
				#}}}
				OPT=2
				;;
			3)
				package_install "libdvdnav libdvdcss cdrdao cdrtools ffmpeg ffmpegthumbnailer ffmpegthumbs"
				if [[ ${KDE} -eq 1 ]]; then
					package_install "kdegraphics-thumbnailers"
				fi
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#GAMES {{{
install_games() {
	while true; do
		print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
		echo " 1) 0AD"
		echo " 2) PlayOnLinux"
		echo " 3) Steam"
		echo " 4) Lutris"
		echo " 5) Mindustry $AUR"
		echo " 6) Minecraft $AUR"
		echo " 7) Minetest"
		echo " 8) Openra"
		echo " 9) OSU!-Lazer $AUR"
		echo "10) Wesnoth"
		echo "11) Xonotic"
		echo ""
		echo " b) BACK"
		echo ""
		GAMES_OPTIONS+=" b"
		read_input_options "$GAMES_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "0ad"
				OPT=1
				;;
			2)
				package_install "playonlinux"
				OPT=2
				;;
			3)
				package_install "steam"
				OPT=3
				;;
			4)
				package_install "lutris"
				OPT=4
				;;
			5)
				aur_package_install "mindustry"
				OPT=5
				;;
			6)
				aur_package_install "minecraft"
				OPT=6
				;;
			7)
				package_install "minetest"
				OPT=7
				;;
			8)
				package_install "openra"
				OPT=8
				;;
			9)
				aur_package_install "osu-lazer"
				OPT=9
				;;
			10)
				package_install "wesnoth"
				OPT=10
				;;
			11)
				package_install "xonotic"
				OPT=11
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#WEBSERVER {{{
install_web_server() {
	install_adminer() { #{{{
		aur_package_install "adminer"
		local ADMINER=$(grep Adminer /etc/httpd/conf/httpd.conf)
		[[ -z $ADMINER ]] && echo -e '\n# Adminer Configuration\nInclude conf/extra/httpd-adminer.conf' >>/etc/httpd/conf/httpd.conf
	} #}}}

	install_mariadb() { #{{{
		package_install "mariadb"
		/usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
		system_ctl enable mysqld.service
		systemctl start mysqld.service
		/usr/bin/mysql_secure_installation
	} #}}}

	install_postgresql() { #{{{
		package_install "postgresql"
		mkdir -p /var/lib/postgres
		chown -R postgres:postgres /var/lib/postgres
		systemd-tmpfiles --create postgresql.conf
		echo "Enter your new postgres account password:"
		passwd postgres
		while [[ $? -ne 0 ]]; do
			passwd postgres
		done
		su - postgres -c "initdb --locale ${LOCALE}.UTF-8 -D /var/lib/postgres/data"
		system_ctl enable postgresql.service
		system_ctl start postgresql.service
		read_input_text "Install Postgis + Pgrouting" "$POSTGIS"
		[[ $OPTION == y ]] && install_gis_extension
	} #}}}

	install_gis_extension() { #{{{
		package_install "postgis"
		aur_package_install "pgrouting"
	} #}}}

	configure_php() { #{{{
		if [[ -f /etc/php/php.ini.pacnew ]]; then
			mv -v /etc/php/php.ini /etc/php/php.ini.pacold
			mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
			rm -v /etc/php/php.ini.aui
		fi
		[[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui" || cp -v /etc/php/php.ini /etc/php/php.ini.aui
		if [[ $1 == mariadb ]]; then
			sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
			sed -i '/mysql.so/s/^;//' /etc/php/php.ini
			sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
		else
			sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
		fi
		sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
		sed -i '/gd.so/s/^;//' /etc/php/php.ini
		sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
	} #}}}

	configure_php_apache() { #{{{
		if [[ -f /etc/httpd/conf/httpd.conf.pacnew ]]; then
			mv -v /etc/httpd/conf/httpd.conf.pacnew /etc/httpd/conf/httpd.conf
			rm -v /etc/httpd/conf/httpd.conf.aui
		fi
		[[ -f /etc/httpd/conf/httpd.conf.aui ]] && echo "/etc/httpd/conf/httpd.conf.aui" || cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
		local IS_DISABLED=$(grep php5_module.conf /etc/httpd/conf/httpd.conf)
		if [[ -z $IS_DISABLED ]]; then
			echo -e 'application/x-httpd-php5                php php5' >>/etc/httpd/conf/mime.types
			sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
			echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >>/etc/httpd/conf/httpd.conf
			#  libphp5.so included with php-apache does not work with mod_mpm_event (FS#39218). You'll have to use mod_mpm_prefork instead
			replace_line 'LoadModule mpm_event_module modules/mod_mpm_event.so' 'LoadModule mpm_prefork_module modules/mod_mpm_prefork.so' /etc/httpd/conf/httpd.conf
			replace_line 'DirectoryIndex\ index.html' 'DirectoryIndex\ index.html\ index.php' /etc/httpd/conf/httpd.conf
		fi
	} #}}}

	configure_php_nginx() { #{{{
		if [[ -f /etc/nginx/nginx.conf.pacnew ]]; then
			mv -v /etc/nginx/nginx.conf.pacnew /etc/nginx/nginx.conf
			rm -v /etc/nginx/nginx.conf.aui
		fi
		[[ -f /etc/nginx/nginx.conf.aui ]] && cp -v /etc/nginx/nginx.conf.aui /etc/nginx/nginx.conf || cp -v /etc/nginx/nginx.conf /etc/nginx/nginx.conf.aui
		sed -i -e '/location ~ \.php$ {/,/}/d' /etc/nginx/nginx.conf
		sed -i -e '/pass the PHP/a\        #\n        location ~ \.php$ {\n            fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;\n            fastcgi_index  index.php;\n            root           /srv/http;\n            include        fastcgi.conf;\n        }' /etc/nginx/nginx.conf
	} #}}}

	create_sites_folder() { #{{{
		[[ ! -f /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
		replace_line 'public_html' 'Sites' /etc/httpd/conf/extra/httpd-userdir.conf
		su - "${username}" -c "mkdir -p ~/Sites"
		su - "${username}" -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
		print_line
		echo "The folder \"Sites\" has been created in your home"
		echo "You can access your projects at \"http://localhost/~username\""
		pause_function
	} #}}}

	print_title "WEB SERVER - https://wiki.archlinux.org/index.php/LAMP|LAPP"
	print_info "*Adminer is installed by default in all options"
	echo " 1) LAMP - APACHE, MariaDB & PHP"
	echo " 2) LAPP - APACHE, POSTGRESQL & PHP"
	echo " 3) LEMP - NGINX, MariaDB & PHP"
	echo " 4) LEPP - NGINX, POSTGRESQL & PHP"
	echo ""
	echo " b) BACK"
	echo ""
	read_input "$WEBSERVER"
	case "$OPTION" in
	1)
		package_install "apache php php-apache php-mcrypt php-gd"
		install_mariadb
		install_adminer
		system_ctl enable httpd.service
		configure_php_apache
		configure_php "mariadb"
		create_sites_folder
		;;
	2)
		package_install "apache php php-apache php-pgsql php-gd"
		install_postgresql
		install_adminer
		system_ctl enable httpd.service
		configure_php_apache
		configure_php "postgresql"
		create_sites_folder
		;;
	3)
		package_install "nginx php php-mcrypt php-fpm"
		install_mariadb
		system_ctl enable nginx.service
		system_ctl enable php-fpm.service
		configure_php_nginx
		configure_php "mariadb"
		;;
	4)
		package_install "nginx php php-fpm php-pgsql"
		install_postgresql
		system_ctl enable nginx.service
		system_ctl enable php-fpm.service
		configure_php_nginx
		configure_php "postgresql"
		;;
	esac
}
#}}}
#FONTS {{{
install_fonts() {
	while true; do
		print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
		echo " 1) $(menu_item "ttf-dejavu")"
		echo " 2) $(menu_item "ttf-fira-code") $AUR"
		echo " 3) $(menu_item "ttf-google-fonts-git") $AUR"
		echo " 4) $(menu_item "ttf-liberation")"
		echo " 5) $(menu_item "ttf-bitstream-vera")"
		echo " 6) $(menu_item "ttf-hack")"
		echo " 7) $(menu_item "ttf-mac-fonts") $AUR"
		echo " 8) $(menu_item "ttf-ms-fonts") $AUR"
		echo " 9) $(menu_item "wqy-microhei") (Chinese/Japanese/Korean Support)"
		echo "10) $(menu_item "noto-fonts-cjk") (Chinese/Japanese/Korean Support)"
		echo "11) $(menu_item "nerd-fonts-complete") $AUR"
		echo "12) $(menu_item "yanc-font") $AUR"
		echo ""
		echo " b) BACK"
		echo ""
		FONTS_OPTIONS+=" b"
		read_input_options "$FONTS_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "ttf-dejavu"
				;;
			2)
				aur_package_install "ttf-fira-code"
				;;
			3)
				package_remove "ttf-droid"
				package_remove "ttf-roboto"
				package_remove "ttf-ubuntu-font-family"
				package_remove "otf-oswald-ib"
				aur_package_install "ttf-google-fonts-git"
				;;
			4)
				package_install "ttf-liberation"
				;;
			5)
				package_install "ttf-bitstream-vera"
				;;
			6)
				package_install "ttf-hack"
				;;
			7)
				aur_package_install "ttf-mac-fonts"
				;;
			8)
				aur_package_install "ttf-ms-fonts"
				;;
			9)
				package_install "wqy-microhei"
				;;
			10)
				package_install "noto-fonts-cjk"
				;;
			11)
				aur_package_install "nerd-fonts-complete"
				;;
			12)
				aur_package_install "yanc-font"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#IME INPUT TOOLS {{{
choose_ime_m17n() {
	while true; do
		print_title "INTERNATIONALIZATION - https://wiki.archlinux.org/index.php/Internationalization"
		echo " 1) $(menu_item "fcitx")"
		echo " 2) $(menu_item "ibus")"
		echo ""
		echo " b) BACK"
		echo ""
		IME_OPTIONS+=" b"
		read_input_options "IME_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				package_install "fcitx"
				package_install "fcitx-m17n"
				package_install "fcitx-qt4"
				package_install "fcitx-qt5"
				package_install "fcitx-gtk2"
				package_install "fcitx-gtk3"
				package_install "kcm-fcitx"
				package_install "fcitx-configtool"
				echo -e '#!/bin/sh\n\n\n# Identify fcitx as a input module for both GTK and QT apps\nXMODIFIERS=@im=fcitx\nGTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\n\nexport XMODIFIERS GTK_IM_MODULE QT_IM_MODULE\necho we set XMODIFIERS GTK_IM_MODULE QT_IM_MODULE in profile.d\n' >/etc/profile.d/ime.sh
				# echo -e '#!/bin/sh\n\n\n# Identify fcitx as a input module for both GTK and QT apps\nXMODIFIERS=@im=fcitx\nGTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\n\nexport XMODIFIERS GTK_IM_MODULE QT_IM_MODULE\necho we set XMODIFIERS GTK_IM_MODULE QT_IM_MODULE in xprofile\n' > /etc/xprofile
				;;
			2)
				package_install "ibus"
				package_install "ibus-m17n"
				package_install "ibus-qt"
				echo -e '#!/bin/sh\n\n\n# Identify ibus as a input module for both GTK and QT apps\nXMODIFIERS=@im=ibus\nGTK_IM_MODULE=ibus\nQT_IM_MODULE=ibus\n\nexport XMODIFIERS GTK_IM_MODULE QT_IM_MODULE\necho we set XMODIFIERS GTK_IM_MODULE QT_IM_MODULE in profile.d\n' >/etc/profile.d/ime.sh
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
}
#}}}
#CLEAN ORPHAN PACKAGES {{{
clean_orphan_packages() {
	print_title "CLEAN ORPHAN PACKAGES"
	pacman -Rsc --noconfirm "$(pacman -Qqdt)"
	#pacman -Sc --noconfirm
	pacman-optimize
}
#}}}
#RECONFIGURE SYSTEM {{{
reconfigure_system() {
	print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
	print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
	printf "%s" "Hostname [ex: archlinux]: "
	read -r HN
	hostnamectl set-hostname "$HN"

	print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
	print_info "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
	OPTION=n
	while [[ $OPTION != y ]]; do
		settimezone
		read_input_text "Confirm timezone ($ZONE/$SUBZONE)"
	done
	timedatectl set-timezone "${ZONE}"/"${SUBZONE}"

	print_title "HARDWARE CLOCK TIME - https://wiki.archlinux.org/index.php/Internationalization"
	print_info "This is set in /etc/adjtime. Set the hardware clock mode uniformly between your operating systems on the same machine. Otherwise, they will overwrite the time and cause clock shifts (which can cause time drift correction to be miscalibrated)."
	hwclock_list=('UTC' 'Localtime')
	PS3="$prompt1"
	select OPT in "${hwclock_list[@]}"; do
		case "$REPLY" in
		1)
			timedatectl set-local-rtc false
			;;
		2)
			timedatectl set-local-rtc true
			;;
		*) invalid_option ;;
		esac
		[[ -n $OPT ]] && break
	done
	timedatectl set-ntp true
}
#}}}
#EXTRA {{{
install_extra() {
	while true; do
		print_title "EXTRA"
		echo " 1) $(menu_item "profile-sync-daemon") $AUR"
		echo ""
		echo " b) BACK"
		echo ""
		EXTRA_OPTIONS+=" b"
		read_input_options "$EXTRA_OPTIONS"
		for OPT in "${OPTIONS[@]}"; do
			case "$OPT" in
			1)
				aur_package_install "profile-sync-daemon"
				run_as_user "psd"
				run_as_user "$EDITOR /home/${username}/.config/psd/psd.conf"
				run_as_user "systemctl --user enable psd.service"
				;;
			"b")
				break
				;;
			*)
				invalid_option
				;;
			esac
		done
		source sharedfuncs_elihw
	done
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
