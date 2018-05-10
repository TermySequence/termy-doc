.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Plain Messages
==============

.. termy:protocol:: HANDSHAKE_COMPLETE P(1)

   Sent by the server after receiving the client's affirmative :ref:`handshake reply <protocol-handshake>`. Do not send any messages to the server until this message is received. After receiving this, the client should :termy:protocol:`announce <ANNOUNCE_CLIENT>` itself. See :ref:`protocol-post`.

.. termy:protocol:: ANNOUNCE_SERVER P(2) serverid termid version hops nterms key+value...

   Sent by the server to notify the client of a newly connected server. This includes the server to which the client is directly connected (the "immediate server").

    * :termy:param:`serverid` (16): The :term:`server identifier`.
    * :termy:param:`peerid` (16): The object to which the server is connected. For the immediate server, this is the client's own identifier. For other servers, this is a terminal or :term:`connection` identifier.
    * :termy:param:`version` (4): The server's protocol minor version, as in the :ref:`handshake message <protocol-handshake>`.
    * :termy:param:`hops` (4): The number of hops (connections) separating the server from the client. For the immediate server, this is zero.
    * :termy:param:`nterms` (4): The number of terminals on the server. An :termy:protocol:`announcement <ANNOUNCE_TERM>` will follow for each terminal (most of the time; there is a race condition where a terminal can be closed). See :ref:`protocol-post` for more information.
    * :termy:param:`key+value`: The server's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: ANNOUNCE_TERM P(3) termid serverid hops width height key+value...

   Sent by the server to notify the client of a new terminal.

    * :termy:param:`termid` (16): The :term:`terminal identifier`.
    * :termy:param:`serverid` (16): The parent :term:`server identifier`.
    * :termy:param:`hops` (4): The number of hops (connections) separating the terminal's parent server from the client. For the immediate server, this is zero.
    * :termy:param:`width` (4): The width of the terminal in character cells.
    * :termy:param:`height` (4): The height of the terminal in character cells.
    * :termy:param:`key+value`: The terminal's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: ANNOUNCE_CONN P(4) connid serverid hops key+value...

   Sent by the server to notify the client of a new :term:`connection`.

    * :termy:param:`connid` (16): The :term:`connection identifier`.
    * :termy:param:`serverid` (16): The parent :term:`server identifier`.
    * :termy:param:`hops` (4): The number of hops (connections) separating the connection's parent server from the client. For the immediate server, this is zero.
    * :termy:param:`key+value`: The connection's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: DISCONNECT P(5) code?

   May be sent by the server or client at any time in order to end the connection. Close the connection after sending or receiving this.

    * :termy:param:`code` (4): An :ref:`error code <protocol-errors>`. This may not be present in the message, in which case it should be treated as 5 (forwarding error).

.. termy:protocol:: KEEPALIVE P(6)

   After keepalives have been :termy:protocol:`configured <CONFIGURE_KEEPALIVE>`, the server will send these periodically. The client should respond to a keepalive by sending one back to the server.

.. termy:protocol:: CONFIGURE_KEEPALIVE P(7) timeout

   Sets up keepalive messages on the connection. The client should send this before :termy:protocol:`announcing <ANNOUNCE_CLIENT>` itself. See :ref:`protocol-post`.

    * :termy:param:`timeout` (4): The requested time between :termy:protocol:`KEEPALIVE` messages in milliseconds. The client should :termy:protocol:`disconnect <DISCONNECT>` if a keepalive message is not received within twice the specified time period. The client should respond to a keepalive by sending one back to the server.

.. termy:protocol:: DISCARD P(9) data

   A message containing arbitrary data which will be ignored by the server. When using the 8-bit "raw" protocol encoding, the client can use this to perform a "channel test" by sending potentially troublesome escape sequences such as ``~.`` in the data.
