void debug (const char* msg)
{
	dbg(DBG_USR2, ":%s\n", msg);
}
void debugi(const char *msg, uint32_t i) 
{
	int j = i;
	dbg(DBG_USR2, ":%s:%lu\n", msg, j);
}


//FIXME: should move this to some separate header file
typedef uint8_t * Data_t;
//FIXME
//#define DEBUG_EDGE
#define NIL (255)
#define MAX_MEMBER_SIZE 10
#define MAX_NEIGHBOR 10
#define MAX_TOPIC_LENGTH 64
#define MAX_DATA_LEN 8
#define MAX_BUFFER_SIZE 10
#define NOT_IMPLEMENTED_YET (MAX_MEMBER_SIZE + 1)
#define NOT_AVAILABLE (MAX_MEMBER_SIZE + 2)
#define SUBJECT_SUBSCRIBE 1
#define SUBJECT_PUBLISH 2
#define SUBJECT_DATA 3
#define SUBJECT_BASE_PHEROMONE_FLOOD 4
#define SUBJECT_BASE_PHEROMONE 5
#define BISNET_HEADER_SIZE 9

typedef struct {
  Data_t item;
  uint8_t src;
  uint8_t orig;
  uint8_t size;
  Topic_t topic;
  Time_t timestamp;
  uint8_t subject;
} Data;

typedef struct {
  uint _length;
  Data* _buffer;
} DataSeq;
typedef DataSeq * DataSeq_p;

