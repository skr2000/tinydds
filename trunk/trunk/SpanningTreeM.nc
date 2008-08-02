//$Id: SpanningTreeM.nc,v 1.1 2008-07-28 06:35:06 pruet Exp $

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
module SpanningtreeM {
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
	
	int my_weight;
	int my_parent;
	uint8_t neighbors[MAX_NETWORK_SIZE];
	Data weight_data;

	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		dbg(DBG_USR3, "SpanningtreeM:OERP:send to %d\n", my_parent);
		data.orig = TOS_LOCAL_ADDRESS;
		return call L4.send(my_parent, data);
	}
	
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR3, "SpanningtreeM:OERP:init\n");
		for(i = 0; i != MAX_NETWORK_SIZE; i++) {
			neighbors[i] = 0;
		}
		my_weight = 9999;
		my_parent = 0;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR3, "SpanningtreeM:OERP:start\n");
		if(TOS_LOCAL_ADDRESS == 0) {
			// If network is dynamic, you might need to chage this from one-shot to periodically
			call Timer.start(TIMER_ONE_SHOT, 5000);
		}
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR3, "SpanningtreeM:OERP:stop\n");
		return SUCCESS;
	}

	task void forward_weight()
	{
		call L4.send(TOS_BCAST_ADDR, weight_data);
	}
	
	event ReturnCode_t L4.receive (uint16_t src, Data data)
	{
		dbg(DBG_USR3, "SpanningtreeM:OERP:receive from=%d orig=%d subject=%d\n", src, data.orig, data.subject);
		if(data.subject == SUBJECT_DATA) {
			if(TOS_LOCAL_ADDRESS != 0) {
				dbg(DBG_USR3, "SpanningtreeM:OERP:receive data forward=%d\n", my_parent);
				return call L4.send(my_parent, data);
			}
		} else if(data.subject == SUBJECT_BASE_PHEROMONE_FLOOD) {
			dbg(DBG_USR3, "SpanningtreeM:OERP:receive base pheromone incoming=%d current=%d\n", data.size, my_weight);
			neighbors[src] = 1;
			if(data.size < my_weight) {
				#ifdef DEBUG_EDGE
				dbg(DBG_USR1, "parent DIRECTED GRAPH: remove edge %d \n", my_parent);
				#endif
				my_parent = src;
				#ifdef DEBUG_EDGE
				dbg(DBG_USR1, "parent DIRECTED GRAPH: add edge %d \n", my_parent);
				#endif
				dbg(DBG_USR3, "SpanningtreeM:OERP:receive forward\n");
				my_weight = data.size++;
				weight_data = data;
				post forward_weight();
			}
			dbg(DBG_USR3, "SpanningtreeM:OERP:receive drop\n");
			return SUCCESS;
		}
		return signal OERP.data_available(data.topic, data);	
	}

	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		return SUCCESS;
	}

	event result_t Timer.fired()
	{
		Data data;
		if(TOS_LOCAL_ADDRESS != 0) 
			return FAIL;
		data.subject = SUBJECT_BASE_PHEROMONE_FLOOD;
		data.topic = 0;
		data.size = 0;
		my_weight = 0;
		return call L4.send(TOS_BCAST_ADDR, data);
	}
}
