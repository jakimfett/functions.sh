# A Raspberry Pi Minimalist's Network Attached Storage Array
Or RPMNASA, for short.

Having a backup isn't enough.  
You need to know that you can restore from your backup without burning your local or cached copy.

Hence, the [p3p system](/doc/p3p.md).

> oh stars this is out of control, but a lot of it is super important to grok...oh well, can't build NeoRome in a day...

## Method(ologies)
Immutable architecture, positive confirmation security.  
Automate everything possible.
Do the hard thing now so later is easier.  

_Collaborate._


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
    Tacked-on-at-the-last-minute security is like afterthought love.  
    Never trust it.  
    Not with your private data, and definitely not with your life.  


Functional warning signs:  
* Single user architecture with monologic backend methodology.  
    If we're using server time to operate this system, it needs to server more than one user.  
* Host/frontend lockin for the backend.  
    If all you're doing over the http(s) protocol is a clickable file list, it needs to run on something other than Apache2. Seriously.  
* Dead or MajorForked.  
    If the original developer instigates a public fork, something went seriously wrong.  

Nice to haves:  
...a built in client-side de-duplication subsystem would be nice,
    could that be built into the file-upload processing?

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

By actually installing a bunch of them and seeing how well it fit into our pipelines and workflows. Your need may vary, so try multiples out yourself once you've wrapped your head around the processes, the how and what of hosting small applications like this.  

For now, take our word for it, give it a try, and see how it works out for your use case with a bit of tweaking.  

Seriously, it's worth your time to understand all this.  

Keep reading.


### How? (Raspbian Sysadmin Crash Course)
Glad you're asking followup questions.


We install SeaFile by doing scripting, after prototyping on our single-board computer's operating system command line interface.

Scripting, a way to automate things to be (massively) repeatable, is super useful.

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

---

Now that you've been introduced to the concepts and terminology (or at least have something to reference as a jumping-off-point), let's jump into the sysadmin side of this task.  

First, let's make sure we're able to actually use git via the terminal.  
Log into your server and enter the following command:
`which git && git --version`

##### <a name="wait-what-server"></a>Wait, what server?
Oh right, we haven't made ourselves a server yet.  
Okay, that's pretty easy.  
Hit the [DietPi downloads page](https://dietpi.com/downloads/images/) and grab the version corresponding to your hardware.  
For Raspberry Pi, that'll be "ARMv6", and we're using Stretch for this.  

You could also jump straight to [raspbian, via their downloads page](https://www.raspberrypi.org/downloads/raspbian/) (or your p2p client).

You're going to need:
* Some form of computer.  
    Yaknow, like a RasPi.
* Some form of storage.  
    Like this [32GB Samsung EVO+ SDHC card (spoiler: amazon link, @todo replaceme)](https://www.amazon.com/dp/B00WR4IJBE/)
* Some form of interfaces.  
    we're not partial to a keyboard and display, so if you've got a direct mental uplink to the machines, more power to ya.  
* Some way to bootstrap the "stage" and "live" system(s).  
    Personally, we like the capabilities of the [Inatech USB OTG hub](https://www.amazon.com/dp/B00OCBXIY8/) paired with our RasPi Zero W running DietPi.  
    More on the dev-->stage-->live pipeline later.  
    For now, just knowing it exists is enough, we're building dev right now.  

So, you've got your software and your hardware, now to combine the two and make a sandwich.  
_(Okay, not really, but also, kinda.)_

Write the Raspbian image to the SD card.  
If you can't get the OTG adapter working with your bootstrap device, give [Etcher](https://etcher.io/) on your desktop a shot.  
There's numerous ways (including the command line, which is what we'll be using here) to write a disk image to an SD card.  

Use whatever works for you.

###### Using Disk Destroyer (to burn an SD card)
Or as it's more officially known, [Data Duplicator](https://ss64.com/bash/dd.html).

**Be careful when doing writes**, you can overwrite your system disk, completely erasing the entire host system!

####### Find your Hardware
First, know what your target is.  
Mine is an SD card plugged into an OTG adapter on the RasPiZero,  
which isn't something that directly translates into the `/dev/sd#` format typically used by 'nix systems.

So, start by listing your devices with `ls /dev/`. You'll see something like this:
```
autofs cpu_dma_latency  gpiomem  loop0  loop-control net ram1   ram3 raw   ...
<snip>  
...tty52  tty6   ttyAMA0  vc-mem vcsa  vcsu   video10
```
Lots of devices.  
Some correspond to physical hardware, others are virtual, like the various `loop` interfaces.  
Let's focus in on the disk devices, which sometimes correspond to a format like `sd<alpha><numeric>`, eg `sda1` or `sdc3`. Other times the'll have other extensions, you may need to search engine ['how to mount SD card']() with your OS's flavourname to figure out what that particular OS uses to designate the hardware type you're plugging into it.

On our shim system, that's gonna be 'sd' with an alphabet character after it, and then a number designating the partition if any exists.

To solve this data problem, we're going to filter again, creating a [single tier stack](/doc/stacks/tiers.md) of `ls` and `grep`.

> eg `ls -lah /dev/ | grep 'sd'`  

Filter that input with `grep 'sd'`, and you'll get something like this:
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
> The `-h` flag designates 'human readable format' here again,  
> however command flags are perhaps 43% similar across the tools we've been using.  
>  
> convention/standards cohesion is not open source's strong point is all we're saying.

From those two commands, we know that there are at least two (possibly four) disks  connected, and one of them (/dev/root) is mounted on `/`, the primary disk (which is 3% used on our system).

What we want to know is _which one is the SD card_, so we need to keep looking. The `lsblk` command helps us with that, it lists all the block devices (whether or not they're mounted) currently available to the system:
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
> There's always another tool that gives alternate perspective.  
>
> You can always check again before executing a potentially destructive command, and most of the time, it'll save you some grief before the end.

So, we want the 32gb SD card. Our identifier is therefore `/dev/sda`, and it's unmounted, which is good for the next part.

###### Local Copy
We can see there's a partition.  
No idea what's on this particular bit of storage.  
We're gonna make a copy of it, and then see if it's worth saving.  

Start with making sure you have enough space, but as we established earlier, the main disk 'mmcblk0' on our RasPiZero here is less than 4% used, we could keep around three copies if necessary.

It's not, and here's the command:  
`dd bs=2M if=/dev/sda of=./sdcard_backup.img status=progress oflag=sync`  

And now we wait for 32 gigs to transfer from an SD card slot to a different SD card slot, a space of perhaps five centimeters, and our speed-of-light bus is going to take several minutes to accomplish it.

```
root@nomad:~/dl# dd bs=2M if=/dev/sda of=./sdcard_backup.img status=progress oflag=sync  
90177536 bytes (90 MB, 86 MiB) copied, 13.1539 s, 6.9 MB/s
```

Breathe.  
Tech is magic.  
Sometimes magic takes time.  

```
31914459136 bytes (32 GB, 30 GiB) copied, 4133.16 s, 7.7 MB/s  
15218+1 records in  
15218+1 records out  
31914983424 bytes (32 GB, 30 GiB) copied, 4133.46 s, 7.7 MB/s  
```
About 69 minutes, then.  
Now to mount it locally.  

`mkdir ./sdcopy; mount -o ro,loop,offset="$(($(fdisk -l sdcard_backup.img | tail -1 | awk '{print $2}')*512))" ./sdcard_backup.img ./sdcopy`

> Using `fdisk` to get the start offset of the disk, then awk and the shell builtin to accomplish block conversion to bytes.  
> @todo - explain this part better


```
root@nomad:~/dl# ls -lah sdcopy  
total 36K  
drwxr-xr-x 2 root root  32K Dec 31  1969 .  
drwxr-xr-x 4 root root 4.0K Jun 13 10:08 ..  
root@nomad:~/dl# lsblk  
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT  
loop0         7:0    0  29.7G  1 loop /root/dl/sdcopy  
sda           8:0    1  29.7G  0 disk  
└─sda1        8:1    1  29.7G  0 part  
root@nomad:~/dl# df -h  
Filesystem      Size  Used Avail Use% Mounted on  
/dev/root       118G   33G   86G  28% /  
/dev/loop0       30G   32K   30G   1% /root/dl/sdcopy  
root@nomad:~/dl# umount ./sdcopy  
```
> The `umount <path>` command will remove the mount point, and allow you to remove the disk image if necessary.  

My SD card is empty, so now we're going to unmount the image, remove the 32gb image file, and then wipe the physical card in prep for writing the Raspbian image.

###### failmuffins
Sometimes, doing things remotely is problematic.  
That's why terminal sessions can be direct, or locally hosted.  
When a terminal session is locally hosted to the server in question,  
when you lose connection, your session persists.  

The combination of the `dtach` and `dvtm` tools gives us a fairly nice server-local work environment.  
Check out the 'twm' command, and look through the commands in the man page for reference.  
I generally run with a main terminal and two tertiary/monitoring panes.  

Combined with a network interrupt mitigation tool such as `mosh`, your session (and the multi-threaded problem solving interface that lives in it) can survive a server being offlined.


###### dd=destroy_disk
Eventually, you've got a system image and an empty SD card.  
Let's make sure it's actually empty.  
This is the part where **doing it wrong will destroy your disk**.  
_(or at least all the data that might have been on it)_  

```
root@nomad:~/dl# dd bs=4M if=/dev/zero of=/dev/sda status=progress oflag=sync
683671552 bytes (684 MB, 652 MiB) copied, 56.3593 s, 12.1 MB/s
```
At 12 MB/s, a 32gb sdcard will take about forty minutes on our system, give or take ten.

Grab a cup of tea (you can make one, there's enough time), and prepare for bringing a new system online.  
This would be a good time to hydrate, locate the hardware you're bringing online, and stage it with the adapter you'll be using to power it.  
Mine is a shiney new RasPi 3, and I'll be plugging it in next to my workhorse server, the converted Mac Mini.

```
root@nomad:~/dl# dd bs=4M if=/dev/zero of=/dev/sda status=progress oflag=sync  
31914459136 bytes (32 GB, 30 GiB) copied, 2448.11 s, 13.0 MB/s  
dd: error writing '/dev/sda': No space left on device  
7610+0 records in  
7609+0 records out  
31914983424 bytes (32 GB, 30 GiB) copied, 2448.88 s, 13.0 MB/s  
```

Disc has been zero'd.  

Now we write the downloaded image to the sd card.  

```
dd bs=2M if=./2019-04-08-raspbian-stretch-lite.img of=/dev/sda status=progress oflag=sync  
root@nomad:~/dl/raspbian# dd bs=2M if=./2019-04-08-raspbian-stretch-lite.img of=/dev/sda status=progress oflag=sync
192937984 bytes (193 MB, 184 MiB) copied, 20.0065 s, 9.6 MB/s
```
Once again, we wait.

```
root@nomad:~/dl/raspbian# dd bs=2M if=./2019-04-08-raspbian-stretch-lite.img of=/dev/sda status=progress oflag=sync1799356416 bytes (1.8 GB, 1.7 GiB) copied, 206.203 s, 8.7 MB/s
860+0 records in
860+0 records out
1803550720 bytes (1.8 GB, 1.7 GiB) copied, 207.055 s, 8.7 MB/s
```

That took less time than expected.  
Next, we mount the disk and see if we can add our hooks.  

```
mkdir ./sdmount;
losetup --offset "$(($(fdisk -l /dev/sda | tail -2 | head -1 | awk '{print $2}')*512))" /dev/sdhc0 /dev/sda

mount -o ro,loop,offset= /dev/sdhc0 ./sdmount
```


@todo.list:
Link functions.sh
checkout --> /usr/bin/src?
link to PATH as `fsh`
odot@

copy pubkeys
setup /etc repo & remote(s)
Create bridge user?


###### Mounting
Make sure you've got a place to put it:
`mkdir -p /mnt/root/shared/usb[0-9]`
`mount -r /dev/sdb1 /mnt/root/shared/usb0`

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

This gives us a list of IDs (second column on our system), and right now, because it's a Pi Zero with nothing plugged in (except power), there's only a single entry:
`Bus 001 Device 001: ID <redacted> Linux Foundation 2.0 root hub`

That was easy enough. We have a single root hub, as expected.  

Plugging our USB OTG hub/reader into the single OTG port on the Pi Zero gives me the following:
```
Bus 001 Device 005: ID <redacted> Silicon Motion, Inc. - Taiwan (formerly Feiya Technology Corp.) Flash Drive
Bus 001 Device 004: ID <redacted> Alcor Micro Corp. Multi Flash Reader
Bus 001 Device 007: ID <redacted> Generalplus Technology Inc.
Bus 001 Device 003: ID <redacted> Plantronics, Inc.
Bus 001 Device 002: ID <redacted> Terminus Technology Inc. Hub
Bus 001 Device 001: ID <redacted> Linux Foundation 2.0 root hub
```

Lots of devices.  
The hub is currently full of devices out here in meatspace.  
Starting at the top, our guess as to which each one is:
```
b001d005: An 8gb flash drive, our 'test' data for this exercise.  
b001d004: The USB OTG Hub's built in data card reader (multiformat, currently holding a 32gb SDHC card as the target system for this exercise).  
b001d007: The audio dongle to give our Zero a mic&headset jack.  
b001d003: USB headset, for reasons.  
b001d002: The hub itself.  
```

Note that there's only one bus on this particular piece of hardware.  
That's a limitation for anything operating across the bus, which means the more stuff we're attempting to do at once, the more this becomes a bottleneck.  
If I remember correctly, the network hardware is on that same bus, so writing an SD card while downloading an updated image via our p2p client might take a bit longer than expected.

Let's check on our torrent.

> I used `aria2c` (from the aria2 package) to download the torrent. For now, just obtain the image file.



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
`Functionally, can we write our data to the system we're working on?`

####### Example Code

Okay, you got this far.  
Congrats!  
That was a lot of information to digest.  

Here's how to check, download, and verify your image file:
`getFile.sh "${location}" "${destinaton}"`

By default, the file will be written to your present working directory (if `pwd` is a writeable location for you).

> lost down a 'does the `touch` command have standardized exit codes, or shall I end up rolling my own, yet again?' rabbit hole and/or trail.

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
https://linux.die.net/man/1/curl
https://linux.die.net/man/1/ls

https://ss64.com/bash/dd.html
http://man7.org/linux/man-pages/man1/dd.1.html
https://www.mail-archive.com/eug-lug@efn.org/msg12073.html
https://www.raspberrypi.org/documentation/installation/installing-images/

https://major.io/2010/12/14/mounting-a-raw-partition-file-made-with-dd-or-dd_rescue-in-linux/
https://linux.die.net/man/1/dvtm
http://www.brain-dump.org/projects/dvtm/#devel
https://www.digitalocean.com/community/tutorials/how-to-use-dvtm-and-dtach-as-a-terminal-window-manager-on-an-ubuntu-vps

https://www.reddit.com/r/linux/comments/ngil2/dvtm_a_twm_for_the_console/c393krj/

https://subbass.blogspot.com/2009/10/howto-sync-bash-history-between.html

https://askubuntu.com/questions/29872/torrent-client-for-the-command-line
https://medium.com/@jakobud/automatic-anonymous-bittorrent-downloading-using-a-raspberry-pi-b367a67de238
