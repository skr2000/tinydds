//$Id: TopicM.nc,v 1.4 2008-08-07 21:27:53 pruet Exp $

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
//Ancestors List:
//	Entity
//	TopicDescription
module TopicM {
	provides {
		 interface StdControl;
		 interface Topic;
	}
}
implementation {
	char* topic_list[MAX_TOPIC_NUM];
	ReturnCode_t enabled;
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2, "TopicM:init:#topic=%d\n", MAX_TOPIC_NUM);
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_TOPIC_NUM; i++) {
			topic_list[i] = 0;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2, "TopicM:start\n");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2, "TopicM:stop\n");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command InconsistentTopicStatus Topic.get_inconsistent_topic_status ()
	{
		InconsistentTopicStatus s;
		dbg(DBG_USR2, "TopicM:get_inconsistent_topic_status\n");
		return s;
	}

	
	command Topic_t Topic.create (uint8_t* topic_name)
	{
		int i;
		int l;
		uint32_t h;
		uint32_t g;
	
		//PJW hash here
		l = strlen(topic_name);
		h = 0;
		for(i = 0; i != l; i++) {
			h = (h << 4) + topic_name[i];
			g = h & 0xf0000000;
			if (g != 0) {
				h = h ^ (g >> 24);
				h = h ^ g;
			}
		}
		h = h % MAX_TOPIC_NUM;
		dbg(DBG_USR2, "TopicM:create:topic=%d\n", h);
		if(topic_list[h] == 0) {
			topic_list[h] = (uint8_t *)malloc(sizeof(uint8_t) * l);
			strcpy(topic_list[h], topic_name);
			return h;
		} else if(strcmp(topic_name, topic_list[h]) == 0) {
			return i;
		}
		dbg(DBG_USR2, "TopicM:create:crashed\n");
		return NOT_AVAILABLE;
	}
	
	
	//Inherited from Entity
	command ReturnCode_t Topic.enable ()
	{
		dbg(DBG_USR2, "TopicM:enable\n");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t Topic.get_statuscondition ()
	{
		dbg(DBG_USR2, "TopicM:get_statuscondition\n");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask Topic.get_status_changes ()
	{
		dbg(DBG_USR2, "TopicM:get_status_changes\n");
		return NOT_IMPLEMENTED_YET;
	}
}
