package dao.interfaces;

import entity.mapping.StubLink;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 10:27 PM
 */

public interface StubLinkDAO {

    List<StubLink> getStubLinksByCuId(Long cuId);
    List<StubLink> getStubLinkByNodeId(Long nodeId);

}
