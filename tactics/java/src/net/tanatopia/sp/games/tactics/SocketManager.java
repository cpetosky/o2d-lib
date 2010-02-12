package net.tanatopia.sp.games.tactics;

import java.net.Socket;
import java.net.ServerSocket;
import java.net.UnknownHostException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.Serializable;
import java.io.ObjectOutputStream;
import java.io.ObjectInputStream;
import java.util.LinkedList;


public class SocketManager implements Runnable {

	final static int DEFAULT_PORT = 1616;
	final static String DATA_SPLIT = ";";

	private Socket sktOpponent;
	private Socket sktObject;
	private PrintWriter dOut;
	private BufferedReader dIn;
	private ObjectOutputStream objOut;
	private ObjectInputStream objIn;

	private LinkedList qData;
	private boolean bPaused;

	public SocketManager() {
		sktOpponent = null;
		dOut = null;
		dIn = null;
		qData = new LinkedList();
		bPaused = false;
	}

	public void host(int nPort) throws IOException {
		ServerSocket sktServer = new ServerSocket(nPort);
		ServerSocket sktServer2 = new ServerSocket(nPort + 1);
		sktOpponent = sktServer.accept();
		sktObject = sktServer2.accept();
		sktServer.close();
		sktServer2.close();
		initComms();
	}

	public void connect(String sIP, int nPort) throws UnknownHostException, IOException {
		sktOpponent = new Socket(sIP, nPort);
		sktObject = new Socket(sIP, nPort + 1);
		initComms();

	}

	public boolean isConnected() {
		return sktOpponent.isConnected();
	}

	private void initComms() throws IOException {
		dOut = new PrintWriter(sktOpponent.getOutputStream(), true);
		dIn = new BufferedReader(new InputStreamReader(sktOpponent.getInputStream()));
		objOut = new ObjectOutputStream(sktObject.getOutputStream());
		objIn = new ObjectInputStream(sktObject.getInputStream());
	}

	public boolean hasPendingData() {
		if (qData.size() > 0)
			return true;
		else
			return false;
	}

	public String[] getData() {
		while (true) {
			if (hasPendingData()) {
				synchronized (this) {
					String[] sReturn = ((String)qData.removeFirst()).split(DATA_SPLIT);
					return sReturn;
				}
			}
			else {
				try { Thread.sleep(750); }
				catch (Exception e) {}
			}
		}
	}

	public void disconnect() {
		send("disconnect", "");
		try {
		if (dOut != null)
			dOut.close();
		}
		catch (Exception e) {}
		try {
		if (dIn != null)
			dIn.close();
		}
		catch (Exception e) {}
		try {
		if (sktOpponent != null)
			sktOpponent.close();
		}
		catch (Exception e) {}
		synchronized (this) {
			qData.clear();
			qData.addFirst("disconnect");
		}
	}

	public void send(String sName, String sData) {
		dOut.println(sName + DATA_SPLIT + sData);
		dOut.flush();
	}

	public void sendObject(Serializable oObject) {
		try {
			objOut.writeObject(oObject);
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
	}

	public Object readObject() {
		try {
			return objIn.readObject();
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
		return null;
	}

	public void run() {
		String sInput;
		String[] sCommand;
		while (isConnected()) {
			if (!bPaused) {
				try {
					sInput = dIn.readLine();
					if (sInput != null)  {
						synchronized (this) {
							qData.addLast(sInput);
						}
					}
				} catch (Exception e) {}
			}
			try {
				Thread.sleep(750);
			} catch (Exception e) {}

		}

	}

}