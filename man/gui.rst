.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

qtermy
======

.. highlight:: none

Name
----

:program:`qtermy` - graphical TermySequence terminal multiplexer client

Synopsis
--------

:program:`qtermy` [\ *options*\ ]

Description
-----------

:program:`qtermy` is a graphical multiplexing terminal emulator client implementing the *TermySequence* protocol using the :doc:`termy-server <../man/server>`\ (1) multiplexing terminal emulator server. The emulator aims for `XTerm <http://invisible-island.net/xterm>`_ compatibility and supports modern terminal extensions such as 256-color text, mouse tracking, shell integration, and inline image display. In addition, the *TermySequence* protocol provides many features beyond standard terminal emulation, including flexible, efficient connectivity between servers, file monitoring and transfer, and multi-user terminal sharing and collaboration.

On startup, by default :program:`qtermy` will attempt to connect to an already running :doc:`termy-server <../man/server>`\ (1) instance using a per-user local socket. If the server is not already running, it will be launched. This server instance is intended to be independent of user login sessions in the manner of :manpage:`tmux(1)` or :manpage:`screen(1)` and is referred to as the "persistent user server." Note that terminals launched on this server will typically lack the environment variables needed to launch graphical programs on the desktop, such as :envvar:`DISPLAY`.

In addition, by default :program:`qtermy` will launch a second, private :doc:`termy-server <../man/server>`\ (1) instance as a direct child process. This server instance will exit along with :program:`qtermy`\ , but its terminals *will* have access to desktop environment variables such as :envvar:`DISPLAY`. This server instance is referred to as the "transient session server."

Connections to additional :doc:`termy-server <../man/server>`\ (1) instances running in containers, on other hosts, or as other users, including root, can be made from :program:`qtermy` or by using :doc:`termy-connect <../man/connect>`\ (1) or its wrapper scripts :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termy-su <../man/su>`\ (1), and others.

:program:`qtermy` listens on a per-user local socket of its own, which can be used to launch remote pipe commands and application actions programmatically using :doc:`qtermy-pipe <../man/pipe>`\ (1).

For comprehensive documentation of the many features offered by :program:`qtermy`\ , refer to the support pages at https://termysequence.io/doc/

Options
-------

**--noplugins**
   Disable loading all plugins.

**--nosysplugins**
   Disable loading plugins from :file:`{$prefix}/share/qtermy/plugins`.

**-t,--rundir** *dir*
   Look for the server's local socket under runtime directory *dir*\ . The specifiers %t and %U, if present, are expanded to the systemd runtime directory and the user UID respectively. Specifying this option is only necessary if :doc:`termy-server <../man/server>`\ (1) is launched with a custom runtime directory.

**--tmp**
   Store the application's per-user local socket and other runtime files under /tmp rather than $\ :envvar:`XDG_RUNTIME_DIR`. This is the default unless systemd support is compiled in.

**--nofdpurge**
   Don't look for and close leaked file descriptors on startup. This is useful when debugging the application with tools such as valgrind.

**--version**
   Print version information

**--man**
   Attempt to show this man page

Files
-----

:file:`{$XDG_CONFIG_HOME}/qtermy/`

Location where :program:`qtermy` stores its configuration files.

| :file:`{$XDG_DATA_HOME}/qtermy/`
| :file:`{$prefix}/share/qtermy/`

Locations where :program:`qtermy` looks for icons, images, plugins, and other data files.

| :file:`{$XDG_CONFIG_HOME}/qtermy/attr-script`
| :file:`/etc/qtermy/attr-script`
| :file:`{$prefix}/lib/qtermy/attr-script`

Programs executed by :program:`qtermy` to set client-specific UTF-8 key-value pairs reported to servers and visible to other clients. The program should print lines of the form ``key=value`` and must exit quickly. These scripts are optional and are not required to be present.

A small number of basic client attributes, such as the UID, are set directly by :program:`qtermy` and cannot be changed from scripts.

Notes
-----

When :manpage:`systemd(1)` is used to manage login sessions, certain administrative commands must be run to to allow the persistent user server to survive across user login sessions. Refer to :doc:`termy-setup <../man/setup>`\ (1) for more information.

:program:`qtermy` has the ability to perform remote file and directory mounts using :manpage:`fuse(8)`, but only if FUSE support was enabled at compile time, the FUSE runtime is present on the system, and the user has the necessary permissions to establish unprivileged FUSE mounts.

See Also
--------

:doc:`termy-server <../man/server>`\ (1), :doc:`termy-connect <../man/connect>`\ (1), :doc:`termy-ssh <../man/ssh>`\ (1), :doc:`termy-su <../man/su>`\ (1), :doc:`termy-sudo <../man/sudo>`\ (1), :doc:`qtermy-pipe <../man/pipe>`\ (1)
