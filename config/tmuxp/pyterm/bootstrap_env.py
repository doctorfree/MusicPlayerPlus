#!/usr/bin/env python
import os
import sys

cwd = os.path.dirname(__file__)
project_root = os.path.dirname(cwd)

sys.path.insert(0, project_root)

from _bootstrap_util import *


def main():
    pymod_exists('virtualenv', msg=(
        'Virtualenv is required for this bootstrap to run.\n'
        'Install virtualenv via:\n'
        '\t$ [sudo] pip install virtualenv'
    ), throw=True)

    pymod_exists('pip', msg=(
        'pip is required for this bootstrap to run.\n'
        'Find instructions on how to install at: %s' %
        'http://pip.readthedocs.org/en/latest/installing.html'
    ), throw=True)

    prompt_toolkit = Project(
        project_dir='~/study/python/python-prompt-toolkit/',
        virtualenv_dir='.venv/'
    )
    prompt_toolkit.setup()

    pyvim = Project(
        project_dir='~/study/python/pyvim',
        virtualenv_dir='.venv/',
    )
    pyvim.setup()
    pyvim.env.install(prompt_toolkit.project_dir, options=['-e'])


    ptpython = Project(
        project_dir='~/study/python/ptpython/',
        virtualenv_dir='.venv/'
    )
    ptpython.setup()
    ptpython.env.install(prompt_toolkit.project_dir, options=['-e'])

    ptpdb = Project(
        project_dir='~/study/python/ptpdb/',
        virtualenv_dir='.venv/'
    )
    ptpdb.setup()
    ptpdb.env.install(prompt_toolkit.project_dir, options=['-e'])

    pymux = Project(
        project_dir='~/study/python/pymux/',
        virtualenv_dir='.venv/'
    )
    pymux.setup()
    pymux.env.install(prompt_toolkit.project_dir, options=['-e'])

    pymux = Project(
        project_dir='~/work/python/profiling/',
        virtualenv_dir='.venv/'
    )
    pymux.setup()

    if os.environ.get('REPL', False):
        from ptpython.repl import embed
        embed(globals(), locals())

if __name__ == '__main__':
    main()
