//$Id: DomainParticipant.nc,v 1.1.1.1 2008-06-11 20:33:09 pruet Exp $
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
			
//This file is generated from IDL/Configuration. Do not edit manually
//Ancestors List:
//	Entity
interface DomainParticipant {
	command  Publisher_t create_publisher (PublisherQos qos, PublisherListener_t a_listener);
	command  ReturnCode_t delete_publisher (Publisher_t p);
	command  Subscriber_t create_subscriber (SubscriberQos qos, SubscriberListener_t a_listener);
	command  ReturnCode_t delete_subscriber (Subscriber_t s);
	command  Subscriber_t get_builtin_subscriber ();
	command  Topic_t create_topic (char * topic_name, char * type_name, TopicQos qos, TopicListener_t a_listener);
	command  ReturnCode_t delete_topic (Topic_t a_topic);
	command  Topic_t find_topic (char * topic_name, Duration_t timeout);
	command  TopicDescription_t lookup_topicdescription (char * name);
	//command  ContentFilteredTopic_t create_contentfilteredtopic (char * name, Topic_t related_topic, char * filter_expression, StringSeq filter_parameters);
	command  ReturnCode_t delete_contentfilteredtopic (ContentFilteredTopic_t a_contentfilteredtopic);
	//command  MultiTopic_t create_multitopic (char * name, char * type_name, char * subscription_expression, StringSeq expression_parameters);
	command  ReturnCode_t delete_multitopic (MultiTopic_t a_multitopic);
	command  ReturnCode_t delete_contained_entities ();
	//command  ReturnCode_t set_qos (DomainParticipantQos qos);
	//command  void get_qos (DomainParticipantQos qos);
	command  ReturnCode_t set_listener (DomainParticipantListener_t a_listener, StatusKindMask mask);
	command  DomainParticipantListener_t get_listener ();
	command  ReturnCode_t ignore_participant (InstanceHandle_t handle);
	command  ReturnCode_t ignore_topic (InstanceHandle_t handle);
	command  ReturnCode_t ignore_publication (InstanceHandle_t handle);
	command  ReturnCode_t ignore_subscription (InstanceHandle_t handle);
	command  DomainId_t get_domain_id ();
	command  void assert_liveliness ();
	command  ReturnCode_t set_default_publisher_qos (PublisherQos qos);
	command  void get_default_publisher_qos (PublisherQos qos);
	command  ReturnCode_t set_default_subscriber_qos (SubscriberQos qos);
	command  void get_default_subscriber_qos (SubscriberQos qos);
	command  ReturnCode_t set_default_topic_qos (TopicQos qos);
	command  void get_default_topic_qos (TopicQos qos);
	//Inherited from Entity
	command  ReturnCode_t enable ();
	//Inherited from Entity
	command  StatusCondition_t get_statuscondition ();
	//Inherited from Entity
	command  StatusKindMask get_status_changes ();
}
