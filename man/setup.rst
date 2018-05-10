.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-systemd-setup
===================

.. highlight:: none

Name
----

:program:`termy-systemd-setup` - Enable user systemd services for :doc:`termy-server <../man/server>`\ (1)

Synopsis
--------

:program:`termy-systemd-setup` [\ *options*\ ]

Description
-----------

:program:`termy-systemd-setup` is an interactive shell script that essentially runs the following commands::

   systemctl --user enable termy-server.socket
   systemctl --user start termy-server.socket
   loginctl enable-linger
   kill `head -1 /tmp/termy-server$UID/pid`

This ensures that the user's persistent instance of :doc:`termy-server <../man/server>`\ (1) will keep running even when the user is logged out. This is only applicable on Linux systems that run systemd user session managers with login sessions controlled by :manpage:`systemd-logind(8)`. On such systems, this script (or the above commands) should be run for each user that will be using :doc:`termy-server <../man/server>`\ (1).

.. important:: These commands, particularly loginctl, must be run from within a fully formed systemd login session. Shells launched via :manpage:`sudo(8)` or :manpage:`su(1)` do not always meet this requirement, nor do terminals run under an existing persistent user server (transient session servers, however, are OK). When in doubt, use ssh or machinectl login to log in as the user and run the script from there.

Options
-------

**--server-pid** *pid*
   The pid of the user's existing persistent user server, which will be killed. If not provided, the script will read the pid from :file:`/tmp/termy-server{$UID}/pid` if present. Otherwise, no processes will be killed.

**--enable-linger**
   Just run loginctl enable-linger. The script will check for the :envvar:`XDG_SESSION_ID` variable as an indicator of whether a fully formed systemd login session exists.

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

See Also
--------

:doc:`termy-server <../man/server>`\ (1), :manpage:`systemctl(1)`, :manpage:`loginctl(1)`, :manpage:`systemd-logind(8)`, :manpage:`systemd(1)`
