.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Tools
=====

Tools are dockable widgets that are displayed in :program:`qtermy`'s main application windows. Use View→Tools or Tools→Activate to bring up a tool. Click the close button on a tool's title bar to close it. Drag a tool's title bar or tab to rearrange or detach the tool.

.. _tools-active:

The *active tool* is the tool other than the :doc:`Terminals tool <terminals>` and :doc:`Keymap tool <keymap>` that was last used in some way. A tool is made active by clicking anywhere in it, by calling :doc:`actions <../actions>` specific to the tool, or when the tool autoraises itself. The Tools menu tracks the active tool and shows only entries that apply to that tool. Certain actions such as :termy:action:`ToolPrevious`, :termy:action:`ToolNext`, :termy:action:`ToolAction` and :termy:action:`ToolSearch` operate on the active tool.

.. _tools-navigable:
.. _tools-searchable:

A tool that is *searchable* has a search bar that can be shown using :termy:action:`ToolSearch`. A tool that is *navigable* has a current selection that can be acted on using :termy:action:`ToolAction` and moved using either the generic :termy:action:`ToolPrevious`, :termy:action:`ToolNext`, :termy:action:`ToolFirst`, and :termy:action:`ToolLast`, or tool-specific actions such as :termy:action:`FilePrevious` and :termy:action:`FileNext`.

Some tools can be configured to autoraise themselves in response to external events. For example, the :doc:`Terminals tool <terminals>` can raise itself when the :term:`active terminal` changes, the :doc:`Suggestions tool <suggestions>` can raise itself when a command is being entered, and the :doc:`Tasks tool <tasks>` can raise itself upon a task starting or finishing. Tool auto-raising is configured in the :doc:`Global settings <../settings/global>`.

.. toctree::
   :caption: Tools:

   terminals
   keymap
   suggestions
   search
   files
   history
   annotations
   tasks

Use the following actions to quickly raise each tool. The key bindings shown are from :program:`qtermy`'s compiled-in default keymap; your keymap may differ.

   * :termy:action:`RaiseKeymapTool`: Shift+F1
   * :termy:action:`RaiseTerminalsTool`: Shift+F2
   * :termy:action:`RaiseSuggestionsTool`: Shift+F3
   * :termy:action:`RaiseSearchTool`: Shift+F4
   * :termy:action:`RaiseFilesTool`: Shift+F5
   * :termy:action:`RaiseHistoryTool`: Shift+F6
   * :termy:action:`RaiseAnnotationsTool`: Shift+F7
   * :termy:action:`RaiseTasksTool`: Shift+F8

Tool settings, including table column sorting and visibility, whether or not the :termy:action:`search bar <ToolSearch>` and table header are visible, and autoscroll options, are saved in the :doc:`State settings <../settings/state>`.
