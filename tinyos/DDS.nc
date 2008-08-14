//$Id: DDS.nc,v 1.9 2008-08-13 05:35:27 pruet Exp $

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
		
//This file is generated from ../dds_dcps.idl by omniidl (nesC backend)- omniORB_4_1. Do not edit manually.
//Header block
includes DDS_enum;
includes DDS_type;
includes DDS_struct;
includes DDS_const;
includes BaseUART;
includes WSN;
includes TinyCDR;
includes TinyGIOP;
includes Apps_utils;
//Configuration block
configuration DDS {
}

//Implementation block
implementation {
	components LedsC, TimerC, NeighborList, LogicalTime, SpanningTreeM, Main, GenericComm, UARTComm, ApplicationM, TinyGIOPM, L4ALM, OneHopM, PublisherM, DomainParticipantM, SubscriberListenerM, SubscriberM, TypeSupportM, EntityM, TopicM, DataReaderM, DataWriterM, ContentFilteredTopicM;

	Main.StdControl -> TimerC;
	Main.StdControl -> NeighborList;
	Main.StdControl -> LogicalTime;
	Main.StdControl -> SpanningTreeM;
	Main.StdControl -> GenericComm;
	Main.StdControl -> UARTComm;
	Main.StdControl -> ApplicationM;
	Main.StdControl -> TinyGIOPM;
	Main.StdControl -> L4ALM;
	Main.StdControl -> OneHopM;
	Main.StdControl -> PublisherM;
	Main.StdControl -> DomainParticipantM;
	Main.StdControl -> SubscriberListenerM;
	Main.StdControl -> SubscriberM;
	Main.StdControl -> TypeSupportM;
	Main.StdControl -> EntityM;
	Main.StdControl -> TopicM;
	Main.StdControl -> DataReaderM;
	Main.StdControl -> DataWriterM;
	Main.StdControl -> ContentFilteredTopicM;
	ApplicationM.Leds -> LedsC;
	ApplicationM.Timer -> TimerC.Timer[unique("Timer")];
	ApplicationM.Time -> LogicalTime;
	ApplicationM.DomainParticipant -> DomainParticipantM;
	ApplicationM.Topic -> TopicM;
	ApplicationM.DataWriter -> DataWriterM;
	ApplicationM.Publisher -> PublisherM;
	DataWriterM.Publisher -> PublisherM;
	DataWriterM.Time -> LogicalTime;
	SubscriberListenerM.DataReader -> DataReaderM;
	SubscriberM.DataReader -> DataReaderM;
	SubscriberM.SubscriberListener -> SubscriberListenerM;
	PublisherM.DataWriter -> DataWriterM;
	DomainParticipantM.Topic -> TopicM;
	PublisherM.OERP -> SpanningTreeM;
	SubscriberM.OERP -> SpanningTreeM;
	SpanningTreeM.TinyGIOP -> TinyGIOPM;
	SpanningTreeM.Timer -> TimerC.Timer[unique("Timer")];
	TinyGIOPM.SendUART -> UARTComm.SendMsg[AM_BASEUARTMSG];
	TinyGIOPM.ReceiveUART -> UARTComm.ReceiveMsg[AM_BASEUARTMSG];
	TinyGIOPM.L4 -> L4ALM;
	TinyGIOPM.OERP -> SpanningTreeM;
	L4ALM.L3 -> OneHopM;
	OneHopM.SendMsg -> GenericComm.SendMsg[0];
	OneHopM.ReceiveMsg -> GenericComm.ReceiveMsg[0];
	OneHopM.Neighbors -> NeighborList.Neighbors;
}
