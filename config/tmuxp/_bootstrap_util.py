"""
You contribute to a lot of open source projects, you want to be able to
contribute, but are tired of repeating the same process over and over again.

Self contained bootstrapper for python projects.

What it helps you do:

- helper functions:
	- check whether virtualenv and pip installed on system
	- check if a virtualenv exists
	- check if packages installed in virtualenv
	- check if programs are installed on target system
	- create a virtualenv
	- install packages from virtualenv
- functions to see if modules are installed at system level (virtualenv
	and pip)

Borrows functions from virtualenv-api (BSD 2-clause)
https://github.com/sjkingo/virtualenv-api
https://github.com/sjkingo/virtualenv-api/blob/master/LICENSE
"""
from __future__ import (
    absolute_import, division, print_function, with_statement, unicode_literals
)

import os
import sys
import subprocess
import pkgutil

class PackageInstallationException(EnvironmentError):
    pass


def warning(*objs):
    print("WARNING: ", *objs, file=sys.stderr)


def fail(message):
    sys.exit("Error: {message}".format(message=message))


PY2 = sys.version_info[0] == 2


def has_module(module_name):
    try:
        import imp
        imp.find_module(module_name)
        del imp
        return True
    except ImportError:
        return False


def split_package_name(p):
    """Splits the given package name and returns a tuple (name, ver)."""
    s = p.split('==')
    if len(s) == 1:
        return (s[0], None)
    else:
        return (s[0], s[1])


def which(exe=None, throw=True):
    """Return path of bin. Python clone of /usr/bin/which.

    from salt.util - https://www.github.com/saltstack/salt - license apache

    :param exe: Application to search PATHs for.
    :type exe: string
    :param throw: Raise ``Exception`` if not found in paths
    :type throw: bool
    :rtype: string

    """
    if exe:
        if os.access(exe, os.X_OK):
            return exe

        # default path based on busybox's default
        default_path = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'
        search_path = os.environ.get('PATH', default_path)

        for path in search_path.split(os.pathsep):
            full_path = os.path.join(path, exe)
            if os.access(full_path, os.X_OK):
                return full_path

        message = (
            '{0!r} could not be found in the following search '
            'path: {1!r}'.format(
                exe, search_path
            )
        )

        if throw:
            raise Exception(message)
        else:
            print(message)
    return None


def pymod_exists(module, msg=None, throw=False):
    """Return True if python module exists.

    :param module: Python package name, only accepts root module, e.g.
        'flask', but not 'flask.app'
    :type module: str
    :param msg: Optional message / instruction if module not found
    :type msg: str
    :param throw: Raise exception if module not found
    :type throw: boot
    :rtype: bool
    :returns: True if module found
    """
    if pkgutil.find_loader(module):
        return True

    if not msg:
        msg = '${module} not found.'.format(module=module)

    if throw:
        fail(msg)

    print(msg)
    return False


def bin_exists(binpath):
    return os.path.exists(binpath) and os.path.isfile(binpath)

project_dir = os.path.dirname(os.path.realpath(__file__))
env_dir = os.path.join(project_dir, '.venv')
pip_bin = os.path.join(env_dir, 'bin', 'pip')
python_bin = os.path.join(env_dir, 'bin', 'python')
virtualenv_bin = which('virtualenv', throw=False)
virtualenv_exists = os.path.exists(env_dir) and os.path.isfile(python_bin)
sphinx_requirements_filepath = os.path.join(
    project_dir, 'doc', 'requirements.pip'
)

def expanddir(_dir):
	return os.path.expanduser(os.path.expandvars(_dir))


class Project(object):

    def __init__(
            self,
            project_dir=os.path.dirname(os.path.realpath(__file__)),
            virtualenv_dir='.venv/',
            project_requirements=None,
            doc_requirements=None,
            test_requirements=None
	):
        """You can override this initializer and anything else here.

        :param project_dir: directory of project
        :type project_dir: str
        :param virtualenv_dir: can be absolute, or relative to the project_dir
        :type virtualenv_dir: str
        """
        self.project_dir = expanddir(project_dir)
        self.virtualenv_dir = expanddir(
            os.path.normpath(os.path.join(self.project_dir, virtualenv_dir))
        )
        self.env = PipEnv(self.pip_bin)

    @property
    def pip_bin(self):
        """Path to pip binary."""
        return os.path.join(self.virtualenv_dir, 'bin', 'pip')

    @property
    def python_bin(self):
        """Path to python binary."""
        return os.path.join(self.virtualenv_dir, 'bin', 'python')

    @property
    def virtualenv_exists(self):
        return (
            os.path.exists(self.virtualenv_dir) and
            os.path.isfile(self.python_bin)
        )

    """
    Requirements
    ------------

    Tuple of pip requirements

    These may be None::

        docs_requirements = None

    A tuple of packages:

        docs_requirements = ('sphinx', 'sphinx-rtd-theme',)

    A tuple of packages with versions (optional)::

        docs_requirements = ('sphinx>=0.13', 'sphinx-rtd-theme',)

    A requirements file::

        docs_requirements = ('-r /path/to/requirements.txt')

    # both::

        docs_requirements = ('-r /path/to/reqs.txt', 'sphinx>=013', 'ptpdb',)

    You can also return it as a property:

        @property
        def docs_requirements(self):
            reqs = ()
            if somecondition:
                reqs += ('specialpkg')
            return reqs
    """
    docs_requirements = None   # path to docs requirement packages
    tests_requirements = None  # path to test requirement textfile
    dev_requirements = None    # path to test requirement textfile

    def setup(self):
        join = os.path.join
        exists = os.path.exists

        if not which('entr', throw=False):
            message = (
                '\nentr(1) is a cross platform file watcher.'
                'You can install it via your package manager on most POSIX '
                'systems. See the site at http://entrproject.org/\n'
            )
            print(message)

        if not self.virtualenv_exists:
            subprocess.check_call(
                [virtualenv_bin, self.virtualenv_dir]
            )

        self.install_project()

        self.setup_docs()

    def install_project(self):
        return self.env.install(self.project_dir, options=['-e'])

    def setup_docs(self):
        join, exists, isfile = os.path.join, os.path.exists, os.path.isfile
        if self.docs_requirements:
            if not isfile(join(env_dir, 'bin', 'sphinx-quickstart')):
                self.env.install(self.docs_requirements)

            # clean sphinx build dir
            if exists(join(env_dir, 'build')):
                os.removedirs(join(env_dir, 'build'))


class PipEnv(object):
    """Tiny wrapper around pip. Useful to target a virtualenv or system pip."""

    def __init__(self, pip_bin):
        self.pip_bin = pip_bin

    def pip(self, command, *args):
        print(self.pip_bin, command, *args)
        return subprocess.check_output((self.pip_bin, command,) + args)

    def installed_bins(self):
        """list bins in bin/"""
        return None

    @property
    def pip_version(self):
        """Version of installed pip."""
        if not hasattr(self, '_pip_version'):
            string_version = self.pip('-V').split()[1]
            self._pip_version = tuple([int(n)
                                       for n in string_version.split('.')])
        return self._pip_version

    def install(self, package, force=False, upgrade=False, options=None):
        """Installs the given package into this virtual environment, as
        specified in pip's package syntax or a tuple of ('name', 'ver'),
        only if it is not already installed. Some valid examples:
         'Django'
         'Django==1.5'
         ('Django', '1.5')
        If `force` is True, force an installation. If `upgrade` is True,
        attempt to upgrade the package in question. If both `force` and
        `upgrade` are True, reinstall the package and its dependencies.
        The `options` is a list of strings that can be used to pass to
        pip."""
        if options is None:
            options = []
        if isinstance(package, tuple):
            package = '=='.join(package)
        if not (force or upgrade) and self.is_installed(package):
            print(
                '%s is already installed, skipping (use force=True to override)' % package)
            return
        if not isinstance(options, list):
            raise ValueError("Options must be a list of strings.")
        if upgrade:
            options += ['--upgrade']
            if force:
                options += ['--force-reinstall']
        elif force:
            options += ['--ignore-installed']

        options += [package]
        try:
            print(self.pip('install', *options))
        except subprocess.CalledProcessError as e:
            raise PackageInstallationException(
                (e.returncode, e.output, package))

    def search(self, term):
        """
        Searches the PyPi repository for the given `term` and returns a
        dictionary of results.
        New in 2.1.5: returns a dictionary instead of list of tuples
        """
        packages = {}
        results = self.pip('search', term)
        for result in results.split(os.linesep):
            try:
                name, description = result.split(' - ', 1)
            except ValueError:
                # '-' not in result so unable to split into tuple;
                # this could be from a multi-line description
                continue
            else:
                name = name.strip()
                if len(name) == 0:
                    continue
                packages[name] = description.split('<br', 1)[0].strip()
        return packages

    def search_names(self, term):
        return list(self.search(term).keys())

    @property
    def installed_packages(self):
        """
        List of all packages that are installed in this environment in
        the format [(name, ver), ..].
        """
        freeze_options = [
            '-l', '--all'] if self.pip_version >= (8, 1, 0) else ['-l']
        return list(map(split_package_name, filter(
            None, self.pip('freeze', *freeze_options).split(os.linesep)))
        )

    @property
    def installed_package_names(self):
        """List of all package names that are installed in this environment."""
        return [name.lower() for name, _ in self.installed_packages]

    def is_installed(self, package):
        """Returns True if the given package (given in pip's package syntax or a
        tuple of ('name', 'ver')) is installed in the virtual environment."""
        if isinstance(package, tuple):
            package = '=='.join(package)
        if package.endswith('.git'):
            pkg_name = os.path.split(package)[1][:-4]
            return pkg_name in self.installed_package_names or \
                pkg_name.replace('_', '-') in self.installed_package_names
        pkg_tuple = split_package_name(package)
        if pkg_tuple[1] is not None:
            return pkg_tuple in self.installed_packages
        else:
            return pkg_tuple[0] in self.installed_package_names
