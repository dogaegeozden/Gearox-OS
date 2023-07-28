#!/bin/bash

declare_variables() {
	# A function which creates variables.

	# List of characters that I can use to generate a random mac address
	mac_address_permitted_characters=0123456789abcde

	# Creating an array called list_of_organizationally_unique_identifiers which contains the first parts of well-known manifacturers' OUI's(Organization Unique Identifiers.). Complete list -> https://standards-oui.ieee.org/oui/oui.txt
	list_of_organizationally_unique_identifiers=("00" "00" "cc" "3c" "00" "00")

	# Creating a variable called username.
	username=${SUDO_USER:-${USER}}

	# Creating a variable called wifi_adaptor_name
	for dev in `ls /sys/class/net` ; do [ -d "/sys/class/net/$dev/wireless" ] && wifi_adaptor_name="$dev" ; done

	# Assign the gearox os's network manager configuration file to a variable
	new_network_configuration_file="../network_manager_conf_file.txt"

	# Assign the original NetworkManager configuration file to a variable
	original_network_configuration_file="/etc/NetworkManager/NetworkManager.conf"

}

main() {
    # The function which runs the entire script.

    # Calling the declare_variables function.
    declare_variables

	# Calling the turn_down_the_wifi_adaptor function.
	turn_down_the_wifi_adaptor

	# Calling the turn_down_the_wifi_adaptor function.
	change_the_mac_address

	# Calling the change_the_network_configuration function.
	change_the_network_managers_configuration

	# Calling the turn_up_the_wifi_adaptor function.
	turn_up_the_wifi_adaptor

	# Restarting the NetworkManager.service
	systemctl restart NetworkManager.service

	# Telling to computer to wait for 4 seconds.
	sleep 4

}

turn_down_the_wifi_adaptor() {
	# A function which turns down the wifi adaptor.

	# Turning down the wifi adaptor.
	ip link set dev $wifi_adaptor_name down

}

change_the_mac_address() {
	# A function which generates random mac address.

	generate_random_mac_address_part(){
		# A function which generates a oui part.

		# Creating a random characters long mac addres part.
		result=${mac_address_permitted_characters:RANDOM%${#mac_address_permitted_characters}:2}

		# Printing the mac address part.
		echo $result

	}

	# Creating the first oui_part. Note: You must create the first part from the list_of_organizationally_unique_identifiers list.
	oui_part1=${list_of_organizationally_unique_identifiers[RANDOM%${#list_of_organizationally_unique_identifiers[@]}]}

	# Creating the second oui part
	oui_part2=`generate_random_mac_address_part`

	# Creating the third oui part
	oui_part3=`generate_random_mac_address_part`

	# Creating the fourth nic part
	nic_part1=`generate_random_mac_address_part`

	# Creating the fifth nic part
	nic_part2=`generate_random_mac_address_part`

	# Creating the sixth nic part
	nic_part3=`generate_random_mac_address_part`

	# Creating the mac_address variable.
	mac_address=$oui_part1:$oui_part2:$oui_part3:$nic_part1:$nic_part2:$nic_part3

	# Printing the mac_address.
	echo "New mac address = $mac_address"

	# Setting the new random mac address to the wireless adaptor
	ip link set dev $wifi_adaptor_name address $mac_address

}

change_the_network_managers_configuration() {
	# A function which reconfigures the NetworkManager service.

	# If the original network manager configuration file is not containing particular string replace it with the gearox os's network manager configuration file
	if [[ ! `grep "wifi.cloned-mac-address=preserve" $original_network_configuration_file` ]]; then

		cat $new_network_configuration_file > $original_network_configuration_file

	fi

}

turn_up_the_wifi_adaptor() {
	# A function which turns up the wifi adaptor.

	# Turning up the wifi adaptor..
	ip link set dev $wifi_adaptor_name up
	
}

# Executing the main function.
main
