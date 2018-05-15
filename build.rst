.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Building from Source
====================

.. highlight:: none

To build from source, download the latest release tarball from the `releases page <https://termysequence.io/releases/>`_ and unpack it into a source folder. Consult the included `README <https://github.com/TermySequence/termysequence/blob/master/README.md>`_ for the list of supported platforms and the list of required and optional dependencies and their minimum versions.

Install the required dependencies on your build machine. For library dependencies, remember to install the "development" version of the package (often named with a "-devel" suffix) in addition to the regular library package. Any dependencies which aren't provided by your distribution will need to be built from source. How to do that is beyond the scope of this documentation, although there are a few hints below about the more difficult dependencies.

Once the dependencies are in place, run :command:`cmake` to configure the build. This can be done using the included :program:`runcmake.sh` or by running :command:`cmake` directly. Take a look at the top of :program:`runcmake.sh` for configuration lines that can be un-commented and changed. By default, the script will set up the build to make both server and client in release mode with the output folder set to :file:`build/` within the source tree.

Once the build is configured, change into the output folder and run :command:`make` to build and :command:`make install` to install. See the sections below for more build instructions. If you find a bug or area of improvement or just need help with the build, refer to :doc:`support`.

.. _server-build:

Building the Server
-------------------

Building :program:`termy-server` by itself is relatively easy due to its lack of dependencies.

If :program:`termy-server` will be installed on a machine that uses systemd-logind to manage user login sessions, you'll need to enable the systemd support and follow the instructions at :doc:`systemd` once you've gotten it installed.

If :program:`termy-server` will be installed on any machine that hosts git repositories or working trees, enabling the `libgit2 <https://libgit2.github.com/>`_ support is recommended. Note that libgit2 is dynamically loaded by the server at runtime, so the library is not required to be present even if the support for it is enabled.

Setting the CMake variable :makevar:`INSTALL_SHELL_INTEGRATION` will install the shell integration scripts distributed with TermySequence. This removes the need for users to manually install shell integration, provided they use certain shells. See :doc:`shell-integration`.

Building the Client
-------------------

Building :program:`qtermy` is more of a challenge due to its many dependencies. There are also two additional repositories containing third-party graphical content which are both highly recommended. These are `termy-icon-theme <https://github.com/TermySequence/termy-icon-theme>`_ and `termy-emoji <https://github.com/TermySequence/termy-emoji>`_, respectively. Follow the instructions in the README files for those repositories to install them alongside :program:`qtermy`.

Make sure that the Base, Svg, and Tools (linguist) components of Qt5 are all installed, including the "development" versions of the packages. If Qt5 is not packaged by your distribution, it can be downloaded from `qt.io <https://www.qt.io>`_ (the free open source version is what you want). If CMake can't locate :file:`FindQt5.cmake`, define the CMake variable :makevar:`Qt5_DIR` to the full path of the appropriate :file:`cmake/Qt5` folder (such as :file:`clang_64/lib/cmake/Qt5`) within the Qt installation. :program:`runcmake.sh` reads this value from the environment variable :envvar:`QT5_CMAKE_DIR` if set.

Check if your distribution has a packaged version of the `Chrome V8 engine <https://developers.google.com/v8/>`_ by Google. If not, follow the instructions on the `V8 Public Wiki <https://v8project.org>`_ to download and build V8. The goal is to build static libraries and blobs. The following build arguments may be necessary to get proper static libraries::

  v8_static_library=true
  use_sysroot=false
  use_glib=false
  use_custom_libcxx=false

Then, point :program:`runcmake.sh` to V8 by setting the following environment variables:

  * :envvar:`V8_HOME`: the path to the v8 repository, for example :file:`{$HOME}/git/v8/v8`.
  * :envvar:`V8_OUTPUT_DIR`: the path to the build folder within the v8 repository, for example :file:`{$V8_HOME}/out.gn/x64.release`.
  * :envvar:`V8_BLOB_DIR`: the directory where the binary blob files :file:`natives_blob.bin` and :file:`snapshot_blob.bin` will be located at *runtime* (i.e. where they will be installed). These files can be found in the build folder. Defining this variable and the next to point to the build folder itself is acceptable for personal builds on one machine as long as the build folder will be around when :program:`qtermy` is run.
  * :envvar:`V8_ICU_DIR`: the directory where the bundled ICU data file :file:`icudtl.dat` will be located at *runtime*. This can also be found in the build folder.

If not using :program:`runcmake.sh` to run CMake, examine the script to see how these environment variables are converted to CMake variable definitions. Remember to define the CMake variable :makevar:`V8_STATIC` to 1 for static V8 builds.

If :envvar:`V8_HOME` is not set, it is assumed that dynamic libraries for V8 are available with no separate blobs required and that the bundled ICU is not used. This may be the case for prebuilt versions of V8, for example `Fedora's version <https://src.fedoraproject.org/rpms/v8/>`_. However, depending on how V8 is built, this assumption may not be valid and it may be necessary to edit one or more of the following:

  * The CMake code that detects V8 and sets up the dependency target, found at `cmake/FindV8.cmake <https://github.com/TermySequence/termysequence/blob/master/cmake/FindV8.cmake>`_
  * The actual C++ code that initializes V8, found in `src/app/main.cpp <https://github.com/TermySequence/termysequence/blob/master/src/app/main.cpp>`_

Building Server and Client
--------------------------

Simply configure the build to make both server and client, following the instructions in both sections above.
