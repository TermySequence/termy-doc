.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termyctl
========

.. highlight:: none

Name
----

:program:`termyctl` - Set or clear TermySequence session attributes

Synopsis
--------

:program:`termyctl` [\ *options*\ ] [\ *command*\ ] [\ *arg*\ ]

Description
-----------

:program:`termyctl` is used to set and clear various useful attributes from within a *TermySequence* terminal session. The effects of setting these attributes will vary depending on the specific client program being used.

Commands
--------

**set-icon** *name*
   Set an icon name for the terminal session. If the client supports this attribute, the corresponding icon will be displayed with the terminal thumbnail or otherwise associated with the terminal.

**clear-icon**
   Unset the custom icon name for the terminal session, which will cause the client to revert to its default behavior for the terminal icon.  Note that setting the empty string is the same as clearing the icon; to force display of no icon in :doc:`qtermy <../man/gui>`\ (1), set the name "none".

**set-badge** *format*
   Set the badge format for the terminal session. This is a text string which may optionally contain attribute names of the form "\\(name)", which will be expanded to the attribute's value dynamically. Quote the text if it contains spaces. Setting the empty string indicates that no badge should be displayed.

   The *TermySequence* protocol specifies many useful attributes that can be displayed in terminal badges, and custom attributes can be set as well. The client may have a means of inspecting the available attributes, such as the "View Terminal Information" action within :doc:`qtermy <../man/gui>`\ (1).

**clear-badge**
   Unset the custom badge for the terminal session, which will cause the client to revert to its default behavior for the terminal badge.

**set-layout** *spec*
   This is a :doc:`qtermy <../man/gui>`\ (1)-specific option which sets the layout of the terminal viewport and its supporting widgets. The argument is a comma-separated list of numbers (without spaces) where each number refers to a specific widget:

   | 0) the terminal viewport itself
   | 1) marks widget
   | 2) plain scroll bar
   | 3) minimap widget
   | 4) timing widget

   The letter "s" may be placed between numbers in the list to request a separator line. A minus sign in front of a number will place the widget at the given location but hide it. Example: "-4,1,s,0,-2,3"

**clear-layout**
   Unset the custom layout for the terminal session, which will cause the client to revert to the default layout.

**set-fills** *spec*
   This is a :doc:`qtermy <../man/gui>`\ (1)-specific option which sets column fills (vertical lines) at specific column positions in the terminal viewport. The argument is a comma-separated list of fill definitions, each taking the form "<\ *column*\ >[:<\ *color*\ >]" where *column* is the column number at which to place the fill, and *color* is a 256-color palette index in the range 0 to 255. If color is omitted, the terminal foreground color is used. Example: "78,80:9"

**clear-fills**
   Unset custom column fills for the terminal session, which will cause the client to revert to the default fills.

Options
-------

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

Notes
-----

When using :doc:`qtermy <../man/gui>`\ (1) it is possible to manage these settings strictly on the client side using settings profiles. This script is provided for completeness.

:program:`termyctl` is a wrapper script that uses :doc:`termy-query <../man/query>`\ (1). to set the session attributes. The escape sequences used are specific to *TermySequence*\ . Running this script under other terminal emulators will have undefined results.

See Also
--------

:doc:`termy-server <../man/server>`\ (1), :doc:`qtermy <../man/gui>`\ (1)
