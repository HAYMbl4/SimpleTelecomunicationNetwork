package dao.interfaces;

import entity.mapping.ConnectionUnit;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:06 PM
 */

public interface ConnectionUnitDAO {

    List<ConnectionUnit> getListConnectionUnit();
    List<ConnectionUnit> getConnectionUnitByNode(Long nodeId);
    Long getCntUsedCpByCu(Long cuId);
    ConnectionUnit getCuByCuId(Long cuId);
    void createConnectionUnit(ConnectionUnit connectionUnit);
    void deleteConnectionUnit(ConnectionUnit connectionUnit);

}
