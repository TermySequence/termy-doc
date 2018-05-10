.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Settings
========

Settings for :program:`qtermy` are stored under :file:`{$HOME}/.config/qtermy`. Settings files use INI format (as written by `Qt's QSettings class <http://doc.qt.io/qt-5/qsettings.html>`_) with the exception of :doc:`keymaps <keymap>` and autoswitch rules which use custom formats. All settings files are text files that can be opened and edited using any text editor. However, note that :program:`qtermy` does not monitor for external changes to settings files. Most settings object management :doc:`dialogs <../dialogs/index>` have a Reload Files button that can be used to load external changes to settings files without restarting the application. Take care not to save settings from within :program:`qtermy` when making external changes to settings files.

Profile autoswitch rules and icon autoswitch rules are documented with the :ref:`Profile Rules Editor <switch-rule-file>` and :ref:`Icon Rules Editor <icon-rule-file>` respectively. The application's :ref:`command history database <suggestions-database>`, although not technically a settings file, is documented with the :doc:`Suggestions Tool <../tools/suggestions>`. All other settings objects are documented on the pages below.

.. tip:: Settings files can be exchanged with other :program:`qtermy` users. Do you have a pretty new :doc:`Theme <theme>` or a useful new :doc:`Profile <profile>`, :doc:`Keymap <keymap>`, :doc:`Alert <alert>`, or :doc:`Launcher <launcher>`? Give it to your friends and coworkers!

.. toctree::

   global
   profile
   keymap
   theme
   alert
   launcher
   connection
   server
   state
