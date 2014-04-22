package dao.interfaces;

import entity.mapping.Node;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 21:43
 *
 */

public interface NodeDAO {

    List<Node> getListNode();
    List<Node> getNodeByNodeTypeName(String nodeTypeName);
    Node getNodeById(Long nodeId);

}
