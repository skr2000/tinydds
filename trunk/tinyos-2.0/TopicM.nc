//$Id: TopicM.nc,v 1.2 2008-07-28 06:32:55 pruet Exp $
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
//Ancestors List:
//	Entity
//	TopicDescription
module TopicM {
	provides {
		 interface Topic;
	}
	uses {
		interface Boot;
	}
}
implementation {
	char topic_list[MAX_MEMBER_SIZE][MAX_TOPIC_LENGTH];
	ReturnCode_t enabled;
	event void Boot.booted ()
	{
		int i;
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			topic_list[i][0] = 0;
		}
		enabled = RETCODE_OK;
	}


	command InconsistentTopicStatus Topic.get_inconsistent_topic_status ()
	{
		InconsistentTopicStatus s;
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		return s;
	}

	
	command Topic_t Topic.create (char* topic_name)
	{
		int i;
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		for(i = 1; i != MAX_MEMBER_SIZE; i++) {
			if(strcmp(topic_name, topic_list[i]) == 0) {
				return i;
			}
		}
		for(i = 1; i != MAX_MEMBER_SIZE; i++) {
			if(topic_list[i][0] == 0) {
				strcpy(topic_list[i], topic_name);
				return i;
			}
		}
		return NOT_AVAILABLE;
	}
	
	
	//Inherited from Entity
	command ReturnCode_t Topic.enable ()
	{
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t Topic.get_statuscondition ()
	{
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask Topic.get_status_changes ()
	{
		dbg("API", "TP:%s:called\n", __FUNCTION__);
		return NOT_IMPLEMENTED_YET;
	}
}
