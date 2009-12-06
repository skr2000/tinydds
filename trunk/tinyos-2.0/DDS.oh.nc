//$Id: DDS.nc,v 1.3 2008-07-28 06:32:55 pruet Exp $

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
		
//This file is generated from dds_dcps.idl by omniidl (nesC backend)- omniORB_4_1. Do not edit manually.
//Header block
includes DDS_enum;
includes DDS_type;
includes DDS_struct;
includes DDS_const;
//includes BaseUART;
includes Apps_utils;
includes WSN;
includes Serial;
//includes WSN_Messages;
//Configuration block
configuration DDS {
}

//Implementation block
implementation {
	//required
	components MainC, ApplicationM, L4ALM, TopicM, DomainParticipantM, DataReaderM, SubscriberListenerM, PublisherM, SubscriberM, TypeSupportM, EntityM, DataWriterM;
	//options
	components LedsC;
	components new TimerMilliC() as AppTimer;
	components LocalTimeMilliC;
	components OneHopM;
	components SpanningTreeM;
	components new AMSenderC(AM_MSG_DDS);
	components new AMReceiverC(AM_MSG_DDS);
	components ActiveMessageC;
	components PrintfM;
	components TopologyM;
	components SerialActiveMessageC as AM;
	//components LedsC, new TimerMilliC() as AppTimer, LocalTimeMilliC, MainC,  ApplicationM, L4ALM,  TopicM, DomainParticipantM, DataReaderM, SubscriberListenerM, PublisherM, SubscriberM, TypeSupportM, EntityM, DataWriterM,  ActiveMessageC, DymoNetworkC, MultiHopM,  DHTM;

	TypeSupportM.Boot -> MainC;
	EntityM.Boot -> MainC;
	TopicM.Boot -> MainC;
	DomainParticipantM.Boot -> MainC;
	PrintfM.Boot -> MainC.Boot;
	//MultiHopM.Boot -> MainC;
	OneHopM.Boot -> MainC;
	SpanningTreeM.Boot -> MainC;
	L4ALM.Boot -> MainC;
	//DHTM.Boot -> MainC;
	SubscriberListenerM.Boot -> MainC;
	SubscriberM.Boot -> MainC;
	PublisherM.Boot -> MainC;
	DataReaderM.Boot -> MainC;
	DataWriterM.Boot -> MainC;
	ApplicationM.Boot -> MainC.Boot;

	PrintfM.Control -> AM;
	PrintfM.Receive -> AM.Receive[AM_SERIAL_MSG];
	PrintfM.AMSend -> AM.AMSend[AM_SERIAL_MSG];
	PrintfM.Packet -> AM;

	DomainParticipantM.Topic -> TopicM;

	OneHopM.LocalTime -> LocalTimeMilliC;
	OneHopM.AMSend -> AMSenderC;
	OneHopM.Receive -> AMReceiverC;
	OneHopM.AMControl -> ActiveMessageC;
	OneHopM.Packet -> AMSenderC;
	OneHopM.Leds -> LedsC;
	OneHopM.Topology -> TopologyM;
	OneHopM.Printf -> PrintfM;

	//MultiHopM.LocalTime -> LocalTimeMilliC;
	//MultiHopM.SplitControl -> DymoNetworkC;
	//MultiHopM.Packet -> DymoNetworkC;
	//MultiHopM.MHPacket -> DymoNetworkC;
	//MultiHopM.MHSend -> DymoNetworkC.MHSend[AM_MSG_DDS];
	//MultiHopM.Receive -> DymoNetworkC.Receive[AM_MSG_DDS];

	L4ALM.L3 -> OneHopM;
	//L4ALM.L3 -> MultiHopM;

	SpanningTreeM.L4 -> L4ALM;
	SpanningTreeM.Leds -> LedsC;
	SpanningTreeM.Printf -> PrintfM;
	//DHTM.L4 -> L4ALM;

	SubscriberListenerM.DataReader -> DataReaderM;
	SubscriberM.DataReader -> DataReaderM;
	SubscriberM.SubscriberListener -> SubscriberListenerM;
	SubscriberM.OERP -> SpanningTreeM;
	//SubscriberM.OERP -> DHTM;

	DataWriterM.Publisher -> PublisherM;
	PublisherM.DataWriter -> DataWriterM;
	PublisherM.OERP -> SpanningTreeM;
	//PublisherM.OERP -> DHTM;
	//

	ApplicationM.Leds -> LedsC;
	ApplicationM.Timer0 -> AppTimer;
	ApplicationM.LocalTime -> LocalTimeMilliC;
	ApplicationM.DomainParticipant -> DomainParticipantM;
	ApplicationM.DataWriter -> DataWriterM;
	ApplicationM.DataReader -> DataReaderM;
	ApplicationM.Publisher -> PublisherM;
	ApplicationM.Subscriber -> SubscriberM;
	ApplicationM.SubscriberListener -> SubscriberListenerM;
	ApplicationM.Topic -> TopicM;
	ApplicationM.Boot -> MainC;
	ApplicationM.Printf -> PrintfM;
}
