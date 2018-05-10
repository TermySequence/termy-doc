.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-connect
=============

.. highlight:: none

Name
----

:program:`termy-connect` - Establish connection between TermySequence servers

Synopsis
--------

:program:`termy-connect` [\ *options*\ ] [--] *command* [\ *arg...*\ ]

Description
-----------

:program:`termy-connect` is used to establish a connection between a local instance of :doc:`termy-server <../man/server>`\ (1) and an instance running on a different host, as a different user, or in a container. :program:`termy-connect` runs a helper program, specified by *command* and *args*\ , which must itself execute an instance of :doc:`termy-server <../man/server>`\ (1) on the desired remote system and make it accessible over standard input and standard output. After the handshake from the remote server is received, :program:`termy-connect` connects to the local :doc:`termy-server <../man/server>`\ (1) instance, sets up the link between the two servers, and exits. File descriptor passing is used to hand the helper process over to the local server, making it unnecessary for :program:`termy-connect` to forward traffic.

Separate convenience scripts are provided for commonly used helper programs: :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termy-sudo <../man/sudo>`\ (1), and :doc:`termy-su <../man/su>`\ (1). However, any program that can be used to execute an instance of  :doc:`termy-server <../man/server>`\ (1) in a remote environment can be used with :program:`termy-connect`\ . The convenience scripts are simple wrappers for :program:`termy-connect` and are documented further in their own man pages.

Until :program:`termy-connect` sees a valid *TermySequence* protocol handshake, any output produced by the helper program is relayed to standard output, and standard input is relayed to the helper program (with terminal echo disabled). This allows passwords, pass phrases, and other input to be collected from the user to establish the connection. Once the connection is established and :program:`termy-connect` has exited, the helper program will be detached from the terminal and running in the background.

However, a side effect of this feature is that any diagnostic messages printed by the helper program once the connection is established will interrupt the protocol stream. Furthermore, the default "raw" encoding of the *TermySequence* protocol cannot be used if the helper program interferes with the data stream, such as by providing escape sequences to interrupt the connection. Helper programs should be run with appropriate arguments to minimize the number of messages printed and to (ideally) make the data stream 8-bit safe. :program:`termy-connect` provides options to change the variant of the *TermySequence* protocol used as necessary to ensure a clean connection. See `Options`_ below for further details.

Options
-------

**-p,--pty**
   Run *command* in a pseudoterminal. Use this option if the helper program expects standard input to be connected to a terminal.

**-P,--nopty**
   Do not run *command* in a pseudoterminal (a socket or pipe is used). This is the default.

**-r,--raw**
   Use the 8-bit "raw" encoding of the *TermySequence* protocol. This encoding offers the best performance, but cannot be used if the data stream is not 8-bit safe. This is the default.

**-R,--noraw**
   Use the 7-bit "term" encoding of the *TermySequence* protocol. This encoding uses Base64 encoded terminal escape sequences, and will function in non-8-bit-safe data streams. It is also somewhat robust against occasional diagnostic messages being printed into the data stream.

**-k,--keepalive** *n*
   Enable keep-alive probes with a timeout of *n* seconds on the connection. A timeout of 0 disables keep-alive probes. The default timeout is 25 seconds and the minimum (nonzero) timeout is 5 seconds.

**-d,--dir** *dir*
   Start *command* in directory *dir*\ . Relative paths are interpreted relative to $\ :envvar:`HOME`. By default $\ :envvar:`HOME` is used.

**-0,--arg0** *arg*
   Use *arg* as the first argument vector element when running *command*\ .

**-n,--noosc**
   Do not issue *TermySequence* escape sequences if standard input is a tty. Use when running in a terminal emulator other than :doc:`termy-server <../man/server>`\ (1).

**-t,--runtime** *dir*
   Look for the per-user local socket in runtime directory *dir*\ .

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

**--about**
   Print license information and disclaimer of warranty

Notes
-----

:program:`termy-connect` is an alias for :doc:`termy-server <../man/server>`\ ; both functions are implemented by the same binary.

See Also
--------

:doc:`termy-server <../man/server>`\ (1), :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termy-su <../man/su>`\ (1), :doc:`termy-sudo <../man/sudo>`\ (1)
