.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Custom Action
=============

A Custom Action is a :doc:`plugin <index>` feature that acts as a new :doc:`action <../actions>` within :program:`qtermy`. It can be invoked with parameters just like an ordinary action, from any setting that specifies an action string. This includes :ref:`action bindings <keymap-action>` in a :doc:`keymap <../settings/keymap>`. Simply prepend the string "Custom" to the name of the custom action as passed to :js:func:`registerCustomAction` and join it together with any parameters separated by vertical bar (\|) characters.

Custom actions have access to a rich API that exposes much of :program:`qtermy`'s internal state. It's even possible to prompt the user for string values and to register timers and callback functions to be notified of :term:`attribute` changes. Custom actions can invoke other actions, including custom actions, although such invocations will not be made until after control has returned from the custom action.

The file :file:`action.mjs.example` distributed with :program:`qtermy` implements a variety of sample custom actions and is annotated with explanatory comments. The file :file:`rectcopy.mjs` is another custom action implementing rectangle copy of selected text.

The entry point to a custom action is the run function passed to :js:func:`plugin.registerCustomAction`, which is called once each time the action is invoked:

.. js:function:: run_function(manager[, arg1, arg2...])

   Invokes the custom action with the specified :ref:`manager handle <action-manager>`. The remaining arguments are the parameters specified in the action invocation, if any.

.. contents::
   :local:

.. _action-handle:

Handle Interface
----------------

The custom action API is based primarily on typed *handles*, which are Javascript objects that provide interfaces to specific objects within :program:`qtermy` such as windows, terminals, :doc:`settings objects <../settings/index>`, etc. Handles have the following common methods across all object types:

.. js:function:: handle.isValid()

   Returns whether the handle is valid. Handles become invalid when their underlying object is deleted. A handle which has been saved across Javascript entry points must be checked using this method before using it.

.. js:function:: handle.setPrivateData(name, value)

   Attaches an arbitrary value to the handle with the given name. It can be retrieved using :js:func:`getPrivateData <handle.getPrivateData>` from any handle of the same type which references the same underlying object.

.. js:function:: handle.getPrivateData(name)

   Returns a value previously attached to the handle using :js:func:`setPrivateData <handle.setPrivateData>`, or ``undefined`` if no such value exists.

.. js:function:: handle.setInterval(callbackObj, timeout)

   Installs a notification callback to be called on a periodic interval. The callback will be called repeatedly until canceled.

   :param object callbackObj: See below
   :param integer timeout: A nonzero timeout interval expressed in tenths of a second.
   :returns: An object with a ``cancel`` method that will cancel the timer.

   The *callbackObj* must define its ``callback`` field to a method which takes a :ref:`handle <action-handle>` as its first argument. The object may also contain arbitrary private fields for the plugin's own use. For protection against future API changes, name private fields starting with an underscore (_) character. A return value other than ``true`` or ``undefined`` from the callback method will cancel the timer.

.. _action-manager:

Manager Interface
-----------------

A manager handle represents an application window. Since actions may need to display modal dialogs, all actions are invoked in the context of an application window.

.. js:function:: manager.invoke(actionName[, arg1, arg2...])

   Invokes the specified :doc:`action <../actions>` with the given parameters, if any. The actual invocation will be delayed until after control has returned from Javascript. Multiple action invocations will be run in the order they are made.

   If it's necessary to regain control after the action has been invoked, register a callback using :js:func:`setInterval <handle.setInterval>`.

.. js:function:: manager.notifySend(summary, body)

   Calls :termy:action:`NotifySend` with the given *summary* and *body*.

.. js:function:: manager.listServers()

   Returns a list of :ref:`server handles <action-server>` corresponding to all currently connected :doc:`servers <../settings/server>`.

.. js:function:: manager.getServerById(uuid)

   Returns a :ref:`server handle <action-server>` for the given server UUID string, or ``undefined`` if no such server is connected.

.. js:function:: manager.getActiveServer()

   Returns a :ref:`server handle <action-server>` for the :term:`active server`, or ``undefined`` if there is no active server.

.. js:function:: manager.getLocalServer()

   Returns a :ref:`server handle <action-server>` for the :term:`local server`, or ``undefined`` if there is no local server connected.

.. js:function:: manager.listTerminals()

   Returns a list of :ref:`terminal handles <action-terminal>` corresponding to all terminals.

.. js:function:: manager.getTerminalById(uuid)

   Returns a :ref:`terminal handle <action-terminal>` for the given terminal UUID string, or ``undefined`` if no such terminal exists.

.. js:function:: manager.getActiveTerminal()

   Returns a :ref:`terminal handle <action-terminal>` for the :term:`active terminal`, or ``undefined`` if there is no active terminal.

.. js:function:: manager.createTerminal(server, profile[, termParams])

   Creates a new terminal on the given server, with the given profile, using the given parameters.

   :param handle server: A :ref:`server handle <action-server>`.
   :param handle profile: A :ref:`profile handle <action-settings>`.
   :param object termParams: See below
   :returns: A :ref:`terminal handle <action-terminal>` for the new terminal.

   If *termParams* is provided, its fields are used to override the settings in the given :doc:`profile <../settings/profile>`. All fields are optional.

      theme
         A :ref:`theme handle <action-settings>` from which the terminal's :termy:profile:`Palette <Appearance/Palette>` and :termy:profile:`Dircolors <Files/Dircolors>` will be set.

      palette
         A palette object as described by :js:attr:`terminal.palette`. Unspecified indices (holes) will be filled with values from the compiled-in default palette. The terminal's :termy:profile:`Palette <Appearance/Palette>` and :termy:profile:`Dircolors <Files/Dircolors>` will be set from the result.

      layout
         See :js:attr:`terminal.layout`.

      fills
         See :js:attr:`terminal.fills`.

      badge
         See :js:attr:`terminal.badge`.

      icon
         See :js:attr:`terminal.icon`.

      attributes
         A dictionary of additional key/value pairs to set as terminal :term:`attributes <attribute>`.

      environment
         A list of strings of the form ``+name=value`` to set an environment variable or ``-name`` to remove an environment variable. These will be applied on top of the profile's :termy:profile:`Environment <Emulator/Environment>` setting.

.. js:function:: manager.getActiveViewport()

   Returns a :ref:`viewport handle <action-viewport>` for the :term:`active viewport`, or ``undefined`` if there is no active viewport.

.. js:function:: manager.getGlobalSettings()

   Returns a :ref:`settings handle <action-settings>` for the :doc:`Global settings <../settings/global>`.

.. js:function:: manager.getDefaultProfile()

   Returns a :ref:`settings handle <action-settings>` for the :term:`global default profile`.

.. js:function:: manager.listThemes()

   Returns a list of :ref:`settings handles <action-settings>` corresponding to all :doc:`themes <../settings/theme>`.

.. js:function:: manager.listPanes()

   Returns a list of objects corresponding to this application window's split window panes. Each object has the following fields:

   viewport
      A :ref:`viewport handle <action-viewport>` for the pane.

   index
      The pane's index number, as displayed in the viewport (with :termy:global:`ShowMainIndex <Appearance/ShowMainIndex>`) or terminal thumbnail (with :termy:global:`ShowThumbnailIndex <Appearance/ShowThumbnailIndex>`).

.. js:function:: manager.prompt(callbackObj, prompt[, initial])

   Prompts the user for a string value. Only one prompt can be displayed at a time.

   :param object callbackObj: See below
   :param string prompt: The prompt message to display to the user.
   :param string initial: An optional initial value for the input text field.
   :returns: ``true`` on success, ``false`` if the prompt cannot be displayed

   The *callbackObj* must define its ``callback`` field to a method which takes a :ref:`manager handle <action-manager>` as its first argument and the user-provided string as its second argument. This will be invoked if and when the user accepts the dialog. The object may also contain arbitrary private fields for the plugin's own use. For protection against future API changes, name private fields starting with an underscore (_) character.

.. js:function:: manager.copy(string)

   Copies the given string to the clipboard as UTF-8 text.

.. _action-server:

Server Interface
----------------

A server handle represents a connected :doc:`server <../settings/server>`.

.. js:attribute:: server.id

   The UUID of the server.

.. js:function:: server.getAttribute(name)

   Returns the value of the named server :term:`attribute`, or ``undefined`` if it doesn't exist.

.. js:function:: server.getActiveManager()

   Returns a :ref:`manager handle <action-manager>` for the active application window.

.. js:function:: server.listTerminals()

   Returns a list of :ref:`terminal handles <action-terminal>` corresponding to the server's terminals.

.. js:function:: server.getDefaultProfile()

   Returns a :ref:`settings handle <action-settings>` for the server's :termy:server:`DefaultProfile <Server/DefaultProfile>`.

.. js:function:: server.setAttributeNotifier(callbackObj, name[, timeout])

   Installs a notification callback to be called whenever the named :term:`attribute` changes on this server.

   :param object callbackObj: See below
   :param string name: The name of the attribute to monitor.
   :param integer timeout: An optional timeout expressed in tenths of a second. The monitor will be automatically canceled after the timeout has elapsed. If not specified, the monitor will remain active until explicitly canceled.
   :returns: An object with a ``cancel`` method that will cancel the attribute monitor.

   The *callbackObj* must define its ``callback`` field to a method which takes a :ref:`server handle <action-manager>` as its first argument, the new value of the attribute as its second argument, and the attribute name as its third argument. The object may also contain arbitrary private fields for the plugin's own use. For protection against future API changes, name private fields starting with an underscore (_) character. A return value other than ``true`` or ``undefined`` from the callback method will cancel the attribute monitor.

.. _action-terminal:

Terminal Interface
------------------

.. js:attribute:: terminal.id

   The UUID of the terminal.

.. js:attribute:: terminal.width

   The width of the terminal's screen in character cells.

.. js:attribute:: terminal.height

   The height of the terminal's screen in character cells.

.. js:attribute:: terminal.palette

   An object specifying hex RGB values by numeric index. When reading, all indices will be set. When writing, unspecified indices (holes) will be filled with values from the terminal's current palette. Use the value 0x1000000 for a "disabled" :ref:`extended color <theme-editor-extended>`. The object's ``dircolors`` field specifies a :doc:`dircolors string <../dialogs/dircolors-editor>`.

.. js:attribute:: terminal.font

   The string describing the terminal's :termy:profile:`Font <Appearance/Font>`. This property can be written.

.. js:attribute:: terminal.layout

   A :termy:profile:`WidgetLayout <Appearance/WidgetLayout>` string in the format specified by :doc:`termyctl <../man/ctl>`. This property can be written.

.. js:attribute:: terminal.fills

   A :termy:profile:`ColumnFills <Appearance/ColumnFills>` string in the format specified by :doc:`termyctl <../man/ctl>`. This property can be written.

.. js:attribute:: terminal.badge

   A :termy:profile:`Badge <Appearance/Badge>` format string. This property can be written.

.. js:attribute:: terminal.icon

   The terminal's :termy:profile:`FixedThumbnailIcon <Appearance/FixedThumbnailIcon>`. An empty string indicates no fixed icon. This property can be written.

.. js:attribute:: terminal.rows

   A :ref:`buffer handle <action-buffer>` for the terminal's scrollback buffer.

.. js:function:: terminal.getAttribute(name)

   Returns the value of the named terminal :term:`attribute`, or ``undefined`` if it doesn't exist.

.. js:function:: terminal.getActiveManager()

   Returns a :ref:`manager handle <action-manager>` for the active application window.

.. js:function:: terminal.getProfile()

   Returns a :ref:`settings handle <action-settings>` for the terminal's current :doc:`profile <../settings/profile>`.

.. js:function:: terminal.getServer()

   Returns a :ref:`server handle <action-server>` for the terminal's :doc:`server <../settings/server>`.

.. js:function:: terminal.setAttributeNotifier(callbackObj, name[, timeout])

   Installs a notification callback to be called whenever the named :term:`attribute` changes on this terminal. Refer to :js:func:`server.setAttributeNotifier`.

.. js:function:: terminal.getStart()

   Returns a :ref:`cursor <action-cursor>` pointing to the top of the terminal's screen.

.. js:function:: terminal.getEnd()

   Returns a :ref:`cursor <action-cursor>` pointing to the bottom of the terminal's screen.

.. js:function:: terminal.nextRegionId()

   Same as :js:func:`processContext.nextRegionId`.

.. js:function:: terminal.createRegion(start, end[, regionParams])

   Creates a :term:`semantic region` in the same manner as a :doc:`semantic parser <parser>`.

   :param handle start: A :ref:`cursor <action-cursor>` at the desired start position.
   :param handle end: A :ref:`cursor <action-cursor>` at the desired end position.
   :param object regionParams: See :ref:`parser-region-params`.
   :returns: A :ref:`region handle <action-region>` for the new region, or ``undefined`` if the region could not be created.

.. js:function:: terminal.createNote(start, end[, noteParams])

   Creates an :term:`annotation`.

   :param handle start: A :ref:`cursor <action-cursor>` at the desired start position.
   :param handle end: A :ref:`cursor <action-cursor>` at the desired end position.
   :param object noteParams: See below
   :returns: ``true`` if the annotation was successfully created, ``false`` otherwise.

   If *noteParams* is provided, its ``text`` field is used to set the annotation's note text and its ``char`` field is used to set the annotation's note character. Both fields are optional. Refer to :doc:`../dialogs/create-annotation` for more information.

.. _action-viewport:

Viewport Interface
------------------

A viewport handle represents a split window pane.

.. js:attribute:: viewport.width

   The width of the viewport in character cells.

.. js:attribute:: viewport.height

   The height of the viewport in character cells.

.. js:attribute:: viewport.active

   Whether the viewport is the :term:`active viewport` in its application window.

.. js:attribute:: viewport.primary

   Whether the viewport is the :term:`active viewport` in its application window *and* the window either has input focus or last received input focus.

.. js:attribute:: viewport.rows

   A :ref:`buffer handle <action-buffer>` for the scrollback buffer of the viewport's terminal.

.. js:function:: viewport.getTerminal()

   Returns a :ref:`terminal handle <action-terminal>` for the viewport's terminal.

.. js:function:: viewport.getStart()

   Returns a :ref:`cursor <action-cursor>` pointing to the top of the viewport.

.. js:function:: viewport.getEnd()

   Returns a :ref:`cursor <action-cursor>` pointing to the bottom of the viewport.

.. js:function:: viewport.getSelectedJob()

   Returns a :ref:`region handle <action-region>` for the viewport's :term:`selected job`, or ``undefined`` if there is none.

.. js:function:: viewport.getSelection()

   Returns a :ref:`region handle <action-region>` for the viewport's active text selection, or ``undefined`` if there is none.

.. js:function:: viewport.createSelection(start, end)

   Creates a text selection.

   :param handle start: A :ref:`cursor <action-cursor>` at the desired start position.
   :param handle end: A :ref:`cursor <action-cursor>` at the desired end position.
   :returns: A :ref:`region handle <action-region>` for the new text selection.

.. js:function:: viewport.createFlash(start, end, regionParams)

   Creates a short-lived, animated :term:`semantic region` to draw the user's attention to a specific piece of text.

   Identical to :js:func:`terminal.createRegion`, but *regionParams* may contain the following additional optional fields:

      duration
         The number of times to flash the semantic region. A default value will be used if unspecified.

      callback
         A callback method as described by :js:func:`handle.setInterval` which will be called after the animation has finished. The callback will only be called once.

.. js:function:: viewport.getMousePosition()

   If the viewport is :js:attr:`active <viewport.active>`, returns a :ref:`cursor <action-cursor>` pointing to the location of the mouse pointer within the viewport, otherwise returns ``undefined``.

.. js:function:: viewport.scrollTo(cursor, exact)

   Scrolls the viewport to a specific location in the scrollback buffer.

   :param cursor cursor: A :ref:`cursor <action-cursor>` at the desired row.
   :param boolean exact: If true, the top of the viewport will be placed at the given row or as close to the given row as possible. If false, the viewport will be scrolled in the direction of the row until it is visible within the viewport.

.. _action-settings:

Settings Interface
------------------

A settings handle refers to a :doc:`settings object <../settings/index>`.

.. js:attribute:: settings.name

   The name of the settings object.

.. js:function:: settings.getSetting(name)

   Retrieves a setting by its full name (including the category), for example :termy:profile:`Effects/EnableTextBlink` in the :doc:`Global settings <../settings/global>`. The value returned will depend on the setting.

.. js:function:: settings.getKeymap()

   For profile handles only, returns a :ref:`settings handle <action-settings>` for the profile's :termy:profile:`Keymap <Input/Keymap>`.

.. js:function:: settings.lookupShortcut(actionString)

   For keymap handles only, looks up the action string in the keymap. If there is an :ref:`action binding <keymap-action>` for it, returns an object with ``expression`` and ``additional`` fields describing the binding.

.. _action-buffer:

Buffer Interface
----------------

A buffer handle provides an array-like interface to a terminal's scrollback buffer. Accessing the handle using an array subscript will return a :ref:`cursor <action-cursor>` pointing to the start of the given row, indexed starting from the top of the scrollback buffer.

.. js:attribute:: buffer.length

   Returns number of rows in the scrollback buffer. Note that the scrollback buffer is considered to include the terminal screen itself.

.. js:attribute:: buffer.origin

   Returns the *true index* of the first row in the scrollback buffer. This is the row number it would have if the scrollback buffer were of size 2\ :sup:`64` rather than the configured :termy:profile:`size <Emulator/ScrollbackSizePower>`. Some actions take true index numbers as parameters.

.. _action-cursor:

Cursor Interface
----------------

A cursor points to a specific character position within a terminal's scrollback buffer. The fields of a cursor are read-only. Use the cursor's methods to reposition it.

The terminal's :termy:profile:`Encoding <Emulator/Encoding>` determines the width and combining characteristics of individual code points which in turn affects the behavior of cursors.

.. important:: Cursors are invalidated once control returns from Javascript. To track a particular location across Javascript entry points, use a :ref:`persistent cursor <action-persistent>`.

.. js:attribute:: cursor.row

   The cursor's row, indexed from the top of the scrollback buffer.

.. js:attribute:: cursor.offset

   The offset of the cursor within the row's text string, measured in UTF-16 code points. Use this value when performing Javascript string computations.

.. js:attribute:: cursor.column

   The "x position" of the cursor indexed from zero. This is the character cell where the cursor would appear on the terminal screen.

.. js:attribute:: cursor.columns

   The "x width" of the row. This is the number of character cells occupied by the row's text.

.. js:attribute:: cursor.character

   The number of logical characters between the beginning of the row and the cursor. Double-width characters may cause this value to differ from the cursor's :js:attr:`column <cursor.column>`.

.. js:attribute:: cursor.characters

   The total number of logical characters in the row's text.

.. js:attribute:: cursor.text

   The text of the row.

.. js:attribute:: cursor.continuation

   Whether the row is a continuation row, meaning that the previous row exceeded the width of the terminal screen and wrapped onto this row.

.. js:attribute:: cursor.flags

   Low-level row flags. This includes the :js:attr:`continuation <cursor.continuation>` flag as well as double-width and double-height flags.

.. js:function:: cursor.compareTo(other)

   Compares this cursor to another cursor. Returns -1, 0, or 1 if this cursor points to a location before, equal to, or after the other cursor's location, respectively.

.. js:function:: cursor.clone()

   Returns a new cursor pointing to the same location as this cursor.

.. js:function:: cursor.toPersistent()

   Returns a new :ref:`persistent cursor <action-persistent>` at this cursor's location. This can be converted back to a cursor at a later time.

.. js:function:: cursor.getJob()

   Returns a :ref:`region handle <action-region>` for the :term:`job` enclosing the cursor position, or or ``undefined`` if there is none.

.. js:function:: cursor.measureColumns(string)

   Returns the "x width" of the given string. This is the number of character cells occupied by the string's text.

.. js:function:: cursor.measureCharacters()

   Returns the number of logical characters in the given string.

.. js:function:: cursor.moveByRows(delta)

   Moves the cursor by the specified number of rows. A positive number moves down in the scrollback buffer. If necessary, the cursor's :js:attr:`character <cursor.character>` position will be adjusted to fit within the text of the new row. Returns a reference to the cursor.

.. js:function:: cursor.moveToRow(row)

   Moves the cursor to the specified row, indexed from the top of the scrollback buffer. Returns a reference to the cursor.

.. js:function:: cursor.moveByOffset(delta)

   Moves the cursor by the specified number of UTF-16 code points within its current row. Use this method when performing Javascript string computations. The new cursor location will be adjusted to the nearest logical character. Returns a reference to the cursor.

.. js:function:: cursor.moveToOffset(offset)

   Moves the cursor to the specified string offset within its current row, measured in UTF-16 code points. Use this method when performing Javascript string computations. The new cursor location will be adjusted to the nearest logical character. Returns a reference to the cursor.

.. js:function:: cursor.moveByColumns(delta)

   Moves the cursor by the specified number of character cell positions or "x width" within its current row The new cursor location will be adjusted to the nearest logical character. Returns a reference to the cursor.

.. js:function:: cursor.moveToColumn(column)

   Moves the cursor to the specified character cell position or "x position" within its current row. The new cursor location will be adjusted to the nearest logical character. Returns a reference to the cursor.

.. js:function:: cursor.moveByCharacters(delta)

   Moves the cursor by the specified number of logical characters within its current row. Returns a reference to the cursor.

.. js:function:: cursor.moveToCharacter(pos)

   Moves the cursor to the specified logical character position within its current row. Returns a reference to the cursor.

.. js:function:: cursor.moveToEnd()

   Moves the cursor to the end of its current row. Returns a reference to the cursor.

.. js:function:: cursor.moveToNextJob()

   Moves the cursor to the beginning of the next :term:`job` and returns a :ref:`region handle <action-region>` for it. If there is no such region, the cursor is unchanged and ``undefined`` is returned.

.. js:function:: cursor.moveToPreviousJob()

   Moves the cursor to the beginning of the previous :term:`job` and returns a :ref:`region handle <action-region>` for it. If there is no such region, the cursor is unchanged and ``undefined`` is returned.

.. js:function:: cursor.moveToNextNote()

   Moves the cursor to the beginning of the next :term:`annotation` and returns a :ref:`region handle <action-region>` for it. If there is no such region, the cursor is unchanged and ``undefined`` is returned.

.. js:function:: cursor.moveToPreviousNote()

   Moves the cursor to the beginning of the previous :term:`annotation` and returns a :ref:`region handle <action-region>` for it. If there is no such region, the cursor is unchanged and ``undefined`` is returned.

.. js:function:: cursor.moveToFirstRow()

   Moves the cursor to the beginning of the first row in the scrollback buffer. Returns a reference to the cursor.

.. js:function:: cursor.moveToLastRow()

   Moves the cursor to the beginning of the last row in the scrollback buffer. Returns a reference to the cursor.

.. js:function:: cursor.moveToScreenStart()

   Moves the cursor to the top of the terminal's screen. Returns a reference to the cursor.

.. js:function:: cursor.moveToScreenEnd()

   Moves the cursor to the bottom of the terminal's screen. Returns a reference to the cursor.

.. js:function:: cursor.moveToScreenCursor()

   Moves the cursor to the location of the terminal's text cursor within its screen. Returns a reference to the cursor.

.. _action-persistent:

Persistent Interface
--------------------

A persistent cursor points to a specific character position within a terminal's scrollback buffer. Unlike an ordinary :ref:`cursor <action-cursor>`, it can be stored across Javascript entry points. However, it may not be possible to restore a saved persistent cursor if the saved location has scrolled off the top of the scrollback buffer.

.. js:function:: persistent.toCursor()

   Returns a new :ref:`cursor <action-cursor>` at the persistent cursor's location, or ``undefined`` if the location is no longer within the scrollback buffer.

.. _action-region:

Region Interface
----------------

A region handle refers to a :term:`region`.

.. js:attribute:: region.id

   The ID of the region (an unsigned integer).

.. js:attribute:: region.flags

   Low-level region flags.

.. js:method:: region.getAttribute(name)

   Returns the value of the named region :term:`attribute`, or ``undefined`` if it doesn't exist.

.. js:method:: region.getStart()

   Returns a :ref:`cursor <action-cursor>` pointing to the beginning of the region.

.. js:method:: region.getEnd()

   Returns a :ref:`cursor <action-cursor>` pointing to the end of the region.

.. js:method:: region.getPrompt()

   Returns a :ref:`region handle <action-region>` for the prompt region belonging to the given :term:`job`, or ``undefined`` if this region is not a job region or the region does not exist.

.. js:method:: region.getCommand()

   Returns a :ref:`region handle <action-region>` for the command region belonging to the given :term:`job`, or ``undefined`` if this region is not a job region or the region does not exist.

.. js:method:: region.getOutput()

   Returns a :ref:`region handle <action-region>` for the output region belonging to the given :term:`job`, or ``undefined`` if this region is not a job region or the region does not exist.

.. js:method:: region.getJob()

   Returns a :ref:`region handle <action-region>` for the job region enclosing this region, or ``undefined`` if this region is not a prompt, command, or output region or the region does not exist.
