# ~/doc/opsec/readme.md
#
# What makes a system insecure?
# The very things that make it useable.
#
# What makes a system secure?
# Layers of cautious assumptions, a healthy air gap, physical security, and immutability.
#
# What makes most security systems unuseable?
# The security.
#
# Know when to compromise, and always have a backup stashed off-site.
#

Doing 'good security' everywhere in an age where the weakest link is the human mind is functionally impossible.

Doing security *well*, where the important things are protected, and there are enough backups in rotation that nothing short of apocalypse will really wipe out the data, is doable on a shoestring budget and a bit of elbow grease.

### Operational Security
Information is power, and although enabling extra debugging on development and staging servers is recommended, please be mindful that a live environment should be actively hostile towards intruders. 

# Active Hostility
Assuming a user is actively trying to undermine and functionally break a system at all times is functionally necessary, because the expense of fixing typewriters far exceeds the cost of hiring (code)monkeys, metaphorically speaking.

Code is just instructions.
Algorithms are just methods for doing a thing.
Eventually, with enough programmers, you can turn any project into a disorganized mess.

But, assuming that all actions against a system are attacks until proven otherwise ignores the necessity of rapid paths and the rapidity with which a modern computer can throw encrypted text across a network.