//$Id: PublisherM.nc,v 1.4 2008-08-11 19:49:34 pruet Exp $

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
module PublisherM {
	provides {
		interface StdControl;
		interface Publisher;
	}
	uses {
		interface TinyGIOP;
		interface DataWriter;
	}
}
implementation {
	ReturnCode_t enabled;
	DataReaderListener_t data_writer_listener[MAX_MEMBER_SIZE];
	
	command result_t StdControl.init ()
	{
		int i;
		dbg(DBG_USR2,"PublisherM:init\n");
		enabled = RETCODE_NOT_ENABLED;
		for(i = 0; i != MAX_MEMBER_SIZE; i++) {
			data_writer_listener[i] = NOT_AVAILABLE;
		}
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		dbg(DBG_USR2,"PublisherM:start\n");
		enabled = RETCODE_OK;
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR2,"PublisherM:stop\n");
		enabled = RETCODE_NOT_ENABLED;
		return SUCCESS;
	}

	command DataWriter_t Publisher.create_datawriter (Topic_t a_topic, DataWriterQos qos, DataWriterListener_t a_listener)
	{
		DataWriter_t w;
		dbg(DBG_USR2,"PublisherM:create_datawriter %d\n", a_topic);
		w = call DataWriter.create(a_topic);
		if(w == NOT_AVAILABLE) w = a_topic;
		data_writer_listener[a_topic] = a_listener;
		return w;
	}

	command ReturnCode_t Publisher.delete_datawriter (DataWriter_t a_datawriter)
	{
		dbg(DBG_USR2,"PublisherM:delete_datawriter\n");
		return NOT_IMPLEMENTED_YET;
	}

	command DataWriter_t Publisher.lookup_datawriter (char * topic_name)
	{
		dbg(DBG_USR2,"PublisherM:lookup_datawriter\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.delete_contained_entities ()
	{
		dbg(DBG_USR2,"PublisherM:delete_contained_entities\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.set_qos (PublisherQos qos)
	{
		dbg(DBG_USR2,"PublisherM:set_qos\n");
		return NOT_IMPLEMENTED_YET;
	}

	command void Publisher.get_qos (PublisherQos qos)
	{
		dbg(DBG_USR2,"PublisherM:get_qos\n");
	}

	command ReturnCode_t Publisher.set_listener (PublisherListener_t a_listener, StatusKindMask mask)
	{
		dbg(DBG_USR2,"PublisherM:set_listener\n");
		return NOT_IMPLEMENTED_YET;
	}

	command PublisherListener_t Publisher.get_listener ()
	{
		dbg(DBG_USR2,"PublisherM:get_listener\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.suspend_publications ()
	{
		dbg(DBG_USR2,"PublisherM:suspend_publications\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.resume_publications ()
	{
		dbg(DBG_USR2,"PublisherM:resume_publications\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.begin_coherent_changes ()
	{
		dbg(DBG_USR2,"PublisherM:begin_coherent_changes\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.end_coherent_changes ()
	{
		dbg(DBG_USR2,"PublisherM:end_coherent_changes\n");
		return NOT_IMPLEMENTED_YET;
	}

	command DomainParticipant_t Publisher.get_participant ()
	{
		dbg(DBG_USR2,"PublisherM:get_participant\n");
		return NOT_IMPLEMENTED_YET;
	}

	command ReturnCode_t Publisher.set_default_datawriter_qos (DataWriterQos qos)
	{
		dbg(DBG_USR2,"PublisherM:set_default_datawriter_qos\n");
		return NOT_IMPLEMENTED_YET;
	}

	command void Publisher.get_default_datawriter_qos (DataWriterQos qos)
	{
		dbg(DBG_USR2,"PublisherM:get_default_datawriter_qos\n");
	}

	command ReturnCode_t Publisher.copy_from_topic_qos (DataWriterQos a_datawriter_qos, TopicQos a_topic_qos)
	{
		dbg(DBG_USR2,"PublisherM:copy_from_topic_qos\n");
		return NOT_IMPLEMENTED_YET;
	}

	event ReturnCode_t DataWriter.data_available (DataWriter_t a_data_writer, Data data)  
	{
		return call TinyGIOP.send(call DataWriter.get_topic(a_data_writer), data);
	}
	
	
	event ReturnCode_t TinyGIOP.data_available (Topic_t topic, Data data)
	{
		return NOT_IMPLEMENTED_YET;
	}
	
	//Inherited from Entity
	command ReturnCode_t Publisher.enable ()
	{
		dbg(DBG_USR2,"PublisherM:enable\n");
		enabled = RETCODE_OK;
		return enabled;
	}
	//Inherited from Entity
	command StatusCondition_t Publisher.get_statuscondition ()
	{
		dbg(DBG_USR2,"PublisherM:get_statuscondition\n");
		return NOT_IMPLEMENTED_YET;
	}
	//Inherited from Entity
	command StatusKindMask Publisher.get_status_changes ()
	{
		dbg(DBG_USR2,"PublisherM:get_status_changes\n");
		return NOT_IMPLEMENTED_YET;
	}
}
