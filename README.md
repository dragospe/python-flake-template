
If you get an error like

```
       >   Preparing metadata (pyproject.toml) ... error
       > error: metadata-generation-failed
       >
       > × Encountered error while generating package metadata.
       > ╰─> See above for output.
       >
       > note: This is an issue with the package mentioned above, not pip.
       > hint: See above for details.
```

this is most likely because nix derivations built using flakes only can 
access files that are known to git. You probably forgot to `git add` 
new code. *Note*: you do not need to _commit_ the code, just add it.
