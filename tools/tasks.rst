.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Tasks
=====

The Tasks tool displays the list of tasks which have been run in the application. There are many different types of tasks, some of which are started by calling certain :doc:`actions <../actions>`. The Tasks tool serves as the central location to view and manage tasks. Tasks come in two flavors: :term:`active tasks <active task>` such as :termy:action:`downloads <DownloadFile>` that run to completion on their own and non-active or "long-running" tasks such as :termy:action:`port forwards <LocalPortForward>` that generally run until explicitly :termy:action:`canceled <CancelTask>`.

The Tasks tool is not :termy:action:`searchable <ToolSearch>` but it is :ref:`navigable <tools-navigable>`, having a current selection that can be moved and acted upon using generic or tool-specific actions. Via global settings, certain :doc:`actions <../actions>` can be configured to run on a double-click, Control-click, Shift-click, or middle-click of a task. Further :doc:`global settings <../settings/global>` for the tool are located under the :ref:`Tasks/Tasks Tool <global-tasks-tool>` category.

The Tasks tool can be :termy:global:`configured <Tasks/AutoRaiseTasks>` to autoraise itself when a task has started or finished. Individual task status dialogs can also be configured to :termy:global:`show <Tasks/AutoShowTaskStatus>` and :termy:global:`hide <Tasks/AutoHideTaskStatus>` themselves automatically. Task status dialogs can be shown manually using Tools→Show Status, from the Tasks tool context menu, or by calling :termy:action:`InspectTask`. The Tasks tool will not autohide until all :term:`active tasks <active task>` have completed and a configurable brief :termy:global:`idle period <Tasks/TasksDelayTime>` has passed.  Clicking in the Tasks tool will cancel autohide as well. This provides time for the user to observe the task that caused the Tasks tool or task status dialog to pop up.

Tasks can be sorted in ascending or descending order by progress, type, source, destination, start time, and several other fields by clicking a table column header. Drag table column headers to reorder them and use the header's context menu to show and hide individual columns.

Some tasks are considered "background" tasks and will not display a task status dialog automatically, regardless of the :termy:global:`AutoShowTaskStatus <Tasks/AutoShowTaskStatus>` setting. These tasks include:

   * :termy:action:`Mount <MountFile>` tasks run by a :doc:`launcher <../settings/launcher>` as part of a call to :termy:action:`OpenFile`.
   * :termy:action:`Fetch image <FetchImage>` tasks used to retrieve images for inline display. See :doc:`termy-imgcat <../man/download>` and :doc:`termy-imgls <../man/download>`.
   * :termy:action:`Run command <LaunchCommand>` tasks run by a :doc:`launcher <../settings/launcher>` configured to display program :termy:launcher:`output <InputOutput/OutputType>` in a separate dialog box.
   * :termy:action:`Connection <OpenConnection>` tasks, including tasks launched by :doc:`batch connections <../dialogs/connect-batch>`. These display a different :doc:`dialog box <../dialogs/connection-status>`.
   * :termy:action:`Port forwarding <LocalPortForward>` tasks launched automatically as a result of server :termy:server:`PortForwardingRules <Server/PortForwardingRules>`.

:term:`Active tasks <active task>` have a progress bar that updates as the task proceeds to completion. The progress bar for the most recently launched active task is shown in the status bar where the home page link is normally displayed. Long-running tasks are shown with an empty progress bar that never advances.

Some tasks such as :termy:action:`download <DownloadFile>` and mount tasks produce an output file or directory on the local machine. This output file can be accessed directly from the Tasks tool or task status dialog in a number of ways: it can be opened using the :term:`default launcher`, a terminal can be opened to its enclosing directory, or its path can be :termy:action:`copied <CopyTaskFile>` or :termy:action:`written <WriteTaskFile>` to the :term:`active terminal`.

Some tasks are *clonable*, which means they can be restarted as a new task with the same parameters as before. Clone a task using Tools→Re-run Task, the Tasks tool context menu, or the :termy:action:`RestartTask` action.
