.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Client Messages
===============

.. termy:protocol:: ANNOUNCE_CLIENT C(2000) clientid version hops flags key+value...

   Sent by the client during the :ref:`protocol-post`.

    * :termy:param:`clientid` (16): The :term:`client identifier`.
    * :termy:param:`version` (4): The client's protocol minor version, as in the :ref:`handshake message <protocol-handshake>`.
    * :termy:param:`hops` (4): Set this field to zero.
    * :termy:param:`flags` (4): The :ref:`client flags <protocol-clientflags>`.
    * :termy:param:`key+value`: The client's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: GET_CLIENT_ATTRIBUTE S(2002) serverid clientid targetid key...

   Request one or more client attributes. A separate response will be sent for each requested attribute.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`targetid` (16): The target :term:`client identifier`.
    * :termy:param:`key`: The requested attribute name(s) as NUL-terminated UTF-8 strings.

.. termy:protocol:: GET_CLIENT_ATTRIBUTE_RESPONSE C(2002) clientid serverid targetid key[+value]

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`serverid` (16): The originating :term:`server identifier`.
    * :termy:param:`targetid` (16): The target :term:`client identifier`.
    * :termy:param:`key[+value]`: The attribute name and optional value as NUL-terminated UTF-8 strings. If the value is absent, the attribute was removed.

.. termy:protocol:: THROTTLE_PAUSE C(2005) clientid destid termid size8 threshold8

   Sent to the client when an intermediate server has too much buffered data waiting to send to a destination. The client should cease sending data, in particular task :termy:protocol:`output <TASK_OUTPUT>` data, to the destination named by :termy:param:`destid`. When the backlog is cleared, a :termy:protocol:`THROTTLE_RESUME` message will be sent for the terminal or connection named by :termy:param:`termid`.

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`destid` (16): The identifier of the destination terminal or server for which traffic should be paused.
    * :termy:param:`termid` (16): The identifier of the intermediate terminal or :term:`connection` where data is piling up waiting to send.
    * :termy:param:`size8` (8): The amount of buffered data outstanding.
    * :termy:param:`threshold8` (8): The threshold of buffered data for sending the pause message.

.. termy:protocol:: THROTTLE_RESUME T(2005) termid

   Sent to the client when a throttled terminal or :term:`connection` has cleared its backlog of buffered data and transmission to destinations downstream of it may resume. See :termy:protocol:`THROTTLE_PAUSE`.

    * :termy:param:`termid` (16): The identifier of the intermediate terminal or connection that is now unthrottled.
