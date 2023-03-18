#!/bin/bash

declare_variables() {
	# A function which creates variables.

    # Get the Wireless Adaptor's name
    for dev in `ls /sys/class/net` ; do [ -d "/sys/class/net/$dev/wireless" ] && wifi_adaptor_name="$dev" ; done
}

main() {
    # The function which runs the entire script.

    # Calling the declare_variables function.
    declare_variables
    # Calling the clean_up_existing_rules function.
    clean_up_existing_rules
    # Calling the drop_connections function.
    default_drop
    # Calling the allow_input_and_output_on_loop_back_interface
    allow_input_and_output_on_loopback_interface
    # Calling the append_iptables_rules
    append_iptables_rules
    # Calling the display_iptables_rules function
    display_iptables_rules
}

clean_up_existing_rules() {
    # A function which deletes, all the previous iptables rules set.

    # First clean up all the firewall policies that are already set up on the system.
    iptables -t filter -F
    iptables -t filter -X
    iptables -t nat -F
    iptables -t nat -X
}

default_drop () {
    # A function which drops all the connections on all chains

    # Default Drop: Drop all packages coming into, coming into the server but that are routed to somewhere else and coming out of the server. So, the packages can be accepted, sended or, routed only in the ways that you stated.
    # INPUT Chain: Network packages coming into the server.
    # FORWARD Chain: Network packages coming into the server that are routed to somewhere else.
    # OUTPUT Chain: Network packages coming out to Linux server.
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP
}

allow_input_and_output_on_loopback_interface() {
    # A function which allows, packages to come in and go out of the interface.

    # Loopback: The loopback device is a special, virtualnetwork interface that your computer uses to communicate with itself. It is used mainly for diagnostics and troubleshooting, and to connect to servers running on the local machine. · The Purpose of Loopback · When a network interface is disconnected--for example, when an Ethernet port is unplugged or Wi-Fi is turned off or not associated with an access point--no communication on that interface is possible, not even communication between your computer and itself. The loopback interface does not represent any actual hardware, but exists so applications running on your computer can always connect to servers on the same machine. · This is important for troubleshooting (it can be compared to looking in a mirror). The loopback device is sometimes explained as purely a diagnostic tool. But it is also helpful when a server offering a resource you need is running on your own machine.
    # You need the allow the communications with this interface to be able use your computer to communicate with services.
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
}

append_iptables_rules() {
    # A function which appens iptables rules.

    # NEW: meaning that the packet has started a new connection, or otherwise associated with a connection which has not seen packets in both directions
    # ESTABLISHED: meaning that the packet is associated with a connection which has seen packets in both directions,
    # RELATED: meaning that the packet is starting a new connection, but is associated with an existing connection, such as an FTP data transfer, or an ICMP error.
    
    # SOURCE: Source is your machine. --sport is the port in your machine
    # DESTINATION: Destionation is the other machine. --dport is the port in the other machine.
    
    # Ping: Ping is a computer network administration software utility used to test the reachability of a host on an Internet Protocol (IP) network. It is available for virtually all operating systems that have networking capability, including most embedded network administration software.
    # iptables -A INPUT -i $wifi_adaptor_name -p icmp -m conntrack --ctstate NEW --icmp-type 8 -j ACCEPT
    # iptables -A INPUT -i $wifi_adaptor_name -p icmp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    # iptables -A OUTPUT -o $wifi_adaptor_name -p icmp -j ACCEPT

    # HTTP: Hypertext Transfer Protocol -> The purpose of the HTTP protocol is to provide a standard way for web browsers and servers to talk to each other.
    # These policies are required if you want to be able to connect to internet using http and https protocols. These are the most common ones and the standard way for web browsers and servers to talk to each other.
    iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED,RELATED --sport 80 -j ACCEPT
    iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m tcp --dport 80 -j ACCEPT

    # HTTPS: Hypertext Transfer Protocol Secure -> The purpose of the HTTP protocol is to provide a standard way for web browsers and servers to talk to each other with a extensive security that prevents man in the middle and etc.
    iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED,RELATED --sport 443 -j ACCEPT
    iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m tcp --dport 443 -j ACCEPT

    # DNS: Domain Name System -> The purpose of DNS is to translate a domain name into the appropriate IP address.
    # Note: You should allow incoming and out going communications to this port if you want to use URLs instead of ipaddresses. ExURL: https://dogaege.pythonanywhere.com
    iptables -A INPUT -i $wifi_adaptor_name -p udp --sport 53 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -o $wifi_adaptor_name -p udp --dport 53 -m udp -j ACCEPT

    # SSH: The Secure Shell Protocol (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network. Its most notable applications are remote login and command-line execution.
    # Puting input -> Packages coming into the destionation port(Destination Port: It is the other machine's port, thats why you are only allowing when the state is either new or established. Because your security is what matters most for you, not the other's.)
    iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate NEW,ESTABLISHED --dport 22 -j ACCEPT
    iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED --sport 22 -j ACCEPT
    # Geting output -> Packages coming into  the source port(Source Port: It is your machine's port, that's why you are only allowing when the state is established. Becase your security is what matters most for you.)
    iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m conntrack --ctstate NEW,ESTABLISHED --dport 22 -j ACCEPT
    iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED --sport 22 -j ACCEPT

    # NTP: Network Time Protocol -> The purpose of this protocol to syncronize the system's time.
    #iptables -A INPUT -i $wifi_adaptor_name -p udp -m conntrack --ctstate ESTABLISHED,RELATED --dport 123 -j ACCEPT
    #iptables -A OUTPUT -o $wifi_adaptor_name -p udp -m udp --sport 123 -j ACCEPT

    # CUPS: Common UNIX Printing System -> The purpose of cups is to allow a computer to act as a priting server so it can accept printing jobs and etc.
    #iptables -A INPUT -p udp -m udp --dport 631 -j ACCEPT
    #iptables -A INPUT -p tcp -m tcp --dport 631 -j ACCEPT
    #iptables -A OUTPUT -p udp -m udp --sport 631 -j ACCEPT
    #iptables -A OUTPUT -p tcp -m tcp --sport 631 -j ACCEPT

    # EMAIL: These settings are for being able to use email services.
    # STMP: The Simple Mail Transfer Protocol (SMTP) is an internet standard communication protocol for electronic mail transmission. Mail servers and other message transfer agents use SMTP to send and receive mail messages.
    #iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED,RELATED --sport 465 -j ACCEPT
    #iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m tcp --dport 465 -j ACCEPT

    # IMAP: The Internet Message Access Protocol (IMAP) is an Internet standard protocol used by email clients to retrieve email messages from a mail server over a TCP/IP connection.
    #iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED,RELATED --sport 993 -j ACCEPT
    #iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m tcp --dport 993 -j ACCEPT

    # POP3: The Post Office Protocol (POP3) is an Internet standard protocol used by local email software clients to retrieve emails from a remote mail server over a TCP/IP connection, these email clients may require the configuration of Post Office Protocol (or POP3) before messages can be downloaded from the server.
    #iptables -A INPUT -i $wifi_adaptor_name -p tcp -m conntrack --ctstate ESTABLISHED,RELATED --sport 995 -j ACCEPT
    #iptables -A OUTPUT -o $wifi_adaptor_name -p tcp -m tcp --dport 995 -j ACCEPT

    # DHCP: The Dynamic Host Configuration Protocol (DHCP) is a network management protocol used on Internet Protocol (IP) networks for automatically assigning IP addresses and other communication parameters to devices connected to the network using a client–server architecture. If you are using a static ip address you don't need it.
    #iptables -A INPUT -i $wifi_adaptor_name -p udp -m conntrack --ctstate ESTABLISHED,RELATED --sport 67:68 -j ACCEPT
    #iptables -A OUTPUT -o $wifi_adaptor_name -p udp -m udp --dport 67:68 -j ACCEPT

    # MySQL: My Structured Query Language. MySQL is a relational database management system based on SQL – Structured Query Language. The application is used for a wide range of purposes, including data warehousing, e-commerce, and logging applications.
    # iptables -A INPUT -i $wifi_adaptor_name -p tcp -s 10.10.10.10/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
    # iptables -A OUTPUT -o $wifi_adaptor_name -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}

display_iptables_rules() {
    # A function which displays the iptables rules
    iptables -vnL
}

# Executing the main function.
main