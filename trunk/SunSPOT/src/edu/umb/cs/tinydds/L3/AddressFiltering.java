/*$Id: AddressFiltering.java,v 1.2 2008/08/26 19:35:08 pruet Exp $
 
Copyright (c) 2008 University of Massachusetts, Boston 
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

package edu.umb.cs.tinydds.L3;

import com.sun.spot.util.IEEEAddress;
import com.sun.spot.util.Utils;

/**
 *
 * @author pruet
 */
public class AddressFiltering {

    protected long[][] addressList = {
        {1, 5}, {0, 2, 6}, {1, 3, 7}, {2, 8, 4}, {3, 9},
        {0, 6, 10}, {1, 5, 7, 11}, {2, 6, 8, 12}, {3, 7, 13, 9}, {4, 8, 14},
        {5, 11, 15}, {6, 10, 12, 16}, {7, 11, 13, 17}, {8, 12, 14, 18}, {9, 13, 19},
        {10, 16, 20}, {11, 15, 17, 21}, {12, 16, 18, 22}, {13, 17, 19, 23}, {14, 18, 24},
        {15, 21}, {16, 20, 22}, {17, 21, 23}, {18, 22, 24}, {19, 23}
    };
    protected long[] myNeighbors;
    // protected long PREFIX = 0;
    public AddressFiltering(long myAddress) {
        //myAddress -= PREFIX;
        myNeighbors = addressList[(int) myAddress];
    }

    public boolean isMyNeighbor(long address) {
        //address -= PREFIX;
        for (int i = 0; i != myNeighbors.length; i++) {
            if (myNeighbors[i] == address) {
                return true;
            }
        }
        return false;
    }

    public boolean isMyNeighbor(String address) {
        return isMyNeighbor(addressToLong(address));
    }

    public static long addressToLong(String address) {
        String addr = "0000.0000.0000." + Utils.split(address, '.')[3];
        return IEEEAddress.toLong(addr) - 4097;
    }
    
    public static String longToAddress(long addr) {
        String addr_str =  "7f00.0001.0000.";
        String dot_hex = IEEEAddress.toDottedHex(addr + 4097);
        return addr_str + Utils.split(dot_hex, '.')[3];
    }
}
