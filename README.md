# smart-scratch

Smart major-mode specific scratch buffers for GNU Emacs.

Current mode-specific scratch buffer extensions didn't really do what I wanted
them to do, so I wrote my own.

Adds a `smart-scratch-toggle` interactive function to toggle between a scratch
buffer for the current buffer's major mode and the current buffer.

Fancy features:

- Major-mode hierachy aware. For example, uses `lisp-interaction-mode` for all
  Emacs Lisp modes.

- Respects `initial-major-mode` and takes into account the state Emacs' default
  `*scratch*` buffer (and if you manually change the major-mode thereof).

- Remembers the source buffer you toggle from for each major-mode's scratch buffer
  so you don't _toggle back_ to random buffers, awkwardly.

## Install

    $ cd ~/.emacs.d/vendor
    $ git clone git://github.com/endofunky/smart-scratch.git

In your emacs config:

    (add-to-list 'load-path "~/.emacs.d/vendor/smart-scratch")
    (require 'smart-scratch)

## Usage

Run with `M-x smart-scratch-toggle`.

## License

Copyright 2017 (c) Tobias Svensson <tob@tobiassvensson.co.uk>

Released under the same license as GNU Emacs:

    GNU Emacs is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    GNU Emacs is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
