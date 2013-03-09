mog
===

A poor-man mock generator for D language.

It uses dscanner in order to generate json file and then parses it.

### Compiling
```sh
dmd main.d -ofmog
```
or 
```sh
rake -f rakefile.linux
```

### Test some example
```
cd test
rake -f rakefile.linux clean
rake -f rakefile.linux
```
