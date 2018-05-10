.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Server
=============

Server settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/server`. Servers can be edited from the Server menu, :doc:`Manage Servers window <../dialogs/manage-servers>`, and various context menus, or by calling the :termy:action:`EditServer` action. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Servers window <../dialogs/manage-servers>` to load external changes without restarting the application.

A *server* is an instance of :doc:`termy-server <server>` running as a certain user on a certain machine. The :term:`local servers <local server>` are those server instances running alongside :program:`qtermy` as the same user, with one of them, the :term:`transient local server`, launched as a private child process of :program:`qtermy` itself.

A server is made accessible to :program:`qtermy` by opening a :doc:`connection <connection>`.

Server settings are named after the :term:`unique identifier <server identifier>` of the server that they reference. When a server is seen for the first time by :program:`qtermy`, a new server settings object with default settings will be created to track it. In addition to storing user preferences for each server, server settings objects also store various :ref:`state information <server-state>` about the server.

.. contents:: Settings Categories
   :local:

Server
------

.. termy:server:: Server/StartupProfiles stringlist

   Terminals to be created automatically on the server at connection time. This is a list of :doc:`profiles <profile>`, each of which will be applied to a :termy:action:`new terminal <NewTerminal>` on the server upon connection. The special profile name ``<Default>`` indicates the current :term:`global default profile`.

   If the server already has existing terminals with matching profiles, new terminals will not be created with those profiles. A terminal's existing profile is determined by the value of the ``profile`` terminal :term:`attribute`.

.. termy:server:: Server/DefaultProfile string

   The default profile to use when creating terminals on the server. This profile will be used when :termy:action:`NewTerminal` is called with an empty :termy:param:`ProfileName`. If this setting is empty, the :term:`global default profile` will be used.

.. termy:server:: Server/PortForwardingRules stringlist

   Saved port forwarding tasks which can be either started on demand from the :doc:`Manage Port Forwarding window <../dialogs/port-forwarding>` or started automatically at server connection time. Click the Ports button to bring up a :ref:`Port Forwarding Editor <edit-port-forwarding>`.

   The list itself consists of :termy:action:`LocalPortForward` and :termy:action:`RemotePortForward` specification strings prefixed by ``L:`` and ``R:`` respectively. The prefix letter is upper case for automatic tasks, lower case otherwise.

.. termy:server:: Server/RenderInlineImages enumeration

   See the :termy:global:`RenderInlineImages <Inline/RenderInlineImages>` global setting. This setting can be used to override the global setting on a per-server basis.

.. termy:server:: Server/AllowSmartHyperlinks enumeration

   See the :termy:global:`AllowSmartHyperlinks <Inline/AllowSmartHyperlinks>` global setting. This setting can be used to override the global setting on a per-server basis.

Appearance
----------

.. termy:server:: Appearance/FixedThumbnailIcon string

   Specifies a custom icon which will be displayed on the server thumbnail in the :doc:`Terminals tool <../tools/terminals>`, in context menus, and in the :doc:`Manage Servers window <../dialogs/manage-servers>`, overriding the ``icon`` server :term:`attribute` normally used to select the icon. This can also be done using the :termy:action:`SetServerIcon` action. Refer to that action for more information.

Files
-----

.. termy:server:: Files/DownloadLocation string

   The default folder in which to store files :termy:action:`downloaded <DownloadFile>` from this server. This setting can be used to override the :termy:global:`global setting <Files/DownloadLocation>` on a per-server basis.

.. termy:server:: Files/DownloadFileConfirmation enumeration

   See the :termy:global:`DownloadFileConfirmation <Files/DownloadFileConfirmation>` global setting. This setting can be used to override the global setting on a per-server basis.

.. termy:server:: Files/UploadFileConfirmation enumeration

   See the :termy:global:`UploadFileConfirmation <Files/UploadFileConfirmation>` global setting. This setting can be used to override the global setting on a per-server basis.

.. termy:server:: Files/DeleteFileConfirmation enumeration

   See the :termy:global:`DeleteFileConfirmation <Files/DeleteFileConfirmation>` global setting. This setting can be used to override the global setting on a per-server basis.

.. termy:server:: Files/RenameFileConfirmation enumeration

   See the :termy:global:`RenameFileConfirmation <Files/RenameFileConfirmation>` global setting. This setting can be used to override the global setting on a per-server basis.

.. _server-state:

State
-----

The following server state information is saved automatically under this category:

   * The date and time of last contact with the server.
   * The username, hostname, :term:`network address <server name>`, and icon :term:`attributes <attribute>` last reported by the server.
   * The name and type of the :doc:`connection <connection>` on which the server was last seen.

This information is displayed in the :doc:`Manage Servers window <../dialogs/manage-servers>`.
