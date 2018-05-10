.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

qtermy-pipe
===========

.. highlight:: none

Name
----

:program:`qtermy-pipe` - send commands and pipe requests to a running :doc:`qtermy <../man/gui>` instance

Synopsis
--------

**qtermy-pipe** [\ *command*\ ] [\ *arg...*\ ]

Description
-----------

:program:`qtermy-pipe` is a command-line interface to certain features of the :doc:`qtermy <../man/gui>`\ (1) graphical multiplexing terminal emulator client. The primary use of :program:`qtermy-pipe` is to pipe input or output from a remote server, sending the data stream over the *TermySequence* protocol. A secondary use of :program:`qtermy-pipe` is performing application actions programmatically. See `Examples`_ below.

For comprehensive documentation of the many features offered by :doc:`qtermy <../man/gui>`\ , refer to the support pages at https://termysequence.io/doc/

Commands
--------

**to** *user\@host*
   Pipe standard input to a named pipe on the remote server, which must be connected within :doc:`qtermy <../man/gui>`\ . The **termy-server**\ (1) instance on the remote server will create a named pipe (fifo) which may be used as standard input to a remote command. The path to the fifo will be printed on standard error (keep in mind that this path is on the remote server). A "Pipe To" task will be created within :doc:`qtermy <../man/gui>` which may be used to track the status of the upload.

**from** *user\@host*
   Pipe standard output from a named pipe on the remote server. Analogous to the *to* command, except with data flowing in the opposite direction. A "Pipe From" task will be created within :doc:`qtermy <../man/gui>` which may be used to track the status of the download.

**list-servers**
   List the currently connected servers.

**invoke** *action...*
   Run the given application action within the :doc:`qtermy <../man/gui>` instance. The format is identical to the "Perform action" key binding, including arguments separated by vertical bar (\|) characters if needed. Quote the action string if necessary. More than one action string may be given; multiple actions will be run sequentially.

Options
-------

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

Files
-----

:file:`{$XDG_RUNTIME_DIR}/termy-server/`

Location where :doc:`termy-server <../man/server>` creates named pipes.

:file:`{$XDG_RUNTIME_DIR}/qtermy/`

Location of the socket file used by :doc:`qtermy <../man/gui>` to accept connections from :program:`qtermy-pipe` (see `Notes`_ below).

Examples
--------

**Pipe** Example
   To compute a local :manpage:`md5sum(1)` of the contents of a file on the connected remote server *user\@example.com*\ : first, execute the local pipe command::

      $ qtermy-pipe from user@example.com | md5sum
      Reading from /run/user/1000/termy-server/p1 on server user@example.com

   Second, on the remote server, redirect the desired file into the named pipe::

      $ cat foo.dat | /run/user/1000/termy-server/p1

**Invoke** Example
   To create a new terminal programmatically, use::

      $ qtermy-pipe invoke NewTerminal

   Or, to create two new terminals using settings profiles Foo and Bar, use::

      $ qtermy-pipe invoke 'NewTerminal|Foo' 'NewTerminal|Bar'

Notes
-----

If more than one instance of :doc:`qtermy <../man/gui>`\ (1) is run by the user, it is unspecified which instance :program:`qtermy-pipe` will connect to.

See Also
--------

:doc:`qtermy <../man/gui>`\ (1), :doc:`termy-server <../man/server>`\ (1), :doc:`termy-connect <../man/connect>`\ (1), :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termyctl <../man/ctl>`\ (1)
