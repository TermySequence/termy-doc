.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-monitor
=============

.. highlight:: none

Name
----

:program:`termy-monitor` - TermySequence information monitor

Synopsis
--------

:program:`termy-monitor` [\ *--initial*\ \|\ *--monitor*\ ]

Description
-----------

:program:`termy-monitor` is a utility program executed by :doc:`termy-server <../man/server>`\ (1) to monitor the local system for useful information to report to terminal clients. This includes the hostname, kernel version, time zone, and primary IP address of the system, but can consist of any number of arbitrary single-line UTF-8 key-value pairs. Run :program:`termy-monitor` from a shell prompt to see what information is reported.

:program:`termy-monitor` has two modes of operation. When run with the --initial option, the program should print lines of the form ``key=value`` on standard output and then exit immediately. When run with no arguments, the program should do the same thing, but may keep running until receipt of *SIGTERM* or until its standard input is closed. The intent is for the program to print an initial set of values on startup in the first mode, then run continuously in the second mode, printing key-value pairs in response to system changes.

Each :doc:`termy-server <../man/server>`\ (1) instance forks its own instances of :program:`termy-monitor` as necessary. In addition, two customizable scripts, *monitor-script* and *attr-script* can be used to override or replace :program:`termy-monitor` entirely, see `Files`_ below. On receipt of *SIGUSR1*\ , :doc:`termy-server <../man/server>`\ (1) restarts the monitor program.

It is possible for terminal clients to send commands to the monitor program, which will be written to its standard input, followed by a newline. An advanced monitor program may support commands telling it to report certain data. For example, the default :program:`termy-monitor` implementation will respond to the command "loadavg" by reporting the system load average every ten seconds for the next half hour.

Options
-------

**--initial**
   Print a set of initial key-value pairs immediately and then exit.

**--monitor**
   Run continuously, printing key-value pairs as changes occur, until standard input is closed or *SIGTERM* is received. This is the default behavior.

**--help**
   Print basic help

**--version**
   Print version information

Files
-----

| :file:`{$XDG_CONFIG_HOME}/termy-server/attr-script`
| :file:`/etc/termy-server/attr-script`
| :file:`/usr/lib/termy-server/attr-script`

Programs executed by :doc:`termy-server <../man/server>`\ (1) to set system-specific UTF-8 key-value pairs reported to clients. Only the first script found using the order shown is executed. The program should print lines of the form ``key=value`` on standard output and must exit quickly. Values output by the program override the values printed by termy-monitor --initial. These scripts are optional and are not required to be present.

| :file:`{$XDG_CONFIG_HOME}/termy-server/monitor-script`
| :file:`/etc/termy-server/monitor-script`
| :file:`/usr/lib/termy-server/monitor-script`

Programs executed by :doc:`termy-server <../man/server>`\ (1) to set system-specific UTF-8 key-value pairs reported to clients. The program should print lines of the form ``key=value`` on standard out and may run as long as necessary, however it must exit on receipt of *SIGTERM* or when its standard input is closed.  Only the first script found using the order shown is executed, and if a script is found, :program:`termy-monitor` is not executed. These scripts are optional and are not required to be present.

Notes
-----

The default :program:`termy-monitor` implementation obtains attributes from the files :manpage:`os-release(5)` and :manpage:`machine-info(5)` and from calls to :manpage:`uname(3)` and :manpage:`getaddrinfo(3)`. On Linux, :manpage:`netlink(7)` is used to monitor for network address changes, and if sd-bus support was compiled in, the D-Bus interfaces *org.freedesktop.hostname1* and *org.freedesktop.timedate1* are used to monitor for hostname and timezone changes.

A small number of basic attributes, such as the UID, are set directly by :doc:`termy-server <../man/server>`\ (1) and cannot be changed from the monitor or from scripts.

See Also
--------

:doc:`termy-server <../man/server>`\ (1)
