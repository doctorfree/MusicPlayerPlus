#!/usr/bin/env python3

from asciimatics.effects import Julia
from asciimatics.scene import Scene
from asciimatics.screen import Screen
from asciimatics.exceptions import ResizeScreenError
import sys
import argparse


def demo(screen):
    scenes = []
    effects = [
        Julia(screen, stop_frame=numcycles),
    ]
    scenes.append(Scene(effects, numcycles))

    if cycle is None:
        screen.play(scenes, stop_on_resize=True)
    else:
        screen.play(scenes, stop_on_resize=True, repeat=False)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--cycle", help="number of times to cycle back through effects")
    args = parser.parse_args()

    if args.cycle:
        numcycles = int(args.cycle)
        cycle = True
    else:
        numcycles = 0
        cycle = None

    while True:
        try:
            Screen.wrapper(demo)
            sys.exit(0)
        except ResizeScreenError:
            pass
