//$Id: DataReaderM.nc,v 1.2 2008-07-28 06:32:55 pruet Exp $

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
module DataReaderM {
	provides {
		 interface StdControl;
		 interface DataReader;
	}
	uses {
		 interface Subscriber;
	}
}
implementation {
	DataReader_t data_reader[MAX_MEMBER_SIZE];
	ReturnCode_t enabled;
	Data	buffer[MAX_MEMBER_SIZE][MAX_BUFFER_SIZE];
	int8_t	buffer_pointer_start[MAX_MEMBER_SIZE];
	int8_t	buffer_pointer_stop[MAX_MEMBER_SIZE];
	command result_t StdControl.init ()
	{
		int i;
		debug("DataReaderM:init");
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			data_reader[i] = NOT_AVAILABLE;
			//FIXME: Might need to be moved to stdcontrol.start
			buffer_pointer_start[i] = buffer_pointer_stop[i] = 0;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		debug("DataReaderM:start");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		debug("DataReaderM:stop");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command ReadCondition_t DataReader.create_readcondition (SampleStateMask sample_states, ViewStateMask view_states, InstanceStateMask instance_states)
	{
		debug("DataReaderM:create_readcondition");
		return NOT_IMPLEMENTED_YET;
	}

	command QueryCondition_t DataReader.create_querycondition (SampleStateMask sample_states, ViewStateMask view_states, InstanceStateMask instance_states, char * query_expression, StringSeq query_parameters)
	{
		debug("DataReaderM:create_querycondition");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataReader.delete_readcondition (ReadCondition_t a_condition)
	{
		debug("DataReaderM:delete_readcondition");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataReader.delete_contained_entities ()
	{
		debug("DataReaderM:delete_contained_entities");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataReader.set_qos (DataReaderQos qos)
	{
		debug("DataReaderM:set_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DataReader.get_qos (DataReaderQos qos)
	{
		debug("DataReaderM:get_qos");
	}

	command ReturnCode_t DataReader.set_listener (DataReaderListener_t a_listener, StatusKindMask mask)
	{
		debug("DataReaderM:set_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command DataReaderListener_t DataReader.get_listener ()
	{
		debug("DataReaderM:get_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command TopicDescription_t DataReader.get_topicdescription ()
	{
		debug("DataReaderM:get_topicdescription");
		return NOT_IMPLEMENTED_YET;
	}

	command Subscriber_t DataReader.get_subscriber ()
	{
		debug("DataReaderM:get_subscriber");
		return NOT_IMPLEMENTED_YET;
	}

	command SampleRejectedStatus DataReader.get_sample_rejected_status ()
	{
		SampleRejectedStatus s;
		debug("DataReaderM:get_sample_rejected_status");
		return s;
	}
	
	command LivelinessChangedStatus DataReader.get_liveliness_changed_status ()
	{
		LivelinessChangedStatus s;
		debug("DataReaderM:get_liveliness_changed_status");
		return s;
	}

	command RequestedDeadlineMissedStatus DataReader.get_requested_deadline_missed_status ()
	{
		RequestedDeadlineMissedStatus s;
		debug("DataReaderM:get_requested_deadline_missed_status");
		return s;
	}

	command RequestedIncompatibleQosStatus DataReader.get_requested_incompatible_qos_status ()
	{
		RequestedIncompatibleQosStatus s;
		debug("DataReaderM:get_requested_incompatible_qos_status");
		return s;
	}

	command SubscriptionMatchStatus DataReader.get_subscription_match_status ()
	{
		SubscriptionMatchStatus s;
		debug("DataReaderM:get_subscription_match_status");
		return s;
	}

	command SampleLostStatus DataReader.get_sample_lost_status ()
	{
		SampleLostStatus s;
		debug("DataReaderM:get_sample_lost_status");
		return s;
	}

	command ReturnCode_t DataReader.wait_for_historical_data (Duration_t max_wait)
	{
		debug("DataReaderM:wait_for_historical_data");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataReader.get_matched_publications (InstanceHandleSeq publication_handles)
	{
		debug("DataReaderM:get_matched_publications");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataReader.get_matched_publication_data (PublicationBuiltinTopicData publication_data, InstanceHandle_t publication_handle)
	{
		debug("DataReaderM:get_matched_publication_data");
		return NOT_IMPLEMENTED_YET;
	}

	command DataReader_t DataReader.create (Topic_t topic) 
	{
		debug("DataReaderM:create");
		if(data_reader[topic] == NOT_AVAILABLE) {
			data_reader[topic] = 1;
			return topic;
		}
		data_reader[topic]++;
		return NOT_AVAILABLE;
	}
	command void DataReader.on_data_available (Topic_t topic, Data data)
	{
		//OK, it's ring buffer here;
		dbg(DBG_USR2, "DataReaderM:on_data_available:topic %d\n", topic);
		buffer_pointer_stop[topic]++;
		if(buffer_pointer_stop[topic] >= MAX_BUFFER_SIZE) {
			buffer_pointer_stop[topic] = 0;
		}
		if(buffer_pointer_stop[topic] == buffer_pointer_start[topic]) {
			dbg(DBG_USR2, "DataReaderM:on_data_available:error:buffer_overflowed\n");
			buffer_pointer_stop[topic]--;
			if(buffer_pointer_stop[topic] < 0) {
				buffer_pointer_stop[topic] = MAX_BUFFER_SIZE - 1;
			}
			return;
		}
		buffer[topic][buffer_pointer_stop[topic]] = data;
		dbg(DBG_USR2, "DataReaderM:on_data_available:done\n");
	}

	command ReturnCode_t DataReader.read(Topic_t topic, Data *data)
	{
		debug("DataReaderM:read");
		if(buffer_pointer_stop[topic] == buffer_pointer_start[topic]) {
			debug("DatareaderM:read:error:no_data");
			return FAIL;
		}
		buffer_pointer_start[topic]++;
		if(buffer_pointer_start[topic] >= MAX_BUFFER_SIZE) {
			buffer_pointer_start[topic] = 0;
		}
		*data = buffer[topic][buffer_pointer_start[topic]];
		return SUCCESS;
	}
	
	//Inherited from Entity
	command ReturnCode_t DataReader.enable ()
	{
		debug("DataReaderM:enable");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t DataReader.get_statuscondition ()
	{
		debug("DataReaderM:get_statuscondition");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask DataReader.get_status_changes ()
	{
		debug("DataReaderM:get_status_changes");
		return NOT_IMPLEMENTED_YET;
	}
}
