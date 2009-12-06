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
includes Topology;
#include <stdio.h>

module TopologyM {
	provides {
		interface Topology;
	}
}

implementation {
	uint8_t indexFromId() {
		int i;
		int max_size = GRID_WIDTH * GRID_HEIGHT;

		for(i = 0; i != max_size; i++) {
			if(idmap[i] == TOS_NODE_ID) return i;
		}
		return -1;
	}
	uint8_t* getNeighborList () {
		int id;

		if((id = indexFromId()) == -1) {
			return 0;
		}
		return topology[id];
	}
	command bool Topology.isNeighbor (uint8_t id) {
		uint8_t *neighbors;
		int i;

		neighbors = getNeighborList();
		for(i = 0; i != MAX_NEIGHBORS; i++) {
			if(id == idmap[neighbors[i]]) return TRUE;
		}
		return FALSE;
	}
	command uint8_t* Topology.getNeighborList () {
		return getNeighborList();
	}
}
