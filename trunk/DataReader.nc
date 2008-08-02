//$Id: DataReader.nc,v 1.2 2008-07-28 06:32:55 pruet Exp $

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
			
//This file is generated from IDL/Configuration. Do not edit manually
//Ancestors List:
//	Entity
interface DataReader {
	command  ReadCondition_t create_readcondition (SampleStateMask sample_states, ViewStateMask view_states, InstanceStateMask instance_states);
	command  QueryCondition_t create_querycondition (SampleStateMask sample_states, ViewStateMask view_states, InstanceStateMask instance_states, char * query_expression, StringSeq query_parameters);
	command  ReturnCode_t delete_readcondition (ReadCondition_t a_condition);
	command  ReturnCode_t delete_contained_entities ();
	command  ReturnCode_t set_qos (DataReaderQos qos);
	command  void get_qos (DataReaderQos qos);
	command  ReturnCode_t set_listener (DataReaderListener_t a_listener, StatusKindMask mask);
	command  DataReaderListener_t get_listener ();
	command  TopicDescription_t get_topicdescription ();
	command  Subscriber_t get_subscriber ();
	command  SampleRejectedStatus get_sample_rejected_status ();
	command  LivelinessChangedStatus get_liveliness_changed_status ();
	command  RequestedDeadlineMissedStatus get_requested_deadline_missed_status ();
	command  RequestedIncompatibleQosStatus get_requested_incompatible_qos_status ();
	command  SubscriptionMatchStatus get_subscription_match_status ();
	command  SampleLostStatus get_sample_lost_status ();
	command  ReturnCode_t wait_for_historical_data (Duration_t max_wait);
	command  ReturnCode_t get_matched_publications (InstanceHandleSeq publication_handles);
	command  ReturnCode_t get_matched_publication_data (PublicationBuiltinTopicData publication_data, InstanceHandle_t publication_handle);
	command ReturnCode_t read (Topic_t topic, Data *data);
	command void on_data_available (Topic_t topic, Data data);
	command DataReader_t create (Topic_t topic);
	//Inherited from Entity
	command  ReturnCode_t enable ();
	//Inherited from Entity
	command  StatusCondition_t get_statuscondition ();
	//Inherited from Entity
	command  StatusKindMask get_status_changes ();
}
