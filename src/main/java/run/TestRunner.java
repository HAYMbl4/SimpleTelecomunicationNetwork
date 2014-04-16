package run;

import dao.service.ServiceConnectionUnit;
import dao.service.ServiceNodeType;
import dao.service.ServiceStubLink;
import entity.Node;
import entity.NodeType;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:41
 *
 */
public class TestRunner {

    public static void main (String[] args) {

//        ServiceNodeType servNodeType = new ServiceNodeType();
//        servNodeType.getListNodeType();

//        ServiceNode servNode = new ServiceNode();
//        servNode.getListNode();

        ServiceConnectionUnit servCU = new ServiceConnectionUnit();
//        servCU.getListConnectionUnit();
//        NodeType nodeType = new NodeType();
//        nodeType.setNodeTypeId(6L);
//        nodeType.setNodeTypeName("Cross");
//        Node node = new Node();
//        node.setNodeId(2L);
//        node.setNodeName("1000");
//        node.setNodeType(nodeType);
        servCU.getCntUsedCpByCu(2L);

//        servCU.getConnectionUnitByNode(2L);

//        ServiceConnectionPoint servCP = new ServiceConnectionPoint();
//        servCP.getConnectionPointList();

        ServiceStubLink serviceStubLink = new ServiceStubLink();

        serviceStubLink.getStubLinksByCuId(2L);

    }

}
