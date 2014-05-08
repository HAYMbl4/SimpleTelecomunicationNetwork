package entity.view;

import entity.mapping.ConnectionPoint;

/**
 * User: Олег Наумов
 * Date: 5/5/14 Time: 2:37 PM
 */

public class ConnectionPointSelect {

    ConnectionPoint connectionPoint;
    boolean selected;

    public ConnectionPointSelect() {
    }

    public ConnectionPointSelect(ConnectionPoint connectionPoint, boolean selected) {
        this.connectionPoint = connectionPoint;
        this.selected = selected;
    }

    public ConnectionPoint getConnectionPoint() {
        return connectionPoint;
    }

    public void setConnectionPoint(ConnectionPoint connectionPoint) {
        this.connectionPoint = connectionPoint;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }
}
