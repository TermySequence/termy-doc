.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-server
============

.. highlight:: none

Name
----

:program:`termy-server` - TermySequence terminal multiplexer server

Synopsis
--------

:program:`termy-server` [\ *options*\ ]

Description
-----------

:program:`termy-server` is a multiplexing terminal emulator server implementing the *TermySequence* protocol. The emulator aims for `XTerm <http://invisible-island.net/xterm>`_ compatibility and supports modern terminal extensions such as 256-color text, mouse tracking, shell integration, and inline image display. In addition, the *TermySequence* protocol provides many features beyond standard terminal emulation, including flexible, efficient connectivity between servers, file monitoring and transfer, and multi-user terminal sharing and collaboration.

.. note:: :program:`termy-server` does not provide a text-based user interface in the manner of :manpage:`tmux(1)` or :manpage:`screen(1)`. A separate client program such as :doc:`qtermy <../man/gui>`\ (1) must be used to interact with the terminals themselves. The client program will typically launch the server automatically, making it unnecessary to run :program:`termy-server` directly in most cases. The intent is to separate the display and user interface components from the server, allowing a single server implementation to support a wide variety of clients, including clients such as :doc:`qtermy <../man/gui>`\ (1) specifically built for graphical windowing systems.

By default, :program:`termy-server` forks into the background, services standard input, and listens on a private, per-user Unix-domain socket for additional connections. If the socket is found to be already bound to another :program:`termy-server` instance, standard input will be forwarded to the existing server (using file descriptor passing when possible to avoid copying overhead). This makes it possible to run a server using e.g. :manpage:`ssh(1)` or :manpage:`sudo(8)`, gaining access to an existing multiplexer running on another host or as another user (see :doc:`termy-connect <../man/connect>`\ (1)). When forwarding standard input, the server changes its name to :program:`termy-forwrd`\ .

The command line options to :program:`termy-server` are used to control the lifecycle of the server. The default behavior described above can be modified to support private, standalone servers and socket-only daemon servers, including socket-activated servers suitable for use with :manpage:`systemd(1)` per-user instances. In all cases, the server exits on receipt of *SIGTERM*\ , *SIGINT*\ , or *SIGHUP*\ , or when all clients have disconnected and all terminals have closed.

Each :program:`termy-server` instance forks a companion process, :doc:`termy-monitor <../man/monitor>`\ (1), to collect system-specific information such as the hostname and IP address. Three additional customizable programs: *monitor-script*\ , *attr-script*\ , and *id-script* are also optionally read by :program:`termy-server` to override the default monitor process, provide additional system-specific information, and to determine the UUID of the local machine, respectively (see `Files`_ below). The system-specific information consists of arbitrary UTF-8 key-value pairs which can be used to customize terminal appearance within supporting *TermySequence* clients such as :doc:`qtermy <../man/gui>`\ (1).

Options
-------

**--nofork**
   Do not fork off a daemon process after startup. Note that even when forking, if standard input is being serviced, the parent process will remain running after the fork as long as standard input is active.

**--nostdin**
   Do not treat standard input as a client connection; accept client connections on the per-user local socket only. If another :program:`termy-server` instance is already listening on the socket, exit immediately.

**--activated**
   Listen on a local socket passed in via systemd socket activation. Implies --nofork, --nostdin, and --rundir :file:`{%t}/termy-server`. Won't work unless :program:`termy-server` was compiled with systemd support.

**--nolisten**
   Do not listen on a per-user local socket for additional client connections; service standard input only. Note that a connection will still be made to the socket to determine if another :program:`termy-server` instance is already running, and if so, standard input will be forwarded to it (see --standalone). Implies --nofork.

**--standalone**
   Service standard input without attempting to either listen on or connect to the per-user local socket. The server (and all terminals) will exit after standard input is closed. Implies --nofork.

**--client**
   Attempt to connect to an existing :program:`termy-server` instance over the per-user local socket and hand off standard input for servicing. If no existing instance is listening, exit immediately.

**-t,--rundir** *dir*
   Use runtime directory *dir*\ . It will be created if necessary, but its parent directory must exist. The specifiers %t and %U, if present, are expanded to $\ :envvar:`XDG_RUNTIME_DIR` and the user UID respectively. The default location is :file:`/tmp/termy-server{%U}` unless --activated is set, in which case this option is ignored. See `Notes`_ below for more information.

**--nogit**
   Disable monitoring for and reporting of git-specific file attributes and branch information. Only applicable if :program:`termy-server` was compiled with libgit2 support.

**--nofdpurge**
   Don't look for and close leaked file descriptors on startup. This is useful when debugging the server with tools such as valgrind.

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

**--about**
   Print license information and disclaimer of warranty

Files
-----

| :file:`{$XDG_CONFIG_HOME}/termy-server/id-script`
| :file:`/etc/termy-server/id-script`
| :file:`{$prefix}/lib/termy-server/id-script`

Programs executed by :program:`termy-server` to determine the UUID of the local machine. The program should print the UUID on standard output. By default, :file:`/etc/machine-id` is used; the *id-script* programs can be used as an override or replacement for that file. One or the other must be present; the *TermySequence* protocol requires each machine to have a unique identifier.

| :file:`{$XDG_CONFIG_HOME}/termy-server/attr-script`
| :file:`/etc/termy-server/attr-script`

Programs executed by :program:`termy-server` to set system-specific UTF-8 key-value pairs reported to clients. The program should print lines of the form key=value and must exit quickly. Refer to :doc:`termy-monitor <../man/monitor>`\ (1) for more information. These scripts are optional and are not required to be present.

| :file:`{$XDG_CONFIG_HOME}/termy-server/monitor-script`
| :file:`/etc/termy-server/monitor-script`

Programs executed by :program:`termy-server` to set system-specific UTF-8 key-value pairs reported to clients. The program should print lines of the form key=value and may run as long as necessary, however it must exit on receipt of *SIGTERM* or when its standard input is closed. By default :doc:`termy-monitor <../man/monitor>`\ (1) is used for this purpose; the *monitor-script* programs can be used as an override or replacement for this program. These scripts are optional and are not required to be present.

:program:`termy-server` runs the scripts on startup, and re-runs the attribute and monitor scripts on receipt of *SIGUSR1*\ .

Notes
-----

:program:`termy-server` is not intended to be run setuid or setgid, and will exit on startup if it detects this condition.

When attempting to connect to an existing server, the following locations are searched for the per-user local socket in this order:

| :file:`{%t}/termy-server` (only if systemd support is enabled)
| :file:`/run/user/{%U}/termy-server` (only if systemd support is enabled)
| :file:`/tmp/termy-server{%U}`

The specifiers %t and %U are expanded to $\ :envvar:`XDG_RUNTIME_DIR` and the user UID respectively.

When listening, the per-user local socket and PID file are placed under :file:`{%t}/termy-server` if --activated is set. Otherwise, :file:`/tmp/termy-server{%U}` is used unless changed using the --rundir option.

The server verifies that the runtime directory is owned by the user and has mode 0700. When making connections over the per-user local socket, the *SO_PASSCREDS* socket option is used to verify that the peer has the same UID. Refer to :manpage:`socket(7)` and :manpage:`unix(7)` for more information.

See Also
--------

:doc:`termy-monitor <../man/monitor>`\ (1), :doc:`termy-connect <../man/connect>`\ (1), :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termy-su <../man/su>`\ (1), :doc:`termy-sudo <../man/sudo>`\ (1)
