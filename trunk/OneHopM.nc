//$Id: OneHopM.nc,v 1.5 2008-08-11 19:49:34 pruet Exp $

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
module OneHopM {
	provides {
		 interface StdControl;
		 interface L3;
	}
	uses {
		 interface SendMsg;
		 interface ReceiveMsg;
		 interface Neighbors;
	}
} implementation {
	TOS_Msg	msg_buf;
	TOS_MsgPtr msg;
	uint8_t retry = 5;
	typedef struct {
		uint16_t src;
		uint16_t orig;
		uint16_t topic;
		uint32_t sec;
		uint32_t nanosec;
		uint8_t size;
		uint8_t subject;
		uint8_t	data[MAX_DATA_LEN];
	} __attribute__ ((packed)) Data_Msg;
	typedef Data_Msg *Data_Msg_Ptr;
	uint16_t currentDest;
	Data currentData;
	uint8_t currentRetry = NIL;
	Data buffer[MAX_BUFFER_SIZE];
	uint16_t dest_buf[MAX_BUFFER_SIZE];
	uint8_t buffer_start = 0;
	uint8_t buffer_stop = 0;

	command result_t StdControl.init ()
	{
		dbg(DBG_USR3,"OneHopM:init\n");
		msg = &msg_buf;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR3,"OneHopM:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR3,"OneHopM:stop\n");
		return SUCCESS;
	}


	event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg_ptr)
	{
		Data_Msg_Ptr data_msg_ptr;
		Data data;
		data_msg_ptr = (Data_Msg_Ptr) msg_ptr->data;
		dbg(DBG_USR3,"OneHopM:Receive:receive\n");
		dbg(DBG_USR3, "OneHopM:Receive:data:%d:%d:%d:%d:%s\n", data_msg_ptr->src, data_msg_ptr->orig, data_msg_ptr->subject, data_msg_ptr->topic, data_msg_ptr->data);
		data.timestamp.sec = data_msg_ptr->sec;
		data.timestamp.nanosec = data_msg_ptr->nanosec;
		data.topic = data_msg_ptr->topic;
		data.size = data_msg_ptr->size;
		data.orig = data_msg_ptr->orig;
		data.src = TOS_LOCAL_ADDRESS;
		data.subject = data_msg_ptr->subject;
		data.item = (Data_t)malloc(sizeof(uint8_t) * data.size);
		if(call Neighbors.isNeighbor(msg_ptr->addr) == FALSE) {
			dbg(DBG_USR3,"OneHopCM:Receive:add neighbor %d\n", msg_ptr->addr);
			call Neighbors.addNeighbor(msg_ptr->addr);
		}
		memcpy(data.item, data_msg_ptr->data, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
		signal L3.receive(data_msg_ptr->src, data);
		return msg_ptr;
	}

	task void sendData()
	{
		Data_Msg_Ptr data_msg_ptr;
		uint16_t len;
		uint16_t dest = currentDest;
		Data data = currentData;
		data_msg_ptr = (Data_Msg_Ptr) msg->data;
		retry = currentRetry;
		dbg(DBG_USR3,"OneHopM:sendData:subject %d\n", data.subject);
		//data_msg_ptr = call Send.getBuffer(msg, &len);
		data_msg_ptr->src = TOS_LOCAL_ADDRESS;
		data_msg_ptr->orig = data.orig;
		data_msg_ptr->sec = data.timestamp.sec;
		data_msg_ptr->nanosec = data.timestamp.nanosec;
		data_msg_ptr->size = data.size;
		data_msg_ptr->topic = data.topic;
		data_msg_ptr->subject = data.subject;
		memcpy(data_msg_ptr->data, data.item, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
		len = sizeof(Data_Msg) + MAX_DATA_LEN;
		dbg(DBG_USR3, "OneHopM:sendData:send to %d len %d\n", dest, len);
		if (call SendMsg.send(dest, (uint16_t) len, msg) != SUCCESS) {
		//if (call SendMsg.send(TOS_BCAST_ADDR, (uint16_t) len, msg) != SUCCESS) {
			dbg(DBG_USR3, "OneHopM:send: Send failed for new packet\n");
			// This is a hack here
			currentRetry--;
			currentData.item[7]++;
			if(currentRetry > 0 && currentRetry != NIL) {
				dbg(DBG_USR3,"OneHopM:send:retry %d\n", currentRetry);
				post sendData();
			} else {
				//spread alert pheromone
				signal L3.sendDone(data, FALSE);
				currentRetry = NIL;
			}
		} else {
			dbg(DBG_USR3, "OneHopM:send success\n");
		}
	}

	event result_t SendMsg.sendDone (TOS_MsgPtr sentBuffer, result_t success) 
	{
		dbg(DBG_USR3,"OneHopM:send:sendDone\n");
		if(success) {
			currentRetry = NIL;
			if(buffer_start != buffer_stop) {
				dbg(DBG_USR3, "OneHopM:send:sendDone:send buffer\n");
				buffer_start++;
				if(buffer_start > MAX_BUFFER_SIZE) buffer_start = 0;
				currentDest = dest_buf[buffer_stop];
				currentData = buffer[buffer_stop];
				currentRetry = retry;
				post sendData();
			}
		}
		return SUCCESS;
	}
	command ReturnCode_t L3.send (uint16_t dest, Data data)
	{
		dbg(DBG_USR3,"OneHopM:send to %d\n", dest);
		if(currentRetry != NIL) {
			buffer_stop++;
			if(buffer_stop > MAX_BUFFER_SIZE) buffer_stop = 0;
			if(buffer_start == buffer_stop) {
				dbg(DBG_USR3,"OneHopM:error:data buffer overflow\n");
				return RETCODE_ERROR;
			}
			buffer[buffer_stop] = data;
			dest_buf[buffer_stop] = dest;
			return RETCODE_OK;

		}
		currentDest = dest;
		currentData = data;
		currentRetry = retry;
		post sendData();
		return RETCODE_OK;
	}


	command uint8_t * L3.get_neighbors()
	{
		int num_neighbors;
		uint8_t *neighbors;
		int i;
		wsnAddr *buf;
		num_neighbors = call Neighbors.numNeighbors();
		neighbors = (uint8_t *)malloc(sizeof(uint8_t) * num_neighbors + 1);
		neighbors[0] = num_neighbors;
		buf = (wsnAddr *)malloc(sizeof(wsnAddr) * num_neighbors);
		call Neighbors.getNeighbors(buf, num_neighbors);
		return buf;
	}
}
