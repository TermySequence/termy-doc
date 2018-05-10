.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Profile
=======

Profile settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/profiles`. Profiles can be edited from the Settings menu, status bar, :doc:`Manage Profiles window <../dialogs/manage-profiles>`, and various context menus, or by calling the :termy:action:`EditProfile` action. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Profiles window <../dialogs/manage-profiles>` to load external changes and new files without restarting the application.

A fallback profile named "Default" must exist at all times. One profile (which need not be the one named "Default") is designated as the :term:`global default profile`. Each :doc:`server <server>` also has a :termy:server:`default profile <Server/DefaultProfile>`, which may defer to the global default. Default profiles are assigned to newly created terminals in the absence of a specific profile name. Profiles can be favorited in the :doc:`Manage Profiles window <../dialogs/manage-profiles>`, which will cause them to appear at the top of profile selection menus.

Each terminal has a current profile at all times. Some profile settings can be overridden on a per-terminal basis from within :program:`qtermy` using various :doc:`adjustment dialogs <../dialogs/index>` or by programs such as :doc:`termyctl <../man/ctl>` running within the terminal. Profile settings are exported to the server as terminal :term:`attributes <attribute>` and can be imported by any user as a new profile using :termy:action:`ExtractProfile`. Terminals created by other users will be assigned a local profile. The :ref:`collaboration settings <profile-collaboration>` allow certain visual settings to be shown as the remote user has set them rather than as they are set in the assigned local profile.

The profile specifies the :doc:`keymap <keymap>` that is used. To change a terminal's keymap, its profile must be changed or the :termy:profile:`Keymap <Input/Keymap>` must be changed in its current profile.

Each terminal has a small stack of profiles which can be :termy:action:`pushed to <PushProfile>` and :termy:action:`popped from <PopProfile>`, rather than simply switching profiles. Using :doc:`profile autoswitch rules <../dialogs/switch-rule-editor>`, profiles can be automatically pushed, popped, or switched in response to terminal :term:`attribute` changes.

.. contents:: Settings Categories
   :local:

Input
-----

.. termy:profile:: Input/Keymap string

   The :doc:`keymap <keymap>` that will be used in terminals with this profile.

.. termy:profile:: Input/SendMouseEvents boolean

   If enabled, the client will honor mouse modes enabled by terminal programs and will send mouse events to the server.

.. termy:profile:: Input/SendFocusEvents boolean

   If enabled, the client will honor the "focus in/focus out" mode enabled by terminal programs and will send focus events to the server.

.. termy:profile:: Input/SendScrollEvents boolean

   If enabled, the client will honor alternate scroll mode and will send scroll events to the server when the terminal's alternate screen buffer is active and the mouse wheel is used. This will override the normal mouse wheel behavior of scrolling the viewport up and down in the scrollback.

.. termy:profile:: Emulator/InitialFlags boolean

   If enabled, the terminal will start in :termy:profile:`alternate scroll mode <Input/SendScrollEvents>`.

Appearance
----------

.. termy:profile:: Appearance/BackgroundColor color

   A convenience setting which sets the terminal background color in the profile's :termy:profile:`Palette <Appearance/Palette>`.

.. termy:profile:: Appearance/ForegroundColor color

   A convenience setting which sets the terminal foreground color in the profile's :termy:profile:`Palette <Appearance/Palette>`.

.. termy:profile:: Appearance/Palette string

   The terminal color palette. This consists of a :ref:`standard 256-color palette <theme-editor-basic>` as well as :ref:`extended colors <theme-editor-extended>`.  This can be overridden on a per-terminal basis using the :ref:`Adjust Colors dialog <adjust-colors>` and :termy:action:`RandomTerminalTheme` action. Also, depending on the value of :termy:profile:`ShowRemoteColors <Collaboration/ShowRemoteColors>`, other users' color palettes may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals. Refer to :doc:`../dialogs/theme-editor` for more information.

   Setting a :doc:`theme <theme>` or editing the color palette via this setting will update the :termy:profile:`Dircolors <Files/Dircolors>` as well.

   .. note:: Each profile stores its own color palette, separate from the :doc:`theme <theme>` system. If any theme happens to match both the profile's :termy:profile:`Palette <Appearance/Palette>` and :termy:profile:`Dircolors <Files/Dircolors>`, its name will be shown in the :doc:`settings editor <../dialogs/settings-editor>` at the :termy:profile:`Palette <Appearance/Palette>` setting. Changes made to that theme will not change the value of any profile settings.

.. termy:profile:: Appearance/Font string

   A string describing the terminal font, which must be a fixed-width (typewriter, monospace) font. This font string is passed to `QFont::fromString <http://doc.qt.io/qt-5/qfont.html#fromString>`_, which handles all font resolution. This can be overridden on a per-terminal basis using the :ref:`Adjust Font dialog <adjust-font>`. Also, depending on the value of :termy:profile:`ShowRemoteFont <Collaboration/ShowRemoteFont>`, other users' fonts may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals.

   Some characters such as box and line drawing characters and :term:`emoji` are rendered directly by :program:`qtermy`.

.. termy:profile:: Appearance/WidgetLayout string

   Describes the position and visibility of the terminal :doc:`../widgets` and separators between them. This can be overridden on a per-terminal basis using the :ref:`Adjust Layout dialog <adjust-layout>`. Also, depending on the value of :termy:profile:`ShowRemoteLayout <Collaboration/ShowRemoteLayout>`, :doc:`termyctl <../man/ctl>` may be used to override this setting from within the terminal and other users' layouts may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals.

.. termy:profile:: Appearance/ColumnFills string

   Draws fill lines in the terminal viewport at specified column positions using specified colors. This can be overridden on a per-terminal basis using the :ref:`Adjust Layout dialog <adjust-layout>`. Also, depending on the value of :termy:profile:`ShowRemoteFills <Collaboration/ShowRemoteFills>`, :doc:`termyctl <../man/ctl>` may be used to override this setting from within the terminal and other users' fills may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals.

.. termy:profile:: Appearance/Badge string

   The format of the badge string drawn along the edge of the terminal viewport. The value of a terminal :term:`attribute` named ``varname`` may be substituted using the notation ``\(varname)``. The value of a server attribute named ``varname`` may be substituted using the notation ``\(server.varname)``. Multiple lines are not supported.

   Depending on the value of :termy:profile:`ShowRemoteBadge <Collaboration/ShowRemoteBadge>`, :doc:`termyctl <../man/ctl>` may be used to override this setting from within the terminal and other users' badge strings may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals.

   Badge strings that do not fit within the terminal viewport can be animated using the :termy:global:`EnableBadgeScrolling <Effects/EnableBadgeScrolling>` and :termy:global:`BadgeScrollingRate <Effects/BadgeScrollingRate>` global settings.

.. termy:profile:: Appearance/ShowMainIndicators boolean

   If enabled, indicator graphics for the following conditions will be drawn in the terminal viewport:

     * Terminal is :termy:action:`owned <TakeTerminalOwnership>` by another client.
     * Terminal is :term:`hosting a connection <connection chaining>` to a server.
     * :termy:action:`Scroll lock <ToggleSoftScrollLock>` is active in the terminal.
     * :ref:`Command mode <keymap-modes>` is active.
     * :ref:`Selection mode <keymap-modes>` is active.
     * An :doc:`Alert <alert>` is :termy:action:`active <SetAlert>` in the terminal.
     * Terminal is an :term:`input multiplexing` leader.
     * Terminal is an :term:`input multiplexing` follower.

.. termy:profile:: Appearance/ShowThumbnailIndicators boolean

   If enabled, indicator images for the following conditions will be drawn in the terminal thumbnail in the :doc:`Terminals tool <../tools/terminals>`:

     * Terminal is :termy:action:`owned <TakeTerminalOwnership>` by another client. If :termy:global:`RenderAvatars <Inline/RenderAvatars>` is set and the owning client has set an :termy:global:`Avatar <Inline/Avatar>` image, it will be shown as this indicator.
     * Terminal is :term:`hosting a connection <connection chaining>` to a server.
     * :termy:action:`Scroll lock <ToggleSoftScrollLock>` is active in the terminal.
     * An :doc:`Alert <alert>` is :termy:action:`active <SetAlert>` in the terminal.
     * Terminal is an :term:`input multiplexing` leader.
     * Terminal is an :term:`input multiplexing` follower.

   Indicator images are loaded as SVG files from :file:`{$HOME}/.local/share/qtermy/images/indicator` and :file:`{prefix}/share/qtermy/images/indicator` in that order.

.. termy:profile:: Appearance/ShowThumbnailIcon boolean

   If enabled, the terminal thumbnail in the :doc:`Terminals tool <../tools/terminals>` will be decorated with an icon. The icon is normally set using the :doc:`icon autoswitch rules <../dialogs/icon-rule-editor>`, but can be set to a fixed icon using the :termy:profile:`FixedThumbnailIcon <Appearance/FixedThumbnailIcon>` profile setting or the :termy:action:`SetTerminalIcon` action.

.. termy:profile:: Appearance/FixedThumbnailIcon string

   Specifies a custom icon which will be displayed on the terminal thumbnail in the :doc:`Terminals tool <../tools/terminals>`, overriding the :doc:`icon autoswitch rules <../dialogs/icon-rule-editor>`. This can also be done using the :termy:action:`SetTerminalIcon` action. Refer to that action for more information.

   Note that :termy:profile:`ShowThumbnailIcon <Appearance/ShowThumbnailIcon>` must be enabled for this setting to have any effect.

.. termy:profile:: Appearance/NumRecentPrompts integer

   The number of recent prompts to show in the :ref:`Minimap widget <minimap-widget>`.

.. termy:profile:: Appearance/ShowFetchPosition boolean

   If enabled, a triangular cursor will be drawn in the :ref:`Minimap widget <minimap-widget>` showing the progress of any ongoing download of scrollback buffer contents. See also :termy:global:`ScrollbackFetchSpeed <Server/ScrollbackFetchSpeed>` in the global settings.

Effects
-------

.. termy:profile:: Effects/ExitStatusEffect enumeration

   Controls the display of a flash animation in the terminal thumbnail when a job finishes within the terminal. This requires :doc:`shell integration <../shell-integration>`.

.. termy:profile:: Effects/ExitStatusRuntime integer

   The minimum time a job must run before the :termy:profile:`ExitStatusEffect <Effects/ExitStatusEffect>` animation will be shown in the terminal thumbnail.

.. _profile-collaboration:

Collaboration
-------------

.. termy:profile:: Collaboration/AllowRemoteInput boolean

   If enabled, other clients can send input to terminals :termy:action:`owned <TakeTerminalOwnership>` by this client. This can be overridden on a per-terminal basis using the Terminal menu or :termy:action:`ToggleTerminalRemoteInput` action.

   .. warning:: **This is not a security mechanism**. Any client connected to a server can take ownership of a terminal at any time. This option is intended to prevent inadvertent input from other users.

.. termy:profile:: Collaboration/ShowRemoteFont enumeration

   Controls whether :termy:profile:`fonts <Appearance/Font>` set by programs within the terminal or by other users on :termy:action:`their <TakeTerminalOwnership>` terminals will be shown.

.. termy:profile:: Collaboration/ShowRemoteColors enumeration

   Controls whether :termy:profile:`colors <Appearance/Palette>` and :termy:profile:`dircolors <Files/Dircolors>` set by programs within the terminal or by other users on :termy:action:`their <TakeTerminalOwnership>` terminals will be shown.

.. termy:profile:: Collaboration/ShowRemoteLayout enumeration

   Controls whether :termy:profile:`widget layouts <Appearance/WidgetLayout>` set by programs within the terminal or by other users on :termy:action:`their <TakeTerminalOwnership>` terminals will be shown.

.. termy:profile:: Collaboration/ShowRemoteFills enumeration

   Controls whether :termy:profile:`column fills <Appearance/ColumnFills>` set by programs within the terminal or by other users on :termy:action:`their <TakeTerminalOwnership>` terminals will be shown.

.. termy:profile:: Collaboration/ShowRemoteBadge enumeration

   Controls whether :termy:profile:`badge strings <Appearance/Badge>` set by programs within the terminal or by other users on :termy:action:`their <TakeTerminalOwnership>` terminals will be shown.

.. termy:profile:: Collaboration/ResetRemoteOnTakingOwnership boolean

   If enabled, all profile settings associated with the current :termy:doc:`profile <../settings/profile>` will be pushed to the server as terminal :term:`attributes <attribute>` when :termy:action:`taking <TakeTerminalOwnership>` terminal ownership. Other clients may :termy:action:`extract <ExtractProfile>` their own profile from these settings.

.. termy:profile:: Collaboration/FollowRemoteScrolling boolean

   If enabled, and the terminal is :termy:action:`owned <TakeTerminalOwnership>` by another client, the active viewport's scrollback position and :ref:`timing origin <timing-widget>` will track the information reported by the owning client. This can be overridden on a per-terminal basis using the Terminal menu or :termy:action:`ToggleTerminalFollowing` action.

.. termy:profile:: Collaboration/AllowRemoteClipboard boolean

   If enabled, clipboard copy requests made by programs within the terminal will be honored.

Emulator
--------

.. termy:profile:: Emulator/TermSize size

   The starting size of the terminal. If there is an active viewport open when a new terminal is created, its size will be used instead of this setting.

.. termy:profile:: Emulator/ScrollbackSizePower integer

   The scrollback size. Must be a power of 2. Can be overridden on a per-terminal basis using the :ref:`Adjust Scrollback dialog <adjust-scrollback>`.

.. termy:profile:: Emulator/Command stringlist

   The command to run in the terminal. This is a list of strings consisting of an executable name and argument vector (including argument zero).

   .. include:: command-common.rst

.. termy:profile:: Emulator/Directory string

   The directory which the :termy:profile:`Command <Emulator/Command>` is run from. If unspecified, the command will be started in the user's :envvar:`HOME` directory. May be ignored if :termy:profile:`StartInSameDirectory <Emulator/StartInSameDirectory>` is set.

.. termy:profile:: Emulator/StartInSameDirectory boolean

   If enabled, the :termy:profile:`Command <Emulator/Command>` will be run from the current directory in the :term:`active terminal`, if available, rather than the configured :termy:profile:`Directory <Emulator/Directory>`.

.. termy:profile:: Emulator/Environment stringlist

   Environment variable rules used to set and clear environment variables before running the :termy:profile:`Command <Emulator/Command>`.

   The terminal answerback string can also be set via this setting.

.. termy:profile:: Emulator/ActionOnProcessExit enumeration

   Specifies what to do when the :termy:profile:`Command <Emulator/Command>` exits. One option is to restart the command. Another option is to stop the emulator, which may close the terminal depending on the configured :termy:profile:`AutoClose <Emulator/AutoClose>` setting.

.. termy:profile:: Emulator/AutoClose enumeration

   Specifies the conditions that permit the terminal to autoclose after the emulator has :termy:profile:`stopped <Emulator/ActionOnProcessExit>`. Note that the terminal will never autoclose if the :termy:profile:`Command <Emulator/Command>` exits before the configured :termy:profile:`AutoCloseTime <Emulator/AutoCloseTime>`.

.. termy:profile:: Emulator/AutoCloseTime integer

   The minimum time that the :termy:profile:`Command <Emulator/Command>` must run before the :termy:profile:`AutoClose <Emulator/AutoClose>` setting will be honored. Use this setting to prevent a terminal from autoclosing when its command exits immediately.

.. termy:profile:: Emulator/PromptClose enumeration

   Specifies the conditions under which a confirmation prompt will be shown before a terminal is :termy:action:`explicitly closed <CloseTerminal>`.

.. termy:profile:: Emulator/InsertNewlineBeforePrompt boolean

   If enabled, a newline will be printed prior to a prompt if the prompt would otherwise not begin at the first column. This feature requires :doc:`shell integration <../shell-integration>`.

.. termy:profile:: Emulator/ClearScreenByScrolling boolean

   If enabled, a clear screen request will be handled by inserting blank lines at the bottom of the terminal if a prompt is active. This will preserve the scrollback contents above the prompt while still placing the prompt at the top of a blank screen. This feature requires :doc:`shell integration <../shell-integration>`.

.. termy:profile:: Emulator/StartingMessage string

   A string to print to the terminal before running the :termy:profile:`Command <Emulator/Command>`.

Encoding
--------

.. termy:profile:: Emulator/Language string

   The desired language for the terminal. On its own, this setting only controls a small number of strings printed in the terminal by the server itself. Use :termy:profile:`SetLangEnvironmentVariable <Encoding/SetLangEnvironmentVariable>` to propagate this setting to programs within the terminal.

   The server must have a matching :term:`translation file <server translations>` installed for this setting to have any effect on the strings that it prints.

.. termy:profile:: Encoding/SetLangEnvironmentVariable boolean

   If enabled, the :envvar:`LANG` environment variable will be set to the value of the :termy:profile:`Language <Emulator/Language>` setting. This will override any :termy:profile:`Environment <Emulator/Environment>` rules for the same variable.

.. termy:profile:: Emulator/Encoding string

   The Unicode variant to use in the terminal. :ref:`Encodings <protocol-unicode>` are defined as part of the :doc:`TermySequence protocol <../protocol>` and specify the widths and combining behavior of Unicode code points, including :term:`emoji`. The encoding is used to synchronize the location of the screen cursor between the client and server.

   The server may not honor this request and may choose a different encoding. See :termy:profile:`WarnOnUnsupportedEncoding <Emulator/WarnOnUnsupportedEncoding>`.

.. note:: Strings are drawn in the terminal viewport using `Qt's QPainter class <http://doc.qt.io/qt-5/qpainter.html>`_, whose interpretation of a given Unicode string may differ from that of the configured encoding. Visual glitches may result in some cases.

.. termy:profile:: Encoding/UseEmoji boolean

   This setting is part of the requested :termy:profile:`Encoding <Emulator/Encoding>`. If enabled, emoji characters will be shown in emoji presentation and drawn as :term:`emoji images <emoji>`.

.. termy:profile:: Encoding/DoubleWidthAmbiguous boolean

   This setting is part of the requested :termy:profile:`Encoding <Emulator/Encoding>`. If enabled, ambiguous characters will be treated as double-width characters.

.. termy:profile:: Encoding/WarnOnUnsupportedEncoding boolean

   If enabled, a warning message will be :doc:`logged <../dialogs/event-log>` if a terminal has an :termy:profile:`Encoding <Emulator/Encoding>` which is unsupported by the client. When the server and client disagree on a terminal's encoding, characters and combining characters may be drawn with incorrect widths.

   See also :termy:global:`LogThreshold <Global/LogThreshold>` global setting.

.. _profile-files:

Files
-----

.. termy:profile:: Files/DirectorySizeLimit integer

   The maximum number of files that will be reported by the server and shown in the :doc:`Files tool <../tools/files>` for any given directory. The Files tool will allow the user to override this limit on a case-by-case basis.

.. termy:profile:: Files/FileDisplayFormat enumeration

   The display format to use in the :doc:`Files tool <../tools/files>`. This can be overridden from the Tools menu or context menu, or via the :termy:action:`SetFileListingFormat` and :termy:action:`ToggleFileListingFormat` actions.

.. termy:profile:: Files/FileChangeEffect enumeration

   Controls the display of a flash animation in the :doc:`Files tool <../tools/files>` when a file is modified.

.. termy:profile:: Files/ShowHiddenFiles boolean

   If enabled, hidden files will be shown in the :doc:`Files tool <../tools/files>`, similar to :command:`ls -a`.

.. termy:profile:: Files/FileClassify boolean

   If enabled, a classification character will be printed following the file names in the in the :doc:`Files tool <../tools/files>`, similar to :command:`ls -F`.

.. termy:profile:: Files/FileColorize boolean

   If enabled, the configured :termy:profile:`Dircolors <Files/Dircolors>` will be honored in the :doc:`Files tool <../tools/files>`, similar to :command:`ls --color`.

.. termy:profile:: Files/FileGittify boolean

   If enabled, a git status character will be printed prior to the file names in the :doc:`Files tool <../tools/files>` if applicable. The server must have `libgit2 <https://libgit2.github.com/>`_ support enabled at both compile time and runtime and libgit2 must be installed on the server's machine.

   If :termy:profile:`FileColorize <Files/FileColorize>` is enabled, git status characters will be drawn using :ref:`extended color categories <dircolors-editor-extended>` defined in the :termy:profile:`Dircolors <Files/Dircolors>`.

.. termy:profile:: Files/ShowGitBanner boolean

   If enabled, the current git branch will be shown in the :doc:`Files tool <../tools/files>` if applicable. The server must have `libgit2 <https://libgit2.github.com/>`_ support enabled at both compile time and runtime and libgit2 must be installed on the server's machine.

.. termy:profile:: Files/Dircolors string

   Specifies the dircolors to use in the :doc:`Files tool <../tools/files>` if :termy:profile:`FileColorize <Files/FileColorize>` is enabled, and in the terminal itself if :termy:profile:`SetLsColorsEnvironmentVariable <Files/SetLsColorsEnvironmentVariable>` is enabled. The setting is a string in :manpage:`dircolors(1)` format with some :program:`qtermy` :ref:`extensions <dircolors-editor-extended>` such as git colors. Refer to :doc:`../dialogs/dircolors-editor` for more information.

   This can be overridden on a per-terminal basis using the :ref:`Adjust Colors dialog <adjust-colors>` and :termy:action:`RandomTerminalTheme` action. Also, depending on the value of :termy:profile:`ShowRemoteColors <Collaboration/ShowRemoteColors>`, other users' dircolors may be shown in the Files tool for :termy:action:`their <TakeTerminalOwnership>` terminals.

   Setting a :doc:`theme <theme>` or editing the color palette via the :termy:profile:`Palette <Appearance/Palette>` setting will also update this setting.

   .. note:: Each profile stores its own dircolors, separate from the :doc:`theme <theme>` system. If any theme happens to match both the profile's :termy:profile:`Palette <Appearance/Palette>` and :termy:profile:`Dircolors <Files/Dircolors>`, its name will be shown in the :doc:`settings editor <../dialogs/settings-editor>` at the :termy:profile:`Palette <Appearance/Palette>` setting. Changes made to that theme will not change the value of any profile settings.

.. termy:profile:: Files/SetLsColorsEnvironmentVariable boolean

   If enabled, the :envvar:`LS_COLORS` and :envvar:`USER_LS_COLORS` environment variables will be set appropriately so that the configured :termy:profile:`Dircolors <Files/Dircolors>` are used by the terminal. This will override any :termy:profile:`Environment <Emulator/Environment>` rules for the same variables.

   .. note:: :doc:`Dircolors adjustments <../dialogs/dircolors-editor>` made while the terminal is running will not be reflected in these environment variables and thus will not be honored by programs within the terminal. Adjustments will be honored in the :doc:`Files tool <../tools/files>`.
