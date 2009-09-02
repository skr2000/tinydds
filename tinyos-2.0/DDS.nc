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
//includes WSN_Messages;
//Configuration block
configuration DDS {
}

//Implementation block
implementation {
	//		components LedsC, TimerMilliC, NeighborsM, LocalTimeMilliC, BisnetM, Main, UARTComm, GenericComm, ApplicationM, L4ALM, PerEventM, LatencyBudgetQosPolicyM, ReliabilityQosPolicyM, QosPolicyM, OneHopM, TopicM, DomainParticipantM, DataReaderM, SubscriberListenerM, PublisherM, SubscriberM, TypeSupportM, EntityM, DataWriterM, ContentFilteredTopicM, SingleHopManager, NeighborAgeM;
	components LedsC, new TimerMilliC() as AppTimer, LocalTimeMilliC, MainC,  ApplicationM, L4ALM,  OneHopM, TopicM, DomainParticipantM, DataReaderM, SubscriberListenerM, PublisherM, SubscriberM, TypeSupportM, EntityM, DataWriterM,  SpanningTreeM, new AMSenderC(AM_MSG_DDS), new AMReceiverC(AM_MSG_DDS), ActiveMessageC;


	TypeSupportM.Boot -> MainC;
	EntityM.Boot -> MainC;
	TopicM.Boot -> MainC;
	DomainParticipantM.Boot -> MainC;
	OneHopM.Boot -> MainC;
	L4ALM.Boot -> MainC;
	SpanningTreeM.Boot -> MainC;
	SubscriberListenerM.Boot -> MainC;
	SubscriberM.Boot -> MainC;
	PublisherM.Boot -> MainC;
	DataReaderM.Boot -> MainC;
	DataWriterM.Boot -> MainC;

	DataWriterM.Publisher -> PublisherM;
	//DataWriterM.Time -> LocalTimeMilliC;
	SubscriberListenerM.DataReader -> DataReaderM;
	SubscriberM.DataReader -> DataReaderM;
	SubscriberM.SubscriberListener -> SubscriberListenerM;
	PublisherM.DataWriter -> DataWriterM;
	//QosPolicyM.LatencyBudgetQosPolicy -> LatencyBudgetQosPolicyM;
	//QosPolicyM.ReliabilityQosPolicy -> ReliabilityQosPolicyM;
	//PublisherM.OERP -> BisnetM;
	//SubscriberM.OERP -> BisnetM;
	PublisherM.OERP -> SpanningTreeM;
	SubscriberM.OERP -> SpanningTreeM;
	DomainParticipantM.Topic -> TopicM;
	SpanningTreeM.L4 -> L4ALM;
	//SpanningTreeM.Timer0 -> OERPTimer;
	//BisnetM.L4 -> L4ALM;
	//BisnetM.Timer -> TimerMilliC.Timer[unique("Timer")];
	//BisnetM.SendUART -> UARTComm.SendMsg[AM_BASEUARTMSG];
	//BisnetM.ReceiveUART -> UARTComm.ReceiveMsg[AM_BASEUARTMSG];
	//BisnetM.Time -> LocalTimeMilliC;
	//L4ALM.EventQueue -> PerEventM;
	//L4ALM.QosPolicy -> QosPolicyM;
	L4ALM.L3 -> OneHopM;
	OneHopM.LocalTime -> LocalTimeMilliC;
	//OneHopM.Neighbors -> NeighborsM.Neighbors;

	//OneHopM.SendMsg -> GenericComm.SendMsg[4];
	//OneHopM.ReceiveMsg -> GenericComm.ReceiveMsg[4];
	OneHopM.AMSend -> AMSenderC;
	OneHopM.Receive -> AMReceiverC;
	OneHopM.AMControl -> ActiveMessageC;
	OneHopM.Packet -> AMSenderC;
	//OneHopM.Neighbors -> NeighborsM.Neighbors;
	//NeighborsM.PickForDeletion -> NeighborAgeM.PickOldest;
	//NeighborAgeM.NeighborMgmt -> NeighborsM.NeighborMgmt;
	//NeighborAgeM.Timer -> TimerMilliC.Timer[unique("Timer")];
	//ApplicationM MUST initiate latest
	//Main.StdControl -> ApplicationM;
	ApplicationM.Leds -> LedsC;
	//ApplicationM.Timer -> TimerMilliC.Timer[unique("Timer")];;
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
	//ApplicationM.QosPolicy -> QosPolicyM;
}
