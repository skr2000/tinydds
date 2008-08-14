//$Id: TinyGIOPM.nc,v 1.3 2008-08-13 05:35:27 pruet Exp $

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
includes Hash;
module TinyGIOPM {
	provides {
		 interface StdControl;
		 interface TinyGIOP;
	}
	uses {
		 interface L4;
		 interface SendMsg as SendUART;
		 interface ReceiveMsg as ReceiveUART;
		 //FIXME: this should not be loop here..
		 interface OERP;
	}
}
implementation {
	TOS_Msg m_msg;
	Topic_t subscribed_topic[MAX_TOPIC_NUM];

	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2, "TinyGIOPM:init\n");
		for(i = 0; i != MAX_TOPIC_NUM; i++) {
			subscribed_topic[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2, "TinyGIOPM:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2, "TinyGIOPM:stop\n");
		return SUCCESS;
	}


	void sendUART(Data data)
	{
		char msg[32];
		char buf[10];
		strcpy(msg, "d,");
		strcat(msg, itoa(TINYGIOP_REPLY, buf, 10));
		strcat(msg, ",");
		strcat(msg, itoa(data.size, buf, 10));
		strcat(msg, ",");
		strcat(msg, itoa(data.orig, buf, 10));
		strcat(msg, ",");

		memcpy(msg + strlen(msg), data.item, data.size);
		dbg(DBG_USR2, "TinyGIOPM:sendUART:msg %s\n", msg);
		msg[31] = 0;
		memcpy(m_msg.data, msg, 32);
		m_msg.length = 32;
		atomic {
			call SendUART.send(TOS_UART_ADDR, 32,   &m_msg);
		}
	}

	event result_t SendUART.sendDone(TOS_MsgPtr msg, result_t success) {
		if(!success) {
			dbg(DBG_USR2, "TinyGIOPM:sendDone:error\n");
		} else {
			dbg(DBG_USR2, "TinyGIOPM:sendDone:success\n");
		}
		return SUCCESS;
	}

	event TOS_MsgPtr ReceiveUART.receive(TOS_MsgPtr msg) {
		char topic[128];
		uint8_t nf;
		dbg(DBG_USR2, "TinyGIOPM:ReceiveUART:receive %s\n", msg->data);
		if(msg->data[0] == 's') { //subscribe
			memcpy(topic, msg->data + 2, strlen(msg->data) - 2);
			topic[strlen(msg->data) - 2] = 0;
			nf = hash(topic);
			subscribed_topic[nf] = 1;
			dbg(DBG_USR2, "TinyGIOPM:subscribe %d\n", nf);
			call OERP.subscribe(nf);
		} else if (msg->data[0] == 'u') { //unsubscribe
		} else {
			dbg(DBG_USR2, "TinyGIOPM:ReceiveUART:receive error %c\n", msg->data[0]);
		}
		return msg;
	}


	command ReturnCode_t TinyGIOP.send (Topic_t topic, Data data)
	{
		dbg(DBG_USR2, "TinyGIOPM:send\n");
		return call L4.send(topic, data);
	}

	event ReturnCode_t L4.receive (uint16_t src, Data data)
	{
		dbg(DBG_USR2, "TinyGIOPM:receive from=%d orig=%d subject=%d\n", src, data.orig, data.subject);
		if(TOS_LOCAL_ADDRESS == 0 && data.subject == SUBJECT_DATA) {
			sendUART(data);
		}
		return signal TinyGIOP.receive(src, data);	
	}
	event ReturnCode_t L4.sendDone (Data data, bool success)
	{
		//TODO: we should do something here
		return SUCCESS;
	}
	event ReturnCode_t OERP.data_available (Topic_t topic, Data data)
	{
		//TODO: we should not do anything here
		return SUCCESS;
	}
	


}
