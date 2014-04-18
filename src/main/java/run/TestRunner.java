package run;

import bean.ConnectionPointBean;
import dao.service.ServiceCableLinks;
import dao.service.ServiceConnectionUnit;
import dao.service.ServiceNodeType;
import dao.service.ServiceStubLink;
import entity.ConnectionUnit;
import entity.ConnectionUnitTable;
import entity.Node;
import entity.NodeType;

import java.util.ArrayList;
import java.util.List;

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
//        servCU.getCntUsedCpByCu(2L);

//        servCU.getConnectionUnitByNode(2L);

//        ServiceConnectionPoint servCP = new ServiceConnectionPoint();
//        servCP.getConnectionPointList();

        ServiceStubLink serviceStubLink = new ServiceStubLink();

//        serviceStubLink.getStubLinksByCuId(2L);
//        Long slId = serviceStubLink.getStubLinkIdByCpId(102L);
//        serviceStubLink.getStubLinkByStubLinkId(slId);

//        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
//        List<ConnectionUnit> listCU = new ArrayList<ConnectionUnit>();
//        listCU = serviceConnectionUnit.getConnectionUnitByNode(2L);
//        List<ConnectionUnitTable> listCUTable = new ArrayList<ConnectionUnitTable>();
////        for (int i = 0; i < listCU.size(); i++) {
//        for (ConnectionUnit lCU: listCU) {
//            Long freePair = lCU.getCapacity() - serviceConnectionUnit.getCntUsedCpByCu(lCU.getCuId());
//            System.out.println("создаем коллекцию: ОКУ " + lCU.getCuNumber() + ", кол-во свободных пар: " + freePair);
//            System.out.println(lCU.toString());
//            listCUTable.add(new ConnectionUnitTable(lCU,freePair));
//        }
//        for (ConnectionUnitTable CUTable: listCUTable) {
//            System.out.println(CUTable.getConnectionUnit().getCuNumber() + " - " + CUTable.getFreePair());
//        }
        // //////////////////////////////////////////
        // cable_links
        // //////////////////////////////////////////

        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
//        serviceCableLinks.getLinkedStubLinkByStubLinkId(2L);


        ConnectionPointBean connectionPointBean = new ConnectionPointBean();
        connectionPointBean.getListConnectionPointTable();

    }

}
