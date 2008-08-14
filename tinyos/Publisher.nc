//$Id: Publisher.nc,v 1.1.1.1 2008-06-11 20:33:09 pruet Exp $

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
interface Publisher {
	command  DataWriter_t create_datawriter (Topic_t a_topic, DataWriterQos qos, DataWriterListener_t a_listener);
	command  ReturnCode_t delete_datawriter (DataWriter_t a_datawriter);
	command  DataWriter_t lookup_datawriter (char * topic_name);
	command  ReturnCode_t delete_contained_entities ();
	command  ReturnCode_t set_qos (PublisherQos qos);
	command  void get_qos (PublisherQos qos);
	command  ReturnCode_t set_listener (PublisherListener_t a_listener, StatusKindMask mask);
	command  PublisherListener_t get_listener ();
	command  ReturnCode_t suspend_publications ();
	command  ReturnCode_t resume_publications ();
	command  ReturnCode_t begin_coherent_changes ();
	command  ReturnCode_t end_coherent_changes ();
	command  DomainParticipant_t get_participant ();
	command  ReturnCode_t set_default_datawriter_qos (DataWriterQos qos);
	command  void get_default_datawriter_qos (DataWriterQos qos);
	command  ReturnCode_t copy_from_topic_qos (DataWriterQos a_datawriter_qos, TopicQos a_topic_qos);
	//Inherited from Entity
	command  ReturnCode_t enable ();
	//Inherited from Entity
	command  StatusCondition_t get_statuscondition ();
	//Inherited from Entity
	command  StatusKindMask get_status_changes ();
}
