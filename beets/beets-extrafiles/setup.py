#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Setup for beets-extrafiles."""
import os

from setuptools import setup

with open(os.path.join(os.path.dirname(__file__), 'README.md')) as f:
    readme = f.read()

setup(
    name='beets-extrafiles',
    version='0.0.7',
    description=(
        'A plugin for beets that copies additional files and directories '
        'during the import process.'
    ),
    long_description=readme,
    long_description_content_type='text/markdown',
    author='Jan Holthuis',
    author_email='holthuis.jan@gmail.com',
    url='https://github.com/Holzhaus/beets-extrafiles',
    license='MIT',
    packages=['beetsplug'],
    namespace_packages=['beetsplug'],
    test_suite='tests',
    install_requires=[
        'beets>=1.4.7',
        'mediafile~=0.6.0',
    ],
    classifiers=[
        'Topic :: Multimedia :: Sound/Audio',
        'Topic :: Multimedia :: Sound/Audio :: Players :: MP3',
        'License :: OSI Approved :: MIT License',
        'Environment :: Console',
        'Environment :: Web Environment',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],
)
