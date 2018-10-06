.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Setup Tasks
===========

The Setup Tasks dialog is a wrapper around the :doc:`termy-setup <../man/setup>` script. To access this dialog, use Help→Setup Tasks or the :termy:action:`SetupTasks` action. The dialog is also shown when running :program:`qtermy` for the first time.

.. _setup-tasks-example:

.. figure:: ../images/setup-tasks.png
   :alt: Picture of Setup Tasks dialog.
   :align: center

   Example Setup Tasks dialog.

The dialog has the following elements:

   Enable systemd user service
      Passes the ``--systemd`` argument to :doc:`termy-setup <../man/setup>`. This will ensure that the user's :term:`persistent server <persistent user server>` is socket activated via the systemd user manager. Refer to :doc:`../systemd` for more information.

   Enable shell integration for bash
      Passes the ``--bash`` argument to :doc:`termy-setup <../man/setup>`. This will append code to the user's :file:`.profile` if it exists, otherwise to :file:`.bash_profile`. The code sources the bundled shell integration script, but only if the :envvar:`TERMYSEQUENCE` environment variable is defined. This variable is set automatically by :program:`termy-server`. Refer to :doc:`../shell-integration` for more information.

   Enable shell integration for zsh
      Passes the ``--zsh`` argument to :doc:`termy-setup <../man/setup>`. This will append code to the user's :file:`.zshrc`.

   Quit
      Quits the application immediately without performing setup. This is only present when running :program:`qtermy` for the first time. The dialog will be displayed again the next time :program:`qtermy` is run.

   Skip
      Skips all setup tasks. This is only present when running :program:`qtermy` for the first time. The dialog will not be displayed again on startup, but can be accessed from the Help menu.
