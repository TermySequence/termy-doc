.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

termy-download
==============

.. highlight:: none

Name
----

:program:`termy-download`\ , :program:`termy-imgcat`\ , :program:`termy-imgls` - Display inline content within TermySequence terminals

Synopsis
--------

| :program:`termy-download` -\|file...
| :program:`termy-imgcat` [-ps] [-w *cells*\ ] [-h *cells*\ ] -\|\ *file*\ ...
| :program:`termy-imgls` [-w *cells*\ ] [-h *cells*\ ] [\ *file*\ ...]

Description
-----------

:program:`termy-download` sends one or more files to a terminal running in an instance of :doc:`termy-server <../man/server>`\ (1). The file data will be kept in the server's memory and can be downloaded by connected clients.

.. note:: The *TermySequence* protocol supports direct file downloads. For a number of reasons, direct downloads should generally be preferred over inline downloads using :program:`termy-download`\ . See `Notes`_ below.

:program:`termy-imgcat` sends one or more images to a terminal for inline display. Command line options can be used to specify the width and height of the image in character cells and whether names should be printed with the images. :program:`termy-imgcat` uses the :manpage:`ImageMagick(1)` suite of tools to query the format and dimensions of input images. If the image dimensions and file size exceed hard-coded thresholds, a thumbnail image will be generated and uploaded in place of the original.

:program:`termy-imgls` produces a long-format directory listing with inline image thumbnails. Command line options can be used to specify the width and height of the thumbnails in character cells. Input images are processed as with :program:`termy-imgcat`\ .

Options
-------

**-**
   Read data from standard input. Cannot be used with other filename arguments.

**-w,--width** *n*
   Set the image or thumbnail width to *n* character cells.

**-h,--height** *n*
   Set the image or thumbnail height to *n* character cells.

**-s,--stretch**
   Request that the image be stretched to fit the display area, rather than preserving its aspect ratio.

**-p,--print**
   Print filenames with images.

**--help**
   Print basic help

**--version**
   Print version information

Notes
-----

.. caution:: There is a size limit on files and images uploaded using these tools.

Currently this limit is 8 MiB, but since file data is Base64 encoded, the actual maximum size for input files is roughly 6 MB. Furthermore, once uploaded, file data is kept in the server's memory until the terminal is closed, its scrollback buffer is cleared, or the insertion point leaves the scrollback buffer. For these reasons, it is recommended that direct file downloads be used for fetching files from remote servers. Direct downloads are not subject to a size limitation and do not consume server memory.

:doc:`termy-server <../man/server>`\ (1) hashes uploaded files and images and only stores one copy of each uploaded file. Re-displaying the same inline image multiple times in the same terminal will not consume additional server memory beyond the first instance.

How inline images are displayed and which image formats are supported is left up to each *TermySequence* client. The server simply stores the data for download. Some clients may not support inline image display or inline downloads. The list of supported image formats (SVG BMP GIF JPEG PNG PBM PGM PPM XBM XPM) coded into :program:`termy-imgcat` and :program:`termy-imgls` reflects the formats supported by the :doc:`qtermy <../man/gui>`\ (1) client and the :manpage:`ImageMagick(1)` tools used for preprocessing.

See Also
--------

:manpage:`ImageMagick(1)`, :doc:`termy-server <../man/server>`\ (1)
