.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Server Messages
===============

.. contents::
   :local:

General
-------

.. termy:protocol:: GET_SERVER_TIME S(1000) serverid clientid

   Request server time. Use this for basic echo testing.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: GET_SERVER_TIME_RESPONSE C(1000) clientid serverid time8

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`time8` (8): The server time in milliseconds since the Epoch.

.. termy:protocol:: REMOVE_SERVER S(1005) serverid code

   Sent to the client when a server other than the immediate server has disconnected. Removal announcements for all downstream terminals and servers should be sent prior to receiving this message, but clients must gracefully handle a bad ordering.

    * :termy:param:`serverid` (16): The :term:`server identifier`.
    * :termy:param:`code` (4): An :ref:`error code <protocol-errors>` describing the reason for the disconnect.

.. termy:protocol:: CREATE_TERM S(1006) serverid clientid termid width height key+value...

   Create a terminal.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`termid` (16): The :term:`terminal identifier` for the new terminal. Randomly generating this is recommended.
    * :termy:param:`width` (4): The width of the new terminal in character cells.
    * :termy:param:`height` (4): The height of the new terminal in character cells.
    * :termy:param:`key+value`: The new terminal's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: MONITOR_INPUT S(1023) serverid clientid data

   Send input to the :doc:`monitor process <../man/monitor>`.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`data`: The UTF-8 string to write. A newline will be appended by the server before writing.

Attributes
----------

.. termy:protocol:: GET_SERVER_ATTRIBUTES S(1001) serverid clientid

   Request server attributes. Attribute names starting with underscore (_) will not be included in the response.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: SERVER_ATTRIBUTES_RESPONSE C(1001) clientid serverid key+value...

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`key+value`: The server's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: GET_SERVER_ATTRIBUTE S(1002) serverid clientid key...

   Request one or more server attributes. A separate response will be sent for each requested attribute.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key`: The requested attribute name(s) as NUL-terminated UTF-8 strings.

.. termy:protocol:: SERVER_ATTRIBUTE_CHANGED S(1002) serverid key[+value]

   Sent to the client when a server attribute has changed.

    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`key[+value]`: The attribute name and optional value as NUL-terminated UTF-8 strings. If the value is absent, the attribute was removed.

.. termy:protocol:: SERVER_ATTRIBUTE_RESPONSE C(1002) clientid serverid key[+value]

   As :termy:protocol:`SERVER_ATTRIBUTE_CHANGED`, but includes the identifier of the requesting client.

.. termy:protocol:: SET_SERVER_ATTRIBUTE S(1003) serverid clientid key+value...

   Set one or more server attributes. This will cause :termy:protocol:`SERVER_ATTRIBUTE_CHANGED` messages to be sent to all clients unless the attribute(s) did not change.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key+value`: The attribute names and new values as NUL-terminated UTF-8 strings.

.. termy:protocol:: REMOVE_SERVER_ATTRIBUTE S(1004) serverid clientid key...

   Remove one or more server attributes. This will cause :termy:protocol:`SERVER_ATTRIBUTE_CHANGED` messages to be sent to all clients unless the attribute(s) did not change.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key`: The attribute name(s) to remove as NUL-terminated UTF-8 strings.

Task Management
---------------

.. termy:protocol:: TASK_INPUT S(1008) serverid clientid taskid data

   Send input data for a :term:`task`.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`data`: The input data.

.. termy:protocol:: TASK_OUTPUT C(1008) clientid serverid taskid data

   Output data for a :term:`task`.

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`data`: The output data.

.. termy:protocol:: TASK_QUESTION C(1009) clientid serverid taskid question

   Sent to the client when a :term:`task` requires user input. The client should reply with an :termy:protocol:`answer <TASK_ANSWER>`.

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`question` (4): The :ref:`question code <protocol-taskquestion>`.

.. termy:protocol:: TASK_ANSWER S(1009) serverid clientid taskid answer

   The answer to a :termy:protocol:`TASK_QUESTION`.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`answer` (4): The :ref:`answer code <protocol-taskconfig>`.

.. termy:protocol:: CANCEL_TASK S(1010) serverid clientid taskid

   Cancel a :term:`task`.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.

File Tasks
----------

.. termy:protocol:: UPLOAD_FILE S(1011) serverid clientid taskid chunksize mode config name

    Create a :term:`task` to upload a file.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`mode` (4): The permissions for the new file.
    * :termy:param:`config` (4): A :ref:`code <protocol-taskconfig>` specifying how to handle an existing file with the same name. The high-order bit, if set, indicates that directories leading up to the file should be created if necessary.
    * :termy:param:`name`: The absolute path where the file should be created on the server.

.. termy:protocol:: DOWNLOAD_FILE S(1012) serverid clientid taskid chunksize windowsize name

    Create a :term:`task` to download a file.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.
    * :termy:param:`name`: The absolute path to the file on the server.

.. termy:protocol:: DELETE_FILE S(1013) serverid clientid taskid config name

    Create a :term:`task` to delete a file or folder (recursively).

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`config` (4): A :ref:`code <protocol-taskconfig>` specifying how to confirm the deletion.
    * :termy:param:`name`: The absolute path to the file on the server.

.. termy:protocol:: RENAME_FILE S(1014) serverid clientid taskid config name dest

    Create a :term:`task` to rename a file or folder.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`config` (4): A :ref:`code <protocol-taskconfig>` specifying how to handle an existing file with the same name.
    * :termy:param:`name`: The absolute path to the existing file on the server.
    * :termy:param:`dest`: The absolute path to the new name on the server.

Pipe Tasks
----------

.. termy:protocol:: UPLOAD_PIPE S(1015) serverid clientid taskid chunksize mode

    Create a :term:`task` to pipe data to a FIFO on the server.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`mode` (4): The permissions for the FIFO.

.. termy:protocol:: DOWNLOAD_PIPE S(1016) serverid clientid taskid chunksize windowsize mode

    Create a :term:`task` to pipe data from a FIFO on the server.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.
    * :termy:param:`mode` (4): The permissions for the FIFO.

.. termy:protocol:: CONNECTING_PORTFWD S(1017) serverid clientid taskid chunksize windowsize type addr

    Create a port forwarding :term:`task` connecting out from the server.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.
    * :termy:param:`type` (4): The type of socket (TCP or Unix-domain).
    * :termy:param:`addr`: The socket address to connect to.

.. termy:protocol:: LISTENING_PORTFWD S(1018) serverid clientid taskid chunksize windowsize type addr

    Create a port forwarding :term:`task` listening on the server.

    TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.
    * :termy:param:`type` (4): The type of socket (TCP or Unix-domain).
    * :termy:param:`addr`: The socket address to listen on.

Execute Tasks
-------------

.. termy:protocol:: RUN_COMMAND S(1019) serverid clientid taskid chunksize windowsize key+value...

   Create a :term:`task` to execute a command.

   TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.
    * :termy:param:`key+value`: Task configuration as NUL-terminated UTF-8 strings.

.. termy:protocol:: RUN_CONNECT S(1020) serverid clientid taskid key+value...

   Create a :term:`task` to establish a new :term:`connection` by executing a command.

   TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`key+value`: Task configuration as NUL-terminated UTF-8 strings.

Mount Tasks
-----------

.. termy:protocol:: MOUNT_FILE_READWRITE S(1021) serverid clientid taskid key+value...

   Create a :term:`task` to mount a file.

   TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`key+value`: Task configuration as NUL-terminated UTF-8 strings.

.. termy:protocol:: MOUNT_FILE_READONLY S(1022) serverid clientid taskid key+value...

   Create a :term:`task` to mount a file or directory tree read-only.

   TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`key+value`: Task configuration as NUL-terminated UTF-8 strings.
