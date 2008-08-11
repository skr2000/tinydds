//$Id: SubscriberM.nc,v 1.4 2008-08-11 19:49:34 pruet Exp $

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
module SubscriberM {
	provides {
		interface StdControl;
		interface Subscriber;
	}
	uses {
		interface TinyGIOP;
		interface DataReader;
		interface SubscriberListener;
	}
}
implementation {
	ReturnCode_t enabled;
	SubscriberListener_t subscriber_listener[MAX_TOPIC_NUM];
	DataReaderListener_t data_reader_listener[MAX_TOPIC_NUM];
	
	
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2,"SubscriberM:init\n");
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_TOPIC_NUM; i++) {
			subscriber_listener[i] = NOT_AVAILABLE;
			data_reader_listener[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2,"SubscriberM:start\n");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2,"SubscriberM:stop\n");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command DataReader_t Subscriber.create_datareader (TopicDescription_t a_topic, DataReaderQos qos, DataReaderListener_t a_listener)
	{
		DataReader_t r;
		dbg(DBG_USR2,"SubscriberM:create_datareader\n");
		r = call DataReader.create(a_topic);
		if(r == NOT_AVAILABLE) r = a_topic;
		data_reader_listener[a_topic] = a_listener;
		call TinyGIOP.subscribe(a_topic);
		return r;
	}

	command ReturnCode_t Subscriber.delete_datareader (DataReader_t a_datareader)
	{
		dbg(DBG_USR2,"SubscriberM:delete_datareader\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Subscriber.delete_contained_entities ()
	{
		dbg(DBG_USR2,"SubscriberM:delete_contained_entities\n");
		return NOT_IMPLEMENTED_YET;
	}

	command DataReader_t Subscriber.lookup_datareader (char * topic_name)
	{
		DataReader_t r;
		dbg(DBG_USR2,"SubscriberM:lookup_datareader\n");
		return r;
	}

	command ReturnCode_t Subscriber.get_datareaders (DataReaderSeq readers, SampleStateMask sample_states, ViewStateMask view_states, InstanceStateMask instance_states)
	{
		dbg(DBG_USR2,"SubscriberM:get_datareaders\n");
		return NOT_IMPLEMENTED_YET;
	}

	command void Subscriber.notify_datareaders ()
	{
	}

	command ReturnCode_t Subscriber.set_qos (SubscriberQos qos)
	{
		dbg(DBG_USR2,"SubscriberM:set_qos\n");
		return NOT_IMPLEMENTED_YET;
	}

	command void Subscriber.get_qos (SubscriberQos qos)
	{
	}

	command ReturnCode_t Subscriber.set_listener (SubscriberListener_t a_listener, StatusKindMask mask)
	{
		dbg(DBG_USR2,"SubscriberM:set_listener\n");
		subscriber_listener[a_listener] = RETCODE_OK;
		return RETCODE_OK;
	}

	command SubscriberListener_t Subscriber.get_listener ()
	{
		SubscriberListener_t l;
		dbg(DBG_USR2,"SubscriberM:get_listener\n");
		return l;
	}

	command ReturnCode_t Subscriber.begin_access ()
	{
		dbg(DBG_USR2,"SubscriberM:begin_access\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Subscriber.end_access ()
	{
		dbg(DBG_USR2,"SubscriberM:end_access\n");
		return NOT_IMPLEMENTED_YET;
	}

	command DomainParticipant_t Subscriber.get_participant ()
	{
		DomainParticipant_t p;
		dbg(DBG_USR2,"SubscriberM:get_listener\n");
		return p;
	}

	command ReturnCode_t Subscriber.set_default_datareader_qos (DataReaderQos qos)
	{
		dbg(DBG_USR2,"SubscriberM:end_access\n");
		return NOT_IMPLEMENTED_YET;
	}

	command void Subscriber.get_default_datareader_qos (DataReaderQos qos)
	{
		dbg(DBG_USR2,"SubscriberM:get_default_datareader_qos\n");
	}
	
	event ReturnCode_t TinyGIOP.data_available (Topic_t topic, Data data)
	{
		//FIXME: I'm not sure about this, we suppose to pass Subscriber_t, but because
		//of limitation in TinyOS, we might need to pass Topic_t instead
		dbg(DBG_USR2,"SubscriberM:data_available %d\n", subscriber_listener[topic]);
		call DataReader.on_data_available(topic, data);
		if(subscriber_listener[topic] == RETCODE_OK) {
			dbg(DBG_USR2,"SubscriberM:SubscriberListener.on_data_readers\n");
			call SubscriberListener.on_data_on_readers(topic);
		}
		if(data_reader_listener[topic] == RETCODE_OK) {
			//TODO: This is disabled for now, no time to implement both way
			//call DataReaderListener.on_data_available(data_reader_listener[topic]);
		}
		return SUCCESS;
	}

	command ReturnCode_t Subscriber.copy_from_topic_qos (DataReaderQos a_datareader_qos, TopicQos a_topic_qos)
	{
		dbg(DBG_USR2,"SubscriberM:copy_from_topic_qos\n");
		return NOT_IMPLEMENTED_YET;
	}

	//Inherited from Entity
	command ReturnCode_t Subscriber.enable ()
	{
		dbg(DBG_USR2,"SubscriberM:enable\n");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t Subscriber.get_statuscondition ()
	{
		dbg(DBG_USR2,"SubscriberM:get_statuscondition\n");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask Subscriber.get_status_changes ()
	{
		dbg(DBG_USR2,"SubscriberM:get_status_changes\n");
		return NOT_IMPLEMENTED_YET;
	}

	event ReturnCode_t SubscriberListener.data_available (Topic_t topic)
	{
		return SUCCESS;
	}
}
