package dao.interfaces;

import entity.mapping.ConnectionPoint;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:16 PM
 */

public interface ConnectionPointDAO {

    List<ConnectionPoint> getListConnectionPointByCuId(Long cuId);
    ConnectionPoint getConnectionPointByCpId(Long cpId);
    String usedCp(Long cpId);

}
