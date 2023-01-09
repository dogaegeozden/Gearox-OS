#!/bin/bash


declaring_variables() {
    # A function which declares variables.

    # Creating a variable called username, by getting the user's username from the system. 
    username=${SUDO_USER:-${USER}}
    # Creating a path which leads to the background image which will be set.
    background_image_path="/home/$username/Pictures/wallpapers/electro_linux_original_wp_2.png"
    # Creating a path which leads to the lock screen image which will be set.
    lock_screen_image_path="/home/$userName/Pictures/lock_screen_images/electro_lock_screen_img.png"

}

main() {
    # The function which runs the entire script.

    if [[ `echo $XDG_CURRENT_DESKTOP` == *"GNOME"*]]; then
        # Calling the declaring_variables function.
        declaring_variables
        # Calling the add_minimize_and_maximize_buttons function.
        add_minimize_and_maximize_buttons
        # Calling the create_custom_keyboard_shortcuts function.
        create_custom_keyboard_shortcuts
        # Calling the set_the_background_image function.
        set_the_background_image
        # Calling the set_the_lock_screen_image function.
        set_the_lock_screen_image
        # Calling the set_the_themes function.
        set_the_themes
        # Changing the default file manager to thunar file manager.
        xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search
        # Update the desktop environment configurations
        sudo dconf update
    fi
}

add_minimize_and_maximize_buttons() {
    # A function which adds minimize and maximize buttons on gnome desktop environment.

    # Adding minimize and maximize buttons.
    gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close

}

create_custom_keyboard_shortcuts() {
    #  A function which creates custom shortcuts on gnome desktop environment.

    # Creating custom short cut to ope nthe thunar file manager.
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Thunar'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'thunar'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'

    # Creating a custom short cut to open the tilix terminal emulator.
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Tilix'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'tilix'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl><Alt>t'

    # Creating a custom short cut to get a screen shot with flame shot.
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'FlameShot ScreenShot'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flatpak run org.flameshot.Flameshot gui'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl>p'

    # Adding the custom shortcuts to the system.
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
    # Displaying the custom shortcuts.
    gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
}

set_the_background_image() {
    # A function which sets the background image on gnome desktop environment.

    # Setting the background image picture option to zoom.
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    # Setting the background image.
    gsettings set org.gnome.desktop.background picture-uri "${background_image_path}"

}

set_the_lock_screen_image() {
    # A function which sets the lock screen image on gnome desktop environments.

    # Setting the background image picture option to zoom.
    gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
    # Setting the lockscreen image.
    gsettings set org.gnome.desktop.screensaver picture-uri "${lock_screen_image_path}"

}

set_the_themes() {
    # A function which sets the themes.

    # Setting the icon theme.
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
    # Setting the cursor theme.
    gsettings set org.gnome.desktop.interface cursor-theme 'Qogir-ubuntu-cursors'

}

# Calling the main function.
main