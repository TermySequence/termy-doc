.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Actions
=======

Actions are the mechanism by which :program:`qtermy`'s internal functions are invoked. All of :program:`qtermy`'s menu entries and all (non-literal) :ref:`key bindings <keymap-action>` are specified as action invocations. Actions can also be invoked in other ways:

  * As a result of mouse clicks in certain :doc:`tools/index`, whose actions can be configured via per-tool :doc:`global settings <settings/global>`.
  * By a :doc:`launcher <settings/launcher>` configured to treat its command's :termy:launcher:`output <InputOutput/OutputType>` as an action invocation.
  * By a triggered :doc:`alert <settings/alert>` configured to invoke an :termy:alert:`action <Parameters/Action>`.
  * By a :doc:`plugin <plugins/index>` implementing a :doc:`custom action <plugins/action>`, via :js:func:`manager.invoke`.
  * From the dialog box raised by the :termy:action:`Prompt` action.
  * From the command line on the local machine via the :doc:`qtermy-pipe <man/pipe>` utility.
  * From the :termy:action:`TipOfTheDay` window using special hyperlinks created by the :doc:`tip provider <plugins/totd>`.

An action invocation consists of an action name along with zero or more parameters, separated by vertical bar (\|) characters. This means that parameters themselves cannot contain the vertical bar (\|) character (there is no escaping mechanism). When invoking a :doc:`custom action <plugins/action>` registered by a :doc:`plugin <plugins/index>`, prepend the string "Custom" to the action's name.

Use the :ref:`genindex` to jump to an action's documentation if you know its name.

.. contents::
   :local:

Conventions
-----------

Some action parameters have consistent behavior across many different actions.

.. _terminal-lookup:

Terminal Lookup
^^^^^^^^^^^^^^^

Unless otherwise noted, the :termy:param:`TerminalId` action parameter has the following semantics:

  * If set to a UUID, the terminal with that identifier is used.
  * If unset, the :term:`active terminal` is used.

.. _server-lookup:

Server Lookup
^^^^^^^^^^^^^

Unless otherwise noted, the :termy:param:`ServerId` action parameter has the following semantics:

  * If set to a UUID, the server with that :term:`identifier <server identifier>` is used.
  * If set to the string ``Local``, the :term:`local server` is used.
  * If unset, the :term:`active server` is used.

.. _job-lookup:

Job Lookup
^^^^^^^^^^

Unless otherwise noted, a combination of :termy:param:`RegionId` and :termy:param:`TerminalId` action parameters has the following semantics. Note that :doc:`shell integration <shell-integration>` is required for :term:`job regions <job>` to be created.

  * If both are empty, the :term:`current job` from the :term:`active viewport` is used.
  * If :termy:param:`RegionId` is the string ``Selected``, the :term:`selected job` in the active viewport is used.
  * If :termy:param:`RegionId` is the string ``Tool``, the selected job in the :doc:`History tool <tools/history>` will be used if that tool is :ref:`active <tools-active>`.
  * Otherwise, the terminal is looked up per :ref:`terminal-lookup` and :termy:param:`RegionId` is parsed as an unsigned decimal number and looked up within that terminal.

If the job lookup is successful, the region's terminal is made active in the active pane.

.. _task-lookup:

Task Lookup
^^^^^^^^^^^

Unless otherwise noted, the :termy:param:`TaskId` action parameter refers to a specific task UUID or to the selected task in the :doc:`Tasks tool <tools/tasks>` if empty.

.. _selection-handle-lookup:

Selection Handle Lookup
^^^^^^^^^^^^^^^^^^^^^^^

A text selection within a terminal viewport has two handles: upper and lower, one at each end of the selection. Certain actions modify the active text selection by adjusting one of the handles. These actions are intended to be run from :ref:`key bindings <keymap-action>` that are conditioned on :ref:`selection mode <keymap-modes>`. In these actions, the :termy:param:`Arg` action parameter used to choose a selection handle has the following semantics:

  * If :termy:param:`Arg` is ``1``, the upper handle is selected.
  * If :termy:param:`Arg` is ``2``, the lower handle is selected.
  * If :termy:param:`Arg` is ``0`` or empty, the currently selected handle is used. If no handle is selected, a default handle will be selected depending on the specific action.

The selected handle is drawn in a :ref:`different color <theme-editor-extended>` to distinguish it from the unselected handle.

Reference
---------

.. termy:action:: AdjustTerminalColors TerminalId

   Opens the :ref:`Adjust Colors dialog <adjust-colors>` for the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: AdjustTerminalFont TerminalId

   Opens the :ref:`Adjust Font dialog <adjust-font>` for the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: AdjustTerminalLayout TerminalId

   Opens the :ref:`Adjust Layout dialog <adjust-layout>` for the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: AdjustTerminalScrollback TerminalId

   Opens the :ref:`Adjust Scrollback dialog <adjust-scrollback>` for the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: AnnotateCommand RegionId TerminalId

   Opens the :doc:`Create Annotation dialog <dialogs/create-annotation>` to annotate the command text of the :ref:`specified job <job-lookup>`. :termy:param:`RegionId` can refer to either a command region itself, or its parent :term:`job`.

.. termy:action:: AnnotateOutput RegionId TerminalId

   Opens the :doc:`Create Annotation dialog <dialogs/create-annotation>` to annotate the output text of the :ref:`specified job <job-lookup>`. :termy:param:`RegionId` can refer to either an output region itself, or its parent :term:`job`.

.. termy:action:: AnnotateRegion RegionId TerminalId

   Opens the :doc:`Create Annotation dialog <dialogs/create-annotation>` to annotate the first line of the :ref:`specified job <job-lookup>`. :termy:param:`RegionId` can refer to any region.

.. termy:action:: AnnotateScreen Row

   Opens the :doc:`Create Annotation dialog <dialogs/create-annotation>` to annotate the specified row within the :term:`active viewport`. :termy:param:`Row` is a decimal integer measured from the top of the screen (if zero, positive, or unspecified) or from the bottom of the screen (if negative).

.. termy:action:: AnnotateSelection

   Opens the :doc:`Create Annotation dialog <dialogs/create-annotation>` to annotate the selected text in the :term:`active viewport`.

.. termy:action:: CancelTask TaskId

   Cancels the :ref:`specified task <task-lookup>`.

.. termy:action:: ClearAlert TerminalId

   Clears any running :doc:`alert <settings/alert>` on the :ref:`specified terminal <terminal-lookup>`. Also clears any "urgent" indicator icon set on the terminal thumbnail by the :termy:alert:`ShowIndicator <Actions/ShowIndicator>` alert setting.

.. termy:action:: ClearTerminalScrollback TerminalId

   Clears the scrollback buffer of the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: CloneTerminal Duplicate TerminalId

   Clones the :ref:`specified terminal <terminal-lookup>`, producing a new terminal on the same server. If :termy:param:`Duplicate` is ``1``, the scrollback buffer (including all regions) is duplicated in the new terminal. Otherwise, only the :doc:`profile settings <settings/profile>` and any settings overrides are copied and the new terminal starts empty.

.. termy:action:: CloseTerminal TerminalId

   Closes the :ref:`specified terminal <terminal-lookup>`. This may prompt for confirmation, depending on the value of the :termy:profile:`PromptClose <Emulator/PromptClose>` profile setting. If the terminal is :term:`hosting a connection <connection chaining>` to a server, the connection will be closed.

.. termy:action:: CloseWindow

   Closes the current application window. If there is only a single application window, equivalent to :termy:action:`QuitApplication`.

.. termy:action:: CommandTerminal ProfileName ServerId Cmdspec

   Creates a new terminal with :termy:param:`ServerId` and :termy:param:`ProfileName` specified as in :termy:action:`NewTerminal`. :termy:param:`Cmdspec` is an executable name and argument vector (including argument zero) separated by unit separator (``0x1f``) characters. The command specified by :termy:param:`Cmdspec` is run in the new terminal rather than the command specified in the :termy:profile:`Profile setting <Emulator/Command>`.

   This action is a specialization of :termy:action:`LaunchCommand`.

.. termy:action:: Copy TerminalId

   Copies the selected text in the :ref:`specified terminal <terminal-lookup>` to the clipboard. If there is no selected text, an empty string will be copied. If :ref:`selection mode <keymap-modes>` is active and :termy:global:`ExitSelectModeOnCopy <Command/ExitSelectModeOnCopy>` is enabled, the selection will be cleared following the copy.

.. termy:action:: CopyAll TerminalId

   Copies the entire scrollback contents in the :ref:`specified terminal <terminal-lookup>` to the clipboard.

.. termy:action:: CopyCommand RegionId TerminalId

   Copies the :ref:`specified job <job-lookup>`'s command text to the clipboard. If the job is not found, an empty string will be copied.

.. termy:action:: CopyDirectoryPath DirPath

   If :termy:param:`DirPath` is empty, the enclosing directory path of the selected file in the :doc:`Files tool <tools/files>` is copied to the clipboard. Otherwise, :termy:param:`DirPath` is copied.

.. termy:action:: CopyFile Format ServerId RemotePath

   Initiates a task to copy the contents of the file named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>` to the clipboard. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used.

.. termy:action:: CopyFilePath FilePath

   If :termy:param:`FilePath` is empty, the path of the selected file in the :doc:`Files tool <tools/files>` is copied to the clipboard. Otherwise, :termy:param:`FilePath` is copied.

.. termy:action:: CopyImage Format TerminalId ContentId

   Initiates a task to copy the named content item in the :ref:`specified terminal <terminal-lookup>` to the clipboard. If :termy:param:`Format` is ``0``, the data is treated as UTF-8 text. If :termy:param:`Format` is ``1``, the data is treated as an image, parsed using `Qt5's QImage class <http://doc.qt.io/qt-5/qimage.html#loadFromData>`_. If :termy:param:`Format` is empty, the data is treated as text if it's valid UTF-8 and as an image otherwise. Otherwise, :termy:param:`Format` is treated as a MIME type and the data is placed on the clipboard using that type.

   Content items are loaded into a terminal using the :doc:`termy-download <man/download>`, :doc:`termy-imgcat <man/download>`, or :doc:`termy-imgls <man/download>` utilities. Note that inline images may be reduced to thumbnails. To ensure that the original image data is downloaded, download the image file itself rather than the content item.

.. termy:action:: CopyJob RegionId TerminalId

   Copies the :ref:`specified job <job-lookup>`'s full text to the clipboard. If the job is not found, the clipboard is not touched.

.. termy:action:: CopyOutput RegionId TerminalId

   Copies the :ref:`specified job <job-lookup>`'s output text to the clipboard. If the job is not found, the clipboard is not touched.

.. termy:action:: CopyRegion RegionId TerminalId

   Looks up the specified region in the :ref:`specified terminal <terminal-lookup>` and copies its contents to the clipboard. Note that this is not a :ref:`job-lookup`. :termy:param:`RegionId` can refer to any region.

.. termy:action:: CopyScreen Format TerminalId

   Copies the contents of a viewport or terminal screen to the clipboard. If :termy:param:`TerminalId` is set, the contents of the specified terminal's screen are copied to the clipboard as text and :termy:param:`Format` is ignored. Otherwise, the contents of the :term:`active viewport` are copied as text if :termy:param:`Format` is empty, or as a PNG image if :termy:param:`Format` is ``png``.

.. termy:action:: CopySemantic RegionId TerminalId

   Looks up the specified :term:`semantic region` in the :ref:`specified terminal <terminal-lookup>` and copies its contents to the clipboard. Note that this is not a :ref:`job-lookup`. :termy:param:`RegionId` must refer to a region created by a :doc:`semantic parser <plugins/parser>`.

.. termy:action:: CopySuggestion Index

   If :termy:param:`Index` is empty, the selected suggestion in the :doc:`Suggestions tool <tools/suggestions>` is copied to the clipboard. Otherwise, the n\ :sup:`th` suggestion is copied, indexed from 0, specified by :termy:param:`Index`.

.. termy:action:: CopyTaskDirectoryPath TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, copies the enclosing directory path of that file to the clipboard.

.. termy:action:: CopyTaskFile Format TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, initiates a task to copy the contents of that file to the clipboard. See :termy:action:`CopyFile`.

.. termy:action:: CopyTaskFilePath TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, copies the path of that file to the clipboard.

.. termy:action:: CopyUrl Url

   Copies the URL string :termy:param:`Url` to the clipboard.

.. termy:action:: DecreaseFont

   Decreases the font size in the :term:`active viewport`.

.. termy:action:: DeleteFile ServerId RemotePath

   Initiates a task to delete the file or directory named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used. A confirmation prompt may be shown, depending on the value of the :termy:global:`DeleteFileConfirmation <Files/DeleteFileConfirmation>` global setting and whether :termy:param:`RemotePath` is a file or directory. Non-empty directories *will* be recursively removed.

.. termy:action:: DisconnectServer ServerId

   Ends the connection to the :ref:`specified server <server-lookup>`.

.. termy:action:: DisconnectTerminal TerminalId

   If the :ref:`specified terminal <terminal-lookup>` terminal hosts a connection to a server, ends the connection.

.. termy:action:: DownloadFile ServerId RemotePath LocalPath

   Initiates a task to download the file named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used. The local destination :termy:param:`LocalPath` is interpreted as follows:

     * If set to the string ``<Prompt>``, a save file dialog will be shown.
     * If empty, the download folder specified by the :termy:server:`DownloadLocation <Files/DownloadLocation>` server setting or :termy:global:`DownloadLocation <Files/DownloadLocation>` global setting is used.
     * If set to an existing directory, the file will be saved to that directory.
     * If set to a path with a filename that does not exist, the file will be saved to that name.

   If the destination file already exists, the file may be saved under a different name, a confirmation prompt may be shown, or the task may fail, depending on the value of the :termy:global:`DownloadFileConfirmation <Files/DownloadFileConfirmation>` global setting.

   Downloads from :term:`local servers <local server>` are not allowed unless the :termy:global:`LocalDownloads <Server/LocalDownloads>` global setting is enabled.

.. termy:action:: DownloadImage TerminalId ContentId LocalPath

   Initiates a task to download the named content item in the :ref:`specified terminal <terminal-lookup>`. :termy:param:`LocalPath` is interpreted as in :termy:action:`DownloadFile`.

   Content items are loaded into a terminal using the :doc:`termy-download <man/download>`, :doc:`termy-imgcat <man/download>`, or :doc:`termy-imgls <man/download>` utilities. Note that inline images may be reduced to thumbnails. To ensure that the original image data is downloaded, download the image file itself rather than the content item.

.. termy:action:: EditGlobalSettings

   Opens a :doc:`settings editor dialog <dialogs/settings-editor>` to edit the :doc:`Global settings <settings/global>`.

.. termy:action:: EditIconRules

   Opens the :doc:`Icon Rules Editor <dialogs/icon-rule-editor>`.

.. termy:action:: EditKeymap KeymapName

   Opens the :doc:`Keymap Editor <dialogs/keymap-editor>` to edit the :doc:`keymap <settings/keymap>` named by :termy:param:`KeymapName`, or the keymap associated with the :term:`active terminal` if empty.

.. termy:action:: EditProfile ProfileName

   Opens a :doc:`settings editor dialog <dialogs/settings-editor>` to edit the :doc:`profile <settings/profile>` named by :termy:param:`ProfileName`, which is interpreted as follows:

     * If empty, the profile associated with the :term:`active terminal`.
     * If set to the string ``<Default>``, the :term:`global default profile`
     * Otherwise, the profile with the given name.

.. termy:action:: EditServer ServerId

   Opens a :doc:`settings editor dialog <dialogs/settings-editor>` to edit the :doc:`Server settings <settings/server>` for the :ref:`specified server <server-lookup>`.

.. termy:action:: EditSwitchRules

   Opens the :doc:`Profile Rules Editor <dialogs/switch-rule-editor>`.

.. termy:action:: EventLog

   Opens the :doc:`Event Log <dialogs/event-log>`.

.. termy:action:: ExitFullScreen

   Exits full screen mode, if active.

.. termy:action:: ExitPresentationMode

   Exits :termy:action:`presentation mode <TogglePresentationMode>`, if active.

.. termy:action:: ExtractProfile TerminalId

   Opens the :doc:`Extract Profile dialog <dialogs/extract-profile>` to create a new profile from the settings in the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: FetchImage TerminalId ContentId

   Initiates a task to download the named content item in the :ref:`specified terminal <terminal-lookup>` and display it inline. This may be done automatically, depending on the :termy:server:`RenderInlineImages <Server/RenderInlineImages>` server setting and :termy:global:`RenderInlineImages <Inline/RenderInlineImages>` global setting.

.. termy:action:: FileFirst

   Selects the first file in the :doc:`Files tool <tools/files>`.

.. termy:action:: FileLast

   Selects the last file in the :doc:`Files tool <tools/files>`.

.. termy:action:: FileNext

   Selects the next file in the :doc:`Files tool <tools/files>`, or the first file if there is no current selection.

.. termy:action:: FilePrevious

   Selects the previous file in the :doc:`Files tool <tools/files>`, or the last file if there is no current selection.

.. termy:action:: FileSearch

   Opens and focuses the search bar within the :doc:`Files tool <tools/files>`.

.. termy:action:: FileSearchReset

   Clears the current search within the :doc:`Files tool <tools/files>`.

.. termy:action:: Find

   Raises the :doc:`Search tool <tools/search>` and focuses the search bar within it. Pressing Return or Escape in the search bar will return focus to the terminal viewport.

.. termy:action:: FirstTerminal

   Activates the first terminal on the first server in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: HelpAbout

   Opens the application help-about dialog.

.. termy:action:: HideServer ServerId

   In the active window, hides all terminals belonging to the :ref:`specified server <server-lookup>` in the :doc:`Terminals tool <tools/terminals>`. See :termy:action:`HideTerminal`.

   Use :termy:action:`ShowServer` to unhide the terminals.

.. termy:action:: HideTerminal TerminalId

   In the active window, hides the :ref:`specified terminal <terminal-lookup>` in the :doc:`Terminals tool <tools/terminals>`. The terminal's thumbnail will not be shown, and navigation actions such as :termy:action:`NextTerminal` and :termy:action:`PreviousTerminal` will skip over the terminal.

   Use :termy:action:`ShowTerminal` to unhide the terminal.

.. termy:action:: HideTerminalEverywhere TerminalId

   In all windows, hides the :ref:`specified terminal <terminal-lookup>` in the :doc:`Terminals tool <tools/terminals>`. See :termy:action:`HideTerminal`.

.. termy:action:: HighlightCursor

   Displays a brief animation at the cursor location in the :term:`active viewport`.

.. termy:action:: HighlightSemanticRegions

   Displays a brief animation over any hyperlinks or other :term:`semantic regions <semantic region>` in the :term:`active viewport`.

.. termy:action:: HistoryFirst

   Selects the first job in the :doc:`History tool <tools/history>`.

.. termy:action:: HistoryLast

   Selects the last job in the :doc:`History tool <tools/history>`.

.. termy:action:: HistoryNext

   Selects the next job in the :doc:`History tool <tools/history>`, or the first job if there is no current selection.

.. termy:action:: HistoryPrevious

   Selects the previous job in the :doc:`History tool <tools/history>`, or the last job if there is no current selection.

.. termy:action:: HistorySearch

   Opens and focuses the search bar within the :doc:`History tool <tools/history>`.

.. termy:action:: HistorySearchReset

   Clears the current search within the :doc:`History tool <tools/history>`.

.. termy:action:: IncreaseFont

   Increases the font size in the :term:`active viewport`.

.. termy:action:: InputSetFollower TerminalId

   Sets the :ref:`specified terminal <terminal-lookup>` to be an :term:`input multiplexing` follower. Any input to the input multiplexing leader will be copied to the specified terminal.

.. termy:action:: InputSetLeader TerminalId

   Sets the :ref:`specified terminal <terminal-lookup>` to be the :term:`input multiplexing` leader. Any input to the input multiplexing leader will be copied to all input multiplexing followers.

.. termy:action:: InputToggleFollower TerminalId

   Toggles whether the :ref:`specified terminal <terminal-lookup>` is an :term:`input multiplexing` follower. See :termy:action:`InputSetFollower`.

.. termy:action:: InputUnsetFollower TerminalId

   Unsets the :ref:`specified terminal <terminal-lookup>` as an :term:`input multiplexing` follower. See :termy:action:`InputSetFollower`.

.. termy:action:: InputUnsetLeader

   Stops :term:`input multiplexing`.

.. termy:action:: InspectTask TaskId

   Opens a task status dialog to view the progress of the :ref:`specified task <task-lookup>`.

.. termy:action:: LaunchCommand LauncherName ServerId Substitutions

   Runs the specified :doc:`launcher <settings/launcher>` on the :ref:`specified server <server-lookup>`. If :termy:param:`LauncherName` is empty or doesn't exist, the :term:`default launcher` is used.

   Markers may be substituted within the launcher's :termy:launcher:`command <Command/Command>` using the :termy:param:`Substitutions` parameter, which consists of zero or more strings of the form ``X=value`` separated by unit separator (``0x1f``) characters. ``X`` is the marker's letter and ``value`` is the string (treated as a single word) to substitute at the location of ``%X`` within the command.

   Depending on the configuration of the launcher and whether the server is :term:`local <local server>` or remote, any of the following may occur:

     * A desktop application may be launched as in :termy:action:`OpenDesktopUrl`.
     * A command may be run as in :termy:action:`RunCommand`.
     * A command may be run with output shown in a dialog box as in :termy:action:`PopupCommand`.
     * A terminal may be opened to run a command as in :termy:action:`CommandTerminal`.
     * A command string may be written to the active terminal using :termy:action:`WriteText`.

   Refer to :doc:`settings/launcher` for more information on launchers.

.. termy:action:: LocalPortForward ServerId Spec

   Initiates a task to perform port forwarding between the application and the :ref:`specified server <server-lookup>`. The listening socket is on the local machine and outbound connections are made on the remote machine.

   :termy:param:`Spec` has the format :termy:param:`LocalSpec:RemoteSpec` with each part having the following format:

     * For TCP sockets: :termy:param:`0:Address:Port` or :termy:param:`0:[Address]:Port` if the address contains colon characters. For a listening socket bound to all addresses, use an empty address.
     * For Unix-domain sockets: :termy:param:`1:Path`. For listening sockets, the socket file will be created but its parent directory must exist and be writable.

   Port forwarding tasks can be launched on demand via the :doc:`Manage Port Forwarding window <dialogs/port-forwarding>` or automatically at server connection time via server :termy:server:`PortForwardingRules <Server/PortForwardingRules>`.

.. termy:action:: ManageAlerts

   Opens the :doc:`Manage Alerts window <dialogs/manage-alerts>`.

.. termy:action:: ManageConnections

   Opens the :doc:`Manage Connections window <dialogs/manage-connections>`.

.. termy:action:: ManageKeymaps

   Opens the :doc:`Manage Keymaps window <dialogs/manage-keymaps>`.

.. termy:action:: ManageLaunchers

   Opens the :doc:`Manage Launchers window <dialogs/manage-launchers>`.

.. termy:action:: ManagePlugins

   Opens the :doc:`Manage Plugins window <dialogs/manage-plugins>`.

.. termy:action:: ManagePortForwarding

   Opens the :doc:`Manage Port Forwarding window <dialogs/port-forwarding>`.

.. termy:action:: ManageProfiles

   Opens the :doc:`Manage Profiles window <dialogs/manage-profiles>`.

.. termy:action:: ManageServers

   Opens the :doc:`Manage Servers window <dialogs/manage-servers>`.

.. termy:action:: ManageTerminals

   Opens the :doc:`Manage Terminals window <dialogs/manage-terminals>`.

.. termy:action:: ManpageTerminal Manpage

   Opens a terminal on the :term:`local server` using the server's :termy:server:`default profile <Server/DefaultProfile>` and runs the command "man :termy:param:`Manpage`" rather than the command specified in the :termy:profile:`Profile setting <Emulator/Command>`.

   This action exists mostly to implement the "View Man Page" entry in the Help menu. For a more flexible way to run commands in new terminals, see :doc:`settings/launcher`.

.. termy:action:: MountFile Readonly ServerId RemotePath

   Initiates a task to perform a FUSE mount of the file or directory named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>`, which must not be a :term:`local server`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used.

   If :termy:param:`Readonly` is ``1`` and :termy:param:`RemotePath` refers to a file, the mount will be made read-only. If :termy:param:`RemotePath` refers to a directory, the mount will always be made read-only regardless of :termy:param:`Readonly`.

   The user account under which :program:`qtermy` is running must have permission to perform unprivileged FUSE mounts using :manpage:`fusermount3(1)`, which may require adding the user to a "fuse" group. Refer to the documentation for your distribution's FUSE package.

   A temporary mountpoint folder will be created in the application's runtime directory. After the mount has been made, the task's output file will be set so that the mounted path can be opened from the :doc:`Tasks tool <tools/tasks>` or via :termy:action:`OpenTaskFile`, :termy:action:`OpenTaskDirectory`, and similar actions. The configured :termy:global:`automatic action<Tasks/MountAction>` for mount tasks in the :doc:`Global settings <settings/global>` will be launched, if any.

   The task will keep running until a :termy:action:`cancel <CancelTask>`, :termy:launcher:`timeout <Launcher/UnmountIdleTime>`, or server connection loss. If the status of the task is "Idle" or "In Use", the mount is set up and ready to use. To unmount, ensure all applications and terminals referencing mounted files have been closed, then cancel the task using the :doc:`Tasks tool <tools/tasks>` or :termy:action:`CancelTask` action.

   For read-write mounts, local applications such as text editors may create temporary files (but not directories) within the mountpoint folder. These will be written to underlying local storage. File rename operations to and from the mounted remote file are supported. Some applications may perform file operations that aren't supported by :program:`qtermy`'s FUSE filesystem implementation. Test each application for compatibility with :program:`qtermy` FUSE mounts before using this feature to edit files in production.

   .. warning:: If :program:`qtermy` is forcibly closed by a KILL signal, the FUSE mount will not be properly unmounted and may need to be cleaned up manually using :manpage:`umount(8)` and :manpage:`fusermount3(1)`. Furthermore, a read-write mount which is interrupted for any reason may cause data loss in the remote file. Use the remote file mount feature with caution.

.. termy:action:: NewConnection ConnType ConnArg ServerId

   Initiates a task to create an anonymous :doc:`connection <settings/connection>` of type :termy:param:`ConnType`. If :termy:param:`ServerId` is empty, the connection is run as a child process of :program:`qtermy` itself. Otherwise, it is run from the specified server.

   If :termy:param:`ConnArg` is empty, a :doc:`dialog box <dialogs/connect-dialogs>` will be shown to collect the configuration for the connection. Otherwise, :termy:param:`ConnArg` contains the connection configuration specific to :termy:param:`ConnType`.

   :termy:param:`ConnType` must be one of the following:

     * ``3``: A :ref:`generic connection <connect-custom>` launched via an arbitrary command. :termy:param:`ConnArg` must be empty; the dialog box will always be shown.
     * ``4``: A :ref:`SSH connection <connect-ssh>`. :termy:param:`ConnArg` is a string of the form "user\@host".
     * ``5``: A :ref:`switch user connection <connect-user>` launched via :manpage:`sudo(8)`. :termy:param:`ConnArg` is a username.
     * ``6``: A :ref:`switch user connection <connect-user>` launched via :manpage:`su(1)`. :termy:param:`ConnArg` is a username.
     * ``7``: A :ref:`switch user connection <connect-user>` launched via :manpage:`machinectl(1)`. :termy:param:`ConnArg` is a username.
     * ``8``: A :ref:`switch user connection <connect-user>` launched via :manpage:`pkexec(1)`. :termy:param:`ConnArg` is a username.
     * ``9``: A :ref:`container connection <connect-container>` launched via :command:`machinectl`. :termy:param:`ConnArg` is a machine name.
     * ``10``: A :ref:`container connection <connect-container>` launched via :command:`docker`. :termy:param:`ConnArg` is a container identifier.
     * ``11``: A :ref:`container connection <connect-container>` launched via :command:`kubectl`. :termy:param:`ConnArg` is a pod name plus an optional container name separated from the pod name by a unit separator (``0x1f``) character.
     * ``12``: A :ref:`container connection <connect-container>` launched via :command:`rkt`. :termy:param:`ConnArg` is a pod identifier plus an optional app name separated from the pod identifier by a unit separator (``0x1f``) character.

   Refer to :doc:`settings/connection` for more information on connections.

.. termy:action:: NewLocalTerminal ProfileName

   Creates a new terminal on the :term:`local server`, with :termy:param:`ProfileName` specified as in :termy:action:`NewTerminal`.

.. termy:action:: NewTerminal ProfileName ServerId

   Creates a new terminal on the :ref:`specified server <server-lookup>` using the profile named by :termy:param:`ProfileName`, which is interpreted as follows:

     * If empty or set to the string ``<ServerDefault>``, the server's :termy:server:`default profile <Server/DefaultProfile>`.
     * If set to the string ``<Default>``, the :term:`global default profile`.
     * If set to the string ``<Prompt>``, a dialog box will be opened where the user can choose a profile.
     * Otherwise, the profile with the given name.

   :termy:action:`Ownership <TakeTerminalOwnership>` of the terminal is assigned to this client.

.. termy:action:: NewWindow ProfileName ServerId

   Opens a new application window and then calls :termy:action:`NewTerminal` with the given :termy:param:`ProfileName` and :termy:param:`ServerId`. If :termy:param:`ProfileName` is empty, no terminal is created.

.. termy:action:: NextPane

   Moves input focus to the next split pane within the same window.

.. termy:action:: NextServer

   Changes the :term:`active server` to the next server in the :doc:`Terminals tool <tools/terminals>`. The first terminal on that server is made the :term:`active terminal`.

.. termy:action:: NextTerminal

   Changes the :term:`active terminal` to the next terminal in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: NoteFirst

   Selects the first annotation in the :doc:`Annotations tool <tools/annotations>`.

.. termy:action:: NoteLast

   Selects the last annotation in the :doc:`Annotations tool <tools/annotations>`.

.. termy:action:: NoteNext

   Selects the note annotation in the :doc:`Annotations tool <tools/annotations>`, or the first note if there is no current selection.

.. termy:action:: NotePrevious

   Selects the previous annotation in the :doc:`Annotations tool <tools/annotations>`, or the last note if there is no current selection.

.. termy:action:: NoteSearch

   Opens and focuses the search bar within the :doc:`Annotations tool <tools/annotations>`.

.. termy:action:: NoteSearchReset

   Clears the current search within the :doc:`Annotations tool <tools/annotations>`.

.. termy:action:: NotifySend Summary Body

   Sends a desktop notification with the given :termy:param:`Summary` and :termy:param:`Body` using the :command:`notify-send` command provided by `libnotify <https://developer.gnome.org/libnotify/>`_ (which must be present on the local machine). Ensure that :termy:param:`Summary` and :termy:param:`Body` do not contain vertical bar (\|) characters.

   This action exists to allow :doc:`custom actions <plugins/action>` and :doc:`alerts <settings/alert>` to send desktop notifications.

.. termy:action:: OpenConnection ConnName

   Initiates a task to open the saved :doc:`connection <settings/connection>` with name :termy:param:`ConnName`.

   Refer to :doc:`settings/connection` for more information on connections.

.. termy:action:: OpenDesktopUrl Url

   Launch the given :termy:param:`Url` via the local desktop environment, specifically by calling `QDesktopServices::openUrl <http://doc.qt.io/qt-5/qdesktopservices.html#openUrl>`_. The application launched will depend on the desktop environment and its configuration.

   See :termy:action:`OpenUrl` for a way to open URL's using arbitrary :doc:`launchers <settings/launcher>`.

.. termy:action:: OpenFile LauncherName ServerId RemotePath Substitutions

   Opens the file named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>` using the specified :doc:`launcher <settings/launcher>`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used.

   :termy:param:`LauncherName` is interpreted as follows:

     * If empty, the :term:`default launcher` is used.
     * If set to the string ``<Prompt>``, a dialog box will be opened where the user can choose a launcher.
     * Otherwise, the launcher with the given name.

   :termy:param:`RemotePath` will be substituted into the launcher's :termy:launcher:`command <Command/Command>` at the location of the ``%f`` marker (other markers are also supported, refer to :doc:`settings/launcher` for more information). Custom markers may also be substituted within the command using the :termy:param:`Substitutions` parameter, which consists of zero or more strings of the form ``X=value`` separated by unit separator (``0x1f``) characters. ``X`` is the marker's letter and ``value`` is the string (treated as a single word) to substitute at the location of ``%X`` within the command.

   Depending on the configuration of the launcher and whether the server is :term:`local <local server>` or remote, any of the following may occur in order to handle the request:

     * A remote file may be mounted locally as in :termy:action:`MountFile`.
     * A desktop application may be launched as in :termy:action:`OpenDesktopUrl`.
     * A command may be run as in :termy:action:`RunCommand`.
     * A terminal may be opened to run a command as in :termy:action:`CommandTerminal`.
     * A command string may be written to the active terminal using :termy:action:`WriteText`.

   Refer to :doc:`settings/launcher` for more information on launchers.

.. termy:action:: OpenTaskDirectory LauncherName TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, opens the enclosing directory of that file on the :term:`local server` using the specified :doc:`launcher <settings/launcher>` as in :termy:action:`OpenFile`.

   :termy:param:`LauncherName` is interpreted as follows:

     * If empty, the launcher set in the :termy:global:`Tasks/PreferredDirectoryLauncher` global setting.
     * If set to the string ``<Desktop>``, the enclosing directory will be opened as a ``file://`` URL via the local desktop environment as in :termy:action:`OpenDesktopUrl`.
     * Otherwise, the launcher with the given name.

.. termy:action:: OpenTaskFile LauncherName TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, opens that file on the :term:`local server` using the specified :doc:`launcher <settings/launcher>` as in :termy:action:`OpenFile`.

   :termy:param:`LauncherName` is interpreted as follows:

     * If empty, the launcher set in the :termy:global:`Tasks/PreferredFileLauncher` global setting.
     * If set to the string ``<Desktop>``, the file will be opened as a ``file://`` URL via the local desktop environment as in :termy:action:`OpenDesktopUrl`.
     * Otherwise, the launcher with the given name.

.. termy:action:: OpenTaskTerminal ProfileName TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, creates a new terminal on the :term:`local server`, with the starting directory set to the enclosing directory of that file. The file's path will also be printed to the terminal as the :termy:profile:`starting message <Emulator/StartingMessage>`.

   :termy:param:`ProfileName` is interpreted as follows:

     * If empty, the profile set in the :termy:global:`Tasks/PreferredProfile` global setting.
     * If set to the string ``<ServerDefault>``, the :term:`local server`'s :termy:server:`default profile <Server/DefaultProfile>`.
     * If set to the string ``<Default>``, the :term:`global default profile`.
     * Otherwise, the profile with the given name.

.. termy:action:: OpenUrl LauncherName ServerId Url

   Opens :termy:param:`Url` using :termy:param:`LauncherName` and :termy:param:`ServerId` as specified in :termy:action:`OpenFile`.

   If :termy:param:`Url` is not a ``file://`` URL, only ``%u`` and ``%U`` markers will be substituted in the launcher's :termy:launcher:`command <Command/Command>`. Refer to :doc:`settings/launcher` for more information.

.. termy:action:: Paste TerminalId

   Paste the clipboard contents into the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: PasteFile TerminalId FilePath

   Paste the contents of the local file named by :termy:param:`FilePath` into the :ref:`specified terminal <terminal-lookup>`. If :termy:param:`FilePath` is empty, an open file dialog will be shown.

   Depending on the size of the input file, a task may be initiated to write the data.

.. termy:action:: PasteSelectBuffer TerminalId

   Paste the select buffer contents into the :ref:`specified terminal <terminal-lookup>`.

   Middle-click in a terminal viewport or on a terminal thumbnail performs this action.

.. termy:action:: PopProfile TerminalId

   Pops the next saved profile off the :ref:`specified terminal <terminal-lookup>`'s saved profile stack and switches the terminal to it. If the stack is empty, the :term:`global default profile` is used.

.. termy:action:: PopupCommand ServerId Cmdspec Startdir

   Initiates a task to run the command specified by :termy:param:`Cmdspec` on the :ref:`specified server <server-lookup>`, using :termy:param:`Startdir` as the starting directory for the command. :termy:param:`Cmdspec` is an executable name and argument vector (including argument zero) separated by unit separator (``0x1f``) characters. The standard output and standard error of the command are displayed in a dialog box.

   This action is a specialization of :termy:action:`LaunchCommand`.

.. termy:action:: PreviousPane

   Moves input focus to the previous split pane within the same window.

.. termy:action:: PreviousServer

   Changes the :term:`active server` to the previous server in the :doc:`Terminals tool <tools/terminals>`. The first terminal on that server is made the :term:`active terminal`.

.. termy:action:: PreviousTerminal

   Changes the :term:`active terminal` to the previous terminal in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: Prompt

   Opens a dialog box where the user can specify an action string to invoke.

.. termy:action:: PushProfile ProfileName TerminalId

   Pushes the :ref:`specified terminal <terminal-lookup>`'s current profile onto its profile stack and switches the terminal to the specified profile. If the stack is full, the profile on the bottom of the stack will be discarded to make room. The default profile stack size is 8.

   :termy:param:`ProfileName` is interpreted as in :termy:action:`SwitchProfile`

.. termy:action:: QuitApplication

   Closes all windows and exits the application. A running :term:`transient local server` will also exit and any terminals on it will be destroyed.

.. termy:action:: RaiseActiveTool

   Raises the :ref:`active tool <tools-active>`.

.. termy:action:: RaiseAnnotationsTool

   Raises the :doc:`Annotations tool <tools/annotations>` in the active window.

.. termy:action:: RaiseFilesTool

   Raises the :doc:`Files tool <tools/files>` in the active window.

.. termy:action:: RaiseHistoryTool

   Raises the :doc:`History tool <tools/history>` in the active window.

.. termy:action:: RaiseKeymapTool

   Raises the :doc:`Keymap tool <tools/keymap>` in the active window.

.. termy:action:: RaiseSearchTool

   Raises the :doc:`Search tool <tools/search>` in the active window.

.. termy:action:: RaiseSuggestionsTool

   Raises the :doc:`Suggestions tool <tools/suggestions>` in the active window.

.. termy:action:: RaiseTasksTool

   Raises the :doc:`Tasks tool <tools/tasks>` in the active window.

.. termy:action:: RaiseTerminalsTool

   Raises the :doc:`Terminals tool <tools/terminals>` in the active window.

.. termy:action:: RandomTerminalTheme SameGroup TerminalId

   Changes the :ref:`specified terminal <terminal-lookup>`'s :termy:profile:`palette <Appearance/Palette>` to that of a randomly chosen :doc:`theme <settings/theme>`. If :termy:param:`SameGroup` is ``1`` and the terminal's current palette matches a defined theme, the chosen theme will have the same :termy:theme:`group <Theme/Group>` as that theme. Otherwise, the chosen theme may be any defined theme.

.. termy:action:: RemotePortForward ServerId Spec

   Initiates a task to perform port forwarding between the application and the :ref:`specified server <server-lookup>`. The listening socket is on the remote machine and outbound connections are made on the local machine.

   :termy:param:`Spec` is as described in :termy:action:`LocalPortForward`.

.. termy:action:: RemoveNote RegionId TerminalId

   A note region is looked up using the :termy:param:`RegionId` and :termy:param:`TerminalId` parameters as follows:
     * If both are empty, the selected note in the :doc:`Annotations tool <tools/annotations>` will be used if that tool is :ref:`active <tools-active>`.
     * Otherwise, the terminal is looked up per :ref:`terminal-lookup` and :termy:param:`RegionId` is parsed as an unsigned decimal number and looked up within that terminal. :termy:param:`RegionId` must refer to an annotation.

   If the note lookup is successful, the specified note is removed.

.. termy:action:: RemoveSuggestion Index

   If :termy:param:`Index` is empty, the selected suggestion in the :doc:`Suggestions tool <tools/suggestions>` is removed from the :ref:`command history database <suggestions-database>`. Otherwise, the n\ :sup:`th` suggestion is removed, indexed from 0, specified by :termy:param:`Index`.

.. termy:action:: RemoveTasks

   Removes all completed tasks from the :doc:`Tasks tool <tools/tasks>`.

.. termy:action:: RenameFile ServerId RemotePath NewPath

   Initiates a task to rename the file or directory named by the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>` to :termy:param:`NewPath`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used. A confirmation prompt may be shown, depending on the value of the :termy:global:`RenameFileConfirmation <Files/RenameFileConfirmation>` global setting.

.. termy:action:: ReorderServerBackward ServerId

   Reorders the :ref:`specified server <server-lookup>` backward in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderServerFirst ServerId

   Reorders the :ref:`specified server <server-lookup>` first in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderServerForward ServerId

   Reorders the :ref:`specified server <server-lookup>` forward in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderServerLast ServerId

   Reorders the :ref:`specified server <server-lookup>` last in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderTerminalBackward TerminalId

   Reorders the :ref:`specified terminal <terminal-lookup>` backward in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderTerminalFirst TerminalId

   Reorders the :ref:`specified terminal <terminal-lookup>` first in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderTerminalForward TerminalId

   Reorders the :ref:`specified terminal <terminal-lookup>` forward in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ReorderTerminalLast TerminalId

   Reorders the :ref:`specified terminal <terminal-lookup>` last in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ResetAndClearTerminal TerminalId

   Resets the emulator, clears the screen, and clears the scrollback buffer of the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: ResetTerminal TerminalId

   Resets the emulator of the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: RestartTask TaskId

   If the :ref:`specified task <task-lookup>` is clonable, starts a new identical task with the same parameters as before.

.. termy:action:: RunCommand ServerId Cmdspec Startdir

   Initiates a task to run the command specified by :termy:param:`Cmdspec` on the :ref:`specified server <server-lookup>`, using :termy:param:`Startdir` as the starting directory for the command. :termy:param:`Cmdspec` is an executable name and argument vector (including argument zero) separated by unit separator (``0x1f``) characters. The standard output and standard error of the command are discarded.

   This action is a specialization of :termy:action:`LaunchCommand`.

.. termy:action:: SaveAll LocalPath TerminalId

   Saves the entire scrollback contents in the :ref:`specified terminal <terminal-lookup>` to a file. The local destination :termy:param:`LocalPath` is interpreted as follows:

     * If empty or set to the string ``<Prompt>``, a save file dialog will be shown.
     * Otherwise, the file will be saved to the specified path.

   If the destination file already exists, the file may be saved under a different name, a confirmation prompt may be shown, or nothing may be saved, depending on the value of the :termy:global:`DownloadFileConfirmation <Files/DownloadFileConfirmation>` global setting.

.. termy:action:: SaveScreen LocalPath TerminalId

   Saves the contents of a viewport or terminal screen to the clipboard. If :termy:param:`TerminalId` is set, the contents of the specified terminal's screen are saved. Otherwise, the contents of the :term:`active viewport` are saved. The local destination :termy:param:`LocalPath` is interpreted as follows:

     * If empty or set to the string ``<Prompt>``, a save file dialog will be shown.
     * Otherwise, the file will be saved to the specified path.

   Terminal screens are always saved as text. Viewport contents are saved in either text or PNG format, depending on whether the specified path ends in ``.png``.

   If the destination file already exists, the file may be saved under a different name, a confirmation prompt may be shown, or nothing may be saved, depending on the value of the :termy:global:`DownloadFileConfirmation <Files/DownloadFileConfirmation>` global setting.

.. termy:action:: ScrollLineDown

   Scrolls down one line in the :term:`active viewport`.

.. termy:action:: ScrollLineUp

   Scrolls up one line in the :term:`active viewport`.

.. termy:action:: ScrollNoteDown

   Scrolls to the next note in the :term:`active viewport`.

.. termy:action:: ScrollNoteUp

   Scrolls to the previous note in the :term:`active viewport`.

.. termy:action:: ScrollPageDown

   Scrolls down one page in the :term:`active viewport`. The page size is half the height of the viewport.

.. termy:action:: ScrollPageUp

   Scrolls up one page in the :term:`active viewport`. The page size is half the height of the viewport.

.. termy:action:: ScrollPromptDown

   Scrolls to and :term:`selects <selected prompt>` the next prompt in the :term:`active viewport`. This requires :doc:`shell integration <shell-integration>`.

.. termy:action:: ScrollPromptFirst

   Scrolls to and :term:`selects <selected prompt>` the first prompt in the :term:`active viewport`. This requires :doc:`shell integration <shell-integration>`.

.. termy:action:: ScrollPromptLast

   Scrolls to and :term:`selects <selected prompt>` the last prompt in the :term:`active viewport`. This requires :doc:`shell integration <shell-integration>`.

.. termy:action:: ScrollPromptUp

   Scrolls to and :term:`selects <selected prompt>` the previous prompt in the :term:`active viewport`. This requires :doc:`shell integration <shell-integration>`.

.. termy:action:: ScrollRegionEnd RegionId TerminalId

   Scrolls to the last line of the :ref:`specified job <job-lookup>` in the :term:`active viewport`. :termy:param:`RegionId` can refer to any region. If the region is a :term:`job region <job>`, its prompt will be :term:`selected <selected prompt>`.

.. termy:action:: ScrollRegionRelative RegionId Offset

   Scrolls :termy:param:`Offset` lines relative to the first line of the region named by :termy:param:`RegionId` in the :term:`active viewport`.

.. termy:action:: ScrollRegionStart RegionId TerminalId

   Scrolls to the first line of the :ref:`specified job <job-lookup>` in the :term:`active viewport`. :termy:param:`RegionId` can refer to any region. If the region is a :term:`job region <job>`, its prompt will be :term:`selected <selected prompt>`.

.. termy:action:: ScrollSemantic RegionId

   Scrolls to the first line of the :term:`semantic region` named by :termy:param:`RegionId` in the :term:`active viewport`. :termy:param:`RegionId` must refer to a region created by a :doc:`semantic parser <plugins/parser>`.

.. termy:action:: ScrollSemanticRelative RegionId Offset

   Scrolls :termy:param:`Offset` lines relative to the first line of the :term:`semantic region` named by :termy:param:`RegionId` in the :term:`active viewport`. :termy:param:`RegionId` must refer to a region created by a :doc:`semantic parser <plugins/parser>`.

.. termy:action:: ScrollToBottom

   Scrolls to the bottom of the scrollback in the :term:`active viewport`.

.. termy:action:: ScrollToTop

   Scrolls to the top of the scrollback in the :term:`active viewport`.

.. termy:action:: SearchDown

   Searches down in the :term:`active viewport` using the current search string in the :doc:`Search tool <tools/search>`. The search is started from the location of the current search match if present, otherwise from the top of the viewport.

.. termy:action:: SearchReset

   Clears the current search in the :doc:`Search tool <tools/search>`. Input focus remains in the search bar if it has focus.

.. termy:action:: SearchUp

   Searches up in the :term:`active viewport` using the current search string in the :doc:`Search tool <tools/search>`. The search is started from the location of the current search match if present, otherwise from the bottom of the viewport.

.. termy:action:: SelectAll

   Selects the contents of the :term:`active viewport`.

.. termy:action:: SelectCommand RegionId TerminalId

   Scrolls to and selects the command text of the :ref:`specified job <job-lookup>` in the :term:`active viewport`. The job's prompt will be :term:`selected <selected prompt>`.

.. termy:action:: SelectHandle Arg

   If :termy:param:`Arg` is nonzero, makes the :ref:`specified selection handle <selection-handle-lookup>` active. If :termy:param:`Arg` is zero, swaps the active selection handle if one is active, otherwise makes the lower selection handle active.

.. termy:action:: SelectHandleBackChar Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` back one character. The upper selection handle is moved by default.

.. termy:action:: SelectHandleBackWord Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` back one word. The upper selection handle is moved by default.

.. termy:action:: SelectHandleDownLine Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` down one line. The lower selection handle is moved by default.

.. termy:action:: SelectHandleForwardChar Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` forward one character. The upper selection handle is moved by default.

.. termy:action:: SelectHandleForwardWord Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` forward one word. The lower selection handle is moved by default.

.. termy:action:: SelectHandleUpLine Arg

   Moves the :ref:`specified selection handle <selection-handle-lookup>` up one line. The upper selection handle is moved by default.

.. termy:action:: SelectJob RegionId TerminalId

   Scrolls to and selects the entire text of the :ref:`specified job <job-lookup>` in the :term:`active viewport`. The job's prompt will be :term:`selected <selected prompt>`.

.. termy:action:: SelectLine Arg

   If no selection is active, equivalent to :termy:action:`SelectMoveUpLine`. Otherwise:

     * If :termy:param:`Arg` is 1, the upper selection handle is moved to the beginning of the line.
     * If :termy:param:`Arg` is 2, the lower selection handle is moved to the end of the line.
     * If :termy:param:`Arg` is 0 or unset, both handles are moved as described.

.. termy:action:: SelectMoveBackWord

   If no selection is active, first calls :termy:action:`SelectMoveUpLine`.

   The active selection is moved to the previous word within the line.

.. termy:action:: SelectMoveDownLine

   If no selection is active, selects the first non-empty line below the top of the :term:`active viewport`. Otherwise, moves the selection to the next non-empty line below the current selection.

.. termy:action:: SelectMoveForwardWord

   If no selection is active, first calls :termy:action:`SelectMoveDownLine`.

   The active selection is moved to the next word within the line.

.. termy:action:: SelectMoveUpLine

   If no selection is active, selects the first non-empty line above the last line of the :term:`active viewport`. Otherwise, moves the selection to the next non-empty line above the current selection.

.. termy:action:: SelectOutput RegionId TerminalId

   Scrolls to and selects the output text of the :ref:`specified job <job-lookup>` in the :term:`active viewport`. The job's prompt will be :term:`selected <selected prompt>`.

.. termy:action:: SelectScreen

   Selects the entire contents of the :term:`active viewport`.

.. termy:action:: SelectWord Index

   If no selection is active, first calls :termy:action:`SelectMoveUpLine`.

   The selection is moved to the n\ :sup:`th` word on the line, indexed from 0, specified by :termy:param:`Index`.

.. termy:action:: SendMonitorInput ServerId Message

   Sends :termy:param:`Message` to the :doc:`attribute monitor <man/monitor>` associated with the :ref:`specified server <server-lookup>`. The attribute monitor may respond by setting server :term:`attributes <attribute>` which can be displayed in :termy:profile:`badge strings <Appearance/Badge>` and other :termy:global:`format strings <Appearance/TerminalThumbnailCaption>`.

   As an example, the attribute monitor distributed with termy-server will respond to the input string "loadavg" by reporting the system load average in the ``loadavg`` attribute. Refer to :doc:`man/monitor` for more information.

.. termy:action:: SendSignal Signal TerminalId

   Sends signal number :termy:param:`Signal` to the foreground process group in the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: SetAlert AlertName TerminalId

   Makes the specified :doc:`alert <settings/alert>` active in the :ref:`specified terminal <terminal-lookup>`. If an alert is already active in the terminal, it is replaced by the new alert.

   :termy:param:`AlertName` is interpreted as follows:

     * If set to the string ``<Prompt>``, a dialog box will be opened where the user can choose an alert.
     * Otherwise, the alert with the given name.

.. termy:action:: SetFileListingFormat Format

   Changes the display format in the :doc:`Files tool <tools/files>`. :termy:param:`Format` is interpreted as follows:

     * 1: long format (similar to :command:`ls -l`) is used.
     * 2: short format (similar to :command:`ls`) is used.
     * 0 or unset: the :termy:profile:`FileDisplayFormat <Files/FileDisplayFormat>` profile setting is used.

.. termy:action:: SetFileListingSort Spec

   Sorts the files in the :doc:`Files tool <tools/files>` on column number :termy:param:`Spec`. If :termy:param:`Spec` is negative, the sort is descending, otherwise it is ascending. The column numbers are:

     * 1: mode
     * 2: user
     * 3: group
     * 4: size
     * 5: modification time
     * 6: git status
     * 7: name

.. termy:action:: SetSelectedUrl Url

   Sets the selected URL in the :term:`active viewport` to :termy:param:`Url`. Any :term:`semantic regions <semantic region>` in the viewport which have the same URL will be highlighted. If :termy:param:`Url` is a ``file://`` URL, that file will be selected in the :doc:`Files tool <tools/files>`, which makes it the default target for file-related actions such as :termy:action:`DownloadFile`. If :termy:param:`Url` is empty, the selected URL will be cleared.

   Clicking on a semantic region performs this action with the semantic region's URL.

.. termy:action:: SetServerIcon Icon ServerId

   Sets the thumbnail icon for the :ref:`specified server <server-lookup>` in the :doc:`Terminals tool <tools/terminals>` to :termy:param:`Icon`. If :termy:param:`Icon` is empty, the icon will revert to the string specified by the ``icon`` server :term:`attribute`. Otherwise, an SVG file with the given name is loaded from :file:`{$HOME}/.local/share/qtermy/images/server` or :file:`{prefix}/share/qtermy/images/server` in that order. If no such file is found, the name "default" is used instead. The name "none" specifies an empty icon.

   A custom icon can be set on a server automatically using the :termy:server:`FixedThumbnailIcon <Appearance/FixedThumbnailIcon>` server setting.

.. termy:action:: SetTerminalIcon Icon TerminalId

   Sets the thumbnail icon for the :ref:`specified terminal <terminal-lookup>` in the :doc:`Terminals tool <tools/terminals>` to :termy:param:`Icon`. If :termy:param:`Icon` is empty, the icon will revert to using the :doc:`icon autoswitch rules <dialogs/icon-rule-editor>`. Otherwise, an SVG file with the given name is loaded from :file:`{$HOME}/.local/share/qtermy/images/terminal` and :file:`{prefix}/share/qtermy/images/terminal` in that order. If no such file is found, the name "default" is used instead. The name "none" specifies an empty icon.

   A custom icon can be set on a terminal automatically using the :termy:server:`FixedThumbnailIcon <Appearance/FixedThumbnailIcon>` profile setting. Note that an icon is never shown if :termy:profile:`ShowThumbnailIcon <Appearance/ShowThumbnailIcon>` is disabled in the :doc:`profile <settings/profile>`.

.. termy:action:: SetupTasks

   Opens the :doc:`Setup Tasks dialog <dialogs/setup-tasks>`.

.. termy:action:: ShowMenuBar

   Shows the menu bar in the active window, if hidden.

.. termy:action:: ShowServer ServerId

   In the active window, shows all hidden terminals belonging to the :ref:`specified server <server-lookup>` in the :doc:`Terminals tool <tools/terminals>`.

.. termy:action:: ShowTerminal TerminalId

   In the active window, shows the :ref:`specified terminal <terminal-lookup>` in the :doc:`Terminals tool <tools/terminals>`, if it is hidden.

.. termy:action:: SplitViewClose

   In the active window, closes the focused split window pane unless it is the only remaining pane.

.. termy:action:: SplitViewCloseOthers

   In the active window, closes all split window panes other than the focused pane.

.. termy:action:: SplitViewEqualize

   In the active window, equalizes the focused split window pane with its companion.

.. termy:action:: SplitViewEqualizeAll

   In the active window, calls :termy:action:`SplitViewEqualize` on all split window panes.

.. termy:action:: SplitViewExpand

   In the active window, expands the size of the focused split window pane relative to its companion.

.. termy:action:: SplitViewHorizontal

   In the active window, splits the focused split window pane horizontally into two companion panes, one above the other. The resize handle between the panes can be used to adjust the relative sizes of the two panes.

.. termy:action:: SplitViewHorizontalFixed

   In the active window, splits the focused split window pane horizontally into two companion panes, one above the other. No resize handle is placed between the panes. However, :termy:action:`SplitViewExpand` and :termy:action:`SplitViewShrink` can be still be used to adjust the relative sizes of the two panes.

.. termy:action:: SplitViewQuadFixed

   In the active window, splits the focused split window pane into four panes using one call to :termy:action:`SplitViewHorizontalFixed` followed by two calls to :termy:action:`SplitViewVerticalFixed`.

.. termy:action:: SplitViewShrink

   In the active window, reduces the size of the focused split window pane relative to its companion.

.. termy:action:: SplitViewVertical

   Like :termy:action:`SplitViewHorizontal` except the panes are split vertically, one next to the other.

.. termy:action:: SplitViewVerticalFixed

   Like :termy:action:`SplitViewHorizontalFixed` except the panes are split vertically, one next to the other.

.. termy:action:: SuggestFirst

   Selects the first suggestion in the :doc:`Suggestions tool <tools/suggestions>`.

.. termy:action:: SuggestLast

   Selects the last suggestion in the :doc:`Suggestions tool <tools/suggestions>`.

.. termy:action:: SuggestNext

   Selects the next suggestion in the :doc:`Suggestions tool <tools/suggestions>`, or the first suggestion if there is no current selection.

.. termy:action:: SuggestPrevious

   Selects the previous suggestion in the :doc:`Suggestions tool <tools/suggestions>`, or the last suggestion if there is no current selection.

.. termy:action:: SwitchPane PaneIndex

   Moves input focus to the n\ :sup:`th` pane within the same window, indexed from 0. Note that pane index numbers displayed in :termy:global:`viewports <Appearance/ShowMainIndex>` and :termy:global:`thumbnails <Appearance/ShowThumbnailIndex>` are indexed from 1.

.. termy:action:: SwitchProfile ProfileName TerminalId

   Switches the :ref:`specified terminal <terminal-lookup>`'s to the specified profile. :termy:param:`ProfileName` is interpreted as follows:

     * If empty, the :term:`global default profile`.
     * If set to the string ``<Prompt>``, a dialog box will be opened where the user can choose a profile.
     * Otherwise, the profile with the given name.

.. termy:action:: SwitchServer ServerId PaneIndex

   Makes the :ref:`specified server <server-lookup>` the :term:`active server`. If :termy:param:`PaneIndex` is empty, the first terminal on that server is made the :term:`active terminal`.  Otherwise, changes the terminal in the n\ :sup:`th` pane, indexed from 0, to the first terminal on that server, making it the :term:`active terminal` if that pane has input focus.

.. termy:action:: SwitchTerminal TerminalId PaneIndex

   If :termy:param:`PaneIndex` is empty, the :ref:`specified terminal <terminal-lookup>` is made the :term:`active terminal`. Otherwise, changes the terminal in the n\ :sup:`th` pane, indexed from 0, to the specified terminal, making it the :term:`active terminal` if that pane has input focus.

.. termy:action:: TakeTerminalOwnership TerminalId

   Takes ownership of the :ref:`specified terminal <terminal-lookup>`. This has the following effects:

     * The terminal's native size will be changed to fit the :term:`active viewport`. Other clients will see the terminal at this size and will not be able to resize the terminal nor :ref:`adjust <adjust-scrollback>` the scrollback buffer size.
     * The local :termy:global:`Avatar <Inline/Avatar>` image will be displayed in other :program:`qtermy` clients that have :termy:global:`RenderAvatars <Inline/RenderAvatars>` enabled.
     * Input to the terminal from other clients can be disallowed using the :termy:profile:`AllowRemoteInput <Collaboration/AllowRemoteInput>` profile setting and the :termy:action:`ToggleTerminalRemoteInput` action. But see warning below about security.
     * If :termy:profile:`enabled <Collaboration/ResetRemoteOnTakingOwnership>`, all profile settings associated with the current :termy:doc:`profile <settings/profile>` will be pushed to the server as terminal :term:`attributes <attribute>`. Other clients may :termy:action:`extract <ExtractProfile>` their own profile from these settings. Only the owning client is allowed to set these attributes.
     * The terminal's :termy:profile:`palette <Appearance/Palette>`, :termy:profile:`font <Appearance/Font>`, :termy:profile:`layout <Appearance/WidgetLayout>`, :termy:profile:`fills <Appearance/ColumnFills>`, and :termy:profile:`badge <Appearance/Badge>` (including any per-terminal adjustments) will be pushed to the server as terminal :term:`attributes <attribute>`. Other clients may honor these settings (in :program:`qtermy` this is controlled via :ref:`profile settings <profile-collaboration>`). Only the owning client is allowed to set these attributes.
     * The active viewport's scrollback position and :ref:`timing origin <timing-widget>` will be pushed to the server as terminal :term:`attributes <attribute>`. Other clients may honor this information (in :command:`qtermy`, this is controlled via the :termy:profile:`FollowRemoteScrolling <Collaboration/FollowRemoteScrolling>` profile setting and the :termy:action:`ToggleTerminalFollowing` action). Only the owning client is allowed to set these attributes.

   .. warning:: **Terminal ownership is not a security mechanism**. Any client connected to a server can take ownership of a terminal at any time.

.. termy:action:: TaskFirst

   Selects the first task in the :doc:`Tasks tool <tools/tasks>`.

.. termy:action:: TaskLast

   Selects the last task in the :doc:`Tasks tool <tools/tasks>`.

.. termy:action:: TaskNext

   Selects the next task in the :doc:`Tasks tool <tools/tasks>`, or the first task if there is no current selection.

.. termy:action:: TaskPrevious

   Selects the previous task in the :doc:`Tasks tool <tools/tasks>`, or the last task if there is no current selection.

.. termy:action:: TerminalContextMenu

   Brings up the context menu for the :term:`active viewport`.

.. termy:action:: TimingFloatOrigin

   Floats the timing origin in the :ref:`Timing widget <timing-widget>`. When the origin is floating, timing measurements are shown relative to the start of the :term:`current job`.

.. termy:action:: TipOfTheDay

   Opens the application Tip of the Day window. The tips shown in it are generated by a dedicated :doc:`plugin feature <plugins/totd>`.

.. termy:action:: ToggleAnnotationsTool

   Toggles the :doc:`Annotations tool <tools/annotations>` in the active window.

.. termy:action:: ToggleCommandMode Arg

   :termy:param:`Arg` is interpreted as follows:

     * 0 or empty: toggles :ref:`command mode <keymap-modes>`.
     * 1: enables command mode.
     * 2: disables command mode.

.. termy:action:: ToggleFileListingFormat

   Toggles the :termy:action:`display format <SetFileListingFormat>` in the :doc:`Files tool <tools/files>` between short and long format.

.. termy:action:: ToggleFilesTool

   Toggles the :doc:`Files tool <tools/files>` in the active window.

.. termy:action:: ToggleFullScreen

   Toggles full screen mode.

.. termy:action:: ToggleHistoryTool

   Toggles the :doc:`History tool <tools/history>` in the active window.

.. termy:action:: ToggleKeymapTool

   Toggles the :doc:`Keymap tool <tools/keymap>` in the active window.

.. termy:action:: ToggleMenuBar

   Toggles display of the menu bar in the active window.

.. termy:action:: TogglePresentationMode

   Toggles presentation mode. Upon entering presentation mode, the applicable :ref:`global settings <global-presentation-mode>` will be applied.

.. termy:action:: ToggleSearchTool

   Toggles the :doc:`Search tool <tools/search>` in the active window.

.. termy:action:: ToggleSelectionMode Arg

   :termy:param:`Arg` is interpreted as follows:

     * 0 or empty: toggles :ref:`selection mode <keymap-modes>`. Treated as 1 if selection mode is disabled, 2 if selection mode is enabled.
     * 1: enables selection mode. If there is no active text selection, calls :termy:action:`SelectMoveUpLine` to create one.
     * 2: disables selection mode. Clears any active text selection.

.. termy:action:: ToggleServer ServerId

   If any terminals belonging to the :ref:`specified server <server-lookup>` are hidden, calls :termy:action:`ShowServer` on that server. Otherwise, calls :termy:action:`HideServer` on that server.

.. termy:action:: ToggleSoftScrollLock TerminalId

   Toggles soft scroll lock in the :ref:`specified terminal <terminal-lookup>`. When soft scroll lock is enabled, the server stops reading output from the terminal.

   This differs from hard scroll lock, which is the result of sending a STOP character (normally DC3, Ctrl+S) to the terminal driver. Hard scroll lock can be undone using the START character (normally DC1, Ctrl+Q). Refer to :manpage:`termios(3)` for more information.

.. termy:action:: ToggleStatusBar

   Toggles display of the status bar in the active window.

.. termy:action:: ToggleSuggestionsTool

   Toggles the :doc:`Suggestions tool <tools/suggestions>` in the active window.

.. termy:action:: ToggleTasksTool

   Toggles the :doc:`Tasks tool <tools/tasks>` in the active window.

.. termy:action:: ToggleTerminalFollowing

   Toggles remote viewport following in the :term:`active viewport`. If enabled, and the terminal is :termy:action:`owned <TakeTerminalOwnership>` by another client, the active viewport's scrollback position and :ref:`timing origin <timing-widget>` will track the information reported by the owning client. The default value for this option is set via the :termy:profile:`FollowRemoteScrolling <Collaboration/FollowRemoteScrolling>` profile setting.

.. termy:action:: ToggleTerminalLayout Item TerminalId

   Toggles display of the specified :doc:`widget <widgets>` in the :ref:`specified terminal <terminal-lookup>`. :termy:param:`Item` is interpreted as follows:

     * 1: :ref:`Marks <marks-widget>`
     * 2: :ref:`Minimap <minimap-widget>`
     * 3: :ref:`Scrollbar <scrollbar-widget>`
     * 4: :ref:`Timing <timing-widget>`

.. termy:action:: ToggleTerminalRemoteInput TerminalId

   Toggles remote input in the :term:`active terminal`. If disabled, and the terminal is :termy:action:`owned <TakeTerminalOwnership>` by this client, input from other clients is not permitted. The default value for this option is set via the :termy:profile:`AllowRemoteInput <Collaboration/AllowRemoteInput>` profile setting.

   .. warning:: **This is not a security mechanism**. Any client connected to a server can take ownership of a terminal at any time. This option is intended to prevent inadvertent input from other users.

.. termy:action:: ToggleTerminalsTool

   Toggles the :doc:`Terminals tool <tools/terminals>` in the active window.

.. termy:action:: ToggleToolSearchBar

   Toggles display of the search bar in the :ref:`active tool <tools-active>` if it supports search. To both show and focus the search bar, use :termy:action:`ToolSearch`.

.. termy:action:: ToggleToolTableHeader

   Toggles display of table column headers in the :ref:`active tool <tools-active>`, if applicable.

.. termy:action:: ToolAction Index

   Calls the action configured in the per-tool :doc:`global settings <settings/global>` and specified by :termy:param:`Index` on the selected item in the :ref:`active tool <tools-active>`.

   :termy:param:`Index` is interpreted as follows:

     * 0 or empty: calls the configured double-click action.
     * 1: calls the configured Control-click action.
     * 2: calls the configured Shift-click action.
     * 3: calls the configured middle-click action.

.. termy:action:: ToolContextMenu

   Brings up the context menu for the selected item in the :ref:`active tool <tools-active>`.

.. termy:action:: ToolFilterAddServer ServerId

   Makes the :ref:`specified server <server-lookup>` visible in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools.

.. termy:action:: ToolFilterAddTerminal TerminalId

   Makes the :ref:`specified terminal <terminal-lookup>` visible in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools.

.. termy:action:: ToolFilterExcludeServer ServerId

   Filters out the :ref:`specified server <server-lookup>` in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools. If :termy:param:`ServerId` is empty, the selected server in the :ref:`active tool <tools-active>` is used.

.. termy:action:: ToolFilterExcludeTerminal TerminalId

   Filters out the :ref:`specified terminal <terminal-lookup>` in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools. If :termy:param:`TerminalId` is empty, the selected terminal in the :ref:`active tool <tools-active>` is used.

.. termy:action:: ToolFilterIncludeNothing

   Filters out everything in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools.

.. termy:action:: ToolFilterRemoveClosed

   Removes closed terminals from the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools.

.. termy:action:: ToolFilterReset

   Resets the filter, making everything visible in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools.

.. termy:action:: ToolFilterSetServer ServerId

   Filters out all but the :ref:`specified server <server-lookup>` in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools. If :termy:param:`ServerId` is empty, the selected server in the :ref:`active tool <tools-active>` is used.

.. termy:action:: ToolFilterSetTerminal TerminalId

   Filters out all but the :ref:`specified terminal <terminal-lookup>` in the :doc:`History <tools/history>`, :doc:`Annotations <tools/annotations>`, and :doc:`Tasks <tools/tasks>` tools. If :termy:param:`TerminalId` is empty, the selected terminal in the :ref:`active tool <tools-active>` is used.

.. termy:action:: ToolFirst

   Selects the first item in the :ref:`active tool <tools-active>`.

.. termy:action:: ToolLast

   Selects the last item in the :ref:`active tool <tools-active>`.

.. termy:action:: ToolNext

   Selects the next item in the :ref:`active tool <tools-active>`, or the first item if there is no current selection.

.. termy:action:: ToolPrevious

   Selects the previous item in the :ref:`active tool <tools-active>`, or the last item if there is no current selection.

.. termy:action:: ToolSearch

   Shows and focuses the search bar in the :ref:`active tool <tools-active>` if it is a :ref:`searchable tool <tools-searchable>`. Pressing Return or Escape in the search bar will return focus to the terminal viewport. To hide the search bar, press Escape while the search bar has input focus, click the close button next to the search bar or use :termy:action:`ToggleToolSearchBar`.

.. termy:action:: ToolSearchReset

   Clears the current search within the :ref:`active tool <tools-active>`.

.. termy:action:: UndoAllAdjustments

   Calls :termy:action:`UndoTerminalAdjustments` for all terminals.

.. termy:action:: UndoTerminalAdjustments TerminalId

   In the :ref:`specified terminal <terminal-lookup>`, undoes any adjustments made using the :doc:`Adjustment dialogs <dialogs/adjust-dialogs>` (except scrollback size changes) as well as the :termy:action:`IncreaseFont`, :termy:action:`DecreaseFont`, and :termy:action:`RandomTerminalTheme` actions. The settings revert to those specified in the terminal's :doc:`profile <settings/profile>`.

.. termy:action:: UploadFile ServerId RemotePath LocalPath

   Initiates a task to upload a file from :termy:param:`LocalPath` on the local machine to the absolute path :termy:param:`RemotePath` on the :ref:`specified server <server-lookup>`. If :termy:param:`RemotePath` is empty, the selected file in the :doc:`Files tool <tools/files>` is used. If :termy:param:`LocalPath` is empty, an open file dialog will be shown.

   If :termy:param:`RemotePath` ends in a slash or is known to be a directory, the local filename is appended to it to form the destination path.

   If the destination file already exists, the file may be saved under a different name, a confirmation prompt may be shown, or the task may fail, depending on the value of the :termy:global:`UploadFileConfirmation <Files/UploadFileConfirmation>` global setting.

   Uploads to :term:`local servers <local server>` are not allowed unless the :termy:global:`LocalDownloads <Server/LocalDownloads>` global setting is enabled.

.. termy:action:: UploadToDirectory ServerId RemoteDir LocalPath

   Like :termy:action:`UploadFile`, but always assumes that the destination path :termy:param:`RemoteDir` is a directory. The local filename is appended to it to form the destination path.

.. termy:action:: ViewServerInfo ServerId

   Opens the :doc:`View Server Information window <dialogs/view-information>` for the :ref:`specified server <server-lookup>`.

.. termy:action:: ViewTerminalContent ContentId TerminalId

   Opens the :doc:`View Terminal Information window <dialogs/view-information>` for the :ref:`specified terminal <terminal-lookup>`, and changes to the Inline Content tab.

.. termy:action:: ViewTerminalInfo TerminalId

   Opens the :doc:`View Terminal Information window <dialogs/view-information>` for the :ref:`specified terminal <terminal-lookup>`.

.. termy:action:: WriteCommand RegionId TerminalId

   Calls :termy:action:`WriteText` on the :ref:`specified terminal <terminal-lookup>` with the :ref:`specified job <job-lookup>`'s command text.

.. termy:action:: WriteCommandNewline RegionId TerminalId

   Calls :termy:action:`WriteCommand`, then writes a newline character.

   .. warning:: This may result in a command being run without opportunity for review. Use this action with caution.

.. termy:action:: WriteDirectoryPath DirPath

   If :termy:param:`DirPath` is empty, the enclosing directory path of the selected file in the :doc:`Files tool <tools/files>` is written to the :term:`active terminal`. Otherwise, :termy:param:`DirPath` is written. The path is enclosed in single quotes when written.

.. termy:action:: WriteFilePath FilePath

   If :termy:param:`FilePath` is empty, the path of the selected file in the :doc:`Files tool <tools/files>` is written to the :term:`active terminal`. Otherwise, :termy:param:`FilePath` is written. The path is enclosed in single quotes when written.

.. termy:action:: WriteSelection

   Writes the selected text in the :term:`active terminal` back to the active terminal. If :ref:`selection mode <keymap-modes>` is active and :termy:global:`ExitSelectModeOnCopy <Command/ExitSelectModeOnWrite>` is enabled, the selection will be cleared following the write.

.. termy:action:: WriteSelectionNewline

   Calls :termy:action:`WriteSelection`, then writes a newline character.

   .. warning:: This may result in a command being run without opportunity for review. Use this action with caution.

.. termy:action:: WriteSuggestion Index

   If :termy:param:`Index` is empty, the selected suggestion in the :doc:`Suggestions tool <tools/suggestions>` is written to the :term:`active terminal` using :termy:action:`WriteText`. Otherwise, the n\ :sup:`th` suggestion is written, indexed from 0, specified by :termy:param:`Index`.

.. termy:action:: WriteSuggestionNewline Index

   Calls :termy:action:`WriteSuggestion`, then writes a newline character.

   .. warning:: This may result in a command being run without opportunity for review. Use this action with caution.

.. termy:action:: WriteTaskDirectoryPath TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, writes the enclosing directory path of that file to the :term:`active terminal`. The path is enclosed in single quotes when written.

.. termy:action:: WriteTaskFilePath TaskId

   If the :ref:`specified task <task-lookup>` has a local output file associated with it, writes the path of that file to the :term:`active terminal`. The path is enclosed in single quotes when written.

.. termy:action:: WriteText Text TerminalId

   Writes :termy:param:`Text` to the :ref:`specified terminal <terminal-lookup>`. With :doc:`shell integration <shell-integration>` enabled, if the terminal has an active prompt and characters have been typed at the prompt, KILL or backspace characters will be written ahead of :termy:param:`Text` in order to clear those characters.

   Note that characters appearing after the cursor at an active prompt will generally *not* be cleared by KILL or backspace, and without shell integration, no characters will be cleared.

.. termy:action:: WriteTextNewline Text TerminalId

   Calls :termy:action:`WriteText`, then writes a newline character.

   .. warning:: This may result in a command being run without opportunity for review. Use this action with caution.
