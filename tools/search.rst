.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Search
======

The Search tool implements text search within the terminal scrollback buffer. Using Edit→Find or calling the :termy:action:`Find` action will simply raise this tool and focus the search bar. Using Edit→Reset Search or calling :termy:action:`SearchReset` will clear the search bar. Press Escape while the search bar has input focus to cancel the current search and return input focus to the terminal viewport. Press Return while the search bar has input focus to return input focus to the terminal viewport without canceling the current search.

The Search tool is considered :ref:`searchable <tools-searchable>`; the :termy:action:`ToolSearch` and :termy:action:`ToolSearchReset` actions have the same effect as :termy:action:`Find` and :termy:action:`SearchReset` when the Search tool is the :ref:`active tool <tools-active>`. The Search tool is not :ref:`navigable <tools-navigable>`. :termy:action:`ToggleToolSearchBar` has no effect on the Search tool.

The Search tool supports searching for single-line literal strings and ECMAScript regular expressions in case sensitive or case insensitive mode. Use the controls within the tool to specify the type of search. Each terminal can only have one search running at a time within the application. If multiple viewports are open onto a single terminal, they will all share the same search string.

Entering a search string into the search bar will immediately start a *passive search*: any matching text inside the terminal viewport will be highlighted in :ref:`prominent colors <theme-editor-extended>`. Clicking the Search Up and Search Down buttons or calling :termy:action:`SearchUp` or :termy:action:`SearchDown` will run an *active search* in which the scrollback buffer is scanned in the given direction starting from the location of the current search match, if present, otherwise from the current position of the viewport. The location of the current search match is shown within the :ref:`Marks <marks-widget>` and :ref:`Minimap <minimap-widget>` widgets.
