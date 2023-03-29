#!/usr/bin/bash

# Hint: To see the location of the command that you are looking forward to use: Use; which <command name>

declare_variables() {
    # A function which creates variables

    # Getting the user name
    username=${SUDO_USER:-${USER}}

    # Creating a path to the scripts folder.
    scripts_folder=`pwd`"/scripts"
}

main () {
    # The function which runs the entire script

    # Calling the print_ascii_art function
    print_ascii_art
    # Calling the declare_variables function
    declare_variables
    # Calling the fix_lines function
    fix_lines
    # Calling the execute_the_scripts function
    execute_the_scripts
}

print_ascii_art() {
    # A function which prints ascii art 

    cat << ""
 _____  _              _                  _____        _                 
|  ___|| |            | |                /  ___|      | |                
| |__  | |  ___   ___ | |_  _ __   ___   \ `--.   ___ | |_  _   _  _ __  
|  __| | | / _ \ / __|| __|| '__| / _ \   `--. \ / _ \| __|| | | || '_ \ 
| |___ | ||  __/| (__ | |_ | |   | (_) | /\__/ /|  __/| |_ | |_| || |_) |
\____/ |_| \___| \___| \__||_|    \___/  \____/  \___| \__| \__,_|| .__/ 
                                                                | |    
                                                                |_|    

}

fix_lines() {
    # A function which fixes lines

    # Iterating through file in electro linux's scripts folder and, trantSFileorming the file's lines as the lines without ^M in their ends anymore.
    for script in `/usr/bin/ls $scripts_folder`; do
        # Removing the invisible characters that are created by windows environment
        sudo sed -i -e 's/\r$//' $scripts_folder"/$script"
    done
}

make_executable() {
    # A function which changes file permissions 

    # Making every single script file in electro linux's scripts folder executable.
    for script in `/usr/bin/ls $scripts_folder`; do
        # Giving execute permission to user
        sudo chmod u+x $scripts_folder"/$script"
    done
}

execute_the_scripts() {
    # A function which executes the scripts

    # Changing the current working directory to the scripts folder.
    cd $scripts_folder

    # Iterating through each file in the scripts folder.
    for script in `/usr/bin/ls $scripts_folder`; do
        # Informing the user about which script is currently running
        echo  "RUNNING SCRIPT: $script" 
        # Checking if the file name is "115_non_su_settings.sh" or "108_installing_yed.sh"
        if [[ $script == "115_non_su_settings.sh" ]] || [[ $script == "108_installing_yed.sh" ]]; then
            # Executing the file as the reqular user.
            bash $script
        # Checking if the file name is not "115_non_su_settings.sh" or "108_installing_yed.sh"
        else
            # Executing the file as the super user.
            sudo ./$script
        fi
        # Printing empty lines
        echo -e "\n\n"
    done
}

# Calling the main function
main

