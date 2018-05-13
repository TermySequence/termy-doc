.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

The TermySequence Protocol
==========================

The TermySequence Protocol defines the interface to the :doc:`termy-server <server>` multiplexer server. A design goal of the protocol is to make it as easy as possible to write new TermySequence clients. A :ref:`minimal client <strategy-minimal>` which only displays terminal screen contents can ignore most of the protocol entirely. Features such as :ref:`scrollback <strategy-scrollback>`, history, annotations, and file system support can be added to the client later if desired.

.. note:: This documentation is a work in progress. File an `issue <https://github.com/TermySequence/termy-doc/issues>`_ against termy-doc to request clarification or improvement if needed while developing a client.

.. toctree::
   :maxdepth: 2

   protocol/basic
   protocol/strategy
   protocol/plain
   protocol/server
   protocol/client
   protocol/terminal
   protocol/enums
   protocol/flags
   protocol/unicode
   protocol/attributes
