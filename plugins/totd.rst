.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Tip of the Day Provider
=======================

The Tip of the Day Provider is a :doc:`plugin <index>` feature that generates tips for the :termy:action:`TipOfTheDay` window accessible via the Help menu. Only one tip provider can be registered. Its feature name is the fixed string ".totd".

The entry point to a tip provider is the tip function passed to :js:func:`plugin.registerTipProvider`, which is called once each time a new tip is needed:

.. js:function:: tip_function(manager)

   :param handle manager: A :ref:`manager handle <action-manager>`.
   :returns: The next tip of the day.

The return value of the tip function should be one of the following:

   * A string.
   * A list of strings. The first string contains numbered place markers of the form ``%n`` where ``n`` is a number from 1 to 9. The remaining strings in the list (up to 9) will be substituted at the location of the markers.

Strings may contain HTML markup from `the subset of HTML <http://doc.qt.io/qt-5/richtext-html-subset.html>`_ supported by Qt. Strings that derive from external sources should be sanitized using :js:func:`plugin.htmlEscape` if necessary before including them in a tip. The following special link types are also supported:

   * ``<a doc='location'>``: Appends the given location to the configured :termy:global:`DocumentationRoot <Global/DocumentationRoot>` to create a documentation URL.
   * ``<a act='action'>``: Creates a hyperlink that will invoke the given :doc:`action string <../actions>` when clicked.

A tip provider is actually a special form of :doc:`custom action <action>` and has access to the custom action API. This can be used to query the state the application and provide tips that are customized to the user's settings. For example, :js:func:`lookupShortcut <settings.lookupShortcut>` can be used to look up key bindings and :js:attr:`plugin.installPrefix` can be used to display paths using the correct install location.
