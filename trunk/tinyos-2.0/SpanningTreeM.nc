//$Id: SpanningTreeM.nc,v 1.1 2008-07-28 06:35:06 pruet Exp $
// Ported to 2.0

/*Copyright (c) 2008,2009 University of Massachusetts, Boston 
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
		 interface OERP;
	}
	uses {
		 interface Boot; 
		 interface L4;
	}
}
implementation {

	typedef nx_struct {
		nx_uint8_t weight;
		nx_uint8_t orig;
		nx_uint8_t parent;
		nx_uint8_t topic;
	} Topics;
	Topics topics[MAX_BUFFER_SIZE];

	int lookup(uint8_t id)
	{
		int i;
		for(i = 0; i != MAX_BUFFER_SIZE; i++) {
			if(topics[i].orig == id) {
				return i;
			}
		}
		return -1;
	}
	int findAvailable()
	{
		int i;
		for(i = 0; i != MAX_BUFFER_SIZE; i++) {
			if(topics[i].orig == 0) {
				return i;
			}
		}
		return -1;
	}

	event void Boot.booted()
	{
		int i;
		dbg("OERP", "ST:%s:called\n", __FUNCTION__);
		for(i = 0; i != MAX_BUFFER_SIZE; i++) {
			topics[i].weight = 0xFF;
			topics[i].parent = 0;
			topics[i].orig = 0;
			topics[i].topic = NIL;
		}
	}

	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		int i;
		dbg("OERP", "ST:%s:called\n", __FUNCTION__);
		data.orig = TOS_NODE_ID;
		for(i = 0; i != MAX_BUFFER_SIZE; i++) {
			if(topics[i].topic == data.topic) {
				dbg("OERP", "ST:%s:sendto %d\n", __FUNCTION__, topics[i].parent);
				call L4.send(topics[i].parent, data);
			}
		}
		return SUCCESS;
	}
	
	
	event ReturnCode_t L4.receive (nx_uint16_t src, Data data)
	{
		dbg("OERP", "ST:%s:receive from=%d orig=%d subject=%d\n", __FUNCTION__, src, data.orig, data.subject);
		if(data.subject == SUBJECT_DATA) {
			if(TOS_NODE_ID == BASESTATION_NODE_ID) {
				signal OERP.data_available(data.topic, data);	
			} else {
				int i;
				for(i = 0; i != MAX_BUFFER_SIZE; i++) {
					if(topics[i].topic == data.topic) {
						dbg("OERP", "ST:%s:receive data forward=%d\n", __FUNCTION__, topics[i].parent);
						call L4.send(topics[i].parent, data);
					}
				}
			}
		} else if(data.subject == SUBJECT_BASE_PHEROMONE_FLOOD) {
			int id;
			dbg("OERP", "ST:%s:receive base pheromone orig=%d incoming=%d \n", __FUNCTION__, data.orig, data.size);
			id = lookup(data.orig);
			if(id == -1) {
				id = findAvailable();
				if(id == -1) {
					dbg("OERP", "ST:%s:topic buffer fulled\n", __FUNCTION__);
					return SUCCESS;	
				}
				dbg("OERP", "ST:%s:receive new forward\n", __FUNCTION__);
				topics[id].weight = data.size++;
				topics[id].parent = src;
				topics[id].orig = data.orig;
				topics[id].topic = data.topic;
				call L4.send(TOS_BCAST_ADDR, data);
			} else {
				if(data.size < topics[id].weight) {
					dbg("OERP", "ST:%s:receive forward\n", __FUNCTION__);
					topics[id].weight = data.size++;
					topics[id].parent = src;
					topics[id].orig = data.orig;
					topics[id].topic = data.topic;
					call L4.send(TOS_BCAST_ADDR, data);
				}
				dbg("OERP", "ST:%s:receive drop\n", __FUNCTION__);
			}
		}
		return SUCCESS;
	}

	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		Data data;
		dbg("OERP", "ST:%s:called\n", __FUNCTION__);
		data.subject = SUBJECT_BASE_PHEROMONE_FLOOD;
		data.topic = topic;
		data.size = 0;
		data.orig = TOS_NODE_ID;
		call L4.send(TOS_BCAST_ADDR, data);
		return SUCCESS;
	}
}
