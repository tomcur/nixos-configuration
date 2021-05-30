#!/usr/bin/env python3

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup


setup(
    name="paper",
    version="1.0.0",
    description="Sets wallpapers",
    author="Thomas Churchman",
    author_email="thomas@kepow.org",
    packages=[],
    install_requires=[],
    scripts=["scripts/paper"],
)
