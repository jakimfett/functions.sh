# Why Serve Your Own
Because you don't trust me.  
Because you want to do something I won't let you do on my systems.  
Because you want an additional layer of separation between your users and my analytics.  

Because it's easy, ish.

## What You'll Need
A server your users can ping.  

This can be LAN or Wide Area Network (WAN), or even a laser-comm VPN that you've airgapped and hardwired into your hermetically sealed off-grid underground bunker, like I did.  

The point is, you need a server if you're not going to use one of the existing ones, that's kinda the point of "self-hosting".

## What You'll Do
Set up a bridge user for outside services/users/etc to connect to.  

Personally, I'm partial to something like `bridge@ssh.pirate.me` or similar.

Make sure the bridge works with the [bridging script](/com/net/bridge.sh), and then [set up a service](/com/net/bridge.service) on your endpoint to keep the connection online.
