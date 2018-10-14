.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-setup
===========

.. highlight:: none

Name
----

:program:`termy-setup` - Perform setup actions for :doc:`termy-server <../man/server>`\ (1)

Synopsis
--------

:program:`termy-setup` [\ *options*\ ]

Description
-----------

For each user that will be running :doc:`termy-server <../man/server>`\ (1), use the :program:`termy-setup` shell script to perform recommended setup actions before running the server for the first time. Use one or more command line options to specify which setup tasks to perform.

Options
-------

**--systemd**
   Enable and start the :manpage:`systemd(1)`. systemd user service for :doc:`termy-server <../man/server>`\ (1). See `Systemd Setup`_ below.

**--bash**
   Enable iTerm2-compatible shell integration for :manpage:`bash(1)` login shells run under :doc:`termy-server <../man/server>`\ (1). Commands will be appended to the user's :file:`.profile` if it exists, otherwise to :file:`.bash_profile`.

**--zsh**
   Enable iTerm2-compatible shell integration for :manpage:`zsh(1)` shells run under :doc:`termy-server <../man/server>`\ (1). Commands will be appended to the user's :file:`.zshrc`.

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

Systemd Setup
-------------

The systemd setup action essentially runs the following commands::

   systemctl --user enable termy-server.socket
   systemctl --user start termy-server.socket
   loginctl enable-linger
   kill `head -1 /tmp/termy-server$UID/pid`

This ensures that the user's persistent instance of :doc:`termy-server <../man/server>`\ (1) will keep running even when the user is logged out. This is only applicable on Linux systems that run systemd user session managers with login sessions controlled by :manpage:`systemd-logind(8)`. On such systems, this script (or the above commands) should be run for each user that will be using :doc:`termy-server <../man/server>`\ (1).

.. important:: These commands, particularly loginctl, must be run from within a fully formed systemd login session. Shells launched via :manpage:`sudo(8)` or :manpage:`su(1)` do not always meet this requirement, nor do terminals run under an existing persistent user server (transient session servers, however, are OK). When in doubt, use ssh or machinectl login to log in as the user and run the script from there.

See Also
--------

:doc:`termy-server <../man/server>`\ (1), :manpage:`systemctl(1)`, :manpage:`loginctl(1)`, :manpage:`systemd-logind(8)`, :manpage:`systemd(1)`
