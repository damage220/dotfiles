from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    cyan, magenta, red, white, default,
    normal, bold, reverse,
    default_colors,
)

class Solarized(ColorScheme):
    progress_bar_color = 4

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors
        elif context.in_browser:
            fg = 12
            attr = normal

            if context.directory:
                fg = 4
            if context.media:
                fg = 2
            if context.executable and not context.directory:
                fg = 3

            if context.selected:
                attr |= bold | reverse
            if context.cut:
                fg = 11
                attr |= bold
            if context.copied:
                fg = 3
                attr |= bold

            if context.empty:
                fg = 11
            if context.error:
                attr = reverse
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 1

            if context.inactive_pane:
                fg = 11
        elif context.in_titlebar:
            if context.hostname:
                fg = 1 if context.bad else 12
            elif context.directory or context.link:
                fg = 4
            if context.tab:
                fg = 4 if context.good else 12
        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 12
                elif context.bad:
                    fg = 1
            if context.message:
                if context.bad:
                    attr |= reverse
            if context.loaded:
                fg = 8
                bg = self.progress_bar_color
                attr |= bold

        if context.marked:
            attr |= bold
            bg = 0

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 2

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        return fg, bg, attr
