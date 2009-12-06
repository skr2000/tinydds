import java.io.IOException;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class SerialPrintf implements MessageListener {
	private MoteIF moteIF;

	public SerialPrintf(MoteIF moteIF) {
		this.moteIF = moteIF;
		this.moteIF.registerListener(new SerialMsg(), this);
	}

	public void sendPackets() {
	}

	public void messageReceived(int to, Message message) {
		SerialMsg msg = (SerialMsg)message;
		short[] buffer = msg.get_buffer();
		byte[] b = new byte[buffer.length + 2];
		int i;
		int len = buffer[0];
		if(len == 0) {
			System.out.println("len is 0");
			return;
		}
		if(len >= buffer.length) len = buffer.length - 1;
		for(i = 1; i != len + 1; i++) {
			b[i] = (byte)buffer[i];
		}
		b[i + 1] = 0;
		System.out.println(">" + new String(b));
	}

	private static void usage() {
		System.err.println("usage: SerialPrintf [-comm <source>]");
	}

	public static void main(String[] args) throws Exception {
		String source = null;
		if(args.length == 2) {
			if(!args[0].equals("-comm")) {
				usage();
				System.exit(1);
			}
			source = args[1];
		} else if(args.length != 0) {
			usage();
			System.exit(1);
		}
		PhoenixSource phoenix;
		if(source == null) {
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		} else {
			phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
		}
		MoteIF mif = new MoteIF(phoenix);
		SerialPrintf serial = new SerialPrintf(mif);
	}
}
