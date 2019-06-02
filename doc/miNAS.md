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

Scripting, at the core of the discipline, is about leveraging the ability of "modern" computing to do repetitive things rather quickly.

A properly scripted system can identify, react, and solve to potentially catastrophic problems before a human finishes processing the system's feedback and realizes that there is a problem developing.

Scripting is about loosely anticipating future needs, and writing now the bits we know we'll need.

It's also about [chef knives](https://lsh.io/plugtalk/#24) and collapseable toolkits, but that's a conversation for later.

Right now, we're going to set up a network attached storage unit, because that's the thing that is currently on fire.

#### Environment

For this set of examples, we'll be using Bash on Linux, which is to say, the **B**ourne-**A**gain **Sh**ell v4.4.12 and [DietPi](https://dietpi.com/) v6.24.1 on a [Raspberry Pi Zero W](https://www.raspberrypi.org/blog/raspberry-pi-zero-w-joins-family/) v1.1 (rev. 9000C1), via SSH/Mosh.  

Bash allows you to run commands manually (by typing them in to the terminal) or via an automatic system, like a server's task scheduler (eg `cron`) or as the result of some event, like an API call or hardware update.

##### Using Git
Version control systems are awesome, and learning to use them effectively is a cornerstone of collaboration.  
Here's a guide written by a friend of mine, inspired by a different friend of mine, on using Git.


Now that you understand the concepts and terminology (or at least have something to reference as a jumping-off-point), let's jump into the sysadmin side of this task.  

First, let's make sure we're able to actually use git via the terminal.  
Log into your server and enter the following command:
`which git && git --version`

##### Wait, what server?
Oh right, we haven't made ourselves a server yet.  
Okay, that's pretty easy.  
Hit the [DietPi downloads page](https://dietpi.com/downloads/images/} and grab the version corresponding to your hardware.  
For Raspberry Pi, that'll be "ARMv6", and I'm using Stretch for this.  

You're going to need:
* Some form of computer.  
    Yaknow, like a RasPi.
* Some form of storage.  
    Like this [32GB Samsung EVO+ SDHC card (spoiler: amazon link, @todo replaceme)](https://www.amazon.com/dp/B00WR4IJBE/)
* Some form of control-feedback loop.  
    I'm partial to a keyboard and display, but if you've got a direct mental uplink to the machines, more power to ya.  
* Some way to bootstrap the "stage" and "live" system(s).  
    Personally, I like the capabilities of the [Inatech USB OTG hub](https://www.amazon.com/dp/B00OCBXIY8/).  
    More on the dev-->stage-->live pipeline later.  
    For now, just knowing it exists is enough, we're building dev right now.  

So, you've got your software and your hardware, now to combine the two and make a sandwich.  
_(Okay, not really, but also, kinda.)_

Write the DietPi image to the SD card.  
If you can't get the OTG adapter working with your phone, give [Etcher](https://etcher.io/) a shot.  
There's numerous ways (including the command line, which is what we'll be using here) to write a disk image to an SD card.  

Use whatever works for you.

###### The Write
Eventually, we want something called "Immutable Architecture", but on dev, we need to be able to modify things easily.

We're going to need some space for the disk image.  
Before we start downloading, let's check how big this thing is:  
`curl -I "${image_url}" | grep -i 'content-length' | awk '{print $2}'`

> What this does:  
> # Gets the response header from variable `image-url`.  
> # Filters for lines containing the string "[Cc][Oo][Nn][Tt][Ee][Nn][Tt]-[Ll][Ee][Nn][Gg][Tt][Hh]", because `-i` means `--case-insensitive`.  
> # Prints the second field only.   
> # Patches all three individual commands together with the `|` (or _pipe_) character, which is how you "stack" program effectiveness in scripting.
>.  
> Stacking is important.  
> Know when to split your stacks, and know when to build an _application_ on top of stacks.  
> Scripts are generally how I'll refer to _backend programming_, but some backend things are applications, which I'll call out where they exist, eg `nginx` is an application, but `uptime` is a script.  
> Scripts work with the underlying parts of how things work in our segment of 'nix adjacent programming.
> Applications are _how information is presented to an end user_.
> A `sysadmin` protects the backend from the user, and the user from the backend.  
> Nobody wants to know how it works.  
> They just want their application available for their needs.  
>.  
>. 
>. Stacks are your `${chef-knives}` and your `${gadgets}` and your `${pets}`. 
> (a `${pet}` is a system you've named)  
> (adorable, but slightly ineffecient when things start to scale)  
> (often lost in `${fires}`, sadly)  

So. Now we have a number.  
What do we do with it?

Well, we take the same concept as above (grabbing some text and shoving it through a filter), apply it to our system, and then compare it with the `diff` utility to tell us what we need to know:  
Functionally, can I write to the system I'm working on?  

###### The (verified) Read  
###### Writing Out  
###### Verified Read 2: Electric Boogaloo  
###### Necromancy 101: Backing up your pets  



## External Sources & Additional Reading



### Suggested Prerequisites
https://semver.org/  
https://tim.siosm.fr/blog/2014/02/10/ewontfix-ecouldfix-systemd/ (and http://ewontfix.com/14/)  
https://linoxide.com/linux-how-to/linux-systemd/  



### Referenced during assembly
https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/  
https://safetomatic.com/best-sd-card-for-raspberry-pi-3/  

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