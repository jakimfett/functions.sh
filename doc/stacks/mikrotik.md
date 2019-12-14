So I've got a mikrotik router.

In theory, it'll let me connect to wireless, and then bridge the connection to all ethernet connected devices in my home lab.

# Ugh. Mikrotik.
I say in theory, because with mikrotik, it's never quite that simple.

You can get it to play music from the command line immediately on reset, but connecting cleanly to wireless? Nah, that'll take a week.

Why?
Mostly a lack of parity between the various GUI modes and the command line interface(s). The documentation is specific to one of three paradigms (most of the time) and translating to a different paradigm is nearly impossible unless you already know the structure of both interfaces.

## Hard Reset
Unplug the device.
Press the 'reset' button (usually in a hole on the back side).
Plug the device back in, and wait 5-7 seconds.

An LED should start blinking (although it more sporadically flickers on my box...).

Release the reset button BEFORE the 10 second mark.

Let the board do its thing.

# Securing
By default, the user is 'admin' and the password is empty.

THIS IS VERY INSECURE, MIKROTIK. FIX YOUR DEFAULTS.

## Users
Connect to the router via ssh.
(@todo - set up mosh?)

You'll need the router's IP address.
``

`ssh admin@`

```

  MMM      MMM       KKK                          TTTTTTTTTTT      KKK
  MMMM    MMMM       KKK                          TTTTTTTTTTT      KKK
  MMM MMMM MMM  III  KKK  KKK  RRRRRR     OOOOOO      TTT     III  KKK  KKK
  MMM  MM  MMM  III  KKKKK     RRR  RRR  OOO  OOO     TTT     III  KKKKK
  MMM      MMM  III  KKK KKK   RRRRRR    OOO  OOO     TTT     III  KKK KKK
  MMM      MMM  III  KKK  KKK  RRR  RRR   OOOOOO      TTT     III  KKK  KKK

  MikroTik RouterOS 6.40.4 (c) 1999-2017       http://www.mikrotik.com/

[?]             Gives the list of available commands
command [?]     Gives help on the command and list of arguments

[Tab]           Completes the command/word. If the input is ambiguous,
                a second [Tab] gives possible options

/               Move up to base level
..              Move up one level
/command        Use command at the base level
The following default configuration has been installed on your router:
-------------------------------------------------------------------------------
RouterMode:
 * WAN port is protected by firewall and enabled DHCP client
 * Wireless interfaces are part of LAN bridge
wlan1 Configuration:
    mode:          ap-bridge;
    band:          2ghz-b/g/n;
    ht-chains:     0,1;
    ht-extension:  20/40mhz-Ce;
LAN Configuration:
    switch group: ether2 (master), ether3, ether4, ether5
    switch group: ether6 (master), ether7, ether8, ether9, ether10
    IP address 192.168.88.1/24 is set on LAN port
    DHCP Server: enabled;
    DNS: enabled;
WAN (gateway) Configuration:
    gateway:  ether1 ;
    ip4 firewall:  enabled;
    ip6 firewall:  enabled;
    NAT:   enabled;
    DHCP Client: enabled;

-------------------------------------------------------------------------------
You can type "v" to see the exact commands that are used to add and remove
this default configuration, or you can view them later with
'/system default-configuration print' command.
To remove this default configuration type "r" or hit any other key to continue.
If you are connected using the above IP and you remove it, you will be disconnected.

```
## Scripting & Shell Access
## Updates
## HTTPS

# Appendices
https://wiki.mikrotik.com/wiki/Manual:Reset#Using_reset_button
https://wiki.mikrotik.com/wiki/Connect_to_an_Available_Wireless_Network
https://wiki.mikrotik.com/wiki/Manual:Interface/Wireless

https://mikrotik.tips/connecting-2-remote-places-using-wireless-bridge/

https://www.reddit.com/r/mikrotik/comments/4rdbgs/dhcp_over_a_wireless_bridge_link/
https://jcutrer.com/howto/networking/mikrotik/mikrotik-tutorial-adding-a-2nd-wireless-ssid-virtual-access-point

https://mikrotik.com/documentation/manual_2.7/Interface/Wireless.html#ht276178286
https://www.reddit.com/r/mikrotik/comments/78t2p7/metal_52ac_connects_to_wifi_but_wont_let_me_use/
https://www.reddit.com/r/mikrotik/comments/3mm0rl/help_dhcp_issue_in_setting_up_rb2011uias2hndin/
https://wiki.mikrotik.com/wiki/Manual:Wireless_Station_Modes
