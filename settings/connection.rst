.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Connection
=============

Connection settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/connections`. Connections can be edited from the Connect menu or the :doc:`Manage Connections window <../dialogs/manage-connections>`. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Connections window <../dialogs/manage-connections>` to load external changes and new files without restarting the application.

A *connection* is simply a :termy:connection:`command <Connection/Command>` that runs :doc:`termy-server <../server>` as another user, on a remote machine, or in a container. The command can be run by :command:`qtermy` itself or by a local or remote :doc:`server <server>` using the principle of :term:`connection chaining`. Any password prompts printed by the command will be shown in the :doc:`Connection Status dialog <../dialogs/connection-status>` which allows responses to be typed in and sent back to the command. If the connection is successful, the connected :doc:`server <server>` and any additional servers already connected to it will become known to :program:`qtermy`, appear in the :doc:`Terminals tool <../tools/terminals>`, and be available for creating new terminals and performing file operations. A connection made from one server to another is visible to all connected clients on the originating server, not just the client that initiated the connection.

Two reserved connections are created for the :term:`persistent user server` and :term:`transient local server`. These connections cannot be edited or removed. Connections can be created using the Connect menu, :doc:`Manage Connections window <../dialogs/manage-connections>`, or :termy:action:`NewConnection` action. A connection can be named, in which case it is saved to file and can be reused, or anonymous, in which case it is run only once and not saved for further use. Named connections can be favorited in the :doc:`Manage Connections window <../dialogs/manage-connections>`, which will cause them to appear in the Favorite Connections menu. The most recently favorited connections of each :termy:connection:`Type <Type/Type>` will be shown directly in the Connect menu itself.

Outside of :program:`qtermy`, anonymous connections can be made directly from the command line using the :doc:`termy-connect <../man/connect>` utility and the :doc:`termy-ssh <../man/ssh>`, :doc:`termy-sudo <../man/ssh>`, and :doc:`termy-su <../man/ssh>` convenience scripts. It's even possible to directly invoke a connection command from a :doc:`termy-server <../server>` terminal. Refer to :term:`connection chaining` for more information.

Depending on the specific external command used to launch :doc:`termy-server <../server>`, the communication channel may or may not be 8-bit clean. For example, escape sequences such as SSH ``~`` escapes and machinectl ``^]`` escapes render a communication channel 8-bit unclean (the SSH escape sequence can be disabled using a command line argument, but the machinectl escape sequence cannot). Furthermore, the external command may not work unless it is run within a pseudoterminal. Commands that collect passwords sometimes have this limitation. The :termy:connection:`UseRawProtocol <Connection/UseRawProtocol>` and :termy:connection:`UseLocalPty <Connection/UseLocalPty>` settings are provided to configure the connection appropriately for these cases. Refer to :doc:`../failed-to-connect` for further assistance in troubleshooting a connection that won't go through.

A :doc:`Batch Connection <../dialogs/connect-batch>` can be used to run one or more saved connections in sequence. This allows connections to be quickly and easily opened to remote systems across multiple hops.

.. tip:: Open commonly used connections, including batch connections, in a single keystroke by making a :doc:`key binding <keymap>` to to the :termy:action:`OpenConnection` action with your connection specified as the :termy:param:`ConnName` parameter. You won't miss typing in SSH commands from scratch.

.. contents:: Settings Categories
   :local:

Type
----

.. termy:connection:: Type/Type enumeration

   Specifies the type of connection made by this connection object. This setting controls which icon is displayed for the connection, which :doc:`New Connection Dialog <../dialogs/connect-dialogs>` is used to edit it, and where it appears in the Connect menu, if it is shown there.

   .. caution:: This setting is **purely cosmetic** in nature and may not accurately reflect the connection's actual :termy:connection:`Command <Connection/Command>`.

Server
------

.. termy:connection:: Server/LaunchFrom string

   Specifies the UUID of the :doc:`server <server>` from which the connection's :termy:connection:`Command <Connection/Command>` will be run. If this setting is empty, the command is run directly by :program:`qtermy` as a child process.

   The list of servers is in the dropdown for this setting is populated from the list of known servers. A server must have been previously seen by :program:`qtermy` to appear in the list. To work around this limitation, a server settings file can be manually installed and then loaded using the reload files button in the :doc:`Manage Servers window <../dialogs/manage-servers>` (assuming that its UUID is known). Refer to :doc:`server` for more information.

   .. note:: The server specified here must be connected when the connection is opened. If this is not the case, the connection will fail.

   :doc:`Batch connections <../dialogs/connect-batch>` provide a way to open multiple connections in sequence.

Connection
----------

.. termy:connection:: Connection/Command stringlist

   The command to run. This is a list of strings consisting of an executable name and argument vector (including argument zero).

   The command must result in an instance of :doc:`termy-server <../server>` being run or a connection to an existing :doc:`termy-server <../server>`'s Unix domain socket being made, such that the standard input and output of the command are forwarded to that server or socket. Based on the characteristics of the connection provided by the command, set :termy:connection:`UseRawProtocol <Connection/UseRawProtocol>` and :termy:connection:`UseLocalPty <Connection/UseLocalPty>` as appropriate.

   .. include:: command-common.rst

.. termy:connection:: Connection/Directory string

   The directory which the :termy:connection:`Command <Connection/Command>` is run from. If unspecified, the command will be started in the user's :envvar:`HOME` directory.

.. termy:connection:: Connection/Environment stringlist

   Environment variable rules used to set and clear environment variables before running the :termy:connection:`Command <Connection/Command>`.

.. termy:connection:: Connection/UseRawProtocol boolean

   If enabled, the 8-bit "raw" binary encoding of the :doc:`TermySequence protocol <../protocol>` will be used on the connection. **Do not** enable this setting unless the communication channel created by the :termy:connection:`Command <Connection/Command>` is known to be fully 8-bit clean. A connection is not clean if any of the following are true after initial setup (such as password prompts) has been performed and :doc:`termy-server <../server>` is running:

     * The communication channel has any in-band signaling or escape sequences such as SSH ``~`` escapes and machinectl ``^]`` escapes. It may be possible to disable escape sequences using a command option such as the ``-e`` argument to :manpage:`ssh(1)`.
     * The communication channel expects data in a particular text encoding such as 7-bit ASCII or UTF-8.
     * Error messages or other strings are printed into the communication channel. It may be possible to disable these using a "quiet" command option such as the ``-q`` argument to :manpage:`ssh(1)`.

   If disabled, the 7-bit Base64 encoding of the :doc:`TermySequence protocol <../protocol>` will be used on the connection. It is slower but more robust against unclean communication channels.

.. termy:connection:: Connection/UseLocalPty boolean

   If enabled, the :termy:connection:`Command <Connection/Command>` will be run inside a pseudoterminal. Some programs that display password prompts require this. The pseudoterminal will be set up in "raw" mode to make it 8-bit clean. It may be possible to remove the need for a local pseudoterminal using a command option such as the ``-S`` argument to :manpage:`sudo(8)`.

.. termy:connection:: Connection/KeepaliveTime integer

   The time between keepalive messages on the connection in milliseconds. If either side of the connection does not receive a keepalive message from the other side within twice the specified time period, the connection will be automatically closed. Use this setting to prevent "frozen" servers and terminals caused by a lost network connection, terminated process, or sleep/hibernate event.  If set to zero, no keepalive messages will be sent.

   .. note:: The keepalive messages configured by this setting are part of the :doc:`TermySequence protocol <../protocol>` and are sent at the application layer. This setting does not control transport layer keepalive probes specified by :manpage:`tcp(7)`.

Batch
-----

.. termy:connection:: Batch/Contents stringlist

   A list of connection names to be invoked in sequence. Only applicable to :doc:`batch connections <../dialogs/connect-batch>`.
