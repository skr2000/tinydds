//$Id: DHTM.nc,v 1.3 2008-08-07 21:27:53 pruet Exp $

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

//This file is generated from IDL. please use it as the skelton file for your module
module DHTM {
	provides {
		 interface StdControl;
		 interface OERP;
	}
	uses {
		 interface L4;
	}
}
implementation {

	typedef struct {
		Topic_t topic;
		uint8_t subscribers[MAX_BUFFER_SIZE];
	} __attribute__ ((packed)) topics[MAX_BUFFER_SIZE];

	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		Data data;
		dbg(DBG_USR2,"DHTM:OERP:subscribe\n");
		data.size = 0;
		data.subject = SUBJECT_SUBSCRIBE;
		return call L4.send(topic, data);
	}
	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		dbg(DBG_USR2,"DHTM:OERP:send\n");
		data.subject = SUBJECT_PUBLISH;
		return call L4.send(topic, data);
	}
	
	command result_t StdControl.init ()
	{
		dbg(DBG_USR2,"DHTM:OERP:init\n");
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2,"DHTM:OERP:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2,"DHTM:OERP:stop\n");
		return SUCCESS;
	}

	event ReturnCode_t L4.receive (uint16_t src, Data data)
	{
		dbg(DBG_USR2,"DHTM:OERP:receive subject=%d\n", data.subject);
		return signal OERP.data_available(data.topic, data);	
	}

	event ReturnCode_t L4.sendDone (Data data, bool success)
	{
	}
}
