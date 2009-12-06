//$Id: DHTM.nc,v 1.1 2008-07-28 06:35:06 pruet Exp $
// Ported to 2.0

/*Copyright (c) 2009 University of Massachusetts, Boston 
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
includes Serial;

module PrintfM {
	provides {
		interface Printf;
	}
	uses {
		interface SplitControl as Control;
		interface Boot;
		interface Receive;
		interface AMSend;
		interface Packet;
	}
}

implementation {
	message_t packet;
	uint8_t queue[MAX_SERIAL_QUEUE_SIZE][MAX_SERIAL_BUFFER_SIZE];
	bool locked;
	uint8_t back_queue;
	uint8_t front_queue;

	event void Boot.booted() {
		locked = FALSE;
		back_queue = 0;
		front_queue = 1;
		call Control.start();
	}

	task void true_printf() {
		int max_payload;
		serial_msg_t* serial_msg;
		int len;
		int i;
		if(locked) {
			return;
		}
		if((back_queue < front_queue && back_queue == front_queue -1 ) ||
				(back_queue > front_queue && back_queue == MAX_SERIAL_QUEUE_SIZE - 1 && front_queue == 0)) {
			//queue is empty
			return;
		}
		serial_msg = (serial_msg_t *)call Packet.getPayload(&packet, sizeof(serial_msg_t));
		max_payload = call Packet.maxPayloadLength();
		if(serial_msg == NULL || sizeof(serial_msg) > max_payload) {
			return;
		}
		back_queue++;
		if(back_queue >= MAX_SERIAL_QUEUE_SIZE) {
			back_queue = 0;
		}
		len = queue[back_queue][0];
		if(len >= MAX_SERIAL_QUEUE_SIZE) len = MAX_SERIAL_QUEUE_SIZE - 1;
		for(i = 0; i != len + 1; i++) {
			serial_msg->buffer[i] = queue[back_queue][i];
			queue[back_queue][i] = 0;
		}
		serial_msg->buffer[i] = 0;
		if(call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(serial_msg_t)) == SUCCESS) {
			locked = TRUE;
		}
	}

	command bool Printf.printf(char *msg) {
		uint8_t len;
		int i;
		if(front_queue == back_queue) {
			// queue is fulled!
			return FALSE;
		}
		len = (uint8_t) strlen(msg);
		if(len > MAX_SERIAL_BUFFER_SIZE) {
			// message is too long, reject
			return FALSE;
		}
		queue[front_queue][0] = (uint8_t)len;
		for(i = 0; i != len; i++) {
			queue[front_queue][i + 1] = msg[i];
		}
		queue[front_queue][i + 1] = 0;
		front_queue++;
		if(front_queue >= MAX_SERIAL_QUEUE_SIZE) front_queue = 0;
		post true_printf();
		return TRUE;
	}
	event message_t * Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		return bufPtr;
	}

	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		locked = FALSE;
		post true_printf();
	}
	event void Control.startDone(error_t err) {
	}
	event void Control.stopDone(error_t err) {
	}
}
