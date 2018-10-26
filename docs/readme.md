

# most people call it 'multithreading'
Everything has a reaction of some sort.  
Including computer programs.

That intent, that direction, often overlaps this reaction.

Eg, you're searching for private data, and a multinational conglomerate is mining your keystrokes for insight into how it can manipulate you to give them your money.

It may, also, turn up that document you couldn't find during the meeting last week, or the video of your friend's kid that they sent you a while ago where the little tyke dances to some song that it's parental figure had playing on the radio.


The point is, for any given action, there can be n+1 reactions, where `n=0` is considered the "a lack of action is a reaction, sorta.".


So, this means that if you consider a frozen "slice" of time, with the action in question caught in the cusp of "almost happening", you could turn over examine, and in some cases guess at what will possibly happen next. You observe paths like this using something called "debugging tools", and I'll be rambling about them a bit later.

The point is, there's multiple *possible* paths, and most programs select a single path despite the many many possible other result that are in theory possible, eg "data matching some input/filter exists, display a list of the result(s)".

When a program multipaths, and caches all the "similar" results, it can sometimes save time, and it can sometimes cause huge problems.


Let's talk about the dangers of meeting yourself on a branching-and-converging multipath. 
_(the multithreading paradigm calls this process a "race condition" at times, and "concurrent writing" at others, but it's the same idea of a merge conflict as seen in the git [version control system](doc://defs.md#version_control).)_

When two [shells](docs://defs.md#data_shell) collide on their hash, normally, it takes user intervention to resolve.  
An intelligent response, frequently by whatever or whoever made the modifications (in the case of a codebase, for example).  
When decision paths collide, it's actually a *good* thing, as with data shells.



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