#!/bin/bash

# The best way to create custom ubuntu based operating system is obtaining the base system, extracting iso contents, extracting the desktop system and then making your customizations. More detailed information is included in the fallowing links.
# 1) https://help.ubuntu.com/community/LiveCDCustomization
# 2) https://help.ubuntu.com/community/LiveCDCustomizationFromScratch
# 3) https://wiki.debian.org/DebianDevelopment

# The best way to create your own operating from scractch is reading the books below the linux from scractch project isn't a super minimal os. It's a set of instructions, written in a book, which makes you create your own linux operating system.
# 1) https://www.linuxfromscratch.org/lfs/downloads/stable-systemd/LFS-BOOK-11.2-NOCHUNKS.html
# 2) https://www.linuxfromscratch.org/blfs/downloads/stable-systemd/BLFS-BOOK-11.2-systemd-nochunks.html
# 3) https://www.linuxfromscratch.org/lfs/download.html
# 4) https://www.linuxfromscratch.org/blfs/download.html
# blfs -> beyond linux from scratch is the second book which is teaching how to install desktop environments and web browsers and etc.
# Note: You can use chatGPT, debootstrap and chroot to create your own debian based operating system.

declaring_variables() {
	# A function which decalres variables.

	# Creating a variable called username by getting the user's username from the system.
	username=${SUDO_USER:-${USER}}
	# Creating a path which leads to the themes folder.
	themes_folder_path="../themes"
	# A path variable for the papirus icon's compressed folder.
	icon_theme_compressed_folder_path="../themes/papirus-icon-theme-green-folders.tar.xz"
	# A path varible to cursor's compressed folder
	cursor_theme_compressed_folder_path="../themes/Qogir-ubuntu-cursors.tar.xz"
	# A path variable for the Papirus folder which is uncompressed and inside the themes folder
	icon_theme_folder_path="../themes/Papirus/"
	# A path variable to cursor theme
	cursor_theme_folder="../themes/Qogir-ubuntu-cursors/"
	# Creating a path for the wallpapers folder
	wallpapers_folder_path="../wallpapers/"
	# Creating a path for the lock screen images folder
	lock_screen_images_folder="../lock_screen_images/"
}

main() {
	# The function which runs the entire script.

	# Calling the declaring_variables function.
	declaring_variables
	# Calling the customize_user_shell function.
	customize_user_shell
	# Calling the customize_root_shell function.
	customize_root_shell
	# Calling the load_the_themes function.
	load_the_themes
	# Calling the load_the_images function.
	load_the_images
}

customize_user_shell() {
	# A function which customizes the user shell.

	# Creating a backup of regular user's .bashrc file.
	cp "/home/$username/.bashrc" "/home/$username/.bashrc.bak"
	if [[ ! `grep HISTTIMEFORMAT="%d/%m/%y %T` != "/home/$username/.bashrc" ]]; then
		# Customizing the shell prompt.
		echo 'export PS1="-[\[$(tput sgr0)\]\[\033[38;5;10m\]\d\[$(tput sgr0)\]-\[$(tput sgr0)\]\[\033[38;5;10m\]\t\[$(tput sgr0)\]]-[\[$(tput sgr0)\]\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;196m\]\h\[$(tput sgr0)\]]-\n-[\[$(tput sgr0)\]\[\033[38;5;33m\]\w\[$(tput sgr0)\]]\\$ \[$(tput sgr0)\]"' >> "/home/$username/.bashrc"
		# Customizing user's history format.
		echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> "/home/$username/.bashrc"
		# Executing commands from a file in the current shell.
		source "/home/$username/.bashrc"
	else
		echo "Terminal is already modified"
	fi
}

customize_root_shell() {
	# A function which customizes the root shell.

	# Creating a backup of root user's .bashrc file.
	cp "/root/.bashrc" "/root/.bashrc.bak"
	# Customizing root user's shell prompt.
	echo 'export PS1="-[\[$(tput sgr0)\]\[\033[38;5;10m\]\d\[$(tput sgr0)\]-\[$(tput sgr0)\]\[\033[38;5;10m\]\t\[$(tput sgr0)\]]-[\[$(tput sgr0)\]\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;196m\]\h\[$(tput sgr0)\]]-\n-[\[$(tput sgr0)\]\[\033[38;5;33m\]\w\[$(tput sgr0)\]]\\$ \[$(tput sgr0)\]"' >> "/root/.bashrc"
	# Customizing root's history format.
	echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> "/root/.bashrc"
	# Executing commands from a file in the current shell.
	source "/root/.bashrc"
}

load_the_themes() {
	# A function which sets up the themes in the system.

	# Checking if the Papirus theme's folder is not exists in the icons folder.
	if [[ ! -d "/usr/share/icons/Papirus" ]]; then
		# Checking if the path which leads to the icon theme's folder where it's extracted is not exists.
		if [[ ! -d "$icon_theme_folder_path" ]]; then
			# Extracting the icon theme
			tar -xf "$icon_theme_compressed_folder_path" -C "$themes_folder_path"
			# Chaning the folder ownership of the extracted folder.
			chown -R $username:$username "$icon_theme_folder_path"
			# Copying the icon theme to icons folder in the system recursively.
			cp -r "$icon_theme_folder_path" "/usr/share/icons/"
		# Checking if the path which leads to the icon theme's folder where it's extracted is exists.
		else
			# Copying the icon theme to the correct location in the system recursively.
			cp -r "$icon_theme_folder_path" "/usr/share/icons/"
		fi
	# Checking if the Papirus themes folder is exists in the icons folder.
	else
		# Letting the user know that the icon theme is already available in the system.
		echo "Papirus icon theme is already in the correct location"
	fi

	# Checking if the Qogir-ubuntu-cursors theme's folder is not exists in the icons folder.
	if [[ ! -d "/usr/share/icons/Qogir-ubuntu-cursors" ]]; then
		# Checking if the path which leads to the cursor theme's folder where it's extracted is not exists.
		if [[ ! -d "$cursor_theme_folder" ]]; then
			# Extracting the cursor themes.
			tar -xf "$cursor_theme_compressed_folder_path" -C "$themes_folder_path"
			# Copying the cursor theme  to the correct location in the system recursively.
			cp -r "$cursor_theme_folder" "/usr/share/icons/"
		# Checking if the path which leads to the cursor theme's folder where it's extracted is exists.
		else
			# Copying the cursor theme  to the correct location in the system recursively.
			cp -r "$cursor_theme_folder" "/usr/share/icons/"
		fi
	# Checking if the Cursor themes folder is exists in the icons folder.
	else
		# Letting the user know that, the cursor themse is already available in the system. 
		echo "Qogir-ubuntu-cursors cursor theme is already avaiable in the system."
	fi
}

load_the_images() {
	# A function which copies images to appropriate locations
	
	# Copying the wallpapers folder into the Pictures folder
	cp -r $wallpapers_folder_path "/home/$username/Pictures/wallpapers"

	# Copying the wallpapers folder into the Pictures folder
	cp -r $lock_screen_images_folder "/home/$username/Pictures/lock_screen_images"
}

# Calling the main function.
main