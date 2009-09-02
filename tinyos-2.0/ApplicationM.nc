//$Id: ApplicationM.nc,v 1.2 2008-07-28 06:32:55 pruet Exp $
// ported to 2.0
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

module ApplicationM {
	provides {
		 interface Application;
	}
	uses {
		 interface Boot;
		 interface Leds;
		 interface Timer<TMilli> as Timer0;
		 interface LocalTime<TMilli>;
		 interface DomainParticipant;
		 interface DataWriter;
		 interface DataReader;
		 interface Publisher;
		 interface Subscriber;
		 interface SubscriberListener;
		 interface Topic;
	}
}
implementation {
	Subscriber_t subscriber = NIL;
	Publisher_t publisher = NIL;
	Topic_t ts_topic;
	DataReader_t data_reader = NIL;
	DataWriter_t data_writer = NIL;
	SubscriberListener_t listener = NIL;
	int id = 0;
  	int PUBLISHER_MOD = 2;
	
	event void Boot.booted ()
	{
		SubscriberQos s_qos;
		PublisherQos p_qos;
		TopicQos t_qos;
		DataWriterQos dw_qos;
		dbg("APP","%s:called\n", __FUNCTION__);
		if(TOS_NODE_ID == BASESTATION_NODE_ID) {
			subscriber = call DomainParticipant.create_subscriber(s_qos, NIL);
		} else if(TOS_NODE_ID % PUBLISHER_MOD == 0) {
			publisher = call DomainParticipant.create_publisher(p_qos, NIL);
		}
		ts_topic = call DomainParticipant.create_topic("TempSensor", "", t_qos, NIL);
		if(TOS_NODE_ID == BASESTATION_NODE_ID) {
			dbg("APP","%s:start timer\n", __FUNCTION__);
			call Timer0.startOneShot(5000);
		} else if(TOS_NODE_ID % PUBLISHER_MOD == 0) {
			data_writer = call Publisher.create_datawriter (ts_topic, dw_qos, NIL);
		}
		if(TOS_NODE_ID != BASESTATION_NODE_ID  && TOS_NODE_ID % PUBLISHER_MOD == 0) {
			dbg("APP","%s:start timer\n", __FUNCTION__);
			call Timer0.startOneShot(10000);
		}
	}


	event void Timer0.fired () 
	{
		Data data;
		nx_uint32_t t;
		dbg("APP","%s:called\n", __FUNCTION__);
		if(TOS_NODE_ID == BASESTATION_NODE_ID) {
			DataReaderQos dr_qos;
			listener = call SubscriberListener.create(ts_topic);
			call Subscriber.set_listener(listener, NIL);
			data_reader = call Subscriber.create_datareader(ts_topic, dr_qos, listener);
		}
		if(data_writer != NIL) {
			t = call LocalTime.get();
			//FIXME no pointer for network type?
			//data.item = (nx_uint8_t *) malloc(sizeof(nx_uint8_t) * 3);
			data.item[0] = 's'; // sensor reading
			data.size = 1;
			data.subject = SUBJECT_DATA;
			//data.src = TOS_NODE_ID;
			data.timestamp.sec = t/1024;
			data.timestamp.nanosec = (t - data.timestamp.sec * 1024);
			dbg("APP","%s:publish data %d time %d\n", __FUNCTION__, id, t);
			call Leds.led0Toggle();
			call DataWriter.write(data_writer, data);
			id++;
		}
		call Timer0.startOneShot(10000);
	}

	
	event ReturnCode_t DataWriter.data_available (DataWriter_t a_data_writer, Data data)  
	{
		dbg("APP","%s:called\n", __FUNCTION__);
		return RETCODE_OK;
	}
	
	event ReturnCode_t SubscriberListener.data_available (Topic_t topic)
	{
		Data data;
		nx_uint32_t t;
		dbg("APP","%s:called\n", __FUNCTION__);
		t = call LocalTime.get();
		call Leds.led1Toggle();
		if( call DataReader.read(topic, &data) == FAIL) {
			dbg("APP","%s:read_fail\n", __FUNCTION__);
			return RETCODE_ERROR;
		}
	
		//FIXME: need real clock sync
		if(t > (data.timestamp.sec * 1024 + data.timestamp.nanosec)) {
			t = t - (data.timestamp.sec * 1024 + data.timestamp.nanosec);
		} else {
			t = 0;
		}
		dbg("APP", "%s:data:%d:%d:%d\n", __FUNCTION__, data.orig, t, data.item[2]);
		return RETCODE_OK;
	}

}
