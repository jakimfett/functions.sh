Doing enough, fast enough, is difficult at times.

This piece of software, written (mostly) in scripting language(s), is a lever, of sorts.

It starts with the idea that the tools we use are more powerful if they operate in similar ways.  
Example, having one interchangeable source of power for most of your small electronics.  
Or that most types of transportation can refuel at any fuel station, across the planet.

But this interoperability can sometimes hold back progress, especially as those tools become powerful in ways that are not balanced.

In martial arts, you are asked to exist in a paradigm that is not your own.  
You have to become teachable, and you have to become more conscious of the potential of your actions.  
The actions associated with this set of computer programs can have far-reaching consequences.  

Levers can be used to lift or move things.  
Levers can also be used to harm things, even if the intention was to lift or move.

This is intended for personal, _offline_ use.

If you're not offline, it may have unintended consequences.  
By using this software, you're accepting the risks associated with that.



# most people call it 'multithreading'
Everything has a reaction of some sort.  
Including computer programs.

That intent, that direction, often overlaps this reaction.

Eg, you're searching for private data, and a multinational conglomerate is mining your keystrokes for insight into how it can manipulate you into giving them your money.

It may, also, turn up that document you couldn't find during the meeting last week, or the video of your friend's kid that they sent you a while ago where the little tyke dances to some song the parental figure had playing on the radio.


The point is, for any given action, there can be `n+1` reactions, where `n=0` is considered the "a lack of action is a reaction, sorta.".


So, this means that if you consider a frozen "slice" of time, with the action in question caught in the cusp of "almost happening", you could turn over examine, and in some cases guess at what will possibly happen next. You observe paths like this using something called "debugging tools", and I'll be rambling about them a bit later.

The point is, there's multiple *possible* paths, and most programs select a single path despite the many many possible other result that are in theory possible, eg "data matching some input/filter exists, display a list of the result(s)".

When a program multipaths, and caches all the "similar" results, it can sometimes save time, and it can sometimes cause huge problems.


Let's talk about the dangers of meeting yourself on a branching-and-converging multipath. 
_(the multithreading paradigm calls this process a "race condition" at times, and "concurrent writing" at others, but it's the same idea of a merge conflict as seen in the git [version control system](doc://defs.md#version_control).)_

When two [shells](docs://defs.md#data_shell) collide on their hash, normally, it takes user intervention to resolve.  
An intelligent response, frequently by whatever or whoever made the modifications (in the case of a codebase, for example).  
When decision paths collide, it's actually a *good* thing, as with data shells.


When two data shells merge, their contents, as determined by algorithm, are identical.  
Note that this is distinct from being "functionally identical", eg as with an image in pixel vs vector.

For small data, eg the value of a single pixel or an individual vector, this takes up _more_ space than traditional forms of storage.  
For larger or "chunky" data, this allows the overlapping portions of unrelated datasets share storage and backup while maintaining anonymity and security, because the user then stores a value for retrieving the shell, which is delivered by the backend to a local server, and then the user will be able to decrypt a copy once it's on their device.

However, there is risk associated with merging.  

And, a lot of that risk stems from _pattern matching_, on some level.  
Most computers have a hard time determining the difference between slightly different data and very different data, and data without context has little meaning to a human, either.

If you don't understand the data, you can't merge effectively.



# the idea
Managing state is complicated. Why should a simple three-liner of a shell script need one?

Because most computer programs are convoluted, overcomplex, under-documented, and frequently [Just Plain Bad](doc://defs.md#Bbad_code).

The key is abstraction and identity.

My shell is unique.  
Yours probably is, too.
That's because the shell's "state" is in flux, just like your entire user account, your data, your connection, etc etc.  

There's a lot of chaos in the process, and frequently, things get lost in the shuffle.  
Documents. Lives. Love.

You know, the important things.

---
A very wise hacker once told me:
> `never do anything for just one reason`  

You can't hear their inflection, and I'd rather not go into the complexities of audio conersation for an un-skilled end user,  
But  
Just that stateement, is why this particular scripting language is possible. 

In code, as with life, the ideal, the vision, is a poor rendering indeed in the final product.

This is an alternate approach.  
It has worked for me.

It may, or may not, work for you.

Judge lightly.  
Understand deeply.  
Criticize constructively.