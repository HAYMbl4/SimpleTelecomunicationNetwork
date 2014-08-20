package dao.interfaces;

import entity.mapping.NodeType;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 17:01
 *
 */

public interface NodeTypeDAO {

    List<String> getListNodeType();
    void createNodeType(NodeType nodeType);
    NodeType getNodeTypeByName(String nodeTypeName);

}
