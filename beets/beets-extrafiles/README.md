# beets-extrafiles [![Build Status](https://travis-ci.org/Holzhaus/beets-extrafiles.svg?branch=master)](https://travis-ci.org/Holzhaus/beets-extrafiles)

A plugin for [beets](http://beets.io/) that copies additional files and directories during the import process.


## Installation

**Important:** Even though beets supports Python 2 and Windows, this plugin does not - it only supports Python 3 on a Unix-like OS. See the [F.A.Q. section](#faq) for details.

This plugin has no dependencies apart from [`setuptools`](https://pypi.org/project/setuptools/) and [`beets`](https://pypi.org/project/beets/) itself.

The plugin in release on [PyPI](https://pypi.org/project/beets-extrafiles/) and can be installed via:

    $ pip3 install --user beets-extrafiles

It is also possible to clone the git repository and install the plugin manually:

    $ git clone https://github.com/Holzhaus/beets-extrafiles.git
    $ cd beets-extrafiles
    $ ./setup.py install --user


## Usage

Activate the plugin by adding it to the `plugins` list in beet's `config.yaml`:

```yaml
plugins:
  # [...]
  - extrafiles
```

Also, you need to add [glob patterns](https://docs.python.org/3/library/glob.html#module-glob) that will be matched.
Patterns match files relative to the root directory of the album, which is the common directory of all the albums files.
This means that if an album has files in `albumdir/CD1` and `albumdir/CD2`, then all patterns will match relative to `albumdir`.

The snippet below will add a pattern group named `all` that matches all files that have an extension.

```yaml
extrafiles:
    patterns:
        all: '*.*'
```

Pattern names are useful when you want to customize the destination path that the files will be copied or moved to.
The following configuration will match all folders named `scans`, `Scans`, `artwork` or `Artwork` (using the pattern group `artworkdir`), copy them to the album path and rename them to `artwork`:

```yaml
extrafiles:
    patterns:
        artworkdir:
          - '[sS]cans/'
          - '[aA]rtwork/'
    paths:
        artworkdir: $albumpath/artwork
```


## Development

After cloning the git repository, you can use `setup.py` to set up the necessary symlinks for you:

    $ git clone https://github.com/Holzhaus/beets-extrafiles.git
    $ cd beets-extrafiles
    $ ./setup.py develop --user

When adding changes, please conform to [PEP 8](https://www.python.org/dev/peps/pep-0008/).
Also, please add docstrings to all modules, functions and methods that you create.
Use can check this by running [`flake8`](http://flake8.pycqa.org/en/latest/index.html) with the [`flake8-docstrings` plugin](https://pypi.org/project/flake8-docstrings/).

Using [pre-commit](https://pre-commit.com/) will perform these checks automatically when committing changes.
You can install the pre-commit hooks by executing this in the git repository's root directory:

    $ pre-commit install

You should also *test every single commit* by running unittests, i.e.:

    $ ./setup.py test

If a test fails, please fix it *before* you create a pull request.
If you accidently commit something that still contains errors, please amend, squash or fixup that commit instead of adding a new one.


## F.A.Q.

### Why not use the `copyartifacts` plugin?

The [`copyartifacts` plugin](https://github.com/sbarakat/beets-copyartifacts) by Samit Barakat serves the same purpose.

However, it curently seems to be unmaintained:
The last commit has been made over a year ago and also suffers from a [bug](https://github.com/sbarakat/beets-copyartifacts/issues/38) that makes it crash on every run.
I wrote a patch and filed a [Pull Request](https://github.com/sbarakat/beets-copyartifacts/pull/43) some time ago, but I has not been merged yet.

Also, wanted to go in a different direction by supporting folders and the ability to do finer-grained path customizations.
Hence, I wrote `beets-extrafiles`.

### Why does this plugin not support Python 2 and Windows?

I initally wrote this plugin, because I needed it.
Since I use neither Python 2 nor Windows, I didn't implement support.

If you really need support, feel free to write a patch and file a Pull Request.
As long as it does not make the code considerably harder to read, I'll merge it.

For Windows support, some kind of Continuous Integration (CI) solution would also be necessary to prevent future breakage.

### What license is used for this project?

This project is released under the terms of the [MIT license](LICENSE).
