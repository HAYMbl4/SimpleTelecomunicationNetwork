package dao.interfaces;

import entity.StubLink;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:28 AM
 */

public interface CableLinksDAO {

    List<Long> getLinkedStubLinkByStubLinkId(Long stubLinkId);

}
