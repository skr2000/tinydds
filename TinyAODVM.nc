//$Id: TinyAODVM.nc,v 1.4 2008-08-07 21:27:53 pruet Exp $

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
module TinyAODVM {
	provides {
		 interface StdControl;
		 interface L3;
	}
	uses {
		 interface Send;
		 interface Receive;
		 interface Intercept;
		 interface SendMHopMsg;
		 interface SingleHopMsg;
		 interface MultiHopMsg;
		 interface AODVMsg;
		 interface Neighbors;
		 interface ReceiveMsg as ReceiveRreq;
		 interface Payload as RreqPayload;
	}
} implementation {
	TOS_Msg	msg_buf;
	TOS_MsgPtr msg;
	uint8_t retry = 5;
	typedef struct {
		uint8_t	src;
		uint16_t topic;
		uint32_t sec;
		uint32_t nanosec;
		uint8_t size;
		uint8_t subject;
		uint8_t	data[MAX_DATA_LEN];
	} __attribute__ ((packed)) Data_Msg;
	typedef Data_Msg *Data_Msg_Ptr;
	uint8_t currentDest;
	Data currentData;
	uint8_t currentRetry = NIL;
	Data buffer[MAX_BUFFER_SIZE];
	uint8_t buffer_start = 0;
	uint8_t buffer_stop = 0;

	command result_t StdControl.init ()
	{
		dbg(DBG_USR2,"TinyAODVM:init\n");
		msg = &msg_buf;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2,"TinyAODVM:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2,"TinyAODVM:stop\n");
		return SUCCESS;
	}

	event result_t Send.sendDone (TOS_MsgPtr sentBuffer, result_t success) 
	{
		dbg(DBG_USR2,"TinyAODVM:send:sendDone\n");
		return SUCCESS;
	}

	event TOS_MsgPtr Receive.receive (TOS_MsgPtr m, void *payload, uint16_t len) 
	{
		Data_Msg_Ptr data_msg_ptr;
		Data data;
		dbg(DBG_USR2,"TinyAODVM:Receive:receive\n");
		data_msg_ptr = (Data_Msg_Ptr) payload;
		dbg(DBG_USR2, "TinyAODVM:Receive:data:%d:%d:%s\n", data_msg_ptr->src, data_msg_ptr->topic, data_msg_ptr->data);
		data.timestamp.sec = data_msg_ptr->sec;
		data.timestamp.nanosec = data_msg_ptr->nanosec;
		data.topic = data_msg_ptr->topic;
		data.size = data_msg_ptr->size;
		data.src = data_msg_ptr->src;
		data.subject = data_msg_ptr->subject;
		data.item = (Data_t)malloc(sizeof(uint8_t) * data.size);
		memcpy(data.item, data_msg_ptr->data, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
		signal L3.receive(data_msg_ptr->src, data);
		return m;
	}

	event PacketResult_t Intercept.intercept (TOS_MsgPtr forward_msg, void *payload, uint16_t len) 
	{
		dbg(DBG_USR2,"TinyAODVM:Intercept:intercept\n");
		return SUCCESS;
	}

	task void sendData()
	{
		Data_Msg_Ptr data_msg_ptr;
		uint16_t len;
		uint8_t dest = currentDest;
		Data data = currentData;
		retry = currentRetry;
		dbg(DBG_USR2,"TinyAODVM:sendData\n");
		data_msg_ptr = call Send.getBuffer(msg, &len);
		data_msg_ptr->src = TOS_LOCAL_ADDRESS;
		data_msg_ptr->sec = data.timestamp.sec;
		data_msg_ptr->nanosec = data.timestamp.nanosec;
		data_msg_ptr->size = data.size;
		data_msg_ptr->topic = data.topic;
		data_msg_ptr->subject = data.subject;
		memcpy(data_msg_ptr->data, data.item, (data.size > MAX_DATA_LEN)?MAX_DATA_LEN:data.size);
		dbg(DBG_USR2, "send to %d\n", dest);
		if (call SendMHopMsg.sendTTL(dest, (uint16_t) len, msg, 0) != SUCCESS) {
			dbg(DBG_USR2, "TinyAODVM:send: Send failed for new packet\n");
			currentRetry--;
			if(currentRetry > 0 && currentRetry != NIL) {
				dbg(DBG_USR2,"TinyAODVM:send:retry %d\n", currentRetry);
				post sendData();
			} else {
				currentRetry = NIL;
			}
		} else {
			dbg(DBG_USR2, "TinyAODVM:send success\n");
			currentRetry = NIL;
			if(buffer_start != buffer_stop) {
				dbg(DBG_USR2, "TinyAODVM:send buffer\n");
				buffer_start++;
				if(buffer_start > MAX_BUFFER_SIZE) buffer_start = 0;
				currentDest = dest;
				currentData = data;
				currentRetry = retry;
				post sendData();
			}
		}
	}

	command ReturnCode_t L3.send (uint16_t dest, Data data)
	{
		dbg(DBG_USR2,"TinyAODVM:send\n");
		if(currentRetry != NIL) {
			buffer_stop++;
			if(buffer_stop > MAX_BUFFER_SIZE) buffer_stop = 0;
			if(buffer_start == buffer_stop) {
				dbg(DBG_USR2,"TinyAODVM:error:data buffer overflow\n");
				return RETCODE_ERROR;
			}
			buffer[buffer_stop] = data;
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
	}

	event TOS_MsgPtr ReceiveRreq.receive(TOS_MsgPtr receivedMsg) 
	{
		wsnAddr prevHop;
		//dbg(DBG_USR2,"TinyAODVCM:RREQ:receive");
		prevHop = call SingleHopMsg.getSrcAddress(receivedMsg);
		if(call Neighbors.isNeighbor(prevHop) == FALSE) {
			//dbg(DBG_USR2,"TinyAODVCM:RREQ:receive:add neighbor %d\n", prevHop);
			call Neighbors.addNeighbor(prevHop);
		}

		return receivedMsg;
	}

}
