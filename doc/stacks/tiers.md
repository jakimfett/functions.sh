# Stacking with Tiers: a How-To
Pipes in scripting are really nice.
```
echo 'a pipe character between two quotation marks with whitespace on either side:'
echo ' \'|\' '
```

We take a pipe, put a command on either side, and sometimes, we can use capabilities of both programs to do something even more useful than a single command could accomplish.

This is the underlying principle of function stacking.  

`echo 'stacking user feedback with a file write' | tee -a ${cache}/tutorial.log`

## Exercise:
Unpack & identify the parts of the above command,  
what they do,  
and some reasons why you might want to do them in a script.
