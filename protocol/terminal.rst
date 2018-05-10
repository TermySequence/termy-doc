.. Copyright © 2018 TermySequence LLC
.. SPDX-License-Identifier: CC-BY-SA-4.0

Terminal Messages
=================

.. contents::
   :local:

Input
-----

.. termy:protocol:: INPUT T(3000) termid clientid data

   Send terminal input.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`data`: The input data as a UTF-8 string.

.. termy:protocol:: MOUSE_INPUT T(3001) termid clientid mouseflags x y

   Send mouse input.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`mouseflags` (4): The low order byte is the index of the mouse button pressed, if any. The remaining bytes are the :ref:`mouse event flags <protocol-mouseflags>`.
    * :termy:param:`x` (4): The pointer x position in character cells.
    * :termy:param:`y` (4): The pointer y position in character cells.

General
-------

.. termy:protocol:: RESIZE_TERM T(3104) termid clientid size

   Resize a terminal.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`width` (4): The terminal width in character cells.
    * :termy:param:`height` (4): The terminal height in character cells.

.. termy:protocol:: BUFFER_CAPACITY T(3002) termid clientid order+bufid

   Resize the scrollback buffer.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`order+bufid` (4): The low-order byte is the :term:`buffer identifier` (should be 0). The next byte is the new buffer capacity exponent (power of 2).

.. termy:protocol:: CONTENT_REQUEST T(3008) termid clientid start8 end8 bufid

   Request terminal row and region content. The replies will be delivered as a state update block using the message types :termy:protocol:`BEGIN_OUTPUT_RESPONSE` and :termy:protocol:`END_OUTPUT_RESPONSE`.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`start8` (8): The starting row number to retrieve content for.
    * :termy:param:`end8` (8): The past-the-end row number.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier`.

.. termy:protocol:: CLOSE_TERM T(3105) termid clientid

   Close a terminal.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: REMOVE_TERM T(3105) termid code

   Sent to the client when a terminal has closed.

   Removal announcements for all downstream terminals and servers should be sent prior to receiving this message, but clients must gracefully handle a bad ordering.

    * :termy:param:`termid` (16): The :term:`terminal identifier`.
    * :termy:param:`code` (4): An :ref:`error code <protocol-errors>` describing the reason for the close.

.. termy:protocol:: REMOVE_CONN T(3106) termid code

   As :termy:protocol:`REMOVE_TERM`, but names a connection rather than a terminal.

.. termy:protocol:: DUPLICATE_TERM T(3106) termid clientid newid width height key+value...

   Create a new terminal by duplicating an existing terminal on the same server. The scrollback buffer contents are copied to the new terminal.

    * :termy:param:`termid` (16): The existing terminal's :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`termid` (16): The new terminal's :term:`terminal identifier`.
    * :termy:param:`width` (4): The width of the new terminal in character cells.
    * :termy:param:`height` (4): The height of the new terminal in character cells.
    * :termy:param:`key+value`: The new terminal's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: RESET_TERM T(3107) termid clientid flags

   Reset a terminal.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`flags` (4): The reset operations to perform.

.. termy:protocol:: CHANGE_OWNER T(3108) termid clientid

   Assign ownership of a terminal to the originating client.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: REQUEST_DISCONNECT T(3109) termid clientid

   Disconnect a connection hosted by the named terminal or connection. In the case of a connection, this is equivalent to :termy:protocol:`REMOVE_CONN`.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: TOGGLE_SOFT_SCROLL_LOCK T(3110) termid clientid

   Toggle scroll lock within a terminal. This causes the server to stop reading input from the terminal driver. This is independent of the "hard" scroll lock that can be set in the terminal driver using the STOP character (normally DC3, Ctrl+S).

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: SEND_SIGNAL T(3111) termid clientid signal

   Send a signal to the terminal's foreground process group.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`signal` (4): The signal number to send.

State Updates
-------------

.. termy:protocol:: BEGIN_OUTPUT T(3000) termid

   Begins a terminal state update block. The message numbers that fall between here and :termy:protocol:`END_OUTPUT` are always reported within a state update block.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.

.. termy:protocol:: BEGIN_OUTPUT_RESPONSE C(3000) clientid termid

   As :termy:protocol:`BEGIN_OUTPUT`, but includes the identifier of the requesting client. This message is sent in response to a :termy:protocol:`CONTENT_REQUEST` or :termy:protocol:`GET_REGION` by the client.

.. termy:protocol:: FLAGS_CHANGED T(3001) termid flags8

   Reports a change in :ref:`terminal flags <protocol-termflags>`.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`flags8` (8): The new terminal flags.

.. termy:protocol:: BUFFER_CAPACITY T(3002) termid rows8 order+bufid

   Reports a change in buffer capacity. This is the buffer's maximum number of saved rows and is a power of 2. If the buffer size exceeds this number, its topmost rows are lost.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`rows8` (8): The new size of the buffer.
    * :termy:param:`order+bufid` (4): The low-order byte is the :term:`buffer identifier`. The next byte is the new buffer capacity exponent (power of 2). The high-order bit of that byte is set if scrollback is disabled in the buffer.

.. termy:protocol:: BUFFER_LENGTH T(3003) termid rows8 bufid

   Reports a change in buffer size. A buffer grows when new rows are added and shrinks when the terminal is :termy:protocol:`reset <RESET_TERM>` or (in some cases) when the terminal is resized to a smaller size. If scrollback is disabled in a buffer, the buffer size will track the terminal size.

   The buffer size includes the rows on the terminal screen itself. The buffer size can exceed the buffer capacity in which case the rows between zero and ``size - capacity`` are lost.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`rows8` (8): The new size of the buffer.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier`.

.. termy:protocol:: BUFFER_SWITCHED T(3004) termid bufid

   Reports a change in the active buffer. This occurs when alternate screen mode is entered or exited.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier`.

.. termy:protocol:: SIZE_CHANGED T(3005) termid size margins

   Reports a change in terminal size.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`width` (4): The terminal width in character cells.
    * :termy:param:`height` (4): The terminal height in character cells.
    * :termy:param:`marginx` (4): The terminal's left margin in character cells.
    * :termy:param:`marginy` (4): The terminal's top margin in character cells.
    * :termy:param:`marginw` (4): The terminal's margin width in character cells.
    * :termy:param:`marginh` (4): The terminal's margin height in character cells.

.. termy:protocol:: CURSOR_MOVED T(3006) termid x y pos flags+subpos

   Reports a change in terminal cursor position.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`x` (4): The cursor x position in character cells.
    * :termy:param:`y` (4): The cursor y position in character cells.
    * :termy:param:`pos` (4): The :term:`character position` of the cursor within the row.
    * :termy:param:`flags+subpos` (4): The low order byte is the cursor sub-position (number of combining characters received). The remaining bytes are the :ref:`cursor flags <protocol-cursorflags>`.

.. termy:protocol:: BELL_RANG T(3007) termid type count

   Reports one or more bell rings.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`type` (4): The bell type, currently always set to zero.
    * :termy:param:`count` (4): The number of bell rings.

.. termy:protocol:: ROW_CONTENT T(3008) termid rownum8 flags+bufid modtime nranges range... string

   Reports terminal row content.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`rownum8` (8): The row number. This should be bounds checked against the buffer size. Due to a race condition, it's possible for row updates to arrive before the corresponding buffer size update. These out-of-bounds row updates should be ignored.
    * :termy:param:`flags+bufid` (4): The low order byte is the :term:`buffer identifier`. The remaining bytes are the :ref:`line flags <protocol-lineflags>`.
    * :termy:param:`modtime` (4): The row modification time in tenths of a second, or INT32_MIN when the row has no modification time.
    * :termy:param:`nranges` (4): The number of cell ranges in the next field.
    * :termy:param:`range`: Cell ranges, each consisting of six 4-byte numbers: starting :term:`character position`, ending character position, :ref:`cell flags <protocol-cellflags>`, foreground color, background color, and hyperlink :term:`region identifier`.
    * :termy:param:`string`: The row text as a UTF-8 string.

.. termy:protocol:: ROW_CONTENT_RESPONSE C(3008) clientid termid rownum8 flags+bufid modtime nranges range... string

   As :termy:protocol:`ROW_CONTENT`, but includes the identifier of the requesting client. This message is sent in response to a :termy:protocol:`CONTENT_REQUEST` by the client.

.. termy:protocol:: REGION_UPDATE T(3009) termid regid type+bufid flags parent srow8 erow8 scol ecol key+value...

   Reports a new or updated terminal region.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`regid` (4): The :term:`region identifier`.
    * :termy:param:`type+bufid` (4): The low order byte is the :term:`buffer identifier`. The next byte is the :ref:`region type <protocol-regiontype>`.
    * :termy:param:`flags` (4): The :ref:`region flags <protocol-regionflags>`.
    * :termy:param:`parent` (4): The region's parent :term:`region identifier`, if nonzero.
    * :termy:param:`srow8` (8): The starting row.
    * :termy:param:`erow8` (8): The ending row.
    * :termy:param:`scol` (4): The starting position. Depending on the region type, this can be measured in character cells or :term:`character positions <character position>`.
    * :termy:param:`ecol` (4): The past-the-end position. Depending on the region type, this can be measured in character cells or :term:`character positions <character position>`.
    * :termy:param:`key+value`: The region's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: REGION_UPDATE_RESPONSE C(3009) clientid termid regid type+bufid flags parent srow8 erow8 scol ecol key+value...

   As :termy:protocol:`REGION_UPDATE`, but includes the identifier of the requesting client. This message is sent in response to a :termy:protocol:`CONTENT_REQUEST` or :termy:protocol:`GET_REGION` by the client.

.. termy:protocol:: DIRECTORY_UPDATE T(3010) termid time8 name key+value...

   Reports a change of the terminal's current directory.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`time8` (8): The time of the update in milliseconds since the Epoch.
    * :termy:param:`name`: The directory name as a NUL-terminated UTF-8 string.
    * :termy:param:`key+value`: Directory attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: FILE_UPDATE T(3011) termid mtime8 size8 mode uid gid name key+value...

   Reports a file change within the terminal's current directory.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`mtime8` (8): The file modification time in milliseconds since the Epoch.
    * :termy:param:`size8` (8): The file size.
    * :termy:param:`mode` (4): The file mode bits.
    * :termy:param:`uid` (4): The file UID.
    * :termy:param:`gid` (4): The file GID.
    * :termy:param:`name`: The file name as a NUL-terminated UTF-8 string.
    * :termy:param:`key+value`: File attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: FILE_REMOVED T(3012) termid mtime8 name

   Reports a file deletion within the terminal's current directory.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`mtime8` (8): The time of the update in milliseconds since the Epoch.
    * :termy:param:`name`: The file name as a NUL-terminated UTF-8 string.

.. termy:protocol:: END_OUTPUT T(3013) termid

   Ends a terminal state update block.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.

.. termy:protocol:: END_OUTPUT_RESPONSE C(3013) clientid termid

   As :termy:protocol:`END_OUTPUT`, but includes the identifier of the requesting client.

.. termy:protocol:: MOUSE_MOVED T(3014) termid x y

   Reports movement of the terminal mouse pointer.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`x` (4): The pointer x position in character cells.
    * :termy:param:`y` (4): The pointer y position in character cells.

Attributes
----------

.. termy:protocol:: GET_TERM_ATTRIBUTES S(3100) termid clientid

   Request terminal or connection attributes. Attribute names starting with underscore (_) will not be included in the response.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.

.. termy:protocol:: TERM_ATTRIBUTES_RESPONSE C(3100) clientid termid key+value...

   Response to a :termy:protocol:`GET_TERM_ATTRIBUTES` request, if the target is a terminal.

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`key+value`: The terminal's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: CONN_ATTRIBUTES_RESPONSE C(3101) clientid termid key+value...

   Response to a :termy:protocol:`GET_TERM_ATTRIBUTES` request, if the target is a connection. As :termy:protocol:`TERM_ATTRIBUTES_RESPONSE`.

.. termy:protocol:: GET_TERM_ATTRIBUTE T(3101) termid clientid key...

   Request one or more terminal or connection attributes. A separate response will be sent for each requested attribute.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key`: The requested attribute name(s) as NUL-terminated UTF-8 strings.

.. termy:protocol:: TERM_ATTRIBUTE_CHANGED T(3101) termid key[+value]

   Sent to the client when a terminal attribute has changed.

    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`key[+value]`: The attribute name and optional value as NUL-terminated UTF-8 strings. If the value is absent, the attribute was removed.

.. termy:protocol:: CONN_ATTRIBUTE_CHANGED T(3101) termid key[+value]

   Sent to the client when a connection attribute has changed. As :termy:protocol:`TERM_ATTRIBUTE_CHANGED`.

.. termy:protocol:: TERM_ATTRIBUTE_RESPONSE C(3103) clientid termid key[+value]

   As :termy:protocol:`TERM_ATTRIBUTE_CHANGED`, but includes the identifier of the requesting client.

.. termy:protocol:: CONN_ATTRIBUTE_RESPONSE C(3104) clientid termid key[+value]

   As :termy:protocol:`CONN_ATTRIBUTE_CHANGED`, but includes the identifier of the requesting client.

.. termy:protocol:: SET_TERM_ATTRIBUTE T(3102) termid clientid key+value...

   Set one or more terminal or connection attributes. This will cause :termy:protocol:`TERM_ATTRIBUTE_CHANGED` or :termy:protocol:`CONN_ATTRIBUTE_CHANGED` messages to be sent to all clients unless the attribute(s) did not change.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key+value`: The attribute names and new values as NUL-terminated UTF-8 strings.

.. termy:protocol:: REMOVE_TERM_ATTRIBUTE T(3103) termid clientid key...

   Remove one or more terminal or connection attributes. This will cause :termy:protocol:`TERM_ATTRIBUTE_CHANGED` or :termy:protocol:`CONN_ATTRIBUTE_CHANGED` messages to be sent to all clients unless the attribute(s) did not change.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`key`: The attribute name(s) to remove as NUL-terminated UTF-8 strings.

Inline Content
--------------

.. termy:protocol:: IMAGE_CONTENT T(3015) termid clientid contentid

   Download an inline content item. If the size of the content item is more than 500KiB, a :termy:protocol:`DOWNLOAD_IMAGE` task should be used to download the content item instead.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`contentid` (8): The :term:`content identifier`.

.. termy:protocol:: IMAGE_CONTENT_RESPONSE C(3015) clientid termid contentid data

    * :termy:param:`clientid` (16): The destination :term:`client identifier`.
    * :termy:param:`termid` (16): The originating :term:`terminal identifier`.
    * :termy:param:`contentid` (8): The :term:`content identifier`.
    * :termy:param:`data`: The content item data.

.. termy:protocol:: DOWNLOAD_IMAGE T(3016) termid clientid taskid contentid chunksize windowsize

   Create a :term:`task` to download a content item.

   TODO more documentation.

    * :termy:param:`serverid` (16): The destination :term:`server identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`taskid` (16): The :term:`task identifier`.
    * :termy:param:`contentid` (8): The :term:`content identifier`.
    * :termy:param:`chunksize` (4): The chunk size.
    * :termy:param:`windowsize` (4): The window size.

Regions
-------

.. termy:protocol:: CREATE_REGION T(3200) termid clientid bufid type srow8 erow8 scol ecol key+value...

   Create an :term:`annotation` region. The server will assign the region identifier and report the new region via :termy:protocol:`REGION_UPDATE` in a state update block.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier` (should be 0).
    * :termy:param:`type` (4): The :ref:`region type <protocol-regiontype>`.
    * :termy:param:`srow8` (8): The starting row.
    * :termy:param:`erow8` (8): The ending row.
    * :termy:param:`scol` (4): The starting position in :term:`character positions <character position>`.
    * :termy:param:`ecol` (4): The past-the-end position in :term:`character positions <character position>`.
    * :termy:param:`key+value`: The region's attributes as NUL-terminated UTF-8 strings.

.. termy:protocol:: GET_REGION T(3201) termid clientid bufid regid

   Request information on a given region. The reply will be delivered as a state update block using the message types :termy:protocol:`BEGIN_OUTPUT_RESPONSE` and :termy:protocol:`END_OUTPUT_RESPONSE`.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier`.
    * :termy:param:`regid` (4): The :term:`region identifier`.

.. termy:protocol:: REMOVE_REGION T(3202) termid clientid bufid regid

   Remove a region created via :termy:protocol:`CREATE_REGION`.

    * :termy:param:`termid` (16): The destination :term:`terminal identifier`.
    * :termy:param:`clientid` (16): The originating :term:`client identifier`.
    * :termy:param:`bufid` (4): The low-order byte is the :term:`buffer identifier`.
    * :termy:param:`regid` (4): The :term:`region identifier`.
