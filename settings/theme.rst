.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Theme
=====

Theme settings are named settings objects stored at :file:`{$HOME}/.config/qtermy/themes`. Themes can be created and edited from the :doc:`Theme Editor dialog <../dialogs/theme-editor>`. The files can also be edited directly in a text editor, but note that :program:`qtermy` does not monitor for external changes to settings files. Use the reload files button in the :doc:`Theme Editor dialog <../dialogs/theme-editor>` to load external changes and new files without restarting the application.

A *theme* is a predefined color palette that can be quickly applied to a :doc:`profile <profile>` using the profile editor or directly to a terminal using the :ref:`Adjust Colors dialog <adjust-colors>`. Applying a theme to a profile or terminal sets both the :termy:profile:`Palette <Appearance/Palette>` and :termy:profile:`Dircolors <Files/Dircolors>`.

Note that each profile and terminal has its own palette and dircolors, separate from any theme. Changing a theme does not modify any profile or terminal settings, and it's possible for a profile or terminal to have settings that do not match any defined theme. In this case, the theme will be displayed as "Custom Color Theme" in the :doc:`settings editor <../dialogs/settings-editor>` at the :termy:profile:`Palette <Appearance/Palette>` setting (for profiles) and in the :ref:`Adjust Colors dialog <adjust-colors>` (for terminals).

Theme
-----

.. termy:theme:: Theme/Group string

   A string describing the group that the theme belongs to. This is used with the :termy:param:`SameGroup` parameter to :termy:action:`RandomTerminalTheme` to select a random theme that belongs to the same group as the terminal's existing theme.

   To see what group names are already defined, use the :doc:`Theme Editor dialog <../dialogs/theme-editor>` or grep the settings files directly. The default (untranslated) group names used by :program:`qtermy`'s built-in themes are:

     * Light background
     * Dark background

.. termy:theme:: Theme/Palette string

   The theme's color palette, in the same format as a profile's :termy:profile:`Palette <Appearance/Palette>`.

.. termy:theme:: Theme/Dircolors string

   The theme's dircolors, in the same format as a profile's :termy:profile:`Dircolors <Files/Dircolors>`.

.. termy:theme:: Theme/LowPriority boolean

   If enabled, the theme will be shown at the bottom of the list in the :doc:`Theme Editor dialog <../dialogs/theme-editor>` and in theme selection dropdowns. Enable this setting in themes that only exist to be used with the :termy:action:`RandomTerminalTheme` action.
