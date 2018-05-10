.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

The Plugin System
=================

Plugins are Javascript modules loaded into :program:`qtermy` and used to provided extended functionality. Plugins are loaded from :file:`{$HOME}/.local/share/qtermy/plugins` and :file:`{prefix}/share/qtermy/plugins`. Files in :envvar:`HOME` take precedence over files in the system directory. System plugins can be disabled using the ``--nosysplugins`` argument to :doc:`qtermy <../man/gui>` and plugins can be disabled entirely using the ``--noplugins`` argument.

Each plugin may register one or more *features* providing a unique capability. Features are described in the pages below. Use the :doc:`Manage Plugins window <../dialogs/manage-plugins>` to view the set of loaded plugins and their features. Plugins can also be unloaded and reloaded from that window.

:program:`qtermy` embeds the `Chrome V8 engine <https://developers.google.com/v8/>`_ by Google to load and run plugins. Plugins are parsed as ECMAScript 6 modules and may use language constructs defined therein, with some caveats:

   * Dynamic module import is not supported yet.
   * Source files must use the ``.mjs`` extension commonly used for ES6 modules.

To get started with plugin development, examine the sample plugins distributed with :program:`qtermy`. The files ending with ``.example`` contain detailed comments describing their respective features and can be renamed in order to load them. When developing a plugin, use the :doc:`Manage Plugins window <../dialogs/manage-plugins>` to reload it after making changes while watching for messages and exceptions in the :doc:`Event Log <../dialogs/event-log>`. Use :js:func:`console.log` to print log messages directly from Javascript.

.. important:: :program:`qtermy`'s plugin API is not yet stable and may change in future releases.

.. toctree::
   :caption: Contents:

   common
   parser
   action
   totd
