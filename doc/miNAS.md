# A Raspberry Pi Minimalist's Network Attached Storage Array
Or RPMNASA, for short.

@todo - write script to autoreplace links with archive.is and internetarchive links, with generation/curlhash/httpcodeverification

## Seafile

As of 2019.06, we're going to use SeaFile.

### Why?
Because it's the least worst option, all things considered.

Functional Requirements:  
* Low overhead  
    The target server is a raspberry pi, you do the math.  
* cross platform client  
    Our users bring their own devices, much to our chagrin.    
    Server, desktop, notebook, and mobile.  
    Must be available on Linux, Windows, OSX, Android, or iOS.  
* open source  
    Gotta be able to compile it ourselves, yo.  
* Security as a core development focus  
    Tacked-on security is like tacked-on love.  
    Never trust it.  


    ...built in client-side de-duplication subsystem would be nice, could that be built into the file-upload processing?

### Why not Syncthing, or FreeNAS, or...?

Glad you asked.  
* Syncthing fails the cross platform test (although the [iOS development bounty may eventually change that](https://www.bountysource.com/issues/7699463-native-ios-port-gui).  
* FreeNAS is overweight for the target hardware (requires [8+GB of RAM](https://www.freenas.org/hardware-requirements/)).  
* OpenMediaVault is a medium-weight [PHP service manager glued together with Python and JavaScript](https://www.openmediavault.org/about.html).  
    ...if that combo isn't enough to disqualify it for you, go right ahead and try it out. We'll wait.  
* OwnCloud - because [NextCloud is proveably better](https://technohedge.com/nextcloud-vs-owncloud/).  
* [NextCloudPi is a serious contender](https://github.com/nextcloud/nextcloudpi). It may ultimately [win out](https://www.getfilecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/), but currently meets too broad of a need and lacks solid client-side encryption. Pass for now.  
* FileRun   
* Pydio  
* Samba  
* [Resilio](https://www.reddit.com/r/selfhosted/comments/69ghby/looking_for_a_dropbox_replacement_in_2017_seafile/dh6sglg/)  



> Phew, that was a lot of alternatives.  
> How did you finally decide?

By actually installing a bunch of them and seeing how well it fit into my pipelines and workflows. Your need may vary, so try it out yourself.


### How?
Glad you're asking followup questions.


We install SeaFile by doing scripting, after prototyping on our single-board computer's operating system command line interface.

Scripting, a way to automate things to be repeatable, is super useful.

For this set of examples, we'll be using Bash on Linux, which is to say, the **B**ourne-**A**gain **Sh**ell v4.4.12 and [DietPi] v6.24.1 on a [Raspberry Pi Zero W]() v1.1, via Mosh.
Bash allows you to run commands manually (by typing them in to the terminal) or via an automatic system, like a server's task scheduler (eg cron) or as the result of some event, like an API call or hardware update.




## External Sources and Additional Reading



### Suggested Prerequisites
https://semver.org/  
https://tim.siosm.fr/blog/2014/02/10/ewontfix-ecouldfix-systemd/ (and http://ewontfix.com/14/)  
https://linoxide.com/linux-how-to/linux-systemd/  



### Referenced during assembly
https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/  

https://eltechs.com/raspberry-pi-nas-guide/  

https://www.howtogeek.com/139433/how-to-turn-a-raspberry-pi-into-a-low-power-network-storage-device/  

https://manual.seafile.com/build_seafile/rpi.html  
https://freezerdev.blogspot.com/2015/08/raspberry-pi-as-seafile-server.html  
https://manual.seafile.com/deploy/using_sqlite.html  


https://www.raspberrypi.org/downloads/raspbian/  
https://downloads.raspberrypi.org/raspbian_lite_latest  


https://www.reddit.com/r/raspberry_pi/comments/1jbtk9/an_alternative_for_samba/  
https://www.taluntis.lt/raspberry-pi-nfs-server-and-windows-client/  

https://www.htpcguides.com/install-openmediavault-raspberry-pi-nas-server-minibian/  

https://www.reddit.com/r/linux/comments/3hyx2x/pydio_vs_seafile_vs_owncloud/  
https://www.reddit.com/r/selfhosted/comments/6ir906/need_help_with_seafile_filerun_or_resilio/
https://www.reddit.com/r/FileRun/comments/6jg5ea/filerun_on_nginx/  