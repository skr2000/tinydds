//$Id: BisnetM.nc,v 1.6 2008-08-07 21:27:53 pruet Exp $

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
module BisnetM {
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
	
	int my_base_pheromone;
	int my_alert_pheromone;
	int my_migrate_pheromone;
	int my_parent;
	int8_t neighbors[MAX_NEIGHBOR];
	uint8_t base_pheromone[MAX_NEIGHBOR];
	uint8_t alert_pheromone[MAX_NEIGHBOR];
	uint8_t migrate_pheromone[MAX_NEIGHBOR];
	uint8_t agent_dna[4];
	Data base_pheromone_data;
	int base_pheromone_count = 0;

	int getNeighbors(int src)
	{
		int i;
		for(i = 0; i != MAX_NEIGHBOR; i++) {
			if(neighbors[i] == src)
				return i;
		}
		if(i == MAX_NEIGHBOR) {
			for(i = 0; i != MAX_NEIGHBOR; i++) {
				if(neighbors[i] == -1) {
					neighbors[i] = src;
					return i;
				}
			}
		}
		return -1;
	}
	command ReturnCode_t OERP.send (Topic_t topic, Data data)
	{
		Data_t new_item;
		int i;
		int new_size;
		dbg(DBG_USR3, "BisnetM:OERP:send to %d\n", my_parent);
		data.orig = TOS_LOCAL_ADDRESS;
		new_size = data.size + 8;
		new_item = (Data_t)malloc(sizeof(uint8_t) * new_size);
		for(i = 0; i != data.size; i++) {
			new_item[i] = data.item[i];
		}
		free(data.item);
		data.item = new_item;
		data.item[1] = my_parent;
	//	data.item[2] = my_alert_pheromone;
	//	data.item[3] = my_base_pheromone;
	//	data.item[4] = my_migrate_pheromone;
		data.item[2] = agent_dna[0]; //alert
		data.item[3] = agent_dna[1]; //base
		data.item[4] = agent_dna[2]; //migrate
		data.item[5] = agent_dna[3]; //p
		data.item[6] = 1;
		data.item[7] = 1; //FIXME: this should be done here
		data.item[8] = 1; //FIXME: this should be done here
		data.size = new_size;
		#ifdef DEBUG_EDGE
		dbg(DBG_USR1, "parent DIRECTED GRAPH: add edge %d color: 0xFF0000\n", my_parent);
		#endif
		return call L4.send(TOS_BCAST_ADDR, data);
		//return call L4.send(my_parent, data);
	}
	
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR3, "BisnetM:OERP:init\n");
		for(i = 0; i != MAX_NEIGHBOR; i++) {
			neighbors[i] = -1;
			base_pheromone[i] = 0; 
			alert_pheromone[i] = 0;
			migrate_pheromone[i] = 0;
		}
		my_base_pheromone = 9999;
		my_alert_pheromone = 0;
		my_migrate_pheromone = 0;
		my_parent = 0;
		// Random
		agent_dna[0] = 100;
		agent_dna[1] = 200;
		agent_dna[2] = 50;
		agent_dna[3] = 100;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR3, "BisnetM:OERP:start\n");
		if(TOS_LOCAL_ADDRESS == 0) {
			call Timer.start(TIMER_REPEAT, 5000);
		}
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR3, "BisnetM:OERP:stop\n");
		return SUCCESS;
	}

	task void forward_base_pheromone()
	{
		call L4.send(TOS_BCAST_ADDR, base_pheromone_data);
	}

	event ReturnCode_t L4.sendDone (Data data, bool success)
	{
		if(success) {
			dbg(DBG_USR3, "BisnetM:L4:sendDone\n");
		} else {
			dbg(DBG_USR1, "BisnetM:L4:failed\n");
		}
		return SUCCESS;
	}
	
	event ReturnCode_t L4.receive (uint16_t src, Data data)
	{
		int id;
		int i;
		int weight;
		int max_weight;
		int nid;
		dbg(DBG_USR3, "BisnetM:OERP:receive from=%d to=%d orig=%d subject=%d\n", src, data.item[1], data.orig, data.subject);
		id = getNeighbors(src);
		if(id == -1) {
			dbg(DBG_USR3, "BisnetM:negative id\n");
			exit(1);
		}
		if(data.subject == SUBJECT_DATA) {
			dbg(DBG_USR3, "BisnetM:OERP:update neighbor pheromone=%d\n", src);
			alert_pheromone[id] = data.item[2];
			base_pheromone[id] = data.item[3];
			migrate_pheromone[id] = data.item[4];
			if(data.item[1] == TOS_LOCAL_ADDRESS) {
				if(TOS_LOCAL_ADDRESS != 0) {
					data.item[1] = my_parent;
					//data.item[2] = my_alert_pheromone;
					//data.item[3] = my_base_pheromone;
					//data.item[4] = my_migrate_pheromone++;
					data.item[6]++; //increase cost for migration
					data.item[7]++; //increase #of transmission
					data.item[8]++; //increase #of transmission
					
					//weight calculation
					max_weight = 0;
					nid = 0;
					for(i = 0; i != MAX_NEIGHBOR; i++) {
						if(neighbors[i] != -1) {
							weight = alert_pheromone[i] * (data.item[5] - 100)
									+ (10 - base_pheromone[i]) * (data.item[6] - 100)
									+ migrate_pheromone[i] * (data.item[7] - 100);

							if(weight > max_weight) {
								max_weight = weight;
								nid = i;
							}
						}
					}
					if(max_weight == 0) {
						nid = my_parent;
					} else {
						nid = getNeighbors(nid);
					}

					dbg(DBG_USR3, "BisnetM:OERP:receive data forward=%d %d.%d.%d\n", nid, my_alert_pheromone, my_base_pheromone, my_migrate_pheromone);
					return call L4.send(TOS_BCAST_ADDR, data);
				} else {
					dbg(DBG_USR3, "BisnetM:OERP:receive data push up\n");
					return signal OERP.data_available(data.topic, data);	
				}
			}
			dbg(DBG_USR3, "BisnetM:OERP:not destination:drop\n");
			return SUCCESS;
		} else if(data.subject == SUBJECT_BASE_PHEROMONE_FLOOD) {
			dbg(DBG_USR3, "BisnetM:OERP:receive base pheromone incoming=%d current=%d\n", data.item[1], my_base_pheromone);
			base_pheromone[id] = data.item[1];;
			if(data.item[1] < my_base_pheromone || base_pheromone_count < data.item[2]  ) {
				#ifdef DEBUG_EDGE
				//dbg(DBG_USR1, "parent DIRECTED GRAPH: remove edge %d \n", my_parent);
				#endif
				my_parent = src;
				#ifdef DEBUG_EDGE
				//dbg(DBG_USR1, "parent DIRECTED GRAPH: add edge %d \n", my_parent);
				#endif
				dbg(DBG_USR3, "BisnetM:OERP:receive forward\n");
				my_base_pheromone = data.item[1]++;
				base_pheromone_data = data;
				base_pheromone_count = data.item[2];
				post forward_base_pheromone();
			}
			dbg(DBG_USR3, "BisnetM:OERP:receive drop\n");
			return SUCCESS;
		}
		dbg(DBG_USR3, "BisnetM:OERP:unknown subject\n");
		return FAIL;
	}

	command ReturnCode_t OERP.subscribe (Topic_t topic)
	{
		return SUCCESS;
	}

	event result_t Timer.fired()
	{
		Data data;
		int i;
		if(TOS_LOCAL_ADDRESS != 0) {
			dbg(DBG_USR3, "BisnetM:OERP:Timer.fired:evapourate pheromones\n");
			//Updating pheromone
			for(i = 0; i != MAX_NEIGHBOR; i++) {
				base_pheromone[i] /= 2;
				alert_pheromone[i] /= 2;
				migrate_pheromone[i] /= 2;
			}
			my_alert_pheromone /= 2;
			my_base_pheromone /= 2;
			my_migrate_pheromone /=2;
			return SUCCESS;
		} else {
			data.item = (Data_t) malloc(sizeof(uint8_t) * 3);
			dbg(DBG_USR3, "BisnetM:OERP:Timer.fired:flood base pheromone\n");
			data.subject = SUBJECT_BASE_PHEROMONE_FLOOD;
			data.topic = 0;
			base_pheromone_count++;
			data.item[1] = 0;
			data.item[2] = base_pheromone_count;
			data.size = 3;
			my_base_pheromone = 0;
			dbg(DBG_USR3, "BisnetM:OERP:Timer.fired:done\n");
			return call L4.send(TOS_BCAST_ADDR, data);
		}
	}
}
