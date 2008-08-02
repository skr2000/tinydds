//$Id: nesc.py,v 1.2 2008-06-25 16:15:28 pruet Exp $

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
includes BaseUART;
includes Apps_utils;
includes WSN;
//Configuration block
configuration DDS {
}

//Implementation block
implementation {
	components LedsC, TimerC, NeighborsM, LogicalTime, DHTM, Main, GenericComm, ApplicationM, L4ALM, PerEventM, LatencyBudgetQosPolicyM, ReliabilityQosPolicyM, QosPolicyM, TinyAODVM, AODV, TopicM, DomainParticipantM, DataReaderM, SubscriberListenerM, PublisherM, SubscriberM, TypeSupportM, EntityM, DataWriterM, ContentFilteredTopicM;

	Main.StdControl -> TimerC;
	Main.StdControl -> NeighborsM;
	Main.StdControl -> LogicalTime;
	Main.StdControl -> DHTM;
	Main.StdControl -> GenericComm;
	Main.StdControl -> ApplicationM;
	Main.StdControl -> L4ALM;
	Main.StdControl -> PerEventM;
	Main.StdControl -> LatencyBudgetQosPolicyM;
	Main.StdControl -> ReliabilityQosPolicyM;
	Main.StdControl -> QosPolicyM;
	Main.StdControl -> TinyAODVM;
	Main.StdControl -> AODV;
	Main.StdControl -> TopicM;
	Main.StdControl -> DomainParticipantM;
	Main.StdControl -> DataReaderM;
	Main.StdControl -> SubscriberListenerM;
	Main.StdControl -> PublisherM;
	Main.StdControl -> SubscriberM;
	Main.StdControl -> TypeSupportM;
	Main.StdControl -> EntityM;
	Main.StdControl -> DataWriterM;
	Main.StdControl -> ContentFilteredTopicM;
	ApplicationM.Leds -> LedsC;
	ApplicationM.Timer -> TimerC.Timer[unique("Timer")];;
	ApplicationM.Time -> LogicalTime;
	ApplicationM.DomainParticipant -> DomainParticipantM;
	ApplicationM.DataWriter -> DataWriterM;
	ApplicationM.DataReader -> DataReaderM;
	ApplicationM.Publisher -> PublisherM;
	ApplicationM.Subscriber -> SubscriberM;
	ApplicationM.SubscriberListener -> SubscriberListenerM;
	ApplicationM.Topic -> TopicM;
	ApplicationM.QosPolicy -> QosPolicyM;
	DataWriterM.Publisher -> PublisherM;
	SubscriberListenerM.DataReader -> DataReaderM;
	SubscriberM.DataReader -> DataReaderM;
	SubscriberM.SubscriberListener -> SubscriberListenerM;
	PublisherM.DataWriter -> DataWriterM;
	QosPolicyM.LatencyBudgetQosPolicy -> LatencyBudgetQosPolicyM;
	QosPolicyM.ReliabilityQosPolicy -> ReliabilityQosPolicyM;
	PublisherM.OERP -> DHTM;
	SubscriberM.OERP -> DHTM;
	DomainParticipantM.Topic -> TopicM;
	DHTM.L4 -> L4ALM;
	L4ALM.EventQueue -> PerEventM;
	L4ALM.QosPolicy -> QosPolicyM;
	L4ALM.L3 -> TinyAODVM;
	TinyAODVM.Send -> AODV.Send[0];
	TinyAODVM.Receive -> AODV.Receive[0];
	TinyAODVM.Intercept -> AODV.Intercept[0];
	TinyAODVM.SendMHopMsg -> AODV.SendMHopMsg[0];
	TinyAODVM.SingleHopMsg -> AODV.SingleHopMsg;
	TinyAODVM.MultiHopMsg -> AODV.MultiHopMsg;
	TinyAODVM.AODVMsg -> AODV.AODVMsg;
	TinyAODVM.Neighbors -> NeighborsM.Neighbors;
}
