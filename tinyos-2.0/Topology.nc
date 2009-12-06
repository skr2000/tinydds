interface Topology {
	command bool isNeighbor (uint8_t id);
	command uint8_t* getNeighborList ();
}
