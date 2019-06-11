# A Raspberry Pi Minimalist's Network Attached Storage Array
Or RPMNASA, for short.

Having a backup isn't enough.  
You need to know that you can restore from your backup without burning your local or cached copy.

Hence, the [p3p system](/doc/p3p.md).

> oh stars this is out of control, but a lot of it is super important to grok...oh well, can't build NeoRome in a day...

## Seafile

As of 2019.06, we're going to use a heavily customized instance of SeaFile to do the heavy lifting.  
By which we mean, we're going to use a bootstrap box to write several SD cards for bringing a 3-node Seafile-based media sharing and collaboration platform online, and then keep it updated with standardized 'nix stuffs, sorta.

We say "sorta" because any time someone says "standardized", we're fighting [XKCD #927](https://xkcd.com/927/).

### Why?
Because it's the least worst option, all things considered.

Functional Requirements:  
* Low overhead  
    The target server hardware is an original raspberry pi, you do the math.  
* cross platform client  
    Our users bring their own devices (much to our chagrin).    
    Server, desktop, notebook, embedded application, and mobile.  
    Must be available on Debian and Kodi, Windows, OSX, Android, and iOS.
        Blackberry and Windows Phone are nice-to-haves, but non-essential.  
* open source  
    Gotta be able to compile it ourselves, yo.  
* Security as a core development focus  
    Tacked-on security is like tacked-on love.  
    Never trust it.  


    ...built in client-side de-duplication subsystem would be nice, could that be built into the file-upload processing?

### Why not Unison, or Syncthing, or FreeNAS, or...?

Glad you asked.  
* Syncthing fails the cross platform test (although the [iOS development bounty may eventually change that](https://www.bountysource.com/issues/7699463-native-ios-port-gui).  
* [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) is designed for two sets of file, and gets really weird when more than a single instance of the application manages a single set of files. Has potential, but...not quite what we need for our use-case of minimum-three-copies.
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


### How? (Raspbian Sysadmin Crash Course)
Glad you're asking followup questions.


We install SeaFile by doing scripting, after prototyping on our single-board computer's operating system command line interface.

Scripting, a way to automate things to be repeatable, is super useful.

Scripting, at the core of the discipline, is about leveraging the ability of "modern" computing to do repetitive things rather quickly.

A properly scripted system can identify, react, and solve to potentially catastrophic problems before a human finishes processing the system's feedback and realizes that there is a problem developing.

Scripting is about loosely anticipating future needs, and writing now the bits we know we'll need.

It's also about [chef knives](https://lsh.io/plugtalk/#24) and [collapsable toolkits](https://pics.jakimfett.com/reactions/collapsable_tools.gif), but that's a conversation for later.

Right now, we're going to set up a network attached storage unit, because that's the thing that is currently on fire.

#### Environment

For this set of examples, we'll be using Bash on Linux, which is to say, the **B**ourne-**A**gain **Sh**ell v4.4.12 and [DietPi](https://dietpi.com/) v6.24.1 on a [Raspberry Pi Zero W](https://www.raspberrypi.org/blog/raspberry-pi-zero-w-joins-family/) v1.1 (rev. 9000C1), via SSH/Mosh.**  

We'll be using [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) as our target image, DietPi serves as a shim for the moment, and is being used because it's what we had on hand when we started writing this.

Go ahead and get Raspbian Lite downloading on your system now, by grabbing the SD image torrent file:  
`curl 'https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-04-09/2019-04-08-raspbian-stretch-lite.zip.torrent' --compressed -O`

> The `-O` or `--remote-name` option tells `curl` to name the file locally whatever it is on the remote server.
> Using `--compressed` is probably overkill for a 30ish kilobyte file, but it's good habit.

Now, load that torrent file into your p2p client, and get some raspbian-y goodness downloading in the background while we figure out what to do with the image file once we've got it.

> If you don't have a command line server yet, see [What Server?](#wait-what-server)

@todo - complete hardware list w/ recommendations and compromise explanation(s).

Bash allows you to run commands manually (by typing them in to the terminal) or via an automatic system, like a server's task scheduler (eg `cron`) or as the result of some event, like an API call or hardware update.

##### Using Git
Version control systems are awesome, and learning to use them effectively is a cornerstone of collaboration.  
Here's [a guide written by a friend of mine, inspired by a different friend of mine, on using Git](https://eliotberriot.com//blog/2019/03/05/building-sotfware-together-with-git/).

Read it, possibly thrice over the course of the week. It'll give you a solid understanding of the why, how, and what of using git as a collaborative project system.

===

Now that you've been introduced to the concepts and terminology (or at least have something to reference as a jumping-off-point), let's jump into the sysadmin side of this task.  

First, let's make sure we're able to actually use git via the terminal.  
Log into your server and enter the following command:
`which git && git --version`

##### <a name="wait-what-server"></a>Wait, what server?
Oh right, we haven't made ourselves a server yet.  
Okay, that's pretty easy.  
Hit the [DietPi downloads page](https://dietpi.com/downloads/images/} and grab the version corresponding to your hardware.  
For Raspberry Pi, that'll be "ARMv6", and I'm using Stretch for this.  

You could also jump straight to raspbian, via their downloads page (or your p2p client).


You're going to need:
* Some form of computer.  
    Yaknow, like a RasPi.
* Some form of storage.  
    Like this [32GB Samsung EVO+ SDHC card (spoiler: amazon link, @todo replaceme)](https://www.amazon.com/dp/B00WR4IJBE/)
* Some form of control-feedback loop.  
    I'm partial to a keyboard and display, but if you've got a direct mental uplink to the machines, more power to ya.  
* Some way to bootstrap the "stage" and "live" system(s).  
    Personally, we like the capabilities of the [Inatech USB OTG hub](https://www.amazon.com/dp/B00OCBXIY8/) paired with my RasPi Zero W.  
    More on the dev-->stage-->live pipeline later.  
    For now, just knowing it exists is enough, we're building dev right now.  

So, you've got your software and your hardware, now to combine the two and make a sandwich.  
_(Okay, not really, but also, kinda.)_

Write the DietPi image to the SD card.  
If you can't get the OTG adapter working with your phone, give [Etcher](https://etcher.io/) a shot.  
There's numerous ways (including the command line, which is what we'll be using here) to write a disk image to an SD card.  

Use whatever works for you.

###### Using Disk Destroyer (to burn an SD card)
Or as it's more officially known, [Data Duplicator](https://ss64.com/bash/dd.html).

**Be careful when doing writes**, you can overwrite your system disk, completely erasing the entire host system!

####### Find your Hardware
First, know what your target is. Mine is an SD card plugged into an OTG adapter on the RasPiZero, which isn't something that directly translates into the `/dev/sd#` format typically used by 'nix systems.

So, start by listing your devices with `ls -lah /dev/sd*`. You'll see something like this:
```
brw-rw---- 1 root disk 8,  0 Jun 10 11:07 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 10 11:07 /dev/sda1
brw-rw---- 1 root disk 8, 16 Jun 10 11:07 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jun 10 11:07 /dev/sdb1
```

> The flags for the `ls` command are for, respectively,  
> `-l` = long listing format, aka full list  
> `-a` or `--all` = list all entries (as opposed to skipping lines which start with a period, the linux 'hidden' or 'system' designator, eg '.config/' or '.local/')
> `-h` or `--human-readable` = print the long listing format using human-readable numbers, eg 3.4GB instead of 3650722202 bytes.

You can also check the size of your disks via the `df` command, eg `df -h`:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       118G  2.5G  115G   3% /
devtmpfs        181M     0  181M   0% /dev
tmpfs           185M     0  185M   0% /dev/shm
tmpfs           185M  2.7M  182M   2% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           185M     0  185M   0% /sys/fs/cgroup
tmpfs            50M  4.0K   50M   1% /var/log
tmpfs            10M  1.4M  8.7M  14% /DietPi
tmpfs          1023M     0 1023M   0% /tmp
/dev/mmcblk0p1   42M   24M   18M  58% /boot
```

From those two commands, we know that there are two disks connected, and one of them is `/dev/root`, the primary disk (which is 3% used on my system).

What we want to know is _which one is the SD card_, so we need to keep looking. The `lsblk` command helps us with that, it lists all the block devices available to the system:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    1  29.7G  0 disk
└─sda1        8:1    1  29.7G  0 part
sdb           8:16   1   7.6G  0 disk
└─sdb1        8:17   1   7.6G  0 part
mmcblk0     179:0    0 119.1G  0 disk
├─mmcblk0p1 179:1    0  41.8M  0 part /boot
└─mmcblk0p2 179:2    0   119G  0 part /
```

Now we're in business. We've got two drives, an 8gb and a 32gb, neither of which are mounted, and the host system SD card, at 128gb, mounted as the boot and root of our system.

> Note how these three commands each give slightly different perspective on the same hardware information.  
> When in doubt about something, **double check**.  
> You can always check again before executing a potentially destructive command, and most of the time, it'll save you some grief before the end.

So, we want the 32gb SD card. Our identifier is therefore `/dev/sda`, and it's unmounted, which is good for the next part.

###### dd
H

##### Hardware Stuffs (post-burn)
Okay. We've got a server online.  
Now, what is connected to it?  

####### GPIO
The [Raspberry Pi org](https://www.raspberrypi.org/documentation/hardware/raspberrypi/README.md) and [pinout.xyz](https://pinout.xyz/) both have a lot of solid info on the onboard GPIO and solder pads, but we're going to focus on USB devices for the moment.  

More on GPIO when we talk about [Immutable Mode](#immutable).

####### USB Devices
USB allows us to use most single board computers (as well as desktops, servers, and virtual machines) and their peripherals interchangeably, and management of the hardware ports is good opsec.  

> Let's assume we know nothing about what is installed or plugged in.

First we want to see all our USB devices:
`lsusb`

This gives us a list of IDs (second column on my system), and right now, because it's a Pi Zero with nothing plugged in (except power), there's only a single entry:
`Bus 001 Device 001: ID <redacted> Linux Foundation 2.0 root hub`

That was easy enough. We have a single root hub, as expected.  

Plugging my USB OTG hub/reader into the single OTG port on the Pi Zero gives me the following:


###### The Write
Eventually, we want something called "Immutable Architecture", but on dev, we need to be able to modify things easily.

We're going to need some space for the disk image.  
Before we start downloading, let's check how big this thing is:  
`curl -I "${image_url}" | grep -i 'content-length' | awk '{print $2}'`

> What this does:  
>  Gets the response header from variable `image-url`.  
> 1. Filters for lines containing the string  
>     "[Cc][Oo][Nn][Tt][Ee][Nn][Tt]-[Ll][Ee][Nn][Gg][Tt][Hh]",  
>     because `-i` means `--case-insensitive`.  
> 2. Prints the second field only.   
> 3. Patches all three individual commands together
>     with the `|` (or _pipe_) character,  
>     which is how you "stack" program effectiveness in scripting.  


So. Now (in theory) we have a number.  
What do we do with it?

> ~~~  
> Stacking is important.  
> ~~~
> Know when to split your stacks, and know when to build an _application_ on top of stacks.  
>
> Scripts are generally how I'll refer to _backend programming_, but some backend things are applications, which I'll call out where they exist, eg `nginx` is an application, but `uptime` is a script.  
> Scripts work with the underlying parts of how things work in our segment of 'nix adjacent programming.
> Applications are _how information is presented to an end user_.
> A `sysadmin` protects the backend from the user, and the user from the backend.  
> Nobody wants to know how it works.  
> They just want their application available for their needs.  
>   
> ~~~  
> Stacks are your `${chef-knives}` and your `${gadgets}` and your `${pets}`.
> (a `${pet}` is a system you've named)  
> (adorable, but slightly ineffecient when things start to scale)  
> (often lost in `${fires}`, sadly)

We then take the same concept as above  
(grabbing some text and shoving it through a filter),  
apply it to our target system,  

and then compare it with the `diff` utility to tell us what we need to know:  
`Functionally, can we write my data to the system I'm working on?`

####### Example Code

Okay, you got this far.  
Congrats!  
That was a lot of information to digest.  

Here's how to check, download, and verify your image file:
`getFile.sh "${location}" "${destinaton}"`

By default, the file will be written to your present working directory (if `pwd` is a writeable location for you).

###### Automounting
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

https://libreelec.tv/downloads_new/raspberry-pi-3-3/

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

https://stackoverflow.com/questions/4554718/how-to-use-patterns-in-the-case-statement-in-bash-scripting#4555979
https://stackoverflow.com/questions/253055/how-do-i-push-amended-commit-to-the-remote-git-repository#432518
https://stackoverflow.com/questions/8883081/git-how-to-change-a-bare-to-a-shared-repo
https://stackoverflow.com/questions/4202726/publish-git-repo-on-a-web-only-provider-no-shell

https://www.tunnelsup.com/raspberry-pi-phoning-home-using-a-reverse-remote-ssh-tunnel/
https://blog.kylemanna.com/linux/ssh-reverse-tunnel-on-linux-with-systemd/
https://linux.die.net/man/1/ssh

http://www.webupd8.org/2009/03/recover-deleted-files-in-ubuntu-debian.html  
https://libreelec.tv/downloads_new/raspberry-pi-3-3/


https://wiki.bash-hackers.org/scripting/posparams


https://www.unix.com/man-page/debian/1/chattr/
http://www.aboutlinux.info/2005/11/make-your-files-immutable-which-even.html

https://linux.die.net/man/1/find
