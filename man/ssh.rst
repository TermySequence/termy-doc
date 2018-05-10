.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-ssh
=========

.. highlight:: none

Name
----

:program:`termy-ssh`\ , :program:`termy-sudo`\ , :program:`termy-su` - Establish a connection between TermySequence servers using common helper programs

Synopsis
--------

| :program:`termy-ssh` [\ *ssh-options*\ ] [\ *user\@*\ ]\ *host*
| :program:`termy-sudo` [\ *su-options*\ ]
| :program:`termy-su` [\ *user*\ ]

Description
-----------

:program:`termy-ssh` is a wrapper around :doc:`termy-connect <../man/connect>`\ (1) for running :doc:`termy-server <../man/server>`\ (1) on a remote host using an instance of :manpage:`ssh(1)`. The *ssh-options*\ , *user*\ , and *host* are passed to :program:`ssh`\ , along with *-q* to disable printing of diagnostic messages, and *-T* to disable pseudoterminal allocation. The single command :program:`termy-server` is requested to be run on the remote host.

.. important:: Make sure that :doc:`termy-server <../man/server>`\ (1) is installed on the remote system and present on the remote user's :envvar:`PATH`. The shell run by :manpage:`ssh(1)` in single command mode is neither a login shell nor interactive, meaning that the remote user's :file:`.profile` and :file:`.bash_profile` will not be sourced. Furthermore, :envvar:`PATH` customizations applied in the remote user's :file:`.bashrc` must be made before any test for interactivity that causes the script to exit.

.. important:: Ensure that *ssh-options* does not contain any switches such as *-v* that interfere with the *-q* or *-T* switches added by :program:`termy-ssh`\ . Some situations might require direct use of :doc:`termy-connect <../man/connect>`\ (1) or a more complex wrapper script.

:program:`termy-sudo` is a wrapper around :doc:`termy-connect <../man/connect>`\ (1) for running :doc:`termy-server <../man/server>`\ (1) as a different user using :manpage:`sudo(8)`. The *sudo-options* are passed to :program:`sudo`\ , along with *-i* to start a login session, and *-S* to remove the need for a pseudoterminal. The command :program:`termy-server` is requested to be run as the new user.

:program:`termy-su` is a wrapper around :doc:`termy-connect <../man/connect>`\ (1) for running :doc:`termy-server <../man/server>`\ (1) as a different user using :manpage:`su(1)`. The optional *user* argument is passed to :program:`su`\ . The command :program:`termy-server` is requested to be run as the new user.

See Also
--------

:manpage:`ssh(1)`, :manpage:`sudo(8)`, :manpage:`su(1)`, :doc:`termy-connect <../man/connect>`\ (1), :doc:`termy-server <../man/server>`\ (1), :doc:`termy-monitor <../man/monitor>`\ (1)
