#!/usr/bin/env python
#
# build the Cython code and compile it from within python
#
# to run this code:
#	python setup.py build_ext --inplace
#
# R. Orvedahl 1-20-2015

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
#from Cython.Build import cythonize
import numpy

npy_include_dir = numpy.get_include()
pyx_file = "cython_def.pyx"
pyx_name = "cython_wrapper"

# list the object files: wrapper.o holds the wrapping code which depends on
# original.o code...note this is the filename, not the module name
objects = ["const_orig.o", "dot_prod_orig.o", "vectors_orig.o", "wrapper.o"]

ext_modules = [Extension(pyx_name, [pyx_file],
                         include_dirs=[npy_include_dir],
                         libraries=["gfortran"],
                         extra_objects=objects)]

setup(name="F90 Wrapping", cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules)

