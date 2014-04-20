package entity.view;

import entity.mapping.ConnectionPoint;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/18/14 Time: 11:54 PM
 */

public class ConnectionPointTable {

    public ConnectionPoint connectionPoint;
    public List<String> linkedCP;

    public ConnectionPointTable() {
    }

    public ConnectionPointTable(ConnectionPoint connectionPoint, List<String> linkedCP) {
        this.connectionPoint = connectionPoint;
        this.linkedCP = linkedCP;
    }

    public ConnectionPoint getConnectionPoint() {
        return connectionPoint;
    }

    public void setConnectionPoint(ConnectionPoint connectionPoint) {
        this.connectionPoint = connectionPoint;
    }

    public List<String> getLinkedCP() {
        return linkedCP;
    }

    public void setLinkedCP(List<String> linkedCP) {
        this.linkedCP = linkedCP;
    }

}
