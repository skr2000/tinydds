/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.umb.cs.tinydds.io;

import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.sensorboard.peripheral.ILightSensor;
import java.io.IOException;

/**
 *
 * @author pruet
 */
public class LightSensorEmulator implements LightSensor {

    private ILightSensor lightSensor = EDemoBoard.getInstance().getLightSensor();

    public int getValue() throws IOException {
        return lightSensor.getValue();
    }
}
