#!/bin/bash

declare_variables() {
    # A function which declares variables.

    # Creating a variable called user name.
    username=${SUDO_USER:-${USER}}
    # Creating a path which leads to the apps.list file.
    apt_app_list_file="../apps.list"
    # Creating a path which leads to the flatpak_apps.list file.
    flatpak_app_list_file="../flatpak_apps.list"
    # Creating a list of virtual environment wrapper profile lines
    list_of_virtual_env_profile_lines=("export WORKON_HOME=$HOME/.virtualenvs" "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" "export PROJECT_HOME=$HOME/Devel" "source /usr/local/bin/virtualenvwrapper.sh")
}

main() {
    # The function which runs the entire program.

    # Calling the declare_variables function.
    declare_variables
    # Calling the install_nala_package_manager function.
    install_nala_package_manager
    # Calling the install_softwares_with_nala function.
    install_softwares_with_nala
    # Calling the install_softwares_with_flatpak function.
    install_softwares_with_flatpak
    # Calling the install_virtual_env_wrapper function.
    install_virtual_env_wrapper
    # Calling the clone_security_lists function.
    clone_security_lists
    # Calling the install_cheat_sheets function.
    install_cheat_sheets
}

install_nala_package_manager() {
    # A function which installs the nala package manager.

    # Installing nala package manager
    apt install nala -y;
}

install_softwares_with_nala() {
    # A function which installs softwares using the nala package manager.

    # Looping through each line in the app.list file.
    for line in $(cat $apt_app_list_file);do
        # Checking if the software which is written in the line is not installed.
        if [[ `apt-cache policy "$line"` == *"(none)"* ]]; then
            # Installing the software which is written in the line.
            nala install $line -yy;
            # Continuing looping after installation.
            continue
        # Checking if the software which is written in the line is installed.
        else
            # Telling to user that the software is already installed.
            echo "$line is already installed";
        fi
    done

    # Checking if veracrypt is not installed.
    if [[ `apt-cache policy "veracrypt"` == *"(none)"* ]]; then
        # Changing the current working directory.
        cd /opt
        # Checking if file is not exists.
        if [[ ! -f /opt/veracrypt.deb ]]; then
            # Send a get request to download the file.
            curl -L https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Debian-11-amd64.deb -o veracrypt.deb;
            # Changing the file permissions.
            chmod 777 veracrypt.deb;
            # Installing the veracrypt
            sudo nala install ./veracrypt.deb -yy;
        # Checking if the file is exists.
        else
            # Changing the file permissions.
            sudo chmod 777 veracrypt.deb;
            # Installing the veracrypt
            sudo nala install ./veracrypt.deb -yy;
        fi
    # Checking if the software is already installed.
    else
        # Telling to user that, the application is already installed.
        echo "Veracrypt is already installed. And, it's available in /opt";
    fi

}

install_softwares_with_flatpak() {
    # A function which installes softwares using the flatpak package manager.

    # Adding the flatpak remote repository Hint: A url which tells to flatpak where to look for packages.
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Looping through each application in the flatpak_apps.list file.
    for app in $(cat $flatpak_app_list_file);do
        # Checking if the application is not installed.
        if [[ `flatpak list` != *"$app"* ]]; then
            # Installing the application.
            flatpak install $app -y;
            # Continuing looping after installation.
            continue
        # Checking if the application is installed.
        else
            # Telling to user that the software is already installed.
            echo "$app is already installed";
        fi
    done
}

install_virtual_env_wrapper() {
	# A function which installs the python virtual environment wrapper.

    # Checking if the virtualenvwrapper is not installed.
	if [[ `pip3 freeze` != *"virtualenvwrapper"* ]]; then
        # Installing the virtualenvwrapper python package.
		sudo pip3 install virtualenvwrapper
        # Looping through each line in the list_of_virtual_env_profile_lines list
        for line in "${list_of_virtual_env_profile_lines[@]}"; do
            # Checking if the line is not written the user's .bashrc file.
            if [[ ! `grep "$line" "/home/$username/.bashrc"` ]]; then
                # Appending the line ot the user's .bashrc file.
                echo "$line" >> "/home/$username/.bashrc"
            fi
        done
    # Checking if the virtualenvwrapper package is installed.
	else 
        # Letting the user know that the package is available in the system.
        echo "virtualenvwrapper is available in the system."
    fi
}

clone_security_lists() {
    # A function which clones security lists from github.

    # Checking if the directory is not exists.
    if [[ ! -d "/home/$username/Downloads/SecLists/" ]]; then
        # Cloning the repository to downloads.
        git clone https://github.com/danielmiessler/SecLists "/home/$username/Downloads/SecLists";
    # Checking if the directory is exists.
    else
        # Telling to user that, the security lists are already available in the system.
        echo "SecLists are already available in your system.";
    fi
}

install_cheat_sheets() {
    # A function which installs cheat sheets.

    # Checking if the file is not exists.
    if [[ ! -f "/usr/local/bin/cheat" ]]; then
        # Changing the current working directory to /tmp
        cd /tmp
        # Download the cheat sheets
        wget https://github.com/cheat/cheat/releases/download/4.3.3/cheat-linux-amd64.gz
        # Extracting the files.
        gunzip cheat-linux-amd64.gz
        # Adding execute permission to the folder.
        chmod +x cheat-linux-amd64
        # Moving the cheat sheets folder to /usr/local/bin/cheat
        mv cheat-linux-amd64 /usr/local/bin/cheat

    # Checknig if the directory is exists.
    else
        # Telling to user that the cheat sheets are already available in the system.
        echo "Cheat sheets command line tool is already available in your system.";
    fi
}

# Calling the main function.
main