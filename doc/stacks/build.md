# Automagic Buildskripten
The foundation of doing things quickly and reliably on 'nix-and-'nix-adjacent systems is a concept of continuous integration, powered by some form of build system.

After much testing, fixing of broken things, and using other people's half-baked attempts, the clear winner for me is a system called [Laminar](https://laminar.ohwg.net/).

It uses many of the underlying 'nix systems, and is thus rather lightweight compared to similarly-featured systems that attempt to reinvent the wheel inside their own paradigm.

## Installation

Because we don't have a build system yet, we have to do this part manually.

Create a new user for the build system.  
Personally, I use 'builder', because I never know when the build system may need to change, and I'd like to avoid having to burn down the account ever single time that happens.

> a sidenote on modular architecture:  
> by keeping the base system non-specific  
> it allows you to make a web of systems with loose dependencies  
> and helps reduce long term technical debt.

You're gonna need privileges for this part.

`adduser builder`


Log in as the user:
`su --login builder`
create a folder to put the build system source code in:
`mkdir -p ~/src/laminar`  

> the `-p` option for `mkdir` creates all necessary parent directories for the given folder.  
> more on this in [directory golf](/doc/stacks/dirmod.md).   

and then clone the repo
`git clone https://github.com/ohwgiles/laminar.git ~/src/laminar`
