#!/bin/bash

main() {
    # The function which runs the entire program.

    # Calling the declare_variables function.
    declare_variables

    # Calling the install_softwares_with_apt function.
    install_softwares_with_apt

    # Calling the install_softwares_with_dpkg function.
    install_softwares_with_dpkg

    # Calling the install_softwares_with_flatpak function.
    install_softwares_with_flatpak

    # Calling the install_softwares_with_snap function
    install_softwares_with_snap

    # Calling the install_virtual_env_wrapper function.
    install_virtual_env_wrapper

    # Calling the clone_security_lists function.
    clone_security_lists

    # Calling the install_cheat_sheets function.
    install_cheat_sheets

}

declare_variables() {
    # A function which declares variables.

    the_script_path=`pwd`

    # Creating a variable called user name.
    username=${SUDO_USER:-${USER}}

    # Creating a path variable which leads to the user's home directory.
    home_dir="/home/$username"

    # Creating a path which leads to the apt_apps.list file.
    apt_apps_list_file="../apt_apps.list"

    # Creating a path which leads to the snap_apps.list file.
    snap_apps_list_file="../snap_apps.list"

    # Creating a path which leads to the flatpak_apps.list file.
    flatpak_apps_list_file="../flatpak_apps.list"

    # Creating a list of virtual environment wrapper profile lines
    list_of_virtual_env_profile_lines=("export WORKON_HOME=$home_dir/.virtualenvs" "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" "export PROJECT_HOME=$home_dir/Devel" "source /usr/local/bin/virtualenvwrapper.sh")
   
    # Creating a list for the command line tools that I created.
    my_apps_list_file="../myapps.list"

}

install_softwares_with_apt() {
    # A function which installs softwares using the apt package manager.

    # Telling to the user what's happening
    echo "Installing the softwares from apt_apps.list file with apt package manager"

    # Looping through each line in the app.list file.
    for line in $(cat $apt_apps_list_file);do

        # Checking if the software which is written in the line is not installed.
        if [[ `apt-cache policy "$line"` == *"(none)"* ]]; then

            # Installing the software which is written in the line.
            apt install $line -yy;

            # Continuing looping after installation.
            continue

        # Checking if the software which is written in the line is installed.
        else

            # Telling to user that the software is already installed.
            echo "$line is already installed";

        fi
        
    done

    # Checking if veracrypt is not installed.
    if [[ `apt-cache policy "veracrypt"` != *"Installed"* ]]; then

        # Changing the current working directory.
        cd /opt

        # Checking if file is not exists.
        if [[ ! -f /opt/veracrypt.deb ]]; then

            # Send a get request to download the file.
            curl -L https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Debian-10-amd64.deb -o veracrypt.deb;
            
            # Changing the file permissions.
            chmod 777 veracrypt.deb;
            
            # Installing the veracrypt
            apt install ./veracrypt.deb -yy;
        
        # Checking if the file is exists.
        else
        
            # Changing the file permissions.
            chmod 777 veracrypt.deb;
        
            # Installing the veracrypt
            apt install ./veracrypt.deb -yy;
        
        fi

    # Checking if the software is already installed.
    else

        # Telling to user that, the application is already installed.
        echo "Veracrypt is already installed. And, it's available in /opt";

    fi
    
    # Checking if ngrok is not installed
    if [[ `apt policy ngrok` != *"Installed"* ]]; then
        
        # Sending a get request to ngrok's asc file silently, creating a new file which contains the request out put and redicrecting both stdout and stderr in to /dev/null
        curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null 
        
        # Reading ngrok's sources information and creating new file with this information in appropriate location.
        echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list 
        
        # Updating the packages' information
        apt update 
        
        # Installing the software
        apt install ngrok
    
    # Checking if ngrok is installed
    else
    
        # Telling the user that ngrok is already installed and available in the system.
        echo "Ngrok is available in the system."
    
    fi

}

install_softwares_with_dpkg() {
    # A function which installs softwares with dpkg

    # Telling to the user what's happening
    echo "Installing the softwares from myapps.list file with dpkg package manager"

    # Iterating over each url in the list_of_urls
    for url in $(cat $my_apps_list_file);do

        # Creating an array from the url by spliting it with the delimeter.
        IFS='/' read -a strarr <<< "$url";

        # Calculating the length of the array
        length_of_the_array="${#strarr[@]}";

        # Calculating the target's index number
        target_index=$(($length_of_the_array-1));

        # Creating a variable called installer_name
        installer_name=${strarr[$target_index]}

        # Creating a variable to store the application's name
        app_name=${installer_name:0:$((${#installer_name}-4))}

        # Changing the current working directory to opt
        cd /opt
    
        # Checking if the installer is not available in the system.
        if [[ ! -f "/opt/$installer_name" ]]; then

            # Downloading the installer
            curl -L "$url" -o "$installer_name";

        else

            echo "Installer $installer_name is already available in the system."

        fi
    
        # Checking if the package is not installed
        if [[ `apt policy "$app_name"` != *"Installed"* ]]; then

            # Starting the installers code.
            dpkg -i "$installer_name"

        # Checking if the application is already installed.
        else

            # Letting the user know that the application is already available in the system.
            echo "$app_name is already available in the system."

        fi

    done

}

install_softwares_with_flatpak() {
    # A function which installes softwares from flathub using the flatpak package manager.
    # Hint: You can search flatpak packages using the following command: flatpak search --columns=name,description,application appname
    
    # Telling to the user what's happening
    echo "Installing the softwares from flatpak_apps.list file with flatpak package manager"

    # Changing the current working directory
    cd $the_script_path
    
    # Adding the official PPA to your system
    add-apt-repository ppa:flatpak/stable
    
    # Updating the repository information
    apt update
    
    # Adding the flatpak remote repository Hint: A url which tells to flatpak where to look for packages.
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Looping through each application in the flatpak_apps.list file.
    for app in $(cat $flatpak_apps_list_file);do

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

install_softwares_with_snap() {
    # A function which installs softwares with snap package manager

    # Telling to the user what's happening
    echo "Installing the softwares from snap_apps.list file with snap package manager"

    # Iterating over each line in the snap_apps_list_file
    for line in $(cat $snap_apps_list_file);do

        # Checking if the software which is written in the line is not installed.
        if [[ `snap list ` != *"$line"* ]]; then

            # Installing the software which is written in the line.
            snap install $line;

            # Continuing looping after installation.
            continue

        # Checking if the software which is written in the line is installed.
        else

            # Telling to user that the software is already installed.
            echo "$line is already installed";
            
        fi
    done
}

install_virtual_env_wrapper() {
	# A function which installs the python virtual environment wrapper.
    
    # Note: The reason why I'm not installing bunch of python package is that, it's better to create a virtual environment for each project, and install it's requirements, recursively from a requirements.txt file. Ex: pip3 install -r requirements.txt

    # Checking if the virtualenvwrapper is not installed.
	if [[ `su - $username -c "pip3 freeze"` == *"virtualenvwrapper"* ]]; then

        # Installing the virtualenvwrapper python package.
		pip3 install virtualenvwrapper

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
