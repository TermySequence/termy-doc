.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-query
===========

.. highlight:: none

Name
----

:program:`termy-query` - Get, set, and clear TermySequence attributes

Synopsis
--------

| :program:`termy-query` get [\ *varname*\ ]
| :program:`termy-query` set [\ *varname*\ ] [\ *value*\ ]
| :program:`termy-query` clear [\ *varname*\ ]

Description
-----------

:program:`termy-query` is used to get, set, and clear terminal attributes from within a *TermySequence* terminal session. This is a low-level tool intended to be used from wrapper scripts such as :doc:`termyctl <../man/ctl>`\ (1).

Commands
--------

**get** *varname*
   Retrieve the value of an attribute, which will be printed on standard output.

**set** *varname* *value*
   Set an attribute to a given value.

**clear** *varname*
   Remove an attribute.

Options
-------

**--help**
   Print basic help

**--version**
   Print version information

**--man**
   Attempt to show this man page

**--about**
   Print license information and disclaimer of warranty

Exit Status
-----------

| 0: Success.
| 1: Failed to parse command line arguments.
| 2: Attribute is not set to any value (get only).
| 3: Error communicating with the server.
| 4: Error writing to standard output.

Notes
-----

Attribute values may contain arbitrary UTF-8, including control characters. Proceed with caution when reading and printing variable values.

Only certain attributes can be set or cleared from within terminals. Attempting to set or clear other attributes will have no effect.

:program:`termy-query` uses escape sequences that are specific to *TermySequence*\ . Running under other terminal emulators will have undefined results.

:program:`termy-query` is an alias for :doc:`termy-server <../man/server>`\ ; both functions are implemented by the same binary.

See Also
--------

:doc:`termyctl <../man/ctl>`\ (1), :doc:`termy-server <../man/server>`\ (1)
