//$Id: ApplicationM.nc,v 1.7 2008-08-11 19:49:34 pruet Exp $

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
includes TinyCDR;
includes Apps_utils;
module ApplicationM {
	provides {
		 interface StdControl;
		 interface Application;
	}
	uses {
		 interface Leds;
		 interface Timer;
		 interface Time;
		 interface DomainParticipant;
		 interface DataWriter;
		 interface DataReader;
		 interface Publisher;
		 interface Subscriber;
		 interface SubscriberListener;
		 interface Topic;
		 interface ContentFilteredTopic;
		 interface QosPolicy;
	}
}
implementation {
	Subscriber_t subscriber = NIL;
	Publisher_t publisher = NIL;
	Topic_t ts_topic = NIL;
	DataReader_t data_reader = NIL;
	DataWriter_t data_writer = NIL;
	SubscriberListener_t listener = NIL;
	int id = 0;
	int mod = 4;
	int duty_cycle = 10000;
	
	command result_t StdControl.init ()
	{
		dbg(DBG_USR1,"ApplicationM:init\n");
		return call Leds.init();
	}

	command result_t StdControl.start ()
	{
		//SubscriberQos s_qos;
		PublisherQos p_qos;
		TopicQos t_qos;
		//DataReaderQos dr_qos;
		DataWriterQos dw_qos;
		dbg(DBG_USR1,"ApplicationM:start\n");
		if(TOS_LOCAL_ADDRESS == 0) {
			//subscriber = call DomainParticipant.create_subscriber(s_qos, NIL);
		} else if(TOS_LOCAL_ADDRESS % mod== 0) {
			publisher = call DomainParticipant.create_publisher(p_qos, NIL);
		}
		ts_topic = call DomainParticipant.create_topic("TempSensor", "", t_qos, NIL);
		if(TOS_LOCAL_ADDRESS == 0) {
			//listener = call SubscriberListener.create(ts_topic);
			//call Subscriber.set_listener(listener, NIL);
			//data_reader = call Subscriber.create_datareader(ts_topic, dr_qos, listener);
		} else if(TOS_LOCAL_ADDRESS % mod == 0) {
			data_writer = call Publisher.create_datawriter (ts_topic, dw_qos, NIL);
		}
		if(TOS_LOCAL_ADDRESS != 0  && TOS_LOCAL_ADDRESS % mod == 0) {
			dbg(DBG_USR1,"ApplicationM:timer:start\n");
			call Timer.start(TIMER_REPEAT, duty_cycle);
		}
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		dbg(DBG_USR1,"ApplicationM:stop\n");
		return SUCCESS;
	}

	event result_t Timer.fired () 
	{
		AppData_t data;
		dbg(DBG_USR1,"ApplicationM:Timer:fired \n");
		call Leds.redOn();

		if(data_writer != NIL) {
			data.data1 = 100;
			dbg(DBG_USR1,"ApplicationM:Timer:publish data %d %d\n", id, data.data1);
			data.data2 = 100;
			data.time = call Time.getLow32();
			call DataWriter.write(data_writer, serialize(data), sizeof(AppData_t));
			id++;
		}
		return SUCCESS;
	}

	
	event ReturnCode_t DataWriter.data_available (DataWriter_t a_data_writer, Data data)  
	{
		dbg(DBG_USR1,"ApplicationM:DataWriter:data_available \n");
		return RETCODE_OK;
	}
	
	event ReturnCode_t SubscriberListener.data_available (Topic_t topic)
	{
		Data data;
		AppData_t app_data;
		uint32_t t = call Time.getLow32();
		dbg(DBG_USR1,"ApplicationM:subscriberlistener:data_available\n");
		call Leds.redToggle();
		if( call DataReader.read(topic, &data) == FAIL) {
			dbg(DBG_USR1,"ApplicationM:subscriberlistener:data_available:read_fail\n");
			return RETCODE_ERROR;
		}
	
		//FIXME: need real clock sync
		app_data = deserialize(data.item);
		if(t > app_data.time) {
			t = t - app_data.time;
		} else {
			t = 0;
		}
		dbg(DBG_USR1, "Application:subscriberlistener:data_available:%d:%d:%d\n", data.orig, t, app_data.data2);
		return RETCODE_OK;
	}

}
