.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

.. _protocol-unicode:

Character Encoding
==================

The character encoding specifies the widths and combining behavior of Unicode code points within a terminal. The encoding is used to synchronize the location of the screen cursor between the client and server.

See `unicode10tab.hpp <https://github.com/TermySequence/termysequence/blob/master/lib/unicode10tab.hpp>`_ for the character width tables and `unicode10impl.hpp <https://github.com/TermySequence/termysequence/blob/master/lib/unicode10impl.hpp>`_ for the parsing code used by the current implementation.

.. _protocol-unicode-plan:

In the future, a plugin model will be added to the multiplexer so that character widths and combining behavior can be implemented in plugins that are dynamically loaded, with each individual terminal able to specify the encoding (plugin) that it wants to use.
