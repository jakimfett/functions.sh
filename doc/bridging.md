# Why Bridge
Because decentralized is the way to go, and a vast amount of stuff generally prevents you from using SSH to get to your stuff from outside a Local Area Network (or LAN).

Because a mesh is made of many hops.

Because it's easy, thanks to open source software tools (like this one!).

## Bridge Nodes
Bridge nodes have (surprise!) a user called `bridge` which acts as a template/default account for doing reverse SSH connections from behind firewalls, routers, switches, etc.

The bridge user password is a closely guarded secret, but you can use an ed25519 key to connect.

## <a name="key-generation"></a>ssh-keygen
First, you'll need to generate an SSH key.  
If you already have one in the ed25519 format, you can skip to [registering your key](#registration).

First, check if you've got the `ssh-keygen` utility on your system:  
`which ssh-keygen`  
If not, you'll need to install it via your package manager.  
Sometimes, utilities are packaged together, so use your search engine to find out what you actually need to install on your specific OS and version.

For Raspbian Lite, the tool is installed by default. You can immediately jump to running the key generation command:  
`ssh-keygen -o -a 256 -t ed25519`

This uses 256 rounds of bcrypt KDF and the EdDSA reference implementation of the [Twisted Edward curve](https://en.wikipedia.org/wiki/Twisted_Edwards_curve), which is "decently secure" as far as I've been able to determine.  
Read more about this in the [external sources](#sources).

## <a name="key-registration"></a>Register Your Key
This part is still in progress.  

Handing your printed key to one an A.S.P. captain (or sysadmin) is still the most secure method, but we're working on a public anonymous drop location for anyone who can't/won't work with the face-to-face paradigm, as well as several digital methods that preserve your privacy.

More on this later.  
Suffice it to say, once you've communicated your pubkey to us, we'll add it to the bridge node `authorized_keys` file, and you'll be able to connect.

## <a name="connect"></a>Connect

## <a name="sources"></a>External Sources
https://blog.g3rt.nl/upgrade-your-ssh-keys.html
