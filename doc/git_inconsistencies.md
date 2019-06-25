# On Git VCS and Inconsistency
Git is a fantastic piece of software which frequently gives me immense frustration.

Consider command consistency for a moment.  
A given application ideally operates by a given set of patterns.  
Once you learn the patterns, it's reflex to type them in.  

However:  
`git fetch origin development`  
and  
`git merge origin/development`
operate under two distinct parameter pattern paradigms.

One uses discrete strings for the remote (eg `origin`) and the branch (eg `development`).  
The other mashes them together with a bit of punctuation (eg `origin/development`).  

This results in Yet Another Thing We Gotta Remember To Use This Tool, and YATWGRTUTT makes me frustrated every time I encounter it.

# Additional Reading
http://archive.is/yjuBb