homebrew-gnuradio
=================
Delicious and foamy tap of the latest ~~development~~ stable version of gnuradio! Yay! 

This will *not* automatically handle gnuradio's python dependencies, in accordance with homebrew's python 
policy. Typically, you can install the python dependencies required by gnuradio by running:

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

Other available flags to be used at your discretion are `--without-qt` and `--without-docs`. 

**Note:** Disabling QT will prevent the GUI companion from being built.

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
brew rm $(brew deps gnuradio) # May need to add --force
brew rm gnuradio
brew install gnuradio
```

To make matters even more complicated, if you hadn't been using homebrew's python before, you might have 
installed the python dependencies using OSX's python, and it keeps its python packages in a different location than homebrew's python. As a result, the formula may complain about missing python dependencies, and you simply need to run pip again and install them. 


Finally, you might be wondering, "What if i don't WANT to use homebrew's python? I want one python on my system 
so I don't have to deal with this!"  No problem! Homebrew only uses it's own python when using bottles.  If you 
run:

```ssh
brew rm $(brew deps gnuradio)
brew rm gnuradio
brew install gnuradio --build-from-source  # Important! Rebuilds deps against OS X's python.
```

Again, you may need to run pip as needed, but pip is not installed by default when using OSX's python.  To install dependencies if you opt not to use homebrew's python, the proedure is as follows:

```ssh
sudo easy_install pip
sudo pip install Cheetah lxml matplotlib numpy scipy docutils sphinx
```

Enjoy! I'll be adding additional build options soon, keep an eye out.
