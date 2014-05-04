package dao.interfaces;

import entity.view.CableLinkGroup;
import entity.view.CableLinkTable;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:28 AM
 */

public interface CableLinksDAO {

    List<CableLinkTable> getCableLinksByNodeId(Long nodeId);
    List<CableLinkTable> getCableLinksByCuId(Long cuId);
    List<CableLinkGroup> getCableLinkGroupByNode(Long nodeId);
    List<CableLinkGroup> getCableLinkGroupByCU(Long cuId);

}
