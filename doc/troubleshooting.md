# failmuffins
Something isn't quite right.  

Why?  

Let's find out.  

## Logs
Under Linux, logs are typically in the `/var/log` directory.

Our test case is the laminar build system, which unfortunately does not seem to conform to this standard.

## Elimination Games
Before you start changing things, decide what you are attempting to find out, and describe it.

If you change multiple things, progress can be rapid, unless the feedback overlaps, and then you're worse off.

A proper concept-prototype-debug-commit loop is a significant tool towards understanding what goes wrong, and how, inside a system.

A tool called `etckeeper` will automagically create install/update/upgrade logs of the apt/apt-get process, and it can be accessed as root, or via sudo commands. Non-administrator users are not given this information, and it should be noted that `etckeeper`, like any other logging, can give an attacker additional surface to attempt leverage against.

### Network Debug
Attempt a connection with a device running a different operating system.

While mobile OSs do not, generally speaking, come with built-in network debugging tools (and obviously you cannot download a tool if the network is down...), most modern app platforms have network debugging tools available.

> iOS - tools unknown, possibly `blink`?
> Android - Port Authority (for local network scanning), Wifi Analyzer (for wireless analytics), and WiGlWifi (for mapping wireless networks in your area).