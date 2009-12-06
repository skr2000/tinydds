
#ifndef APPS_UTILS_H
#define APPS_UTILS_H

//FIXME: should move this to some separate header file
typedef nx_uint8_t * Data_t;
//FIXME
#define NIL (0xFF)
#define NILNIL (0xFFFF)
#define MAX_MEMBER_SIZE 10
#define MAX_NEIGHBOR 10
#define MAX_TOPIC_LENGTH 64
#define MAX_DATA_LEN 1 
#define MAX_BUFFER_SIZE 20
#define NOT_IMPLEMENTED_YET (MAX_MEMBER_SIZE + 1)
#define NOT_AVAILABLE (MAX_MEMBER_SIZE + 2)
#define SUBJECT_SUBSCRIBE 1
#define SUBJECT_PUBLISH 2
#define SUBJECT_DATA 3
#define SUBJECT_BASE_PHEROMONE_FLOOD 4
#define SUBJECT_BASE_PHEROMONE 5
#define SUBJECT_PHEROMONE 6
#define SUBJECT_DATA_TO_HASH 7
//#define DEBUG_EDGE 
#define BASESTATION_NODE_ID 10
#define PUBLISHER_MOD 12
#define TRUE (1)
#define FALSE (0)
#define MAX_HASH 10

typedef nx_struct {
  nx_uint8_t item[MAX_DATA_LEN];
  nx_uint8_t src;
  nx_uint8_t orig;
  nx_uint8_t size;
  nx_uint8_t topic;
  Time_t timestamp;
  nx_uint8_t subject;
} Data;

/*typedef struct {
  uint _length;
  Data* _buffer;
} DataSeq;
typedef DataSeq * DataSeq_p;*/

enum {
	AM_MSG_DDS = 6,
};

#endif
