.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Troubleshooting: Failed to Connect
==================================

.. highlight:: none

A TermySequence connection can fail to complete for a number of reasons. If you are still stuck after trying the solutions below, see :doc:`support`.

.. contents::
   :local:

Server Not Installed
--------------------

A TermySequence connection requires :doc:`termy-server <server>` to be installed on the target machine and available to the target user. Fortunately, the server is written in C++ and has almost no dependencies, making it easy to :ref:`build and install <server-build>` on a variety of systems.

Before building the server from source, check if it is available via the target machine's package manager. Refer to :doc:`getting-started` for more information.

If it's not possible to install :doc:`termy-server <server>` on the target machine, TermySequence connections cannot be used to access it. Connect to the machine by running a normal SSH command, container entry command, etc. from a terminal.

Server Not on Path
------------------

:envvar:`PATH` problems are a common source of failed connections. The :doc:`connections <settings/connection>` created using :program:`qtermy`'s :doc:`New Connection Dialogs <dialogs/connect-dialogs>` have a :termy:connection:`Command <Connection/Command>` that simply runs "termy-server". This means that the :doc:`termy-server executable <man/server>` must be on the target user's :envvar:`PATH` on the target machine.

One way to fix the problem is to simply edit the offending connection from the :doc:`Manage Connections window <dialogs/manage-connections>` and change the :termy:connection:`Command <Connection/Command>` to specify an absolute path to the termy-server executable.

Another way to fix the problem is to ensure that the user's :envvar:`PATH` contains the directory where termy-server is installed. The way to accomplish this varies from shell to shell but usually involves setting the :envvar:`PATH` environment variable from startup script such as :file:`.bashrc`. Of course, this assumes that the program run from the connection's command either launches a shell or searches a configurable path itself. If this is not the case, it will be necessary to specify an absolute path to the termy-server executable or to create a wrapper script that runs termy-server and run the wrapper script from connection's command.

The behavior of :manpage:`ssh(1)` and :manpage:`bash(1)` with regard to :envvar:`PATH` merits further discussion. When SSH is given an explicit command to run, it does so from a non-interactive, non-login shell. In the case of bash, this means that the target user's :file:`.profile` and :file:`.bash_profile`, which are only sourced from login shells, will not be sourced. On the other hand, the target user's :file:`.bashrc`, which is normally sourced only from interactive shells, *will* be sourced (this is a special case for "network connections" only). Thus, :envvar:`PATH` should be set from :file:`.bashrc`, but there is another wrinkle: some startup scripts contain logic such as the following which checks for an interactive shell and exits the script early::

   # If not running interactively, don't do anything
   [ -z "$PS1" ] && return

:envvar:`PATH` modifications made from :file:`.bashrc` must happen *before* a check such as the one above in order to be honored by the (non-interactive) shell run from SSH. For more information about all of this, refer to `this fine StackOverflow question and answer <https://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive>`_. For shells other than bash, check the shell's documentation and take note of the above when setting :envvar:`PATH`. Some experimentation might be required.

Local Pseudoterminal
--------------------

Making a connection to any server except a :term:`local server` involves running termy-server as another user or on a remote machine. This in turn means that password prompts are likely to be displayed by the program run from the connection's command.

:program:`qtermy` will display prompts and other strings printed by the program in a :doc:`Connection Status dialog <dialogs/connection-status>`. User responses will be sent back to the program on its standard input.  However, some programs such as :manpage:`ssh(1)` refuse to read passwords from standard input unless it is a pseudoterminal. For such programs, make sure that the :termy:connection:`Connection/UseLocalPty` setting is enabled.

The :doc:`New Connection Dialogs <dialogs/connect-dialogs>` may not pick the correct :termy:connection:`UseLocalPty <Connection/UseLocalPty>` setting for your system. Edit the offending connection from the :doc:`Manage Connections window <dialogs/manage-connections>` to change the setting.

On the other hand, some programs may *not* work when run inside a local pseudoterminal. This is because they configure the pseudoterminal in "cooked" mode using :manpage:`termios(3)` settings, which in turn makes the communication channel unclean for 8-bit traffic (see the :ref:`next section <failed-connection-protocol-encoding>`). To fix this, disable the local pseudoterminal if possible, otherwise disable the :termy:connection:`UseRawProtocol <Connection/UseRawProtocol>` connection setting.

.. _failed-connection-protocol-encoding:

Protocol Encoding
-----------------

The 8-bit "raw" encoding of the :doc:`TermySequence protocol <protocol>` requires a communication channel that is fully 8-bit clean. Whether a communication channel is 8-bit clean or not depends on the program run from the connection's command. For connections that are not 8-bit clean, the 7-bit Base64 encoding of the TermySequence protocol must be used instead. It is slower but more robust against unclean communication channels.

The :termy:connection:`Connection/UseRawProtocol` setting determines which encoding is used on the connection. Refer to that setting's documentation and the discussion at the top of :doc:`settings/connection` for more information about communication channels and 8-bit cleanliness. Make sure that the connection's :termy:connection:`Command <Connection/Command>` includes any switches necessary to enable clean operation, if applicable.

The :doc:`New Connection Dialogs <dialogs/connect-dialogs>` may not pick the correct :termy:connection:`UseRawProtocol <Connection/UseRawProtocol>` setting for your system. Edit the offending connection from the :doc:`Manage Connections window <dialogs/manage-connections>` to change the setting.

It's important to note that even the 7-bit Base64 encoding of the TermySequence protocol can be disrupted by human-readable strings printed into the connection channel. This can occur as a result of program error messages or by system-wide notifications printed into a local or remote pseudoterminal. Use :manpage:`mesg(1)` to disable :manpage:`wall(1)` notifications to your terminals. Make sure that the connection's :termy:connection:`Command <Connection/Command>` includes any switches necessary to enable quiet operation, if applicable. Disable local and remote pseudoterminals entirely if possible.
