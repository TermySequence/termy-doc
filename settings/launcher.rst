.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Launcher
=============

Launcher settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/launchers` and at :file:`{prefix}/share/qtermy/launchers`. Files in :envvar:`HOME` take precedence over files in the system directory. Launchers can be created and edited from the :doc:`Manage Launchers window <../dialogs/manage-launchers>`. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Launchers window <../dialogs/manage-launchers>` to load external changes and new files without restarting the application.

A *launcher* describes the execution of a command by :program:`qtermy` or by a local or remote :doc:`server <server>`. Launchers are used for two purposes within :program:`qtermy`: to run commands with optional processing of input and output streams, and to launch programs to handle files opened via :termy:action:`OpenFile` through context menus or the :doc:`Files tool <../tools/files>`.

A fallback launcher named "Default" must exist at all times. One launcher (which need not be the one named "Default") is designated as the :term:`default launcher`. The default launcher is used to open files in the absence of a specific launcher name. The default launcher as shipped by :program:`qtermy` opens files using :termy:action:`OpenDesktopUrl`, but this can be changed (see the :ref:`tip <launcher-script-tip>` below).

.. _launcher-markers:

A launcher used to open files and URL's should contain one or more of the following markers in its :termy:launcher:`Command <Command/Command>`. The marker will be replaced at launch time with the corresponding URL, path, or name, treated as a single word.

   * ``%U`` or ``%u``: substitute target URL.
   * ``%F`` or ``%f``: substitute full path of target file.
   * ``%n``: substitute name of file.
   * ``%d``: substitute enclosing directory of file.

These markers are identical to those used in `desktop entry files <https://standards.freedesktop.org/desktop-entry-spec/latest/>`_ and it is possible to import a desktop entry file as a new launcher in the :doc:`Manage Launchers window <../dialogs/manage-launchers>`. It's also possible for a launcher to make use of custom markers not listed here, using the :termy:param:`Substitutions` parameter to :termy:action:`OpenFile` and :termy:action:`LaunchCommand`. This feature can be used by :doc:`custom actions <../plugins/action>` or by :term:`semantic regions <semantic region>` created by :doc:`semantic parsers <../plugins/parser>` to launch commands with arbitrary argument substitutions.

Launchers may specify :termy:launcher:`filename extensions <Match/FileExtensions>` and :termy:launcher:`URI schemes <Match/URISchemes>` to match against when used to open files and URL's.

.. _launcher-script-tip:

.. tip:: For maximum flexibility when opening files using desktop applications, create your own custom script which launches the application of your choice depending on the URL or path provided as its ``%u`` or ``%f`` argument, and run that script from the default launcher. You can even create multiple launchers which run the script with different arguments to achieve different results.

.. tip:: Run commonly used commands in a single keystroke by making a :doc:`key binding <keymap>` to to the :termy:action:`LaunchCommand` action with your custom launcher specified as the :termy:param:`LauncherName` parameter. Try creating a launcher to run :manpage:`fortune(6)` as a bare command with its :termy:launcher:`output <InputOutput/OutputType>` displayed in a dialog box!

.. contents:: Settings Categories
   :local:

Match
-----

.. termy:launcher:: Match/FileExtensions string

   A list of space-separated filename extensions which the launcher is intended to be used to open. This setting is a hint used to prioritize launchers when building the "Open with" context menu.

.. termy:launcher:: Match/URISchemes string

   A list of space-separated URI schemes such as "https" which the launcher is intended to be used to open. This setting is a hint used to prioritize launchers when building the "Open with" context menu.

Launcher
--------

.. termy:launcher:: Launcher/LaunchType enumeration

   The type of command to be launched. The choices are as follows:

     * *Open file via local desktop environment*: The :termy:action:`OpenDesktopUrl` action is used to open the target via the local desktop environment. If the target file is on a remote server, it may be :termy:action:`mounted <MountFile>` first, depending on the value of :termy:launcher:`MountType <Launcher/MountType>`. If this is done, the locally mounted file name will be passed to :termy:action:`OpenDesktopUrl` rather than the remote path. Command and input/output settings are ignored.
     * *Run bare command on the local machine*: A task is initiated to run the launcher's :termy:launcher:`Command <Command/Command>` as a child process of :program:`qtermy` itself. Command and input/output settings are honored. When used to open a remote file, a file :termy:action:`mount <MountFile>` may be performed as described in the first choice.
     * *Run bare command on the remote machine*: A task is initiated to run the launcher's :termy:launcher:`Command <Command/Command>` as a child process of the target file's server or the server specified in a call to :termy:action:`LaunchCommand`. Note that this option encompasses all servers including :term:`local servers <local server>`. Command and input/output settings are honored. A :termy:action:`mount <MountFile>` will never be performed since the command is run on the same server as the target file.
     * *Run command in a new local terminal*: A terminal is created on the :term:`local server` using the specified :termy:launcher:`Profile <Launcher/Profile>` and the launcher's :termy:launcher:`Command <Command/Command>` is run within it rather than the command specified in the profile. Command settings are honored but input/output settings are not. When used to open a remote file, a file :termy:action:`mount <MountFile>` may be performed as described in the first choice.
     * *Run command in a new remote terminal*: A terminal is created on the target file's server or the server specified in a call to :termy:action:`LaunchCommand`, using the specified :termy:launcher:`Profile <Launcher/Profile>`, and the launcher's :termy:launcher:`Command <Command/Command>` is run within it rather than the command specified in the profile. Command settings are honored but input/output settings are not. A :termy:action:`mount <MountFile>` will never be performed since the command is run on the same server as the target file.
     * *Write command text into the active terminal*: The :termy:launcher:`Command <Command/Command>` string will be written into the :term:`active terminal` using :termy:action:`WriteText`, rather than being executed. When used to open a remote file, a file :termy:action:`mount <MountFile>` may be performed as described in the first choice.

.. termy:launcher:: Launcher/Profile string

   The :doc:`profile <../settings/profile>` to use to create a new terminal. Only applicable when the :termy:launcher:`LaunchType <Launcher/LaunchType>` is configured to create a terminal. Note that the :termy:profile:`Command <Emulator/Command>` set in the profile itself will be ignored.

.. termy:launcher:: Launcher/MountType enumeration

   The type of :termy:action:`mount <MountFile>` to perform if a launcher configured to run a local command is used to open a file on a remote server. Mounts can be disabled or can be made read-only or read-write. If mounts are disabled, the launcher can only be used to open files on the local machine.

   Note that mount tasks started by launchers are considered "background tasks." The :termy:global:`MountAction <Tasks/MountAction>` configured in the :doc:`Global settings <global>` will not be run, nor will a task status dialog be shown even if :termy:global:`AutoShowTaskStatus <Tasks/AutoShowTaskStatus>` is enabled. A task status dialog can be manually shown using the :doc:`Tasks tool <../tools/tasks>` or :termy:action:`InspectTask` action.

.. termy:launcher:: Launcher/UnmountIdleTime integer

   The maximum time that a :termy:action:`mount <MountFile>` task run by this launcher will remain idle before being automatically unmounted. A mount is considered "idle" if there are no open filehandles to files within it. If disabled, the mount task will never time out and must be manually canceled using the :doc:`Tasks tool <../tools/tasks>` or :termy:action:`CancelTask` action.

   .. caution:: Some applications and editors don't hold open filehandles to the file that they are editing. In this case, the mount may time out while the file is still open within the application or editor. Test each application, checking whether the status of the mount task is "Idle" while the file is open within the application. If so, consider disabling this setting.

.. termy:launcher:: Launcher/DisplayIcon string

   Sets the icon for the launcher, displayed in context menus and the :doc:`Manage Launchers window <../dialogs/manage-launchers>`. An SVG file with the specified name will be loaded from :file:`{$HOME}/.local/share/qtermy/images/command` and :file:`{prefix}/share/qtermy/images/command` in that order. If no such file is found, the name "default" is used instead.

Command
-------

.. termy:launcher:: Command/Command stringlist

   The command to run. This is a list of strings consisting of an executable name and argument vector (including argument zero).

   The command may contain markers of the form ``%X`` where ``X`` is a letter or number. Predefined markers :ref:`listed above <launcher-markers>` are used to substitute file paths and URL's. Other markers can be substituted using the :termy:param:`Substitutions` parameter to :termy:action:`OpenFile` and :termy:action:`LaunchCommand`.

   .. include:: command-common.rst

.. termy:launcher:: Command/Directory string

   The directory which the :termy:launcher:`Command <Command/Command>` is run from. If unspecified, the command will be started in the user's :envvar:`HOME` directory. Ignored if :termy:launcher:`FileDirectory <Command/FileDirectory>` is set and the launcher is used to open a file.

.. termy:launcher:: Command/FileDirectory boolean

   If enabled, the :termy:launcher:`Command <Command/Command>` will be run from the target file's enclosing directory, if available, rather than the configured :termy:launcher:`Directory <Command/Directory>`.

.. termy:launcher:: Command/Environment stringlist

   Environment variable rules used to set and clear environment variables before running the :termy:launcher:`Command <Command/Command>`.

InputOutput
-----------

.. termy:launcher:: InputOutput/InputType enumeration

   Specifies what to provide to the launched :termy:launcher:`Command <Command/Command>` on its standard input stream. Only applicable when the :termy:launcher:`LaunchType <Launcher/LaunchType>` is configured to run a bare command.

.. termy:launcher:: InputOutput/InputFile string

   The file to read input from if :termy:launcher:`InputType <InputOutput/InputType>` is configured to read from a local file. This file must be accessible to :program:`qtermy`. Select a predefined value from the dropdown list or specify a custom path.

.. termy:launcher:: InputOutput/OutputType enumeration

   Specifies what to do with the standard output and standard error streams of the launched :termy:launcher:`Command <Command/Command>`. Only applicable when the :termy:launcher:`LaunchType <Launcher/LaunchType>` is configured to run a bare command.

   .. warning:: The *Interpret output as action to run* option will interpret the output of the command as an arbitrary :doc:`action invocation <../actions>`, which could result in local commands being run. Do not run launchers of this type on untrusted or shared servers.

.. termy:launcher:: InputOutput/OutputFile string

   The file to write output to if :termy:launcher:`OutputType <InputOutput/OutputType>` is configured to write output to a local file. This file must be accessible to :program:`qtermy`. Select a predefined value from the dropdown list or specify a custom path.

.. termy:launcher:: InputOutput/OutputFileConfirmation enumeration

   What to do if :termy:launcher:`OutputType <InputOutput/OutputType>` is configured to write output to a local file that already exists.
