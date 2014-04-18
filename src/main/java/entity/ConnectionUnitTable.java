package entity;

/**
 * User: Олег Наумов
 * Date: 4/18/14 Time: 7:40 AM
 */

public class ConnectionUnitTable {

    public ConnectionUnit connectionUnit;
    public Long freePair;

    public ConnectionUnitTable() {
    }

    public ConnectionUnitTable(ConnectionUnit connectionUnit, Long freePair) {
        this.connectionUnit = connectionUnit;
        this.freePair = freePair;
    }

    public ConnectionUnit getConnectionUnit() {
        return connectionUnit;
    }

    public void setConnectionUnit(ConnectionUnit connectionUnit) {
        this.connectionUnit = connectionUnit;
    }

    public Long getFreePair() {
        return freePair;
    }

    public void setFreePair(Long freePair) {
        this.freePair = freePair;
    }
}
