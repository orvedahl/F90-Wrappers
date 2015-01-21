#!/usr/bin/env python
#
# test the setup.py & hello.pyx prescription
#
# R. Orvedahl 12-23-2014

from hello import hello_world

def test():

    print hello_world("World")
    print hello_world("Ryan")

test()
