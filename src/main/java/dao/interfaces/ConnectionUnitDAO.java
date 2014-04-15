package dao.interfaces;

import entity.ConnectionUnit;
import entity.Node;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:06 PM
 */

public interface ConnectionUnitDAO {

    List<ConnectionUnit> getListConnectionUnit();
    List<ConnectionUnit> getConnectionUnitByNode(Long nodeId);

}
