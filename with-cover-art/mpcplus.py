#!/usr/bin/env python3

from random import choice
from asciimatics.renderers import Plasma, Rainbow, FigletText
from asciimatics.scene import Scene
from asciimatics.screen import Screen
from asciimatics.effects import Print
from asciimatics.exceptions import ResizeScreenError
import sys
import argparse


class MusicPlayerPlusScene(Scene):

    def __init__(self, screen):
        self._screen = screen
        effects = [
            Print(screen,
                  Plasma(screen.height, screen.width, screen.colours),
                  0,
                  speed=1,
                  transparent=False),
        ]
        super(MusicPlayerPlusScene, self).__init__(effects, 200, clear=False)

    def _add_mpcplus_comment(self):
        msg = FigletText(choice(comments), font)
        self._effects.append(
            Print(self._screen,
                  msg,
                  (self._screen.height // 2) - 4,
                  x=(self._screen.width - msg.max_width) // 2 + 1,
                  colour=Screen.COLOUR_BLACK,
                  stop_frame=80,
                  speed=1))
        self._effects.append(
            Print(self._screen,
                  Rainbow(self._screen, msg),
                  (self._screen.height // 2) - 4,
                  x=(self._screen.width - msg.max_width) // 2,
                  colour=Screen.COLOUR_BLACK,
                  stop_frame=80,
                  speed=1))

    def reset(self, old_scene=None, screen=None):
        super(MusicPlayerPlusScene, self).reset(old_scene, screen)

        # Make sure that we only have the initial Effect
        # and add a new comment
        self._effects = [self._effects[0]]
        self._add_mpcplus_comment()


def mpplus(screen, cycle=None):
    if cycle is None:
        screen.play([MusicPlayerPlusScene(screen)], stop_on_resize=True)
    else:
        numplays=0
        while numplays < cycle:
            screen.play([MusicPlayerPlusScene(screen)], stop_on_resize=True, repeat=False)
            numplays += 1


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--cycle", help="number of times to cycle back through effects")
    parser.add_argument("-f", "--font", help="Font for FigletText, default 'banner3'")
    parser.add_argument('-t', "--text", action='store_true', help="Use alternate set of comments")
    args = parser.parse_args()
    cycle = 0

    if args.cycle:
        numcycles = int(args.cycle)
    else:
        numcycles = None
    if args.font:
        font = args.font
    else:
        font = "banner3"
    if args.text:
        comments = [
            "Far out!",
            "Groovy",
            "Excellent!",
            "Heavy",
            "Right on!",
            "Cool",
            "Epic",
            "Dude!"
        ]
    else:
        comments = [
            "Music Player",
            "Music Server",
            "Visualizer!",
            "Asciimatics",
            "Terminals!",
            "Cool",
            "Retro",
            "Album Art"
        ]

    while True:
        try:
            Screen.wrapper(mpplus, arguments=[numcycles])
            sys.exit(0)
        except ResizeScreenError:
            pass

