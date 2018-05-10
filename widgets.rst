.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Widgets
=======

Widgets are optional navigation and information aides displayed next to each terminal viewport. They can be arranged using the :termy:profile:`Appearance/WidgetLayout` profile setting as well as the :ref:`Adjust Layout dialog <adjust-layout>`. They can also be toggled from View→Tools.

Depending on the value of the :termy:profile:`ShowRemoteLayout <Collaboration/ShowRemoteLayout>` profile setting, :doc:`termyctl <../man/ctl>` may be used to adjust the widget layout from within the terminal and other users' widget layouts may be shown in :termy:action:`their <TakeTerminalOwnership>` terminals.

.. contents::
   :local:

.. _marks-widget:

Marks
-----

The Marks widget displays supplemental information about each line in the terminal in the form of two-character codes called *marks*. Marks are drawn using the appropriate :ref:`extended colors <theme-editor-extended>` from the terminal's color palette.

:doc:`Shell integration <shell-integration>` is required for prompt and job marks to be displayed.

The following marks are displayed:

   * ``E*``: A prompt (or equivalently, a :term:`job`) whose command exited normally. The second character is the reported exit status (see below).
   * ``S*``: A prompt (or equivalently, a :term:`job`) whose command was killed by a signal. The second character is the reported signal number (see below).
   * ``P>``: The current prompt (where the next command will be typed).
   * ``R<``: The currently running command.
   * ``M>``: The current :doc:`search match <tools/search>`.
   * ``N*``: An :term:`annotation`. The second character is the :doc:`note character <dialogs/create-annotation>` specified when creating the annotation.

The following convention is used to display the exit status or signal number of a completed job:

======  =========
Number  Character
======  =========
0-9     0-9
10-35   a-z
35-126  \+
127     \-
======  =========

Click in the marks widget to :term:`select <selected job>` the enclosing job and scroll to its prompt. Hover over a mark to display a tooltip with information about the item. Right click to bring up an item-specific context menu.

.. _minimap-widget:

Minimap
-------

The Minimap widget combines the functionality of a scrollbar with a display of points of interest within the terminal scrollback buffer. It is similar to the :ref:`Marks widget <marks-widget>`, but scaled to the size of the entire scrollback buffer. It displays the following information:

   * The location of its own :term:`viewport <active viewport>` within the scrollback buffer, displayed in a solid color with the viewport's pane index number at the center.
   * The location of other viewports onto the same terminal, each displayed as an outline with the other viewport's pane index number at the center.
   * The location of recent :term:`jobs <job>`, displayed using the :ref:`extended colors <theme-editor-extended>` appropriate for the job's exit status. The number of jobs shown is controlled by the :termy:profile:`NumRecentPrompts <Appearance/NumRecentPrompts>` profile setting. Clicking a job will :term:`select <selected job>` it. This requires :doc:`shell integration <shell-integration>`.

     The icon displayed with each job is derived by matching its command against the :doc:`icon autoswitch rules <../dialogs/icon-rule-editor>` that reference the ``proc.comm`` attribute.
   * The location of the :term:`selected job`. If multiple viewports are open onto the terminal, multiple selected jobs may be displayed.
   * The location of the current :doc:`search match <tools/search>`, if any.
   * The location of :term:`annotations <annotation>`, each displayed with its :doc:`note character <dialogs/create-annotation>`, if any.
   * The location of the active text selection, if any, displayed in a checkerboard pattern.
   * The progress of any ongoing background :termy:global:`fetch <Server/ScrollbackFetchSpeed>` of scrollback buffer contents, displayed as a triangular cursor. This is enabled by the :termy:profile:`ShowFetchPosition <Appearance/ShowFetchPosition>` profile setting.

Minimap items are drawn using the same :ref:`extended colors <theme-editor-extended>` as the marks in the :ref:`Marks widget <marks-widget>`. Hover over an item to display a tooltip with information about the item. Right click an item to bring up an item-specific context menu.

For a more minimal look, use an :ref:`ordinary scrollbar <scrollbar-widget>` instead.

.. _scrollbar-widget:

Scrollbar
---------

An ordinary vertical `scroll bar <http://doc.qt.io/qt-5/qscrollbar.html>`_ used to scroll within the terminal scrollback buffer.

To view more information about points of interest within the scrollback buffer, use the :ref:`Minimap widget <minimap-widget>` instead.

.. _timing-widget:

Timing
------

The Timing widget displays the time when each line in the terminal was last modified, relative to a particular line designated as the *origin*. Times are measured to the tenth of a second, but will be shown with less precision the further they are from the origin. Lines shown with no time have the same time as the line above (but see note below about blank lines).

The timing origin is normally *floating*, meaning that it will follow the terminal's :term:`current job` (this requires :doc:`shell integration <shell-integration>`). To set the origin at a fixed position, right click in the timing widget to bring up a context menu. To float the origin, use the context menu or :termy:action:`TimingFloatOrigin` action.

If the terminal is :termy:action:`owned <TakeTerminalOwnership>` by another client and :termy:profile:`FollowRemoteScrolling <Collaboration/FollowRemoteScrolling>` is enabled, the timing origin will track the information reported by the owning client.

.. note:: The modification times reported by :doc:`termy-server <server>` are only a rough approximation with no guarantee of precision or accuracy.

   Blank lines may not have a valid modification time. This is because modification times are only recorded for printable characters, and newline is considered a cursor movement rather than a printable character. Due to this, setting the timing origin on a blank line may fail.
