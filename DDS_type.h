// $Id: DDS_type.h,v 1.5 2008-08-13 05:35:27 pruet Exp $

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

#ifndef DDS_TYPE_H
#define DDS_TYPE_H

typedef uint16_t Topic_t;
typedef uint16_t DomainParticipant_t;
typedef uint16_t DataReader_t;
typedef uint16_t SubscriberListener_t;
typedef uint16_t Publisher_t;
typedef uint16_t OERP_t;
typedef uint16_t Subscriber_t;
typedef uint16_t TypeSupport_t;
typedef uint16_t Entity_t;
typedef uint16_t LatencyBudgetQosPolicy_t;
typedef uint16_t Application_t;
typedef uint16_t L4_t;
typedef uint16_t L3_t;
typedef uint16_t EventQueue_t;
typedef uint16_t ReliabilityQosPolicy_t;
typedef uint16_t DataWriter_t;
typedef uint16_t QosPolicy_t;
typedef uint16_t ContentFilteredTopic_t;
typedef uint16_t Condition_t;
typedef uint16_t GuardCondition_t;
typedef uint16_t QueryCondition_t;
typedef uint16_t DataReaderListener_t;
typedef uint16_t DataWriterListener_t;
typedef uint16_t Listener_t;
typedef uint16_t PublisherListener_t;
typedef uint16_t TopicListener_t;
typedef uint16_t DomainParticipantFactory_t;
typedef uint16_t DomainParticipantListener_t;
typedef uint16_t MultiTopic_t;
typedef uint16_t TopicDescription_t;
typedef uint16_t WaitSet_t;
typedef uint16_t ReadCondition_t;
typedef uint16_t StatusCondition_t;


typedef uint32_t DomainId_t;

typedef uint32_t InstanceHandle_t;

typedef uint32_t BuiltinTopicKey_t[3];

typedef struct {
	uint16_t _length;
	InstanceHandle_t* _buffer;
} InstanceHandleSeq;

typedef uint32_t ReturnCode_t __attribute__((combine(rccombine)));
ReturnCode_t rccombine (ReturnCode_t e1, ReturnCode_t e2)
{
	return ((e1 == 0) && (e2 == 0))?0:1;
}


typedef uint32_t QosPolicyId_t;

typedef struct {
	uint16_t _length;
	char ** _buffer;
} StringSeq;

typedef uint32_t StatusKind;

typedef uint32_t StatusKindMask;

typedef struct {
	uint16_t _length;
	struct QosPolicyCount* _buffer;
} QosPolicyCountSeq;

typedef struct {
	uint16_t _length;
	Topic_t* _buffer;
} TopicSeq;

typedef struct {
	uint16_t _length;
	DataReader_t* _buffer;
} DataReaderSeq;

typedef struct {
	uint16_t _length;
	Condition_t* _buffer;
} ConditionSeq;

typedef uint32_t SampleStateKind;

typedef struct {
	uint16_t _length;
	SampleStateKind* _buffer;
} SampleStateSeq;

typedef uint32_t SampleStateMask;

typedef uint32_t ViewStateKind;

typedef struct {
	uint16_t _length;
	ViewStateKind* _buffer;
} ViewStateSeq;

typedef uint32_t ViewStateMask;

typedef uint32_t InstanceStateKind;

typedef struct {
	uint16_t _length;
	InstanceStateKind* _buffer;
} InstanceStateSeq;

typedef uint32_t InstanceStateMask;

typedef struct {
	uint16_t _length;
	struct SampleInfo* _buffer;
} SampleInfoSeq;


#endif
