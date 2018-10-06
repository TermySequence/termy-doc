.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Building from Source
====================

.. highlight:: none

To build from source, download the latest release tarball from the `releases page <https://termysequence.io/releases/>`_ and unpack it into a source folder. Consult the included `README <https://github.com/TermySequence/termysequence/blob/master/README.md>`_ for the list of supported platforms and the list of required and optional dependencies and their minimum versions.

*New in version 1.1*: The server and client are now distributed in separate tarballs.

Install the required dependencies on your build machine. For library dependencies, remember to install the "development" version of the package (often named with a "-devel" suffix) in addition to the regular library package. Any dependencies which aren't provided by your distribution will need to be built from source. How to do that is beyond the scope of this documentation, although there are a few hints below about the more difficult dependencies.

Once the dependencies are in place, run :command:`cmake` to configure the build. This can be done using the included :program:`runcmake.sh` or by running :command:`cmake` directly. Take a look at the top of :program:`runcmake.sh` for configuration lines that can be un-commented and changed. By default, the script will set up the build to make both server and client in release mode with the output folder set to :file:`build/` within the source tree.

Once the build is configured, change into the output folder and run :command:`make` to build and :command:`make install` to install. See the sections below for more build instructions. If you find a bug or area of improvement or just need help with the build, refer to :doc:`support`.

.. _server-build:

Building the Server
-------------------

Building :program:`termy-server` by itself is relatively easy due to its lack of dependencies.

If :program:`termy-server` will be installed on a machine that uses systemd-logind to manage user login sessions, you'll need to enable the systemd support by setting the CMake variable :makevar:`USE_SYSTEMD`. Follow the instructions at :doc:`systemd` once you've gotten it installed.

If :program:`termy-server` will be installed on any machine that hosts git repositories or working trees, enabling the `libgit2 <https://libgit2.github.com/>`_ support is recommended. Do this by setting the CMake variable :makevar:`USE_LIBGIT2`. Note that libgit2 is dynamically loaded by the server at runtime, so the library is not required to be present even if the support for it is enabled.

Building the Client
-------------------

Make sure that the Base, Svg, and Tools (linguist) components of Qt5 are all installed, including the "development" versions of the packages. If Qt5 is not packaged by your distribution, it can be downloaded from `qt.io <https://www.qt.io>`_ (the free open source version is what you want). If CMake can't locate :file:`FindQt5.cmake`, define the CMake variable :makevar:`Qt5_DIR` to the full path of the appropriate :file:`cmake/Qt5` folder (such as :file:`clang_64/lib/cmake/Qt5`) within the Qt installation. :program:`runcmake.sh` reads this value from the environment variable :envvar:`QT5_CMAKE_DIR` if set.

As with the server, if :program:`qtermy` will be installed on a machine that uses systemd-logind to manage user login sessions, you'll need to enable the systemd support and follow the instructions at :doc:`systemd` once you've gotten it installed.

*New in version 1.1*: The `Chrome V8 engine <https://developers.google.com/v8/>`_ by Google is now bundled in the client tarball and built automatically. Downloading and building V8 separately is no longer required. Refer to the `V8 Public Wiki <https://v8project.org>`_ for more information on Chrome V8. If not building on amd64, it may be necessary to set the :makevar:`V8_ARCH` and :makevar:`V8_ARMFP` CMake variables appropriately.

.. note:: The V8 build runs as a sub-make. To avoid having the entire output of the V8 build buffered until completion, run the top-level make without ``-O`` or with ``-Onone``. The V8 build can take over an hour to run.

*New in version 1.1*: :program:`qtermy` now supports either version 2 or version 3 of `the libfuse FUSE library <https://github.com/libfuse/libfuse/>`_. Set the CMake variables :makevar:`USE_FUSE3` or :makevar:`USE_FUSE2` to enable one or the other version. By default, version 3 is enabled. Set both variables to OFF to disable FUSE support.

*New in version 1.1*: The `termy-icon-theme <https://github.com/TermySequence/termy-icon-theme>`_ and `termy-emoji <https://github.com/TermySequence/termy-emoji>`_ graphical content is now bundled in the client tarball. Downloading and installing these separately is no longer required.
