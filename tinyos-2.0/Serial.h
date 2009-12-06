enum {
	MAX_SERIAL_BUFFER_SIZE=20,
};

enum {
	MAX_SERIAL_QUEUE_SIZE=20,
};

typedef nx_struct serial_msg {
	nx_uint8_t buffer[MAX_SERIAL_BUFFER_SIZE];
} serial_msg_t;

enum {
	AM_SERIAL_MSG = 0x89,
};

enum {
	QUEUE_SIZE = 10,
};
