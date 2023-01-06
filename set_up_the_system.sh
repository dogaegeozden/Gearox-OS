#!/usr/bin/bash

# Hint: To see the location of the command that you are looking forward to use: Use; which <command name>

declare_variables() {
    # A function which creates variables
    # Getting the user name
    userName=${SUDO_USER:-${USER}}

    # Creating a path to the scripts folder.
    tSFolder=`pwd`"/scripts"
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
    for shf in `/usr/bin/ls $tSFolder`; do
        sudo sed -i -e 's/\r$//' $tSFolder"/$shf"
    done
}

make_executable() {
    # Making every single script file in electro linux's scripts folder executable.
    for s in `/usr/bin/ls $tSFolder`; do
        sudo chmod u+x $tSFolder"/$s"
    done
}

execute_the_scripts() {
    # Changing the current working directory to the scripts folder.
    cd $tSFolder

    # Looping through each file in the scripts folder.
    for tSFile in `/usr/bin/ls $tSFolder`; do
        # Checking if the file name is not "115_non_su_settings.sh" or "108_installing_yed.sh"
        if [[ $tSFile != "115_non_su_settings.sh" ]] || [[ $tSFile != "108_installing_yed.sh" ]]; then
            # Executing the file as the super user.
            sudo ./$tSFile
        # Checking if the file name is "115_non_su_settings.sh" or "108_installing_yed.sh"
        else
            # Executing the file as the reqular user.
            ./$tSFile
        fi
    done

}
