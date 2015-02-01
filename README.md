homebrew-gnuradio
=================
**Now maintained and fixed as of 2/1/15. Sorry about the hiatus.**

Delicious and foamy tap of the latest development version of gnuradio! Yay! Builds clean on Mac OS X Yosemite 10.10 using Xcode 6.1 command line tools (clang/llvm).

Simply run: 
```sh
brew tap metacollin/gnuradio
brew install gnuradio
```
or, if you prefer to use brewed python instead of the system's python:
```sh
brew install gnuradio --with-brewed-python
```

Other available flags to be used at your discretion are `--without-qt` and `--without-docs`. **Note:** Disabling QT will prevent the GUI companion from being built.

The latest dev build can be attempted using the `--HEAD` argument, but this isn't necessarily guaranteed to 
work.
