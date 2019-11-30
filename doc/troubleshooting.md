# failmuffins
Something isn't quite right.  

Why?  

Let's find out.  

## Logs
Generally speaking, logs are in the `/var/log` directory.

Our test case is the laminar continuous integration build system.  
Which, as fate (or developer oversight) would have it, doesn't create an entry at `/var/log/${service}.log` or `/var/log/${service}/${something}.log`

> You can validate this with `ls -lah /var/log | grep laminar` on your system, although this would require you to have the laminar system already installed, like we do (currently) on live.
