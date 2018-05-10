.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Global
======

The global settings object is a singleton stored at :file:`{$HOME}/.config/qtermy/qtermy.conf`. Global settings can be edited from the View menu or by calling the :termy:action:`EditGlobalSettings` action. The file can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files.

.. contents:: Settings Categories
   :local:

General
-------

.. termy:global:: Global/LogThreshold enumeration

   Specifies which severity level of log message will automatically show the :doc:`../dialogs/event-log`.

.. termy:global:: Global/LogToSystem boolean

   If enabled, log messages will be sent to the default Qt logging handler in addition to the :doc:`../dialogs/event-log`.

.. termy:global:: Global/RestoreGeometry boolean

   If enabled, the information described in :termy:global:`SaveGeometry <Global/SaveGeometry>` is restored when an application window is opened to the value it had when the window was last closed with :termy:global:`SaveGeometry <Global/SaveGeometry>` enabled or the :termy:global:`SaveGeometryNow <Global/SaveGeometryNow>` button was pressed.

.. termy:global:: Global/SaveGeometry boolean

   If enabled, the following information is saved when an application window is closed. It will be restored when the same number of windows are reopened if :termy:global:`RestoreGeometry <Global/RestoreGeometry>` is enabled. The saved information is stored in the :doc:`State settings <state>` in an opaque format.

     * The size and position of the window and dockable widgets within it.
     * The layout of split view panes within the window.
     * For each pane, the ID and profile name of the terminal within the pane.
     * For each pane, the scrollback position, :ref:`Timing widget <timing-widget>` origin, and :term:`selected job` of each viewport that has been created in that pane.

   When restoring the saved settings, the application will try to match viewports and terminals as closely as possible. For example, if the saved terminal for a pane cannot be found by its ID, but an unassigned terminal with the same profile name exists, it will be substituted.

.. termy:global:: Global/SaveGeometryNow none

   A button that causes the information described in :termy:global:`SaveGeometry <Global/SaveGeometry>` to be saved immediately for all application windows.

.. termy:global:: Global/RestoreOrder boolean

   If enabled, the ordering and shown/hidden status of terminals within the :doc:`Terminals tool <../tools/terminals>` will be restored to the values they had when the window was last closed with :termy:global:`SaveOrder <Global/SaveOrder>` enabled or the :termy:global:`SaveOrderNow <Global/SaveOrderNow>` button was pressed.

.. termy:global:: Global/SaveOrder boolean

   If enabled, the ordering and shown/hidden status of terminals within the :doc:`Terminals tool <../tools/terminals>` is saved when an application window is closed. It will be restored when the same number of windows are reopened if :termy:global:`RestoreOrder <Global/RestoreOrder>` is enabled. The saved information is stored in the :doc:`State settings <state>` in an opaque format.

.. termy:global:: Global/SaveOrderNow none

   A button that causes the information described in :termy:global:`SaveOrder <Global/SaveOrder>` to be saved immediately for all application windows.

.. termy:global:: Global/ProfileMenuSize integer

   The number of items to show in dynamic item chooser menus such as the Switch Profile menu, in which :doc:`settings objects <../settings/index>` or icons are displayed for the user to select from.

.. termy:global:: Global/DocumentationRoot string

   The root URL used by the application to access :doc:`this documentation <../index>`. Setting an empty string and restarting the application will restore the default value.

   .. tip:: Save a `copy <https://termysequence.io/releases/>`_ of this documentation to your hard drive, then set this setting to its ``file://`` URL to get instant page loads and offline availability.

   .. note:: This setting requires an application restart to take effect.

.. termy:global:: Global/IconTheme string

   The name of an icon theme directory located under :file:`{prefix}/share/qtermy/icons`, or ``none`` to disable icons. Icons are shown within menu entries and in windows and dialog boxes. This setting does not affect images loaded from :file:`{prefix}/share/qtermy/images` which are shown in terminal thumbnails.

   .. note:: This setting requires an application restart to take effect.

Server
------

.. termy:global:: Server/LaunchTransient boolean

   If enabled, a :term:`transient local server` is launched by the application on startup.

.. termy:global:: Server/LaunchPersistent boolean

   If enabled, a connection to the :term:`persistent user server` is made by the application on startup, launching it if it's not already running.

.. termy:global:: Server/PreferTransient boolean

   If enabled, the :term:`transient local server` is preferred over the :term:`persistent user server` for creating new local terminals and running local tasks. Note that if only one of the two servers is connected, it will be used as the :term:`local server` regardless of the value of this setting.

.. termy:global:: Server/CloseConnectionsWindowOnLaunch boolean

   If enabled, the :doc:`Manage Connections window <../dialogs/manage-connections>` will close when a :doc:`connection <../settings/connection>` is launched from within it.

.. termy:global:: Server/AutoQuit boolean

   If enabled, the application will exit when the last terminal is closed.

.. termy:global:: Server/PopulateTime integer

   The number of milliseconds that the application should wait after a server connection has been made for all of the server's existing terminals to be reported. At connection time, the server reports how many terminals it has, followed the by information for each terminal. The information on existing terminals is used in the :termy:global:`Global/RestoreGeometry` logic to restore the previous appearance of the application. Normally the terminal information arrives immediately, but a very slow connection might cause it to arrive late. A race condition also exists where a terminal might be closed between the time that the server reports the number of existing terminals and the time that the server sends the terminal information. This setting puts a limit on the amount of time the application will wait for the information to arrive.

.. termy:global:: Server/ScrollbackFetchSpeed enumeration

   Controls how quickly the application downloads scrollback contents in the background. Enable the :termy:profile:`ShowFetchPosition <Appearance/ShowFetchPosition>` profile setting to view the progress of scrollback downloads in the :ref:`Minimap widget <minimap-widget>`.

.. termy:global:: Server/LocalDownloads boolean

   If enabled, :termy:action:`file downloads <DownloadFile>` and :termy:action:`uploads <UploadFile>` are permitted to :term:`local servers <local server>`. Note that :termy:action:`file mounts <MountFile>` of files on local servers are never permitted.

.. _global-terminals-tool:

Appearance / Terminals Tool
---------------------------

.. termy:global:: Appearance/ShowMenuBar boolean

   If disabled, the menu bar in new application windows will be hidden. It can be shown via the View menu or the :termy:action:`ToggleStatusBar` action.

.. termy:global:: Appearance/ShowStatusBar boolean

   If disabled, the status bar in new application windows will be hidden. It can be shown via the View menu or the :termy:action:`ToggleMenuBar` action.

.. termy:global:: Appearance/AutoRaiseTerminals boolean

   If enabled, the :doc:`Terminals tool <../tools/terminals>` will autoraise whenever the :term:`active terminal` is changed.

.. termy:global:: Appearance/ShowTerminalsPopup boolean

   If enabled, a popup will appear for a :termy:global:`brief period <Appearance/TerminalsPopupTime>` over the active viewport whenever the :term:`active terminal` is changed. The popup displays a list of servers and terminals with the active server and terminal highlighted.

.. termy:global:: Appearance/TerminalsPopupTime integer

   The number of milliseconds to display the :termy:global:`terminals popup <Appearance/ShowTerminalsPopup>`, if it's enabled.

.. termy:global:: Appearance/TerminalThumbnailCaption string

   The format of the caption shown below terminal thumbnails in the :doc:`Terminals tool <../tools/terminals>`. The value of a terminal :term:`attribute` named ``varname`` may be substituted using the notation ``\(varname)``. The value of a server attribute named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are supported; use ``\n`` to insert a newline.

.. termy:global:: Appearance/TerminalThumbnailTooltip string

   The format of the tooltip on terminal thumbnails in the :doc:`Terminals tool <../tools/terminals>`. The value of a terminal :term:`attribute` named ``varname`` may be substituted using the notation ``\(varname)``. The value of a server attribute named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are supported; use ``\n`` to insert a newline.

.. termy:global:: Appearance/ServerThumbnailCaption string

   The format of the caption shown below server thumbnails in the :doc:`Terminals tool <../tools/terminals>`. The value of a server :term:`attribute` named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are supported; use ``\n`` to insert a newline.

.. termy:global:: Appearance/ServerThumbnailTooltip string

   The format of the tooltip on server thumbnails in the :doc:`Terminals tool <../tools/terminals>`. The value of a server :term:`attribute` named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are supported; use ``\n`` to insert a newline.

.. termy:global:: Appearance/WindowTitle string

   The format of the window title. The value of a terminal :term:`attribute` named ``varname`` may be substituted using the notation ``\(varname)``. The value of a server :term:`attribute` named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are not supported.

.. termy:global:: Appearance/ShowMainIndex boolean

   If enabled, the index of each pane is shown in the associated viewport.

.. termy:global:: Appearance/ShowThumbnailIndex boolean

   If enabled, the index of the pane where a terminal is active is shown in its thumbnail in the :doc:`Terminals tool <../tools/terminals>`. If a terminal is active in more than one pane, the lowest numbered pane will be shown followed by a plus sign (+).

.. termy:global:: Appearance/DenseThumbnails boolean

   If enabled, less space will be allocated for the :termy:global:`TerminalThumbnailCaption <Appearance/TerminalThumbnailCaption>`, and thumbnails will be packed closer together in the :doc:`Terminals tool <../tools/terminals>`. This setting has no effect if thumbnail caption is empty.

.. termy:global:: Appearance/TerminalAction0 string

   The :doc:`action <../actions>` to invoke when a terminal thumbnail is double-clicked. The strings ``<terminalId>`` and ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/TerminalAction1 string

   The :doc:`action <../actions>` to invoke when a terminal thumbnail is Control-clicked. The strings ``<terminalId>`` and ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/TerminalAction2 string

   The :doc:`action <../actions>` to invoke when a terminal thumbnail is Shift-clicked. The strings ``<terminalId>`` and ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/TerminalAction3 string

   The :doc:`action <../actions>` to invoke when a terminal thumbnail is middle-clicked. The strings ``<terminalId>`` and ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/ServerAction0 string

   The :doc:`action <../actions>` to invoke when a server thumbnail is double-clicked. The string ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/ServerAction1 string

   The :doc:`action <../actions>` to invoke when a server thumbnail is Control-clicked. The string ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/ServerAction2 string

   The :doc:`action <../actions>` to invoke when a server thumbnail is Shift-clicked. The string ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

.. termy:global:: Appearance/ServerAction3 string

   The :doc:`action <../actions>` to invoke when a server thumbnail is middle-clicked. The string ``<serverId>`` within the action string will be replaced as appropriate. Any other action parameters must be hard-coded.

Effects
-------

.. termy:global:: Effects/MainBell enumeration

   How to display a bell event in the terminal.

.. termy:global:: Effects/ThumbnailBell enumeration

   How to display a bell event in the terminal thumbnail.

.. termy:global:: Effects/EnableCursorBlink boolean

   If disabled, the cursor will not blink.

.. termy:global:: Effects/EnableTextBlink boolean

   If disabled, text decorated with the blink property in the terminal will not blink.

.. termy:global:: Effects/CursorBlinkCount integer

   Number of times the cursor will blink after terminal activity occurs.

.. termy:global:: Effects/TextBlinkCount integer

   Number of times text decorated with the blink property will blink after terminal activity occurs.

.. termy:global:: Effects/SkipBlinkCount integer

   Number of cursor blinks to skip after keyboard input occurs. This prevents the cursor from blinking off while text is being entered.

.. termy:global:: Effects/BlinkTime integer

   Duration of each half-blink in milliseconds.

.. termy:global:: Effects/EnableResizeEffect boolean

   If enabled, a popup will appear for a brief period in viewports and terminal thumbnails when a terminal or viewport is resized. The popup displays the new size of the terminal and/or viewport.

.. termy:global:: Effects/EnableFocusEffect enumeration

   Controls the display of a brief animation in the border of the newly focused pane whenever the focus changes.

.. termy:global:: Effects/EnableBadgeScrolling boolean

   If enabled, the :termy:profile:`badge string <Appearance/Badge>` will scroll down and back up if the string exceeds the height of the viewport.

.. termy:global:: Effects/BadgeScrollingRate integer

   The rate at which the badge string will scroll, measured in milliseconds per character, if badge scrolling is enabled.

.. _global-command-mode:

Command Mode / Selection Mode
-----------------------------

.. termy:global:: Command/StartInCommandMode boolean

   If enabled, the application will start with :ref:`command mode <keymap-modes>` enabled.

.. termy:global:: Command/RaiseKeymapInCommandMode boolean

   If enabled, the :doc:`Keymap tool <../tools/keymap>` will autoraise and autohide when :ref:`command mode <keymap-modes>` is entered and exited. Note that the Keymap tool will not autohide when command mode is toggled from within the tool itself.

.. termy:global:: Command/RaiseKeymapInSelectMode boolean

   If enabled, the :doc:`Keymap tool <../tools/keymap>` will autoraise and autohide when :ref:`selection mode <keymap-modes>` is entered and exited. Note that the Keymap tool will not autohide when selection mode is toggled from within the tool itself.

.. termy:global:: Command/AutoSelectMode boolean

   If enabled, :ref:`selection mode <keymap-modes>` will be automatically entered whenever a selection is made.

.. termy:global:: Command/ExitSelectModeOnCopy boolean

   If enabled, the selection will be cleared after a :termy:action:`Copy` action.

.. termy:global:: Command/ExitSelectModeOnWrite boolean

   If enabled, the selection will be cleared after a :termy:action:`WriteSelection` or :termy:action:`WriteSelectionNewline` action.

.. termy:global:: Command/SelectModeInputDisabled boolean

   If enabled, input to the terminal is disabled while in :ref:`selection mode <keymap-modes>`. Only :doc:`keymap <keymap>` bindings to :doc:`actions <../actions>` will be run.

.. _global-presentation-mode:

Presentation Mode
-----------------

.. termy:global:: Presentation/EnterFullScreen boolean

   If enabled, enter full screen mode on entering :termy:action:`presentation mode <TogglePresentationMode>`.

.. termy:global:: Presentation/HideMenuBar boolean

   If enabled, hide the menu bar in the application window on entering :termy:action:`presentation mode <TogglePresentationMode>`. See also :termy:global:`Appearance/ShowMenuBar`.

.. termy:global:: Presentation/HideStatusBar boolean

   If enabled, hide the status bar in the application window on entering :termy:action:`presentation mode <TogglePresentationMode>`. See also :termy:global:`Appearance/ShowStatusBar`.

.. termy:global:: Presentation/HideTools boolean

   If enabled, hide any visible :doc:`../tools/index` on entering :termy:action:`presentation mode <TogglePresentationMode>`.

.. termy:global:: Presentation/HideIndex boolean

   If enabled, hide the pane index in the viewport on entering :termy:action:`presentation mode <TogglePresentationMode>`. See also :termy:global:`Appearance/ShowMainIndex`.

.. termy:global:: Presentation/HideIndicators boolean

   If enabled, hide the status indicator graphics in the viewport on entering :termy:action:`presentation mode <TogglePresentationMode>`. See also :termy:profile:`Appearance/ShowMainIndicators` (profile setting).

.. termy:global:: Presentation/HideBadge boolean

   If enabled, hide the badge string in the viewport on entering :termy:action:`presentation mode <TogglePresentationMode>`. See also :termy:profile:`Appearance/Badge` (profile setting).

.. termy:global:: Presentation/FontSizeIncrement integer

   Add the specified number of points to the font size on entering :termy:action:`presentation mode <TogglePresentationMode>`, reverting to normal when exiting presentation mode.

Inline Content
--------------

.. termy:global:: Inline/InlineAction0 enumeration

   What to do when a hyperlink, inline image, or other :term:`semantic region` is double-clicked.

.. termy:global:: Inline/InlineAction1 enumeration

   What to do when a hyperlink, inline image, or other :term:`semantic region` is Control-clicked.

.. termy:global:: Inline/InlineAction2 enumeration

   What to do when a hyperlink, inline image, or other :term:`semantic region` is Shift-clicked.

.. termy:global:: Inline/DragStartMultiplier integer

   A multiplier applied to the normal distance that the mouse pointer must move to begin a drag operation. Use this option to make it more difficult to accidentally start a drag operation on a :term:`semantic region` when clicking in the terminal viewport.

.. termy:global:: Inline/RenderInlineImages boolean

   If enabled, inline images uploaded using :doc:`termy-imgcat <../man/download>` and :doc:`termy-imgls <../man/download>` are parsed using Qt's `QImage <http://doc.qt.io/qt-5/qimage.html>`_ and `QMovie <http://doc.qt.io/qt-5/qmovie.html>`_ classes and displayed inline as :term:`semantic regions <semantic region>`. If disabled, inline images must be individually :termy:action:`shown <FetchImage>` using the region's context menu. This setting can be :termy:server:`overridden <Server/RenderInlineImages>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Inline/AllowSmartHyperlinks boolean

   If enabled, :ref:`smart hyperlinks <smart-hyperlinks>` created by terminal programs are honored. This setting can be :termy:server:`overridden <Server/AllowSmartHyperlinks>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Inline/RenderAvatars boolean

   If enabled, custom :termy:global:`avatar <Inline/Avatar>` images uploaded to the server by remote users are displayed on :termy:action:`their <TakeTerminalOwnership>` terminals.

.. termy:global:: Inline/Avatar none

   Displays your custom avatar image. To change the custom avatar image, place an SVG image at :file:`{$HOME}/.config/qtermy/avatar.svg` and restart the application.

.. _global-files-tool:

Files / Files Tool
------------------

.. termy:global:: Files/DownloadLocation string

   The default folder in which to store :termy:action:`downloaded files <DownloadFile>`. This setting can be :termy:server:`overridden <Files/DownloadLocation>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Files/DownloadFileConfirmation enumeration

   What to do when an existing local file would be overwritten by a :termy:action:`DownloadFile` task. This setting can be :termy:server:`overridden <Files/DownloadFileConfirmation>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Files/UploadFileConfirmation enumeration

   What to do when an existing remote file would be overwritten by an :termy:action:`UploadFile` task. This setting can be :termy:server:`overridden <Files/UploadFileConfirmation>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Files/DeleteFileConfirmation enumeration

   Whether to confirm removal of a remote file or folder during a :termy:action:`DeleteFile` task. This setting can be :termy:server:`overridden <Files/DeleteFileConfirmation>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Files/RenameFileConfirmation enumeration

   What to do when an existing remote file would be overwritten by a :termy:action:`RenameFile` task. This setting can be :termy:server:`overridden <Files/RenameFileConfirmation>` on a per-\ :doc:`server <server>` basis.

.. termy:global:: Files/TerminalLocalFileDrop enumeration

   What to do when a ``file://`` URL is dropped onto a terminal that is running on a :term:`local server`.

.. termy:global:: Files/TerminalRemoteFileDrop enumeration

   What to do when a ``file://`` URL is dropped onto a terminal that is *not* running on a :term:`local server`.

.. termy:global:: Files/ThumbnailLocalFileDrop enumeration

   What to do when a ``file://`` URL is dropped onto the thumbnail of a terminal that is running on a :term:`local server` in the :doc:`Terminals tool <../tools/terminals>`.

.. termy:global:: Files/ThumbnailRemoteFileDrop enumeration

   What to do when a ``file://`` URL is dropped onto the thumbnail of a terminal that is *not* running on a :term:`local server` in the :doc:`Terminals tool <../tools/terminals>`.

.. termy:global:: Files/ServerFileDrop enumeration

   What to do when a ``file://`` URL is dropped onto the thumbnail of a server in the :doc:`Terminals tool <../tools/terminals>`.

.. termy:global:: Files/AutoRaiseFiles boolean

   If enabled, the :doc:`Files tool <../tools/files>` will autoraise whenever its selected file changes. This can occur outside the tool itself as a result of :termy:action:`certain actions <FileFirst>` or by clicking on a :term:`semantic region` that has an associated ``file://`` URL.

.. termy:global:: Files/FilesAction0 enumeration

   What to do when a file or folder is double-clicked in the :doc:`Files tool <../tools/files>`.

.. termy:global:: Files/FilesAction1 enumeration

   What to do when a file or folder is Control-clicked in the :doc:`Files tool <../tools/files>`.

.. termy:global:: Files/FilesAction2 enumeration

   What to do when a file or folder is Shift-clicked in the :doc:`Files tool <../tools/files>`.

.. termy:global:: Files/FilesAction3 enumeration

   What to do when a file or folder is middle-clicked in the :doc:`Files tool <../tools/files>`.

.. _global-tasks-tool:

Tasks / Tasks Tool
------------------

.. termy:global:: Tasks/AutoRaiseTasks boolean

   If enabled, the :doc:`Tasks tool <../tools/tasks>` will autoraise whenever a task starts or finishes. The tool will autohide after a :termy:global:`brief period <Tasks/TasksDelayTime>` once there are no outstanding :term:`active tasks <active task>`.

.. termy:global:: Tasks/AutoShowTaskStatus boolean

   If enabled, a task status dialog will be shown whenever most types of task are started. Some tasks are considered :doc:`background tasks <../tools/tasks>` and will ignore this setting. Task status dialogs can be manually launched using the :doc:`Tasks tool <../tools/tasks>` context menu or the :termy:action:`InspectTask` action.

.. termy:global:: Tasks/AutoHideTaskStatus boolean

   If enabled, tasks status dialogs will automatically close after a :termy:global:`brief period <Tasks/TasksDelayTime>` when their task finishes.

.. termy:global:: Tasks/TasksDelayTime integer

   The number of milliseconds to hold the :doc:`Tasks tool <../tools/tasks>` and task status dialogs open before autoclosing them. Task status dialogs are held open for only half of the configured time.

.. termy:global:: Tasks/DownloadAction enumeration

   What to do when a :termy:action:`download task <DownloadFile>` finishes. The "preferred :doc:`launcher <launcher>`" for files refers to the :termy:global:`PreferredFileLauncher <Tasks/PreferredFileLauncher>`. The "new terminal" option uses the :termy:global:`PreferredProfile <Tasks/PreferredProfile>` as the profile to create new terminals.

.. termy:global:: Tasks/MountAction enumeration

   What to do when a the file mounted via a :termy:action:`mount task <MountFile>` is ready. The "preferred :doc:`launchers <launcher>`" for files and directories refer to the :termy:global:`PreferredFileLauncher <Tasks/PreferredFileLauncher>` and :termy:global:`PreferredDirectoryLauncher <Tasks/PreferredDirectoryLauncher>` respectively. The "new terminal" option uses the :termy:global:`PreferredProfile <Tasks/PreferredProfile>` as the profile to create new terminals.

.. termy:global:: Tasks/PreferredFileLauncher string

   The preferred :doc:`launcher <launcher>` for opening task result files. See :termy:action:`OpenTaskFile`.

.. termy:global:: Tasks/PreferredDirectoryLauncher string

   The preferred :doc:`launcher <launcher>` for opening task result directories. See :termy:action:`OpenTaskDirectory`.

.. termy:global:: Tasks/PreferredProfile string

   The preferred :doc:`profile <profile>` for creating new terminals to handle task result files and directories. See :termy:action:`OpenTaskTerminal`.

.. termy:global:: Tasks/TasksAction0 enumeration

   What to do when a task is double-clicked in the :doc:`Tasks tool <../tools/tasks>`.

.. termy:global:: Tasks/TasksAction1 enumeration

   What to do when a task is Control-clicked in the :doc:`Tasks tool <../tools/tasks>`.

.. termy:global:: Tasks/TasksAction2 enumeration

   What to do when a task is Shift-clicked in the :doc:`Tasks tool <../tools/tasks>`.

.. termy:global:: Tasks/TasksAction3 enumeration

   What to do when a task is middle-clicked in the :doc:`Tasks tool <../tools/tasks>`.

.. termy:global:: Tasks/TaskSizeLimit integer

   The maximum number of tasks to show in the :doc:`Tasks tool <../tools/tasks>`. Completed tasks can be removed from the list using the context menu or the :termy:action:`RemoveTasks` action.

.. _global-suggestions-tool:

Suggestions Tool
----------------

.. termy:global:: Suggestions/AutoRaiseSuggestions boolean

   If enabled, the :doc:`Suggestions tool <../tools/suggestions>` will autoraise after a :termy:global:`brief idle period <Suggestions/SuggestionsDelayTime>` when a certain number of characters have been typed at a prompt with :doc:`shell integration <../shell-integration>` enabled.

   The tool will autohide when command entry is finished.

.. termy:global:: Suggestions/SuggestionsDelayTime integer

   The idle time required before the :doc:`Suggestions tool <../tools/suggestions>` will :termy:global:`autoraise <Suggestions/AutoRaiseSuggestions>`. This prevents the tool from popping up and flickering rapidly while a command is still being typed out.

.. termy:global:: Suggestions/SuggestionsAction0 enumeration

   What to do when a suggestion is double-clicked in the :doc:`Suggestions tool <../tools/suggestions>`.

.. termy:global:: Suggestions/SuggestionsAction1 enumeration

   What to do when a suggestion is Control-clicked in the :doc:`Suggestions tool <../tools/suggestions>`.

.. termy:global:: Suggestions/SuggestionsAction2 enumeration

   What to do when a suggestion is Shift-clicked in the :doc:`Suggestions tool <../tools/suggestions>`.

.. termy:global:: Suggestions/SuggestionsAction3 enumeration

   What to do when a suggestion is middle-clicked in the :doc:`Suggestions tool <../tools/suggestions>`.

.. _global-history-tool:

History and Notes Tools
-----------------------

.. termy:global:: History/HistoryAction0 enumeration

   What to do when a job is double-clicked in the :doc:`History tool <../tools/history>`.

.. termy:global:: History/HistoryAction1 enumeration

   What to do when a job is Control-clicked in the :doc:`History tool <../tools/history>`.

.. termy:global:: History/HistoryAction2 enumeration

   What to do when a job is Shift-clicked in the :doc:`History tool <../tools/history>`.

.. termy:global:: History/HistoryAction3 enumeration

   What to do when a job is middle-clicked in the :doc:`History tool <../tools/history>`.

.. termy:global:: History/NotesAction0 enumeration

   What to do when an annotation is double-clicked in the :doc:`Annotations tool <../tools/annotations>`.

.. termy:global:: History/NotesAction1 enumeration

   What to do when an annotation is Control-clicked in the :doc:`Annotations tool <../tools/annotations>`.

.. termy:global:: History/NotesAction2 enumeration

   What to do when an annotation is Shift-clicked in the :doc:`Annotations tool <../tools/annotations>`.

.. termy:global:: History/NotesAction3 enumeration

   What to do when an annotation is middle-clicked in the :doc:`Annotations tool <../tools/annotations>`.

.. termy:global:: History/HistoryFont string

   The font to use in the :doc:`History <../tools/history>` and :doc:`Annotations <../tools/annotations>` tools.

.. termy:global:: History/HistorySizeLimit integer

   The maximum number of items to show in the :doc:`History <../tools/history>` and :doc:`Annotations <../tools/annotations>` tools. Items associated with closed terminals can be removed from the lists using the context menu or the :termy:action:`ToolFilterRemoveClosed` action.
