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

/*typedef struct {
	uint _length;
	InstanceHandle_t* _buffer;
} InstanceHandleSeq;*/

typedef uint32_t ReturnCode_t __attribute__((combine(rccombine)));
ReturnCode_t rccombine (ReturnCode_t e1, ReturnCode_t e2)
{
	return ((e1 == 0) && (e2 == 0))?0:1;
}


typedef uint32_t QosPolicyId_t;

/*typedef struct {
	uint _length;
	char ** _buffer;
} StringSeq;*/

typedef uint32_t StatusKind;

typedef uint32_t StatusKindMask;

/*typedef struct {
	uint _length;
	struct QosPolicyCount* _buffer;
} QosPolicyCountSeq;*/

/*typedef struct {
	uint _length;
	Topic_t* _buffer;
} TopicSeq;*/

/*typedef struct {
	uint _length;
	DataReader_t* _buffer;
} DataReaderSeq;*/

/*typedef struct {
	uint _length;
	Condition_t* _buffer;
} ConditionSeq;*/

typedef uint32_t SampleStateKind;

/*typedef struct {
	uint _length;
	SampleStateKind* _buffer;
} SampleStateSeq;*/

typedef uint32_t SampleStateMask;

typedef uint32_t ViewStateKind;

/*typedef struct {
	uint _length;
	ViewStateKind* _buffer;
} ViewStateSeq;*/

typedef uint32_t ViewStateMask;

typedef uint32_t InstanceStateKind;

/*typedef struct {
	uint _length;
	InstanceStateKind* _buffer;
} InstanceStateSeq;*/

typedef uint32_t InstanceStateMask;

/*typedef struct {
	uint _length;
	struct SampleInfo* _buffer;
} SampleInfoSeq;*/

