.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Implementation Strategy
=======================

This section describes implementation strategies for clients.

When getting started with implementing a client, it's beneficial to print out a summary of each message that arrives from the server in order to get a feel the order in which things happen. Of course, this requires the message parser and connection code to be written first.

.. contents::
   :local:

Guidelines
----------

Write clients to be forward-compatible. Future minor versions of the protocol might add fields or flags to messages. Gracefully handle message lengths that are larger than expected. Always initialize unused bits to zero in outgoing messages, particularly in flags fields.

Write clients to be robust against buggy and/or malicious servers, especially when using a language that is not memory-safe. Bounds-check all messages and fields. Don't assume any particular message ordering.

.. _strategy-minimal:

Minimal Client
--------------

A minimal client (no scrollback, no cursor, plain text only) can be implemented as follows:

 * Connect to the server.
 * Perform the handshake and post-handshake message exchange.
 * Build a list of terminals from received :termy:protocol:`ANNOUNCE_TERM` and :termy:protocol:`REMOVE_TERM` messages.
 * Create new terminals by sending :termy:protocol:`CREATE_TERM` messages.
 * Send keyboard input to the terminal by sending :termy:protocol:`INPUT` messages.
 * Track the size of each terminal from the :termy:protocol:`SIZE_CHANGED` messages.
 * Track the size of each terminal's buffers from the :termy:protocol:`BUFFER_LENGTH` messages. The terminal screen is always positioned at the bottom of the buffer (highest-numbered rows).
 * Update the terminal screen based on the :termy:protocol:`ROW_CONTENT` messages. The cell range information in the messages can be ignored.
 * Track which buffer to display based on the :termy:protocol:`BUFFER_SWITCHED` messages.

Ignore all other messages. It should never be necessary to request content from the server; all screen rows should be pushed to the client asynchronously.

.. _strategy-scrollback:

Scrollback
----------

Because the server only pushes screen rows asynchronously, in order to implement scrollback in a client it is necessary to download scrollback rows from the server by sending :termy:protocol:`CONTENT_REQUEST` messages.

The easiest way to do this is to wait for the user to scroll up, then issue a request for the rows where the viewport is positioned and update the viewport when the responses arrive. This may cause screen flicker. To avoid the flicker, the client can proactively download scrollback rows in the background. This is the approach taken by :program:`qtermy`.

Note that a row above the terminal screen should always be downloaded, even if it was previously pushed to the client by a :termy:protocol:`ROW_CONTENT` message. The reason for this is that the pushed row text may be incomplete. This can occur if a boundary between :manpage:`read(2)` data occurs in the middle of a row, followed by additional scrolling that moves the row off the screen before the next updates can be pushed to the client.
