homebrew-gnuradio
=================
Delicious and foamy tap of the latest development version of gnuradio! Yay! 

This will *not* automatically handle gnuradio's python dependencies, in accordance with homebrew's python 
policy. Typically, this can be done using pip:

```sh
pip install Cheetah lxml matplotlib numpy scipy docutils sphinx
```

Then, simply run: 
```sh
brew tap metacollin/gnuradio
brew install gnuradio
```

But don't worry, if you weren't able to use pip or are missing a python dependency, homebrew will see which 
python packages are missing (if any) and tell you how to install them after you try to `brew install gnuradio`.

Other available flags to be used at your discretion are `--without-qt` and `--without-docs`. **Note:** Disabling 
QT will prevent the GUI companion from being built.

The latest dev build can be attempted using the `--HEAD` argument, but this isn't necessarily guaranteed to 
work.

Python Woes and Other Issues
-------------

If you are experiencing problems such as gnuradio-companion not being built, or gnuradio crashing immediately on 
launch, or simple build failure, it's almost certainly a python issue.  

Here is the problem: homebrew bottles are linked against homebrew's python formula, but it wasn't always this 
way.  Certain dependencies like pygtk or pyqt, if they've been on your system long enough, may have been built 
locally and will have linked to OS X's python, while other gnuradio dependencies are linking to homebrew's 
python.  One must link to either OS X's python, OR homebrew's python, but never both in the same executable 
binary.

The only fool-proof way to ensure this is by reinstalling all of the gnuradio dependencies:

```ssh
brew rm $(brew deps gnuradio)
brew rm gnuradio
brew install gnuradio
```

To make matters even more complicated, if you hadn't been using homebrew's python before, you might have 
installed the python dependencies with pip under OS X's python, and haven't been installed for homebrew's 
python.  The formula may complain about missing python dependencies, please rerun the commands it asks, now that 
it will run homebrew python's pip.  If it doesn't find any issues, that is OK too, again, it may or may not 
happen depending on your system.


Finally, you might be wondering, "What if i don't WANT to use homebrew's python? I want one python on my system 
so I don't have to deal with this!"  No problem! Homebrew only uses it's own python when using bottles.  If you 
run:

```ssh
brew rm $(brew deps gnuradio)
brew rm gnuradio
brew install gnuradio --build-from-source  # Important! Rebuilds all dependencies against OS X's python!
```

Again, you may need to run pip as needed, but its ok if the formula never asks either.  The downside to this is 
that you won't be using bottles, so build times will be significant, and could potentially break other formula 
that were built against homebrew's python and they will need to be rebuilt from source to fix.  
