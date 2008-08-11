uint32_t hash(uint8_t *name)
{
	int i;
	int l;
	uint32_t h;
	uint32_t g;

	//PJW hash here
	l = strlen(name);
	h = 0;
	for(i = 0; i != l; i++) {
		h = (h << 4) + name[i];
		g = h & 0xf0000000;
		if (g != 0) {
			h = h ^ (g >> 24);
			h = h ^ g;
		}
	}
	h = h % MAX_TOPIC_NUM;
	return h;
}
