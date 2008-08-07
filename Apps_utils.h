//$Id: Apps_utils.h,v 1.6 2008-08-07 21:27:53 pruet Exp $

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
#define DEBUG_EDGE
#define NIL (255)
#define MAX_MEMBER_SIZE 10
#define MAX_NEIGHBOR 10
// number of topic should be prime!!!
#define MAX_TOPIC_NUM 61
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

