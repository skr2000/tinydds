//$Id: TinyGIOPM.nc,v 1.2 2008-08-11 19:49:34 pruet Exp $

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
		 interface OERP;
		 interface SendMsg as SendUART;
		 interface ReceiveMsg as ReceiveUART;
	}
}
implementation {
	TOS_Msg m_msg;
	Topic_t subscribed_topic[MAX_TOPIC_NUM];

	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2, "TinyGIOPM:OERP:init\n");
		for(i = 0; i != MAX_TOPIC_NUM; i++) {
			subscribed_topic[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2, "TinyGIOPM:OERP:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2, "TinyGIOPM:OERP:stop\n");
		return SUCCESS;
	}

	uint8_t split(uint8_t *str, char **out, const char sep)
	{
		int i;
		int count = 0;
		uint8_t nf = 0;
		char *buf;
		int len = strlen(str);
		for(i = 0; i != len; i++) {
			if(str[i] == sep) count++;
		}
		out = (char **)malloc(sizeof(char *) * (count + 1));
		count = 0;
		buf = (char *)malloc(sizeof(char) * len);
		for(i = 0; i != len; i++) {
			if(str[i] != sep) {
				buf[count] = str[i];
				count++;
			} else {
				out[nf] = (char *)malloc(sizeof(char) * count + 1);
				memcpy(out[nf], buf, count);
				out[nf][count] = 0;
				nf++;
				count = 0;
			}
		}
		if(count != 0) {
			out[nf] = (char *)malloc(sizeof(char) * count + 1);
			memcpy(out[nf], buf, count);
			out[nf][count] = 0;
			nf++;
		}
		return nf;
	}
	int szLen( int8_t* data, int maxlen )
	{
		int i;
		for( i=0; i<maxlen; i++ )
		{
			if( data[i] == 0 )
				return i;
		}
		return maxlen;
	}

	void sendUART(Data data)
	{
		char msg[32];
		sprintf(msg, "d,%u,%u,%u,", TINYGIOP_REPLY, data.size, data.orig);
		memcpy(msg + strlen(msg), data.item, data.size);
		//msg = (uint8_t *)m_msg.data;
		//sprintf(msg, "d,%d,%d,%d", TINYGIOP_REPLY, data.size, data.orig);
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
			dbg(DBG_USR2, "TinyGIOPM:OERP:subscribe %d\n", nf);
			call OERP.subscribe(nf);
		} else if (msg->data[0] == 'u') { //unsubscribe
		} else {
			dbg(DBG_USR2, "TinyGIOPM:ReceiveUART:receive error %c\n", msg->data[0]);
		}
		return msg;
	}


	command ReturnCode_t TinyGIOP.send (Topic_t topic, Data data)
	{
		dbg(DBG_USR2, "TinyGIOPM:OERP:send\n");
		return call OERP.send(topic, data);
	}

	event ReturnCode_t OERP.data_available (uint16_t src, Data data)
	{
		dbg(DBG_USR2, "TinyGIOPM:OERP:receive from=%d orig=%d subject=%d\n", src, data.orig, data.subject);
		if(TOS_LOCAL_ADDRESS == 0) {
			sendUART(data);
		}
		return signal TinyGIOP.data_available(data.topic, data);	
	}

	command ReturnCode_t TinyGIOP.subscribe (Topic_t topic)
	{
		dbg(DBG_USR2, "TinyGIOPM:OERP:subscribe %d\n", topic);
		return call OERP.subscribe(topic);
	}

}
