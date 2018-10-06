.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Systemd Setup
=============

On a machine that employs `systemd-logind <https://www.freedesktop.org/software/systemd/man/systemd-logind.service.html>`_ to manage user login sessions, some setup is required for each user that will be running :doc:`termy-server <server>`. This setup ensures that the user's :term:`persistent server <persistent user server>` is socket activated via the systemd user manager, and that it keeps running even when the user logs out.

.. note:: This setup is specific to machines on which a systemd user manager is run for each logged in user. This setup is not required for machines that only use systemd as the system manager, PID 1.

This setup consists of the following tasks:

  * :command:`systemctl --user enable termy-server.socket` to enable the socket unit file
  * :command:`systemctl --user start termy-server.socket` to start the socket unit file
  * :command:`loginctl enable-linger` to allow services to run beyond the user logging out. This may be a privileged action that requires authentication.
  * Kill any existing persistent :program:`termy-server` instance that wasn't launched via socket activation. This will destroy any terminals running on it.

Complicating the situation is the fact that these commands, particularly :manpage:`loginctl(1)`, must be run from within a fully formed systemd login session. Shells launched via :manpage:`sudo(8)` or :manpage:`su(1)` do not always meet this requirement, nor do terminals on an existing persistent user server (a terminal on a :term:`transient local server`, however, is OK). The presence of the :envvar:`XDG_SESSION_ID` environment variable indicates that a session exists. When in doubt, use :command:`ssh` or :command:`machinectl login` to log in as the user and perform the setup from there, since this always results in a clean session.

:program:`termy-server` ships with an interactive setup script, :doc:`termy-setup <man/setup>`, which can be used to run the above commands. This script can be run from the :doc:`Setup Tasks dialog <dialogs/setup-tasks>` which is displayed when :program:`qtermy` is launched for the first time.
