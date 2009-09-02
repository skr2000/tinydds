//$Id: DataWriter.nc,v 1.2 2008-07-28 06:32:55 pruet Exp $
// Ported to 2.0

/*Copyright (c) 2008, 2009 University of Massachusetts, Boston 
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
interface DataWriter {
	command  ReturnCode_t set_qos (DataWriterQos qos);
	command  void get_qos (DataWriterQos qos);
	command  ReturnCode_t set_listener (DataWriterListener_t a_listener, StatusKindMask mask);
	command  DataWriterListener_t get_listener ();
	command  Topic_t get_topic (DataWriter_t data_writer);
	command  Publisher_t get_publisher ();
	command  LivelinessLostStatus get_liveliness_lost_status ();
	command  OfferedDeadlineMissedStatus get_offered_deadline_missed_status ();
	//command  OfferedIncompatibleQosStatus get_offered_incompatible_qos_status ();
	command  PublicationMatchStatus get_publication_match_status ();
	command  void assert_liveliness ();
	//command  ReturnCode_t get_matched_subscriptions (InstanceHandleSeq subscription_handles);
	command  ReturnCode_t get_matched_subscription_data (SubscriptionBuiltinTopicData subscription_data, InstanceHandle_t subscription_handle);
	command DataWriter_t create (Topic_t topic);
	command ReturnCode_t write (DataWriter_t data_writer, Data data);
	event ReturnCode_t data_available (DataWriter_t data_writer, Data data);
	//Inherited from Entity
	command  ReturnCode_t enable ();
	//Inherited from Entity
	command  StatusCondition_t get_statuscondition ();
	//Inherited from Entity
	command  StatusKindMask get_status_changes ();
}
