.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Keymap
======

Keymap settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/keymaps`. Keymaps can be edited from the Settings menu, the :doc:`Manage Keymaps window <../dialogs/manage-keymaps>`, and various context menus, or by calling the :termy:action:`EditKeymap` action. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Manage Keymaps window <../dialogs/manage-keymaps>` to load external changes and new files without restarting the application.

The keymap that is used in a terminal is specified by the terminal's :doc:`profile <profile>`. To change a terminal's keymap, its profile must be changed or the :termy:profile:`keymap setting <Input/Keymap>` must be changed in its profile. Use the :doc:`Keymap Tool <../tools/keymap>` to see a list of key bindings for the :term:`active terminal`'s keymap at a glance.

The format of :program:`qtermy` keymap files is an extension of `Konsole <https://konsole.kde.org/>`_'s keymap file format. The sections below describe the different rules that can appear in keymap files.

.. contents:: Rule Types
   :local:

.. _keymap-description:

Keymap Description
------------------

Format: ``keyboard "description"``

An optional brief description of the keymap, displayed in the :doc:`Manage Keymaps window <../dialogs/manage-keymaps>`. Can be edited using the Keymap Options button in the :doc:`Keymap Editor <../dialogs/keymap-editor>`.

.. _keymap-inherit:

Keymap Inheritance
------------------

Format: ``inherit "name"``

Specifies that the keymap inherits from the named keymap. This allows a keymap to make modifications to a parent keymap without having to redefine all of the parent keymap's rules. Only one inheritance statement is permitted per keymap. Multiple levels of inheritance are permitted.

To change a keymap's inheritance, use the Rename Keymap button in the :doc:`Manage Keymaps window <../dialogs/manage-keymaps>`.

.. _keymap-option:

Keymap Option
-------------

Format: ``(enable|disable) optionname``

Enable or disable the keymap option ``optionname``. The available options are:

   * *EscapeOnAlt*: If enabled and an Alt key on the keyboard is pressed, an escape character (``0x1b``) will be prepended to the `text string <http://doc.qt.io/qt-5/qkeyevent.html#text>`_ of all keypresses for which no explicit binding exists. For example, an Alt+A keypress will produce the input Escape+A (assuming there is no explicit binding for the A key). This option is enabled by default.
   * *EscapeOnMeta*: Like `EscapeOnAlt`, but for the Meta key instead of the Alt key. This option is disabled by default.

A keymap that does not explicitly enable or disable an option will inherit the option from its :ref:`parent keymap <keymap-inherit>`, if applicable.

.. _keymap-literal:

Literal Key Binding
-------------------

Format: ``(key|digraph) keyname conditions: "string"``

Defines a key binding for the key named ``keyname`` that sends the string ``string`` as input to the terminal. The given ``conditions`` must be true for the binding to be used. A rule starting with ``digraph`` instead of ``key`` specifies the second keystroke of a two-keystroke combination binding and must follow a :ref:`digraph opener <keymap-digraph>` specifying the first keystroke of the combination.

The key name is one of the following:

   * The name of a key defined in the `Qt::Key enumeration <http://doc.qt.io/qt-5/qt.html#Key-enum>`_, without the ``Key_`` prefix.
   * The name ``BackButton``, ``ForwardButton``, or ``TaskButton``, referring to the first three extended mouse buttons.
   * The name ``MouseButtonN`` where ``N`` is a number between 4 and 24 inclusive, referring to further extended mouse buttons beyond ``TaskButton``.

The ``conditions`` is a list of condition names prefixed with plus (+) or minus (-) characters and joined together without spaces or punctuation. A positive condition must be true at the time of the keypress, while a negative condition must be false at the time of the keypress. All conditions in the list must be met for the key binding to be used. Multiple bindings for the same ``keyname`` will be processed in order, with the first binding whose conditions are met being used. If no binding's conditions are met, the :ref:`parent keymap <keymap-inherit>` will be searched, if applicable.

.. _keymap-modes:

The conditions are as follows:

   * *Command*: The application is in :termy:action:`command mode <ToggleCommandMode>`. This mode exists to support vim-style keymaps that use a second input mode to avoid excessive use of modifier keys.
   * *Selection*: The application is in :termy:action:`selection mode <ToggleSelectionMode>`, which can be manually or automatically entered when a text selection is made in the :term:`active viewport`. The default keymap has many bindings conditioned on this mode which are used to edit the active selection.
   * *Shift*: A Shift key on the keyboard is pressed.
   * *Control*: A Control key on the keyboard is pressed.
   * *Alt*: An Alt key on the keyboard is pressed.
   * *Meta*: A Meta key on the keyboard is pressed.
   * *AnyMod*: A Shift, Control, Alt, or Meta key on the keyboard is pressed.
   * *KeyPad*: The key is located on the keypad portion of the keyboard. For example, the keypad Enter key as opposed to the regular Enter key.
   * *AppScreen*: The alternate screen buffer is active in the terminal. This is a second terminal screen used by most fullscreen terminal applications such as vim. In the default keymap, certain scrolling action bindings are disabled in AppScreen mode since fullscreen terminal applications might use those keys.
   * *AppCuKeys*: The terminal is in Application Cursor Keys mode, which can be enabled by terminal programs using an escape sequence. In the default keymap, this mode affects the strings produced by the arrow and navigation keys.
   * *AppKeyPad*: The terminal is in Application Keypad mode, which can be enabled by terminal programs using an escape sequence.
   * *NewLine*: The terminal is in Newline mode, which is enabled by default but can be disabled by terminal programs using an escape sequence. In the default keymap, this mode dictates whether the Return key produces a carriage return and newline or just a carriage return.

.. _keymap-escapes:

The ``string`` surrounded by double quotes is the text to write to the terminal as input. It must be valid UTF-8. This field supports the following escapes:

   * ``\E``: an escape character, ``0x1b``.
   * The C language escapes ``\a``, ``\b``, ``\t``, ``\n``, ``\v``, ``\f``, ``\r``.
   * ``\xHH``: a character specified by two hexadecimal digits. For characters above 127, use ``\u``.
   * ``\uHHHH``: a Unicode code point specified by between 2 and 5 hexadecimal digits. It will be encoded in UTF-8.
   * ``*``: when an asterisk appears in a key binding that has a positive AnyMod condition, it will be replaced by a number indicating which modifier keys are pressed. The default keymap uses this feature to implement various literal bindings (such as function keys) that must report this information.

   .. note:: A non-empty `text string <http://doc.qt.io/qt-5/qkeyevent.html#text>`_ generated by a keypress will be sent to directly to the terminal as input if no binding in the keymap (or its :ref:`parent keymap <keymap-inherit>`, if applicable) matches the key and conditions. This means that literal bindings for plain character keys such as ``A`` are not required.

.. _keymap-action:

Action Key Binding
------------------

Format: ``(key|digraph) keyname conditions: action``

Like a :ref:`literal key binding <keymap-literal>`, but instead of sending a string as input to the terminal, invokes an :doc:`action <../actions>` using the action name and parameters specified by ``action``. Note the lack of double quotes around the action string.

.. _keymap-digraph:

Digraph Opener
--------------

Format: ``key keyname conditions: BeginDigraph``

Opens a two-keystroke combination binding. The ``keyname`` and ``conditions`` are as specified in :ref:`literal key binding <keymap-literal>`.

Literal and action bindings of type ``digraph`` immediately following this rule specify the second keystrokes of the combination binding.

Combination bindings may not be nested; ``BeginDigraph`` is only accepted as a top-level ``key`` binding.
