.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Troubleshooting: Lost Connection
================================

An established TermySequence connection can be lost for a number of reasons. When this happens, not only will the server itself become inaccessible, but any additional servers connected :term:`through it <connection chaining>` will also become inaccessible. All affected servers and terminals will be displayed with a prominent "disconnected" indicator in the :doc:`Terminals tool <tools/terminals>`. In this state, the terminal scrollback buffer can be accessed normally, assuming it has been :termy:global:`fetched <Server/ScrollbackFetchSpeed>`. Input to the terminal, :doc:`tasks <tools/tasks>` such as file downloads, and many :doc:`actions <actions>` will have no effect.

If you are still stuck after trying the solutions below, see :doc:`support`.

.. contents::
   :local:

Server Killed
-------------

The usual reason for a lost connection is a server that is killed by a signal. When connecting to a daemonized or socket activated server such as a :term:`persistent user server`, a forwarding process named :doc:`termy-forwrd <man/forwarder>` is created for each connection. Killing this process will also cause a connection loss for the specific client that created it.

It's also possible for the program run from the connection's :termy:connection:`Command <Connection/Command>` to be killed or exit prematurely.

Keepalive Timeout
-----------------

Another common reason for a lost connection is a timeout caused by a keepalive not being acknowledged in a timely manner. The keepalive time on each connection is configured using the :termy:connection:`Connection/KeepaliveTime` setting. The intent of this setting is to prevent "frozen" servers and terminals caused by a lost network connection, terminated process, or sleep/hibernate event. However, a timeout can also be caused by simple network, I/O, or scheduling lag.

If this is occurring, increase the keepalive time to an appropriate value for the connection. Or, disable keepalives entirely by setting the keepalive time to zero.

Setup Script
------------

The :doc:`termy-setup <man/setup>` script intentionally kills the local :term:`persistent user server` in order to relaunch it as a socket activated user service. This is expected behavior.

Refer to :doc:`systemd` for more information.

Protocol Encoding
-----------------

A lost connection can occur when the 8-bit "raw" encoding of the :doc:`TermySequence protocol <protocol>` is used over a communication channel that is not 8-bit clean. A "protocol parse error" message is a giveaway that this is happening.

Refer to :ref:`failed-connection-protocol-encoding` in :doc:`failed-to-connect` for more information.
