.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Common Interfaces
=================

The plugin API is exposed through objects in the global namespace:

.. js:data:: plugin

   Provides version and system information attributes, utility methods, and the registration methods used to create plugin features.

.. js:data:: console

   Provides :ref:`logging methods <plugin-logging>`.

.. _plugin-logging:

Logging
-------

.. js:function:: console.log(message)

   Creates a :doc:`log message <../dialogs/event-log>` at the info level containing the plugin's :js:attr:`name <plugin.pluginName>` in square brackets followed by the given message string.

.. js:function:: console.info(message)

   Same as :js:func:`console.log`.

.. js:function:: console.warn(message)

   As :js:func:`console.log`, but creates the log message at the warning level.

Constants
---------

.. js:attribute:: plugin.majorVersion

   The major version of the plugin API. Check this value before registering any features to ensure that the plugin is compatible with the plugin API.

.. js:attribute:: plugin.minorVersion

   The minor version of the plugin API. Check this value if the plugin depends on a particular interface introduced by a minor revision of the plugin API.

.. js:attribute:: plugin.installPrefix

   The install prefix configured when :program:`qtermy` was :doc:`built <../build>`. Useful for plugins which need to reference files or paths relative to the install location.

.. js:attribute:: plugin.installDatadir

   *(API version 1.3)* The install datadir configured when :program:`qtermy` was built.

.. js:attribute:: plugin.installConfdir

   *(API version 1.3)* The install sysconfdir configured when :program:`qtermy` was built.

Properties
----------

.. js:attribute:: plugin.pluginName

   Assign the name of the plugin to this property before registering any features. It will be shown in the :doc:`Manage Plugins window <../dialogs/manage-plugins>` and in :doc:`log messages <../dialogs/event-log>`. If unset, the name of the plugin's source file will be used.

.. js:attribute:: plugin.pluginVersion

   Assign the version of the plugin to this property before registering any features. It will be shown in the :doc:`Manage Plugins window <../dialogs/manage-plugins>` but is otherwise not used by the plugin system.

.. js:attribute:: plugin.pluginDescription

   Assign a brief, one line description of the plugin to this property before registering any features. It will be shown in the :doc:`Manage Plugins window <../dialogs/manage-plugins>` but is otherwise not used by the plugin system.

Methods
-------

.. js:function:: plugin.now()

   Returns a timestamp value representing the current time, measured in tenths of a second. This can be used to compare relative times.

.. js:function:: plugin.htmlEscape(string)

   Returns the given string with HTML metacharacters replaced by the appropriate HTML entities.

.. js:function:: plugin.registerSemanticParser(version, name, callback[, variant])

   Registers a :doc:`semantic parser <parser>` feature. The variant argument specifies the parser type and is one of:

      * 0: a standard parser (the default)
      * 1: a fast parser

   :param integer version: The requested interface version (must be 1). Future revisions of the API may introduce new versions.
   :param string name: The name of the parser being registered.
   :param function callback: The parser's :js:func:`match function <match_function>`.
   :param integer variant: The type of parser being registered.

.. js:function:: plugin.registerCustomAction(version, name, callback[, description])

   Registers a :doc:`custom action <action>` feature.

   :param integer version: The requested interface version (must be 1). Future revisions of the API may introduce new versions.
   :param string name: The name of the action. To :doc:`invoke <../actions>` the action from a :ref:`key binding <keymap-action>` or elsewhere within :program:`qtermy`, prepend "Custom" to this name.
   :param function callback: The action's :js:func:`run function <run_function>`.
   :param string description: A brief, one line description of the action. This will be displayed in tooltips but is otherwise not used by the plugin system. If unspecified, the value of :js:attr:`plugin.pluginDescription` is used.

.. js:function:: plugin.registerTipProvider(version, callback)

   Registers a :doc:`tip of the day provider <totd>`. There can only be one of these registered.

   :param integer version: The requested interface version (must be 1). Future revisions of the API may introduce new versions.
   :param function callback: The tip provider's :js:func:`tip function <tip_function>`.

File Interface
--------------

.. js:function:: plugin.createOutputFile(filename)

   Creates and opens a file for writing, overwriting any existing file with the same name. The file is created in the :termy:global:`DownloadLocation <Files/DownloadLocation>` specified in the :doc:`global settings <../settings/global>`. An Error exception is thrown on open failure. Otherwise, a handle object is returned with attributes and methods described below.

.. js:attribute:: fileHandle.path

   The path of this handle's file.

.. js:function:: fileHandle.print(value)

   Writes the given value to this handle's file as UTF-8 text. No newline is added to the printed string.

.. js:function:: fileHandle.close()

   Closes this handle's file. This is required; file handles are not closed implicitly.
