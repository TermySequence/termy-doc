.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Alert
=====

Alert settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/alerts`. Alerts can be created and edited from the :doc:`Manage Alerts window <../dialogs/manage-alerts>`. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Alerts window <../dialogs/manage-alerts>` to load external changes and new files without restarting the application.

An *alert* is a description of a terminal condition, together with the action that should be taken when the condition becomes true. An alert can be made active in a terminal from the Terminal menu, various context menus, or by using the :termy:action:`SetAlert` action. Only one alert can be active in a terminal at any given time.

When the condition described by the action becomes true in the terminal, the action will trigger and the action described by the alert will be taken. The alert will then be made inactive and will not trigger again in that terminal. An alert can also be made inactive from the Terminal menu, various context menus, or by using the :termy:action:`ClearAlert` action.

Alerts can be favorited in the :doc:`Manage Alerts window <../dialogs/manage-alerts>`, which will cause them to appear at the top of alert selection menus.

.. contents:: Settings Categories
   :local:

.. _alert-condition:

Condition
---------

.. termy:alert:: Condition/Type enumeration

   The type of condition that the alert will monitor for. The choices are as follows:

     * *Activity in terminal*: Any activity is reported by the terminal. This includes printable output as well as non-printing output such as control characters, bells, or region updates.
     * *Inactivity in terminal*: No activity occurs in the terminal for the duration of time specified by :termy:alert:`InactivityTime <Condition/InactivityTime>`.
     * *Command finishes in terminal*: A job finishes in the terminal with any exit status. This requires :doc:`shell integration <../shell-integration>`.
     * *Command succeeds in terminal*: A job finishes in the terminal with an exit status of zero. This requires :doc:`shell integration <../shell-integration>`.
     * *Command fails in terminal*: A job finishes in the terminal with a nonzero exit status. This requires :doc:`shell integration <../shell-integration>`.
     * *String seen in terminal*: The literal string specified by :termy:alert:`SearchString <Condition/SearchString>` is printed to the terminal. This must occur after the alert is made active (scrollback is not searched).
     * *Regex seen in terminal*: Any string matching the ECMAScript regular expression specified by by :termy:alert:`SearchString <Condition/SearchString>` is printed to the terminal. This must occur after the alert is made active (scrollback is not searched).
     * *Bell seen in terminal*: A bell character (BEL, Ctrl+G) is printed to the terminal.
     * *Attribute is string*: The terminal :term:`attribute` named by :termy:alert:`AttributeName <Condition/AttributeName>` becomes equal to the literal string specified by :termy:alert:`SearchString <Condition/SearchString>`. If this condition is true when the alert is :termy:action:`set <SetAlert>`, the alert will trigger immediately.
     * *Attribute is regex*: The terminal :term:`attribute` named by :termy:alert:`AttributeName <Condition/AttributeName>` matches the ECMAScript regular expression specified by :termy:alert:`SearchString <Condition/SearchString>`. If this condition is true when the alert is :termy:action:`set <SetAlert>`, the alert will trigger immediately.

.. termy:alert:: Condition/InactivityTime integer

   The time that the terminal must remain idle before the alert triggers, if the condition :termy:alert:`Type <Condition/Type>` is set to monitor for inactivity.

.. termy:alert:: Condition/SearchString string

   The search string or regular expression to match. Several condition types make use of this setting. See :termy:alert:`Type <Condition/Type>`.

.. termy:alert:: Condition/AttributeName string

   The terminal :term:`attribute` name to monitor, if the condition :termy:alert:`Type <Condition/Type>` is set to monitor for changes to an attribute.

.. _alert-actions:

Actions
-------

.. termy:alert:: Actions/SwitchProfile boolean

   If enabled, the terminal will be :termy:action:`switched <SwitchProfile>` to the configured :termy:alert:`Profile <Parameters/Profile>` when the alert is triggered.

.. termy:alert:: Actions/PushProfile boolean

   If enabled, the terminal will be :termy:action:`pushed <PushProfile>` to the configured :termy:alert:`Profile <Parameters/Profile>` when the alert is triggered.

.. termy:alert:: Actions/InvokeAction boolean

   If enabled, the configured :termy:alert:`Action <Parameters/Action>` will be :doc:`invoked <../actions>` when the alert is triggered.

.. termy:alert:: Actions/RunLauncher boolean

   If enabled, the configured :termy:alert:`Launcher <Parameters/Launcher>` will be :termy:action:`launched <LaunchCommand>` with no marker substitutions when the alert is triggered.

.. termy:alert:: Actions/DesktopNotify boolean

   If enabled, the name of the alert and the configured :termy:alert:`Message <Parameters/Message>` will be passed to :termy:action:`NotifySend` to show a desktop notification when the alert is triggered.

.. termy:alert:: Actions/ShowIndicator boolean

   If enabled, an "urgent" indicator icon will be displayed on the terminal thumbnail in the :doc:`Terminals tool <../tools/terminals>` when the alert is triggered.

   The "urgent" indicator icon will be cleared when input focus moves to or from the affected terminal, or when :termy:action:`ClearAlert` is called on the terminal.

.. termy:alert:: Actions/FlashThumbnail boolean

   If enabled, the the terminal thumbnail in the :doc:`Terminals tool <../tools/terminals>` will flash the number of times configured by :termy:alert:`Flashes <Parameters/Flashes>` when the alert is triggered.

.. termy:alert:: Actions/MoveTerminalForward boolean

   If enabled, :termy:action:`ReorderTerminalFirst` will be called on the terminal when the alert is triggered.

.. termy:alert:: Actions/MoveServerForward boolean

   If enabled, :termy:action:`ReorderServerFirst` will be called on the terminal's server when the alert is triggered.

Parameters
----------

.. termy:alert:: Parameters/Profile string

   The :doc:`profile <profile>` to use if :termy:alert:`SwitchProfile <Actions/SwitchProfile>` or :termy:alert:`PushProfile <Actions/PushProfile>` is enabled.

.. termy:alert:: Parameters/Action string

   The :doc:`action <../actions>` to invoke if :termy:alert:`InvokeAction <Actions/InvokeAction>` is enabled. The strings ``<terminalId>`` and ``<serverId>`` within the action string will be replaced as appropriate at invocation time. Any other action parameters must be hard-coded.

.. termy:alert:: Parameters/Launcher string

   The :doc:`launcher <launcher>` to run if :termy:alert:`RunLauncher <Actions/RunLauncher>` is enabled.

.. termy:alert:: Parameters/Flashes integer

   The number of times to flash the terminal thumbnail if :termy:alert:`FlashThumbnail <Actions/FlashThumbnail>` is enabled.

   .. note:: Thumbnail flashing may be interrupted if the terminal thumbnail is flashed for another reason, such as a :termy:global:`ThumbnailBell <Effects/ThumbnailBell>` or :termy:profile:`ExitStatusEffect <Effects/ExitStatusEffect>`.

.. termy:alert:: Parameters/Message string

   The message to use as the :termy:param:`Body` parameter to :termy:action:`NotifySend` if :termy:alert:`DesktopNotify <Actions/DesktopNotify>` is enabled. The name of the alert itself is used as the :termy:param:`Summary` parameter.
