.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Enumerations
============

.. contents::
   :local:

.. _protocol-errors:

Error Codes
-----------

These appear in the :termy:protocol:`DISCONNECT` message, in a negative :ref:`handshake reply <protocol-handshake>`, and elsewhere.

 * 0: Normal exit (terminals only, the :termy:profile:`Command <Emulator/Command>` exited).
 * 1: Closed (terminals only, the terminal was explicitly :termy:protocol:`closed <CLOSE_TERM>`).
 * 2: The server process is shutting down on a signal.
 * 3: The forwarding process (forked and executed by the client) is shutting down on a signal.
 * 4: A server error occurred.
 * 5: A forwarding error occurred.
 * 6: The client and server do not agree on protocol major version.
 * 7: Protocol parse error.
 * 8: Duplicate connection. The client and server are already connected.
 * 9: The connection closed unexpectedly.
 * 10: The server has reached its connection limit.
 * 11: The connection timed out because a :termy:protocol:`keepalive <KEEPALIVE>` was not received.

In :termy:protocol:`REMOVE_SERVER`, :termy:protocol:`REMOVE_TERM`, and :termy:protocol:`REMOVE_CONN` messages, the high order bit (32) can be set in the error code. This indicates that the disconnection occurred on an intermediate hop.

.. _protocol-regiontype:

Region Type
-----------

Region types above 255 are reserved for client use.

Only type 8 (User) may be specified in a :termy:protocol:`CREATE_REGION` message. Type 0 (Invalid) will be treated as 8.

 * 0: Invalid region type.
 * 1: Text selection. Reserved for client use.
 * 2: :term:`Job <job>`
 * 3: Prompt, a job sub-region
 * 4: Command, a job sub-region
 * 5: Output, a job sub-region
 * 6: Image, a content item within a terminal.
 * 7: Content, a dummy region which carries `hyperlink <https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda>`_ information.
 * 8: User, an :term:`annotation`.

.. _protocol-taskconfig:

Task Configuration
------------------

When creating tasks that might overwrite or remove files, specifies what to do when a file would be overwritten or removed. Also used in :termy:protocol:`TASK_ANSWER` messages.

 * 0: Fail the task.
 * 1: Overwrite without asking.
 * 2: Use a different file name to avoid overwriting.
 * 3: Ask for confirmation via a :termy:protocol:`TASK_QUESTION`.
 * 4: Ask for confirmation, but only when recursively removing the contents of a folder.

.. _protocol-taskquestion:

Task Question
-------------

Specifies the type of question that should be presented to the user:

 * 0: A file would be overwritten; the answer is one of overwrite, rename, or fail.
 * 1: A file would be overwritten; the answer is one of overwrite or fail.
 * 2: A file would be removed; the answer is one of overwrite (i.e. remove) or fail.
 * 3: A non-empty folder would be recursively removed; the answer is one of overwrite (i.e. remove) or fail.
