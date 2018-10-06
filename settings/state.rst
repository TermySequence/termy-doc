.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

State
=====

The state settings object is a singleton stored at :file:`{$HOME}/.config/qtermy/qtermy.state`. This settings object is used to store application state information and cannot be edited directly from within :program:`qtermy`. The file is in INI format but many state settings are stored as opaque byte arrays.

The information saved in the state settings includes the following:

   * The information saved by the :termy:global:`SaveGeometry <Global/SaveGeometry>` feature.
   * The information saved by the :termy:global:`SaveOrder <Global/SaveOrder>` feature.
   * Window geometry and other settings saved by :doc:`windows and dialog boxes <../dialogs/index>`.
   * Table column ordering, visibility, sorting, :termy:action:`search bar <ToolSearch>` visibility, and other settings saved by :doc:`Tools <../tools/index>`.
   * Which :doc:`profiles <profile>`, :doc:`connections <connection>`, :doc:`launchers <launcher>`, and :doc:`alerts <alert>` have been marked as favorite.
   * Which :doc:`profile <profile>` and :doc:`launcher <launcher>` have been marked as default.
   * Which icons were last specified in calls to :termy:action:`SetTerminalIcon` and :termy:action:`SetServerIcon`.
   * Whether to show the :termy:action:`TipOfTheDay` and :termy:action:`SetupTasks` dialog boxes on startup.
