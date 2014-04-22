package entity.view;

import entity.mapping.ConnectionPoint;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/18/14 Time: 11:54 PM
 */

public class ConnectionPointTable {

    public ConnectionPoint connectionPoint;
    public String usedCP;

    public ConnectionPointTable() {
    }

    public ConnectionPointTable(ConnectionPoint connectionPoint, String usedCP) {
        this.connectionPoint = connectionPoint;
        this.usedCP = usedCP;
    }

    public ConnectionPoint getConnectionPoint() {
        return connectionPoint;
    }

    public void setConnectionPoint(ConnectionPoint connectionPoint) {
        this.connectionPoint = connectionPoint;
    }



}
