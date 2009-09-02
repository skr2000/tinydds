//$Id: OneHopM.nc,v 1.1 2008-07-28 06:35:06 pruet Exp $
// Ported to 2.0

/*Copyright (c) 2008, 2009 University of Massachusetts, Boston 
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
module OneHopM {
	provides {
		 interface L3;
	}
	uses {
		 interface Boot;
		 interface AMSend;
		 interface Receive;
		 interface Packet;
         interface LocalTime<TMilli>;
		 interface SplitControl as AMControl;
	}
} implementation {
	message_t packet;
	Neighbors _neighbors[MAX_NEIGHBOR];
	nx_uint16_t DEFAULT;

	typedef nx_struct data_msg {
		nx_uint16_t src;
		nx_uint16_t orig;
		nx_uint8_t topic;
		nx_uint32_t sec;
		nx_uint32_t nanosec;
		nx_uint8_t size;
		nx_uint8_t subject;
		nx_uint8_t	data[MAX_DATA_LEN];
	} Data_Msg;
	typedef Data_Msg *Data_Msg_Ptr;
	
	void initNighbors()
	{
		int k;
		for(k = 0; k != MAX_NEIGHBOR; k++) {
			_neighbors[k].id = DEFAULT;
			_neighbors[k].dist = DEFAULT;
			_neighbors[k].status = DEFAULT;
		}
	}

	int getNeighborSize()
	{
		int k;
		int j = 0;
		for(k = 0; k != MAX_NEIGHBOR; k++) {
			if(_neighbors[k].id != DEFAULT) j++;
		}
		return j;
	}

	int addNeighbor(nx_uint16_t id)
	{
		int k;
		for(k = 0; k != MAX_NEIGHBOR; k++) {
			if(_neighbors[k].id == DEFAULT) {
				_neighbors[k].id = id;
				return RETCODE_OK;
			} 
			if(_neighbors[k].id == id) {
				return RETCODE_OK;
			}
		}
		return RETCODE_ERROR;
	}

	nx_uint16_t* getNeighborList()
	{
		int k;
		int j = 1;
		nx_uint16_t *list = (nx_uint16_t *)malloc(sizeof(nx_uint16_t) * (MAX_NEIGHBOR + 1));
		for(k = 0; k != MAX_NEIGHBOR; k++) {
			if(_neighbors[k].id != DEFAULT) {
				list[j] = _neighbors[k].id;
				j++;
			}
		}
		list[0] = j -1;
		return list;
	}


	event void Boot.booted()
	{
		dbg("L3", "OH:%s:called\n", __FUNCTION__);
		DEFAULT = 0xFFFF;

		call AMControl.start();
	}

	event void AMControl.startDone(error_t err) {
		dbg("L3", "OH:%s:called\n", __FUNCTION__);
		if(err != SUCCESS) {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
		dbg("L3", "OH:%s:called\n", __FUNCTION__);
	}


	event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len)
	{
		if(len == sizeof(Data_Msg)) {
			Data data;
			Data_Msg_Ptr data_msg_ptr = (Data_Msg_Ptr) payload;
			addNeighbor(data_msg_ptr->src);
			dbg("L3", "OH:%s:called Receive:data:%d:%d:%d:%d:%s\n", __FUNCTION__, data_msg_ptr->src, data_msg_ptr->orig, data_msg_ptr->subject, data_msg_ptr->topic, data_msg_ptr->data);
			data.timestamp.sec = data_msg_ptr->sec;
			data.timestamp.nanosec = data_msg_ptr->nanosec;
			data.topic = data_msg_ptr->topic;
			data.size = data_msg_ptr->size;
			data.orig = data_msg_ptr->orig;
			data.src = TOS_NODE_ID;
			data.subject = data_msg_ptr->subject;
			//data.item = (Data_t)malloc(sizeof(nx_uint8_t) * data.size);
			memcpy(data.item, data_msg_ptr->data, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
			signal L3.receive(data_msg_ptr->src, data);
		}
		return bufPtr;
	}

	event void AMSend.sendDone (message_t* sentBuffer, error_t err) 
	{
		dbg("L3", "OH:%s:called\n", __FUNCTION__);
		if(&packet == sentBuffer) {
			dbg("L3", "OH:%s:status %d\n", __FUNCTION__, err);
		}
	}

	command ReturnCode_t L3.send (nx_uint16_t dest, Data data)
	{
		nx_uint16_t len;
		Data_Msg_Ptr m = (Data_Msg_Ptr)(call Packet.getPayload(&packet, NULL));
		dbg("L3", "OH:%s:called\n", __FUNCTION__);
		m->src = TOS_NODE_ID;	
		m->orig = data.orig;
		m->sec = data.timestamp.sec;
		m->nanosec = data.timestamp.nanosec;
		m->size = data.size;
		m->topic = data.topic;
		m->subject = data.subject;
		if(data.subject == SUBJECT_DATA) {
			data.item[10]++;
			dbg("L3", "OH:%s:subject %d:trans count %d \n", __FUNCTION__, data.subject, data.item[10]);
		}
		memcpy(m->data, data.item, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
		len = sizeof(Data_Msg) + MAX_DATA_LEN;
		dbg("L3", "OH:%s:send to %d len %d time %d\n", __FUNCTION__, dest, len, call LocalTime.get());
		if(call AMSend.send(dest, &packet, sizeof(Data_Msg)) == SUCCESS) {
			dbg("L3", "OH:%s:sent\n", __FUNCTION__);
		} else {
			dbg("L3", "OH:%s:failed\n", __FUNCTION__);
		}
		return RETCODE_OK;
	}


	command nx_uint16_t * L3.get_neighbors()
	{
		return getNeighborList();
	}
}
