//$Id: SpanningTreeM.nc,v 1.3 2008-08-07 21:27:53 pruet Exp $

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
module SpanningTreeM {
	provides {
		 interface StdControl;
		 interface OERP;
	}
	uses {
		 interface L4;
		 interface Timer;
	}
}
implementation {
	
	int my_weight[MAX_TOPIC_NUM];
	int my_parent;
	uint8_t neighbors[MAX_MEMBER_SIZE];
	Data weight_data;
	Topic_t my_topic;
	int weight_counter;


	
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR3, "SpanningTreeM:OERP:init\n");
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			neighbors[i] = 0;
		}
		for(i = 0; i != MAX_TOPIC_NUM; i++) {
			my_weight[i] = 9999;
		}
		my_parent = 0;
		weight_counter = 0;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR3, "SpanningTreeM:OERP:start\n");
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR3, "SpanningTreeM:OERP:stop\n");
		return SUCCESS;
	}

	task void forwardWeight()
	{
		call L4.send(TOS_BCAST_ADDR, weight_data);
	}

	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		data.orig = TOS_LOCAL_ADDRESS;
		if(my_weight[topic] == 9999) {
			dbg(DBG_USR3, "SpanningTreeM:OERP:no path, data is dropped\n");
			return FAIL;
		}
		dbg(DBG_USR3, "SpanningTreeM:OERP:send to %d\n", my_parent);
		return call L4.send(my_parent, data);
	}
	
	event ReturnCode_t L4.receive (uint16_t src, Data data)
	{
		dbg(DBG_USR3, "SpanningTreeM:OERP:receive from=%d orig=%d subject=%d\n", src, data.orig, data.subject);
		if(data.subject == SUBJECT_DATA) {
			if(TOS_LOCAL_ADDRESS != 0) {
				dbg(DBG_USR3, "SpanningTreeM:OERP:receive data forward=%d\n", my_parent);
				return call L4.send(my_parent, data);
			}
		} else if(data.subject == SUBJECT_SUBSCRIBE) {
			dbg(DBG_USR3, "SpanningTreeM:OERP:receive weight incoming=%ld current=%ld\n", data.size, my_weight);
			neighbors[src] = 1;
			if(data.item[0] < my_weight[data.topic] || data.item[1] > weight_counter) {
				#ifdef DEBUG_EDGE
				dbg(DBG_USR1, "parent DIRECTED GRAPH: remove edge %d \n", my_parent);
				#endif
				my_parent = src;
				#ifdef DEBUG_EDGE
				dbg(DBG_USR1, "parent DIRECTED GRAPH: add edge %d \n", my_parent);
				#endif
				dbg(DBG_USR3, "SpanningTreeM:OERP:receive forward\n");
				my_weight[data.topic] = data.item[0]++;
				weight_data = data;
				weight_counter = data.item[1];
				post forwardWeight();
			}
			dbg(DBG_USR3, "SpanningTreeM:OERP:receive drop\n");
			return SUCCESS;
		}
		return signal OERP.data_available(data.topic, data);	
	}

	
	task void sendSubscription()
	{
		if(TOS_LOCAL_ADDRESS != 0) 
			return;
		dbg(DBG_USR1, "SpanningTreeM:OERP:sendSubscription %d\n", my_topic);
		weight_data.subject = SUBJECT_SUBSCRIBE;
		weight_data.topic = my_topic;
		weight_data.item = (Data_t) malloc(sizeof(uint8_t) * 2);
		weight_data.item[0] = 0;
		weight_data.item[1] = weight_counter++;
		weight_data.size = 2;
		my_weight[my_topic] = 0;
		post forwardWeight();
	}
	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		dbg(DBG_USR3, "SpanningTreeM:OERP:subscribe %d\n", topic);
		my_topic = topic;
		//post sendSubscription();
		// If network is dynamic, you might need to chage this from one-shot to periodically
		//call Timer.start(TIMER_REPEAT, 10000);
		call Timer.start(TIMER_ONE_SHOT, 10000);
		return SUCCESS;
	}
	event result_t Timer.fired()
	{
		post sendSubscription();
		return SUCCESS;
	}

	event ReturnCode_t L4.sendDone (Data data, bool success)
	{
		return SUCCESS;
	}
}
