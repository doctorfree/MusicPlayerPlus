#!/usr/bin/env python3
#
# Animate a zoom bounce on a Julia Set
# Written by Ronald Record <ronaldrecord@gmail.com>
#
# Usage: julia.py [-c int] [-x float -y float]
# Where -c int specifies how many times to cycle the zoom/bounce before exit
#              without any -c argument the cycling continues until 'q' press
#       -x float -y float specify the real coordinates of the complex number
#                     used as starting point for the Julia Set calculation.
#                     Default value for this is [-0.8, 0.156]
#
# Interesting zooms occur with these example invocations:
#     julia.py -x 0.687 -y 0.312
#     julia.py -x 0.6 -y 0.55
#     julia.py -x 0.0 -y 0.8

from asciimatics.effects import Julia
from asciimatics.scene import Scene
from asciimatics.screen import Screen
from asciimatics.exceptions import ResizeScreenError
import sys
import argparse


def julia(screen, c):
    scenes = []
    effects = [
        Julia(screen, c, stop_frame=numcycles),
    ]
    scenes.append(Scene(effects, numcycles))

    if cycle is None:
        screen.play(scenes, stop_on_resize=True)
    else:
        screen.play(scenes, stop_on_resize=True, repeat=False)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--cycle", help="number of times to cycle back through effects")
    parser.add_argument("-x", "--xvalue", help="starting x value of 'c' for the Julia set")
    parser.add_argument("-y", "--yvalue", help="starting y value of 'c' for the Julia set")
    args = parser.parse_args()

    if args.cycle:
        numcycles = int(args.cycle)
        cycle = True
    else:
        numcycles = 0
        cycle = None

    c = None
    if args.xvalue:
      if args.yvalue:
        c = [float(args.xvalue.replace('\U00002013', '-')),
             float(args.yvalue.replace('\U00002013', '-'))]

    while True:
        try:
            Screen.wrapper(julia, arguments=[c])
            sys.exit(0)
        except ResizeScreenError:
            pass
