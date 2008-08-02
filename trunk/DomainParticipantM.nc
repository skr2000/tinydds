//$Id: DomainParticipantM.nc,v 1.1.1.1 2008-06-11 20:33:09 pruet Exp $

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
module DomainParticipantM {
	provides {
		interface StdControl;
		interface DomainParticipant;
	}
	uses {
		interface Topic;
	}
}
implementation {
	Subscriber_t subscriber_list[MAX_MEMBER_SIZE];
	Publisher_t publisher_list[MAX_MEMBER_SIZE];
	ReturnCode_t enabled;
	
	command result_t StdControl.init ()
	{
		int i;
		debug("DomainParticipantM:init");
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			subscriber_list[i] = NOT_AVAILABLE;
			publisher_list[i] = 0;
		}
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		debug("DomainParticipantM:start");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		debug("DomainParticipantM:stop");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command Publisher_t DomainParticipant.create_publisher (PublisherQos qos, PublisherListener_t a_listener)
	{
		int i;
		debug("DomainParticipantM:create_publisher");
		if(a_listener == NIL) {
			for(i = 0; i != MAX_MEMBER_SIZE; i++) {
				if(publisher_list[i] == NOT_AVAILABLE) {
					publisher_list[i] = 1;
					return i;
				}
			}
		} else {
			if(publisher_list[a_listener] != NOT_AVAILABLE) {
				return NOT_AVAILABLE;
			}
			publisher_list[a_listener] = 1;
			return a_listener;
		}
		return NOT_AVAILABLE;
	}

	command ReturnCode_t DomainParticipant.delete_publisher (Publisher_t p)
	{
		debug("DomainParticipantM:delete_publisher");
		return NOT_IMPLEMENTED_YET;
	}

	command Subscriber_t DomainParticipant.create_subscriber (SubscriberQos qos, SubscriberListener_t a_listener)
	{
		int i;
		debug("DomainParticipantM:create_subscriber");
		if(a_listener == NIL) {
			for(i = 0; i != MAX_MEMBER_SIZE; i++) {
				if(subscriber_list[i] == NOT_AVAILABLE) {
					subscriber_list[i] = 1;
					return i;
				}
			}
		} else {
			if(subscriber_list[a_listener] != NOT_AVAILABLE) {
				return NOT_AVAILABLE;
			}
			subscriber_list[a_listener] = 1;
			return a_listener;
			
		}
		return NOT_AVAILABLE;
	}

	command ReturnCode_t DomainParticipant.delete_subscriber (Subscriber_t s)
	{
		debug("DomainParticipantM:delete_subscriber");
		return NOT_IMPLEMENTED_YET;
	}

	command Subscriber_t DomainParticipant.get_builtin_subscriber ()
	{
		debug("DomainParticipantM:get_builtin_subscriber");
		return NOT_IMPLEMENTED_YET;
	}

	command Topic_t DomainParticipant.create_topic (char * topic_name, char * type_name, TopicQos qos, TopicListener_t a_listener)
	{
		debug("DomainParticipantM:create_topic");
		return call Topic.create(topic_name);
	}

	command ReturnCode_t DomainParticipant.delete_topic (Topic_t a_topic)
	{
		debug("DomainParticipantM:delete_topic");
		return NOT_IMPLEMENTED_YET;
	}

	command Topic_t DomainParticipant.find_topic (char * topic_name, Duration_t timeout)
	{
		debug("DomainParticipantM:find_topic");
		return NOT_IMPLEMENTED_YET;
	}

	command TopicDescription_t DomainParticipant.lookup_topicdescription (char * name)
	{
		debug("DomainParticipantM:lookup_topicdescription");
		return NOT_IMPLEMENTED_YET;
	}

	command ContentFilteredTopic_t DomainParticipant.create_contentfilteredtopic (char * name, Topic_t related_topic, char * filter_expression, StringSeq filter_parameters)
	{
		debug("DomainParticipantM:create_contentfilteredtopic");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.delete_contentfilteredtopic (ContentFilteredTopic_t a_contentfilteredtopic)
	{
		debug("DomainParticipantM:delete_contentfilteredtopic");
		return NOT_IMPLEMENTED_YET;
	}

	command MultiTopic_t DomainParticipant.create_multitopic (char * name, char * type_name, char * subscription_expression, StringSeq expression_parameters)
	{
		debug("DomainParticipantM:create_contentfilteredtopic");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.delete_multitopic (MultiTopic_t a_multitopic)
	{
		debug("DomainParticipantM:delete_multitopic");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.delete_contained_entities ()
	{
		debug("DomainParticipantM:delete_contained_entities");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.set_qos (DomainParticipantQos qos)
	{
		debug("DomainParticipantM:set_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DomainParticipant.get_qos (DomainParticipantQos qos)
	{
		debug("DomainParticipantM:get_qos");
	}

	command ReturnCode_t DomainParticipant.set_listener (DomainParticipantListener_t a_listener, StatusKindMask mask)
	{
		debug("DomainParticipantM:set_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command DomainParticipantListener_t DomainParticipant.get_listener ()
	{
		debug("DomainParticipantM:get_listener");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.ignore_participant (InstanceHandle_t handle)
	{
		debug("DomainParticipantM:ignore_participant");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.ignore_topic (InstanceHandle_t handle)
	{
		debug("DomainParticipantM:ignore_topic");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.ignore_publication (InstanceHandle_t handle)
	{
		debug("DomainParticipantM:ignore_publication");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t DomainParticipant.ignore_subscription (InstanceHandle_t handle)
	{
		debug("DomainParticipantM:ignore_subscription");
		return NOT_IMPLEMENTED_YET;
	}

	command DomainId_t DomainParticipant.get_domain_id ()
	{
		debug("DomainParticipantM:get_domain_id");
		return NOT_IMPLEMENTED_YET;
	}

	command void DomainParticipant.assert_liveliness ()
	{
		debug("DomainParticipantM:assert_liveliness");
	}

	command ReturnCode_t DomainParticipant.set_default_publisher_qos (PublisherQos qos)
	{
		debug("DomainParticipantM:set_default_publisher_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DomainParticipant.get_default_publisher_qos (PublisherQos qos)
	{
		debug("DomainParticipantM:get_default_publisher_qos");
	}

	command ReturnCode_t DomainParticipant.set_default_subscriber_qos (SubscriberQos qos)
	{
		debug("DomainParticipantM:set_default_subscriber_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DomainParticipant.get_default_subscriber_qos (SubscriberQos qos)
	{
		debug("DomainParticipantM:get_default_subscriber_qos");
	}

	command ReturnCode_t DomainParticipant.set_default_topic_qos (TopicQos qos)
	{
		debug("DomainParticipantM:set_default_topic_qos");
		return NOT_IMPLEMENTED_YET;
	}

	command void DomainParticipant.get_default_topic_qos (TopicQos qos)
	{
		debug("DomainParticipantM:get_default_topic_qos");
	}

	//Inherited from Entity
	command ReturnCode_t DomainParticipant.enable ()
	{
		debug("DomainParticipantM:enable");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t DomainParticipant.get_statuscondition ()
	{
		debug("DomainParticipantM:get_statuscondition");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask DomainParticipant.get_status_changes ()
	{
		debug("DomainParticipantM:get_status_changes");
		return NOT_IMPLEMENTED_YET;
	}
}
