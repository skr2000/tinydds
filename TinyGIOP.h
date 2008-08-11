//$Id: TinyGIOP.h,v 1.2 2008-08-11 19:49:34 pruet Exp $

/*Copyright (c) 2008 University of Massachusetts, Boston 
All rights reserved. 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

	Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
    Neither the name of the University of Massachusetts, Boston  nor 
the names of its contributors may be used to endorse or promote products 
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY OF
MASSACHUSETTS, BOSTON OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef TINYGIOP_H
#define TINYGIOP_H

#include "TinyCDR.h"

// Based on GIOP 1.3
enum {
	TINYGIOP_REQUEST, 
	TINYGIOP_REPLY,
	TINYGIOP_CANCEL_REQUEST,
	TINYGIOP_LOCATE_REQUEST,
	TINYGIOP_LOCATE_REPLY,
	TINYGIOP_CLOSE_CONNECTION,
	TINYGIOP_MESSAGE_ERROR,
	TINYGIOP_FLAGMENT,
};

typedef struct {
	cdr_octet major;
	cdr_octet minor;
} TinyGIOPVersion;

typedef struct {
	cdr_char	magic[4];
	TinyGIOPVersion	GIOP_Version;
	cdr_octet	flags;
	cdr_octet	message_type;
	cdr_ulong	message_size;
} TinyGIOPMessageHeader;

typedef struct {
	cdr_ulong	request_id;
	cdr_octet	response_flags;
	cdr_octet	reserved[3];
	cdr_short	target;
	cdr_string	operation;
} TinyGIOPRequestHeader;

enum {
	NO_EXCEPTION_REPLY_STATUS_TYPE,
	USER_EXCEPTION_REPLY_STATUS_TYPE,
	SYSTEM_EXCEPTION_REPLY_STATUS_TYPE,
	LOCATION_FORWARD_REPLY_STATUS_TYPE,
	LOCATION_FORWARD_PERM_REPLY_STATUS_TYPE,
	LOCATION_FORWARD_MODE_REPLY_STATUS_TYPE,
};

#define TinyGIOPReplyStatusType uint8_t
typedef struct {
	cdr_long	request_id;
	TinyGIOPReplyStatusType reply_status;
} TinyGIOPReplyHeader;

typedef struct {
	cdr_ulong	request_id;
} TinyGIOPCancelRequestHeader;

typedef struct {
	cdr_ulong	request_id;
	cdr_short	target;	
} TinyGIOPLocateRequestHeader;

enum {
	UNKNOWN_OBJECT_LOCATE_STATUS_TYPE,
	OBJECT_HERE_LOCATE_STATUS_TYPE,
	OBJECT_FORWARD_LOCATE_STATUS_TYPE,
	OBJECT_FORWARD_PERM_LOCATE_STATUS_TYPE,
	LOC_SYSTEM_EXCEPTION_LOCATE_STATUS_TYPE,
	LOC_NEEDS_ADDRESSING_MODE_LOCATE_STATUS_TYPE,
};

#define TinyGIOPLocateReplyStatusType uint8_t
typedef struct {
	cdr_ulong	request_id;
	TinyGIOPLocateReplyStatusType locate_status;
} TinyGIOPLocateReplyHeader;
#endif
