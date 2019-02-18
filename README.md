![preview](https://github.com/damage220/dotfiles/raw/master/img/vifm.png "Project tree view in vifm")

dotfiles
---

This repository is about my vision of working with the system. I tend to use
lean and fast applications, especially ones from
[suckless](https://suckless.org) community. Besides config files and color
schemes, you will find shell functions and vim plugins you might be interested
in. For screenshots go to [img/](img).

vim
---

Most plugins are lightweight (~100 lines or less) alternatives to well known
solutions. I was not satisfied with most of them for one reason or another, or
it was either the part of studying vim or something personal, e.g. color scheme,
tabline or statusline. I am using neovim and its config is just symlink to .vim.
There are no options in my rc file which are defaults in neovim. I do not even
have syntax highlighting in vim, keep it in mind.

#### plugin/*

- [commenter](.vim/plugin/commenter.vim) - not so smart commenter,
  but it fills all my needs. Requires &commentstring to be set.
- [is](.vim/plugin/is.vim) - helper functions for mappings.
- [session](.vim/plugin/session.vim) - simple session manager.
- [syntax](.vim/plugin/syntax.vim) - just prints highlight group
  name with set fg color.
- [time](.vim/plugin/time.vim) - the time nvim spent for a command.
- [wildcard](.vim/plugin/wildcard.vim) - highlights word under the
  cursor. Unlike default vim behavior, this will not jump to next word and in
  case there is no word under the cursor, it will highlight current symbol.
  Works in visual mode as well. Multi line selection is available.
- [tabline](.vim/plugin/tabline.vim),
  [statusline](.vim/plugin/statusline.vim),
  [ruler](.vim/plugin/ruler.vim) - no comments.

#### syntax/*

- [ml](.vim/syntax/ml.vim) - markup language I use for my note files. See
  [preview](https://github.com/damage220/dotfiles/raw/master/img/ml.png) on how
  to use.
- [manpage](.vim/syntax/manpage.vim) - I prefer to use vim as (man) pager
  because see no reason to configure another application for text related tasks.
  See [.bashrc](.bashrc) on how to use (/^man).

pass
---

Lightweight password manager I wrote, being inspired by
[pass](https://www.passwordstore.org). Does not provide many features, actually.
It only allows you to generate, store and retrieve passwords using openssl for
encryption. Use `ls` or `tree` to view all saved passwords. See
[.bashrc](.bashrc) for internals (/^pass and /^aes). There is also
implementation of pass with single function. I have not decided yet what I like
more :)

```bash
# to init new database, generate public/private keys
mkdir ~/.passwords
cd ~/.passwords
openssl genrsa -aes256 -out .dec 2048
openssl rsa -in .dec -pubout -out .enc

# generate password
pass

# store encrypted password
mkdir google
pass | aes > google/mail

# in case you already have one
echo $password | aes > google/mail

# retrieve password
pass google/mail
```

Password will be copied to primary selection, and will be cleared after first
request.

plain
---

GTK3 (only) simple [theme](.themes/plain) with white background and black text
([preview](https://github.com/damage220/dotfiles/raw/master/img/plain.png)). It
was not designed to and will not fit all GTK applications, just the ones I am
using. Looks bad in firefox, libreoffice and maybe other heavy applications.
Thunar, gcolor3, transmission-gtk, gnome-system-monitor and a few more were
tested. Since it has ~800 lines (comparing to ~4000 in regular theme), it is
probably a good template to start from if you want to create your own theme. The
following links helped me a lot:

- [Gnome manual](https://developer.gnome.org/gtk3/stable/theming.html)
- [GtkInspector](https://wiki.gnome.org/action/show/Projects/GTK/Inspector) in
  case you are running GNOME.
- [Parasite](https://chipx86.github.io/gtkparasite) for anything else.

desktop
---

[desktop](bin/desktop) is used to change dwm status line, change audio volume
and take screenshot of both root window and the one you selected.  Depends on
pulseaudio, imagemagick, and sox commands. Dependencies should be reviewed
later, I guess.

dwm
---

[dwm](https://dwm.suckless.org) was patched to be able to spawn default
application when the user switches to certain tag, in case there are no other
windows with that tag. I have also removed title in the status bar.

st
---

X cursor autohide patch was applied. I have also patched the terminal cursor to
match foreground/background color of the glyph the cursor is on. In other words,
when the cursor is on glyph with blue foreground, its background color becomes
blue and foreground color becomes glyph background color. It is a feature all
vte/qt based terminal emulators have, and I missed it a lot.

However, I am using termite currently because of [st](https://st.suckless.org)
drawing issues. When xfps is 60, I often see half screen redraw. When it is 40,
there is noticeable input lag when moving the cursor, also fast scrolling is not
smooth in vim. Setting higher value (120 or more) causes the cursor to flicker
sometimes. There are a lot of issues in the shell, too. For instance, ls a
directory on my HDD mounted through ntfs-3g start to jitter. Another example is
when a message is shown on the screen and right after it was replaced by another
message, like it is when deleting a file(s) in vifm. It causes a flicker on high
fps terminals such as xterm or urxvt. For that reason I am stuck with vte.
