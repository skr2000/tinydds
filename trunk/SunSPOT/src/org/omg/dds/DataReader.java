package org.omg.dds;


/**
* org/omg/dds/DataReader.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from dds_dcps.idl
* Monday, August 18, 2008 12:58:40 AM EDT
*/

public interface DataReader extends  org.omg.dds.Entity 
{
  int set_listener (org.omg.dds.DataReaderListener a_listener);
  org.omg.dds.DataReaderListener get_listener ();
  org.omg.dds.Subscriber get_subscriber ();
} // interface DataReader
