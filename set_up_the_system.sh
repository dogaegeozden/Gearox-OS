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
    # Calling the declare_variables function
    declare_variables
    # Calling the fix_lines function
    fix_lines
    # Calling the execute_the_scripts function
    execute_the_scripts
}

fix_lines() {
    # Looping through file in electro linux's scripts folder and, trantSFileorming the file's lines as the lines without ^M in their ends anymore.
    for script in `/usr/bin/ls $scripts_folder`; do
        sudo sed -i -e 's/\r$//' $scripts_folder"/$script"
    done
}

make_executable() {
    # Making every single script file in electro linux's scripts folder executable.
    for script in `/usr/bin/ls $scripts_folder`; do
        sudo chmod u+x $scripts_folder"/$script"
    done
}

execute_the_scripts() {
    # Changing the current working directory to the scripts folder.
    cd $scripts_folder

    # Looping through each file in the scripts folder.
    for script in `/usr/bin/ls $scripts_folder`; do
        # Checking if the file name is not "115_non_su_settings.sh" or "108_installing_yed.sh"
        if [[ $script != "115_non_su_settings.sh" ]] || [[ $script != "108_installing_yed.sh" ]]; then
            # Executing the file as the super user.
            sudo ./$script
        # Checking if the file name is "115_non_su_settings.sh" or "108_installing_yed.sh"
        else
            # Executing the file as the reqular user.
            ./$script
        fi
    done

}

# Calling the main function
main
