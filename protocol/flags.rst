.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Flags
=====

.. contents::
   :local:

.. _protocol-termflags:

Terminal Flags
--------------

A 64-bit flags enumeration. Bits 24-32 and 56-64 are reserved for client use.

Refer to the TermFlag enumeration in lib/protocol.h for the values.

.. _protocol-mouseflags:

Mouse Event Flags
-----------------

A 32-bit flags enumeration. Bits 1-8 are reserved for the index of the mouse button (a number, not flags):

 * 0: none
 * 1: left
 * 2: middle
 * 3: right
 * 4: wheel up
 * 5: wheel down

Refer to the MouseEventFlag enumeration in lib/protocol.h for the values.

.. _protocol-cellflags:

Cell Flags
----------

A 32-bit flags enumeration.

Refer to the MouseEventFlag enumeration in lib/protocol.h for the values.

.. _protocol-lineflags:

Line Flags
----------

A 32-bit flags enumeration. Bits 1-8 are reserved for the buffer identifier. Bits 17-32 are reserved for client use.

Refer to the LineFlag enumeration in lib/protocol.h for the values.

.. _protocol-cursorflags:

Cursor Flags
------------

A 32-bit flags enumeration. Bits 1-8 are reserved for the cursor sub-position.

Refer to the CursorFlag enumeration in lib/protocol.h for the values.

.. _protocol-regionflags:

Region Flags
------------

A 32-bit flags enumeration. Bits 17-32 are reserved for client use.

Refer to the RegionFlag enumeration in lib/protocol.h for the values.

.. _protocol-clientflags:

Client Flags
------------

A 32-bit flags enumeration. Currently only one value is defined:

 * TakeOwnership (1): The client will be assigned ownership of any terminals which lack an owner. Leave this flag unset when implementing passive clients which only watch terminal contents.
