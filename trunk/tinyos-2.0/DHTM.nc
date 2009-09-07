//$Id: DHTM.nc,v 1.1 2008-07-28 06:35:06 pruet Exp $
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
module DHTM {
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
	//FIXME, better change to dynamic one
	nx_uint16_t subscribers[MAX_HASH][MAX_MEMBER_SIZE];
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

	void initialize()
	{
		int j,i;
		for(i = 0; i != MAX_BUFFER_SIZE; i++) {
			topics[i].weight = 0xFF;
			topics[i].parent = 0;
			topics[i].orig = 0;
			topics[i].topic = NIL;
		}
		for(i = 0; i != MAX_HASH; i++) {
			for(j = 0; j != MAX_MEMBER_SIZE; j++) {
				subscribers[i][j] = NILNIL;
			}
		}
	}
	event void Boot.booted()
	{
		dbg("OERP", "DH:%s:called\n", __FUNCTION__);
		initialize();
	}
	nx_uint8_t hash(nx_uint8_t topic) 
	{
		return topic % MAX_HASH;
	}
	uint8_t hashSize(nx_uint8_t topic)
	{
		return (uint8_t)topic / MAX_HASH;
	}

	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		dbg("OERP", "DH:%s:called\n", __FUNCTION__);
		data.orig = TOS_NODE_ID;
		// rewrite subject
		data.subject = SUBJECT_DATA_TO_HASH;
		dbg("OERP", "DH:%s:sendto hash node %d\n", __FUNCTION__, hash(data.topic));
		return call L4.send(data.topic, data);
	}
	
	
	event ReturnCode_t L4.receive (nx_uint16_t src, Data data)
	{
		dbg("OERP", "DH:%s:receive from=%d orig=%d subject=%d\n", __FUNCTION__, src, data.orig, data.subject);
		if(data.subject == SUBJECT_DATA) {
			if(TOS_NODE_ID == BASESTATION_NODE_ID) {
				signal OERP.data_available(data.topic, data);	
			} else {
				int i;
				for(i = 0; i != MAX_BUFFER_SIZE; i++) {
					if(topics[i].topic == data.topic) {
						dbg("OERP", "DH:%s:receive data forward=%d\n", __FUNCTION__, topics[i].parent);
						call L4.send(topics[i].parent, data);
					}
				}
			}
		} else if(data.subject == SUBJECT_DATA_TO_HASH) {
			dbg("OERP", "DH:%s:receive published data request orig=%d incoming=%d \n", __FUNCTION__, data.orig, data.size);
			if(data.topic == hash(TOS_NODE_ID)) {
				int i;
				dbg("OERP", "DH:%s:my hashed data from %d topic %d \n", __FUNCTION__, data.orig, data.topic);
				data.subject = SUBJECT_DATA;
				for(i = 0; i != MAX_MEMBER_SIZE; i++) {
					if(subscribers[hashSize(data.topic)][i] != NILNIL) {
						dbg("OERP", "DH:%s:published to %d \n", __FUNCTION__, subscribers[hashSize(data.topic)][i]);
						call L4.send(subscribers[hashSize(data.topic)][i], data);
					}	
				}
			}
		} else if(data.subject == SUBJECT_SUBSCRIBE) {
			int i;
			dbg("OERP", "DH:%s:receive subscribe request orig=%d incoming=%d \n", __FUNCTION__, data.orig, data.size);
			if(data.topic == hash(TOS_NODE_ID)) {
				for(i = 0; i != MAX_MEMBER_SIZE; i++) {
					if(subscribers[hashSize(data.topic)][i] == data.orig) {
						dbg("OERP", "DH:%s:we know this subscriber, skip %d\n", __FUNCTION__, hashSize(data.topic));
						return SUCCESS;	
					}
				}
				for(i = 0; i != MAX_MEMBER_SIZE; i++) {
					if(subscribers[hashSize(data.topic)][i] == NILNIL) {
						dbg("OERP", "DH:%s:added to subscription slot for topic %d\n", __FUNCTION__, hashSize(data.topic));
						subscribers[hashSize(data.topic)][i] = data.orig;
						return SUCCESS;	
					}
				}
			}
		}
		return SUCCESS;
	}

	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		Data data;
		dbg("OERP", "DH:%s:called\n", __FUNCTION__);
		data.subject = SUBJECT_SUBSCRIBE;
		data.topic = topic;
		data.size = 0;
		data.orig = TOS_NODE_ID;
		call L4.send(hash(topic), data);
		return SUCCESS;
	}
}
