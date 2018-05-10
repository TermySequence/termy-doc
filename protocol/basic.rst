.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Basics
======

.. highlight:: none

This section describes the connection process, the initial handshake, and the protocol message format and encoding.

.. caution:: Write robust message parsing code in the client. Check all fields, lengths, and bounds. Do not trust the server to send well-formed messages.

.. contents::
   :local:

Connecting
----------

To connect to the local :term:`persistent user server`, create a socket pair using :manpage:`socketpair(2)` and then fork and execute :doc:`termy-server <../man/server>`, giving it one of the socket filehandles as its standard input and output. The new server process will hand the filehandle off to an existing persistent user server if it is running. Otherwise, the process will fork and execute a new persistent user server.

To create a :term:`private, transient server <transient local server>`, do the same thing, but pass the ``--standalone`` switch to the server. Other switches are also available to fine-tune the behavior of the server. Refer to :doc:`../man/server`.

To connect to a remote server, establish a connection to the remote host, account, or container using whatever means is required, then execute :program:`termy-server` in the context of the connection. Take note of whether the connection channel is 8-bit clean, which will be important when selecting the protocol encoding later. Where possible, configure the connection to be 8-bit clean. See :ref:`failed-connection-protocol-encoding` under :doc:`../failed-to-connect` for more information.

In all cases, the goal is to hold standard input and output streams to a running :program:`termy-server` process.

For local connections, as an optimization only, the client can manually try connecting to :program:`termy-server`'s Unix-domain socket before forking and executing. If the persistent user server is already running, this will avoid fork and process overhead. However, the Unix-domain socket can be in different locations depending on whether the server is socket activated. Refer to :doc:`../man/server` for more information. Simple clients should always fork and execute :program:`termy-server`.

.. _protocol-handshake:

Handshake
---------

Once the connection is established, the server will initiate the handshake by sending the following string::

   ESC ] 5 1 1 ; server-version ; protocol-version ; server-uuid ESC \

The spaces between literal characters and field names are for readability only and are not present in the actual string. ``ESC`` is ASCII 27. The fields are as follows:

server-version
   A decimal number. The server's protocol minor version, indicating which features it supports. Currently 1.

protocol-version
   A decimal number. The server's protocol major version, which must be supported by the client. Currently 1.

server-uuid
   The :term:`server identifier`, expressed as a text UUID (including dashes).

The client must reply with the following string::

   ESC ] 5 1 1 ; client-version ; protocol-type ; client-uuid ESC \

client-version
   A decimal number. When accepting the connection, the client's protocol minor version, indicating which features it supports. Currently 1. When rejecting the connection, the reason for rejection (see next field).

protocol-type
   A decimal number. Specifies which protocol encoding the client wishes to use on the connection:

    * 0: Reject the connection. In the client version field, specify the reason for rejecting the connection. This is one of the :ref:`error codes <protocol-errors>`. Close the connection after sending this reply.
    * 1: Use the 7-bit Base64 encoding.
    * 2: Use the 8-bit "raw" encoding.

client-uuid
   The :term:`client identifier`, expressed as a text UUID (including dashes).

Immediately following the handshake, a further exchange of messages will typically take place. This is described at :ref:`protocol-post`.

.. _protocol-encoding:

Encoding
--------

All messages following the initial handshake take the following form::

   type length body padding

type
   A 4-byte little-endian binary number. This specifies the type of message. The high-order byte of the number is as follows:

    * 0: A plain message. Notated P in the following sections.
    * 1: A server message. The first 16 bytes of the body are a :term:`server identifier`. Notated S in the following sections.
    * 2: A client message. The first 16 bytes of the body are a :term:`client identifier`. Notated C in the following sections.
    * 3: A terminal message. The first 16 bytes of the body are a :term:`terminal identifier`. Notated T in the following sections.

length
   A 4-byte little-endian binary number. This specifies the length in bytes of the body, not including the type, length, or padding. A length above 16MiB is invalid; abort the connection if one occurs.

body
   The contents of the message, which depend on the type of message. This generally consists of little-endian 4-byte and 8-byte binary numbers and NUL-terminated or unterminated UTF-8 strings.

padding
   0-3 NUL bytes, padding the message body to a multiple of 4 bytes. Don't forget this part!

The 8-bit "raw" protocol encoding consists of messages in the format above, written directly across the connection. For local connections using sockets, this is the only encoding that the client needs to support.

The 7-bit Base64 protocol encoding consists of messages in the format above, divided into chunks and encoded in the following fashion::

   ESC ] 5 1 2 ; base64-data ESC \

This chunking need not occur on message boundaries. The base64-data need not include trailing equals sign characters. Chunks with more than 8MiB of base64-data are invalid; abort the connection if one occurs. In practice, :program:`termy-server` sends 1016 bytes of base64-data per chunk, producing a 1024-byte total chunk length when adding the 8 bytes of framing.

.. _protocol-post:

Post-Handshake Exchange
-----------------------

The post-handshake exchange begins with the :termy:protocol:`HANDSHAKE_COMPLETE` message sent by the server. Upon receipt of this message, the client should:

 * Perform a channel test by sending a :termy:protocol:`DISCARD` message, if using the 8-bit "raw" protocol encoding. This step is optional.
 * Configure keepalives by sending a :termy:protocol:`CONFIGURE_KEEPALIVE` message. This step is optional.
 * Announce itself by sending an :termy:protocol:`ANNOUNCE_CLIENT` message.

The server will send :termy:protocol:`ANNOUNCE_SERVER`, :termy:protocol:`ANNOUNCE_TERM`, and :termy:protocol:`ANNOUNCE_CONN` messages immediately following the handshake complete message. These announcements should be properly ordered by hop distance, with each server announcement preceding the server's terminal and :term:`connection` announcements. However, clients must gracefully handle a bad ordering.

Note that the :termy:protocol:`ANNOUNCE_SERVER` message contains a :termy:param:`nterms` parameter which indicates the number of terminal and :term:`connection` announcements to follow. However, due to a race condition, it's possible for a terminal or connection to be closed after the server announcement is sent but before its own announcement is sent. Clients making use of :termy:param:`nterms` should have a timeout or other fallback in case the expected number of announcements does not arrive.

The server will send state updates for each terminal once the client announcement is received.
