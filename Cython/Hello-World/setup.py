#!/usr/bin/env python
#
# build the C code and compile it from within python using Cython
#
# to run this code:
#	python setup.py build_ext --inplace
# then from within another python code:
#	from hello import hello_world
#	use it as you would any other python code
#
# R. Orvedahl 12-23-2014

from distutils.core import setup
from Cython.Build import cythonize

setup(name="Hello world app",
      ext_modules=cythonize("hello.pyx"))

