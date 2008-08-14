//$Id: SubscriberListenerM.nc,v 1.4 2008-08-11 19:49:34 pruet Exp $

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
//	DataReaderListener
module SubscriberListenerM {
	provides {
		interface StdControl;
		interface SubscriberListener;
	}
	uses {
		interface DataReader;
		interface DomainParticipant;
	}
}
implementation {
	ReturnCode_t enabled;
	SubscriberListener_t subscriber_listener_list[MAX_MEMBER_SIZE];
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2,"SubscriberListenerM:init\n");
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			subscriber_listener_list[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2,"SubscriberListenerM:start\n");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2,"SubscriberListenerM:stop\n");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command void SubscriberListener.on_data_on_readers (Subscriber_t subs)
	{
		dbg(DBG_USR2,"SubscriberListenerM:on_data_on_readers\n");
		signal SubscriberListener.data_available(subs);
	}

	command ReturnCode_t SubscriberListener.read(Topic_t topic, Data *data)
	{
		dbg(DBG_USR2,"SubscriberListenerM:read\n");
		return call DataReader.read(topic, data);
	}
	
	command SubscriberListener_t SubscriberListener.create(Topic_t topic)
	{
		if(subscriber_listener_list[topic] == NOT_AVAILABLE) {
			subscriber_listener_list[topic] = 1;
			return topic;
		}
		return NOT_AVAILABLE;
	}
}
