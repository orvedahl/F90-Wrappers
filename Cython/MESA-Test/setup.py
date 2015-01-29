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
import numpy
import os

mesa_dir = os.environ['MESA_DIR']  # uses MESA_DIR environment variable
                                   # that is required to install MESA
mesa_lib = mesa_dir + '/lib'       # library directory of MESA libs
mesa_inc = mesa_dir + '/include'   # include directory of MESA include files

npy_include_dir = numpy.get_include()
pyx_file = "cython_def.pyx"
pyx_name = "cython_wrapper"

# order of libraries follows from MAESTRO build system of MESA EOS
libraries = ['gfortran', 'eos', 'chem', 'interp_2d', 'interp_1d', 'num',
             'utils', 'alert', 'const', 'mtx', 'mesaklu', 'mesalapack',
             'mesablas']
lib_dirs = [mesa_lib]
include_dirs = [npy_include_dir, mesa_inc]

# list the object files: wrapper.o holds the wrapping code which depends on
# original.o code...note this is the filename, not the module name
objects = ["setup_mesa_eos.o", "shutdown_mesa_eos.o",
           "MESA_eos_from_MAESTRO.o", "eos_stuff.o", "eos_utils.o",
           "wrapper.o"]

ext_modules = [Extension(pyx_name, [pyx_file],
                         include_dirs=include_dirs,
                         libraries=libraries,
                         library_dirs=lib_dirs,
                         extra_objects=objects)]

setup(name="F90 Wrapping", cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules)

