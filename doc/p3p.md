# What's a p3p?
The p3p system is an abstraction layer built on top of standard-ish 'nix principles, that ensures each file is on my computer, my local cache, and backed up somewhere else in encrypted format.

In theory, sharing a file is as easy as allowing someone to restore the file from the remote backup, to their cache, so it can be accessed on their computer.

Thus, three locations for every file, and 3x the confidence when working with files that change rapidly.

The more you change the file, the more the backup increments.

If you've not used a file for a while, the system prunes your local copy after adding a second encrypted backup, and finally prunes your cache (based on usage needs of that particular resource) after adding a 3rd encrypted backup elsewhere.

Minimum of three locations for each file.

Indicator appears `p1p` if local file has been modified.  
Indicator appears `p2p` if local cache is identical to local file.  
Indicator appears `p3p` if encrypted remote is synchronized.
