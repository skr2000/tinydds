//$Id: DataWriterM.nc,v 1.3 2008-07-29 19:39:40 pruet Exp $

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
module DataWriterM {
	provides {
		 interface StdControl;
		 interface DataWriter;
	}
	uses {
		 interface Publisher;
	}
}
implementation {
	ReturnCode_t enabled;
	DataReader_t data_writer[MAX_MEMBER_SIZE];
	command result_t StdControl.init ()
	{
		int i;
		debug("DataWriterM:init");
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			data_writer[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		debug("DataWriterM:start");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		debug("DataWriterM:stop");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command ReturnCode_t DataWriter.set_qos (DataWriterQos qos)
	{
		debug("DataWriterM:set_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DataWriter.get_qos (DataWriterQos qos)
	{
		debug("DataWriterM:get_qos");
	}

	command ReturnCode_t DataWriter.set_listener (DataWriterListener_t a_listener, StatusKindMask mask)
	{
		debug("DataWriterM:set_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command DataWriterListener_t DataWriter.get_listener ()
	{
		debug("DataWriterM:get_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command Topic_t DataWriter.get_topic (DataWriter_t a_data_writer)
	{
		debug("DataWriterM:get_topic");
		return a_data_writer;
	}

	command Publisher_t DataWriter.get_publisher ()
	{
		debug("DataWriterM:get_publisher");
		return NOT_IMPLEMENTED_YET;
	}

	command LivelinessLostStatus DataWriter.get_liveliness_lost_status ()
	{
		LivelinessLostStatus s;
		debug("DataWriterM:get_liveliness_lost_status");
		return s;
	}

	command OfferedDeadlineMissedStatus DataWriter.get_offered_deadline_missed_status ()
	{
		OfferedDeadlineMissedStatus s;
		debug("DataWriterM:get_offered_deadline_missed_status");
		return s;
	}

	command OfferedIncompatibleQosStatus DataWriter.get_offered_incompatible_qos_status ()
	{
		OfferedIncompatibleQosStatus s;
		debug("DataWriterM:get_offered_incompatible_qos_status");
		return s;
	}

	command PublicationMatchStatus DataWriter.get_publication_match_status ()
	{
		PublicationMatchStatus s;
		debug("DataWriterM:get_publication_match_status");
		return s;
	}

	command void DataWriter.assert_liveliness ()
	{
		debug("DataWriterM:assert_liveliness");
	}

	command ReturnCode_t DataWriter.get_matched_subscriptions (InstanceHandleSeq subscription_handles)
	{
		debug("DataWriterM:get_matched_subscriptions");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DataWriter.get_matched_subscription_data (SubscriptionBuiltinTopicData subscription_data, InstanceHandle_t subscription_handle)
	{
		debug("DataWriterM:get_matched_subscription_data");
		return NOT_IMPLEMENTED_YET;
	}
	
	command DataWriter_t DataWriter.create (Topic_t topic)
	{
		debug("DataWriterM:create");
		if(data_writer[topic] == NOT_AVAILABLE) {
			data_writer[topic] = 1;
			return topic;
		}
		data_writer[topic]++;
		return topic;
	}
	
	command ReturnCode_t DataWriter.write (DataWriter_t _data_writer, Data data)
	{
		char buf[100];
		debug("DataWriterM:write");
		if(data_writer[_data_writer] == NOT_AVAILABLE) return NOT_AVAILABLE;
		data.topic = _data_writer;
		sprintf(buf, "DataWriterM:signal:data_available:%d", _data_writer);
		debug(buf);
		return signal DataWriter.data_available (_data_writer, data);
	}

	//Inherited from Entity
	command ReturnCode_t DataWriter.enable ()
	{
		debug("DataWriterM:enable");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t DataWriter.get_statuscondition ()
	{
		debug("DataWriterM:get_statuscondition");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask DataWriter.get_status_changes ()
	{
		debug("DataWriterM:get_status_changes");
		return NOT_IMPLEMENTED_YET;
	}
}
