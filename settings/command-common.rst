.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Commands entered into the text field will be split on whitespace and the first word will be used as both the executable to run and argument zero of the argument vector, unless the first word ends with a separate argument in square brackets. In this case, the portion before the square brackets is used as the executable name and the portion within the square brackets is used as argument zero.

For more control over the argument vector, click the Advanced button to bring up a command editor dialog. The dialog displays the executable name and argument vector separately and supports arguments containing whitespace.

.. important:: Shell constructs such as quoting and variable expansion should not be used since the command may not be run by a shell. Use a wrapper script if this is required.
