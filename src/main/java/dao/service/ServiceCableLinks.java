package dao.service;

import dao.interfaces.CableLinksDAO;
import entity.mapping.CableLink;
import entity.mapping.StubLink;
import entity.view.CableLinkGroup;
import entity.view.CableLinkTable;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;
import org.hibernate.transform.Transformers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:28 AM
 */

public class ServiceCableLinks implements CableLinksDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    public List<CableLinkTable> getCableLinksByNodeId(Long nodeId) {

        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();

        // получаем список стабов, по которым будем собирать подключения
        ServiceStubLink serviceStubLink = new ServiceStubLink();
        List<StubLink> stubLinkList = serviceStubLink.getStubLinkByNodeId(nodeId);

        List<CableLink> cableLinkList;

        // для сбора информации по подключениям
        List<CableLinkTable> cableLinkTableList = new ArrayList<CableLinkTable>();
        StubLink stubLink;
        StubLink linkedStubLink;
        //

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceCableLinks.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем подключения по полученным стабам");
        for (StubLink sl: stubLinkList) {
            Query query;
            logger.info("----------------------------------------");
            logger.trace("Ищем случаи, когда стаб с ID = " + sl.getStubLinkId() + " с левой стороны");
            query = session.createQuery("from CableLink where stubLink.stubLinkId = :stubLinkId");
            query.setParameter("stubLinkId", sl.getStubLinkId());
            if (query.list().size() != 0) {
                cableLinkList = query.list();
                // передаем данные в контейнер для отображения
                logger.info("----------------------------------------");
                logger.trace("Передаем в контейнер по подключениям следующие подключения:");
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getStubLink();
                    linkedStubLink = cl.getLinkedStubLink();
                    logger.trace(stubLink.toString() + " - " + linkedStubLink.toString());
                    cableLinkTableList.add(new CableLinkTable(stubLink, linkedStubLink));
                }
            }

            logger.info("----------------------------------------");
            logger.trace("Ищем случаи, когда стаб с ID = " + sl.getStubLinkId() + " с правой стороны");
            query = session.createQuery("from CableLink where linkedStubLink.stubLinkId = :stubLinkId");
            query.setParameter("stubLinkId", sl.getStubLinkId());
            logger.info("----------------------------------------");
            logger.trace("Передаем в контейнер по подключениям следующие подключения:");
            if (query.list().size() != 0) {
                cableLinkList = query.list();
                // передаем данные в контейнер для отображения, меняя направление
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getLinkedStubLink();
                    linkedStubLink = cl.getStubLink();
                    logger.trace(stubLink.toString() + " - " + linkedStubLink.toString());
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink));
                }
            }
        }

        for (CableLinkTable clT: cableLinkTableList) {
            System.out.println("От " + clT.getStubLink().toString() + " К " + clT.getLinkedStubLink().toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cableLinkTableList;
    }

    public List<CableLinkTable> getCableLinksByCuId(Long cuId) {

        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();

        // получаем список стабов, по которым будем собирать подключения
        ServiceStubLink serviceStubLink = new ServiceStubLink();
        List<StubLink> stubLinkList = serviceStubLink.getStubLinksByCuId(cuId);

        List<CableLink> cableLinkList;

        // для сбора информации по подключениям
        List<CableLinkTable> cableLinkTableList = new ArrayList<CableLinkTable>();
        StubLink stubLink;
        StubLink linkedStubLink;
        //

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceCableLinks.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем подключения по полученным стабам");
        for (StubLink sl: stubLinkList) {
            Query query;
            logger.info("----------------------------------------");
            logger.trace("Ищем случаи, когда стаб с ID = " + sl.getStubLinkId() + " с левой стороны");
            query = session.createQuery("from CableLink where stubLink.stubLinkId = :stubLinkId ");
            query.setParameter("stubLinkId", sl.getStubLinkId());
            if (query.list().size() != 0) {
                cableLinkList = query.list();
                // передаем данные в контейнер для отображения
                logger.info("----------------------------------------");
                logger.trace("Передаем в контейнер по подключениям следующие подключения:");
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getStubLink();
                    linkedStubLink = cl.getLinkedStubLink();
                    logger.trace(stubLink.toString() + " - " + linkedStubLink.toString());
                    cableLinkTableList.add(new CableLinkTable(stubLink, linkedStubLink));
                }
            }

            logger.info("----------------------------------------");
            logger.trace("Ищем случаи, когда стаб с ID = " + sl.getStubLinkId() + " с правой стороны");
            query = session.createQuery("from CableLink where linkedStubLink.stubLinkId = :stubLinkId");
            query.setParameter("stubLinkId", sl.getStubLinkId());
            logger.info("----------------------------------------");
            logger.trace("Передаем в контейнер по подключениям следующие подключения:");
            if (query.list().size() != 0) {
                cableLinkList = query.list();
                // передаем данные в контейнер для отображения, меняя направление
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getLinkedStubLink();
                    linkedStubLink = cl.getStubLink();
                    logger.trace(stubLink.toString() + " - " + linkedStubLink.toString());
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink));
                }
            }
        }

        for (CableLinkTable clT: cableLinkTableList) {
            System.out.println("От " + clT.getStubLink().toString() + " К " + clT.getLinkedStubLink().toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cableLinkTableList;
    }

    public List<CableLinkGroup> getCableLinkGroupByNode(Long nodeId) {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        Session session = serviceCableLinks.getSessionFactory().openSession();
        Query query = session.createSQLQuery
               ("SELECT \n" +
                "  to_char(n.node_id) as \"nodeId\",\n" +
                "  to_char(n.node_name) as \"nodeName\",\n" +
                "  to_char(cu.cu_number) as \"cuName\",\n" +
                "  to_char(cu.cu_id) as \"cuId\",\n" +
                "  to_char(cp.cp_name) as \"firstCpName\",\n" +
                "  to_char(cp.cp_name) as \"endCpName\",\n" +
                "  to_char(ln.node_name) as \"linkedNodeName\",\n" +
                "  to_char(ln.node_id) as \"linkedNodeId\",\n" +
                "  to_char(lcu.cu_number) as \"linkedCuName\",\n" +
                "  to_char(lcu.cu_id) as \"linkedCuId\",\n" +
                "  to_char(lcp.cp_name) as \"linkedFirstCpName\",\n" +
                "  to_char(lcp.cp_name) as \"linkedEndCpName\"\n" +
                "FROM cable_link cl,\n" +
                "  stub_link sl,\n" +
                "  stub_link lsl,\n" +
                "  connection_point cp,\n" +
                "  connection_point lcp,\n" +
                "  connection_unit cu,\n" +
                "  connection_unit lcu,\n" +
                "  node n,\n" +
                "  node ln\n" +
                "WHERE cl.stub_link_id      = sl.stub_link_id\n" +
                "AND cl.linked_stub_link_id = lsl.stub_link_id\n" +
                "AND sl.cp_id               = cp.cp_id\n" +
                "AND lsl.cp_id              = lcp.cp_id\n" +
                "AND sl.cu_id = cu.cu_id\n" +
                "AND lsl.cu_id = lcu.cu_id\n" +
                "AND sl.node_id = n.node_id\n" +
                "AND lsl.node_id = ln.node_id\n" +
                "AND n.node_id = :nodeId\n" +
                "UNION\n" +
                "SELECT \n" +
                "  to_char(ln.node_id) as \"nodeId\",\n" +
                "  to_char(ln.node_name) as \"nodeName\",\n" +
                "  to_char(lcu.cu_number) as \"cuName\",\n" +
                "  to_char(lcu.cu_id) as \"cuId\",\n" +
                "  to_char(lcp.cp_name) as \"firstCpName\",\n" +
                "  to_char(lcp.cp_name) as \"endCpName\",\n" +
                "  to_char(n.node_name) as \"linkedNodeName\",\n" +
                "  to_char(n.node_id) as \"linkedNodeId\",\n" +
                "  to_char(cu.cu_number) as \"linkedCuName\",\n" +
                "  to_char(cu.cu_id) as \"linkedCuId\",\n" +
                "  to_char(cp.cp_name) as \"linkedFirstCpName\",\n" +
                "  to_char(cp.cp_name) as \"linkedEndCpName\"\n" +
                "FROM cable_link cl,\n" +
                "  stub_link sl,\n" +
                "  stub_link lsl,\n" +
                "  connection_point cp,\n" +
                "  connection_point lcp,\n" +
                "  connection_unit cu,\n" +
                "  connection_unit lcu,\n" +
                "  node n,\n" +
                "  node ln\n" +
                "WHERE cl.stub_link_id      = sl.stub_link_id\n" +
                "AND cl.linked_stub_link_id = lsl.stub_link_id\n" +
                "AND sl.cp_id               = cp.cp_id\n" +
                "AND lsl.cp_id              = lcp.cp_id\n" +
                "AND sl.cu_id = cu.cu_id\n" +
                "AND lsl.cu_id = lcu.cu_id\n" +
                "AND sl.node_id = n.node_id\n" +
                "AND lsl.node_id = ln.node_id\n" +
                "AND ln.node_id = :nodeId\n" +
                "ORDER BY 4,10,5").setResultTransformer(Transformers.aliasToBean(CableLinkGroup.class));
        query.setParameter("nodeId", nodeId);
        List<CableLinkGroup> cableLinkGroupList = query.list();

        ArrayList<CableLinkGroup> groupCLGList = new ArrayList<CableLinkGroup>();

        int minPairNum;
        int maxPairNum;
        int i;
        for (int j = 0; j < cableLinkGroupList.size()-1; j++) {
           minPairNum = j;
           maxPairNum = j;
            i = j;
            int k = 0;
            while ((Long.parseLong(cableLinkGroupList.get(i).getNodeId()) == Long.parseLong(cableLinkGroupList.get(i+1).getNodeId())) &
                   (Long.parseLong(cableLinkGroupList.get(i).getLinkedNodeId()) == Long.parseLong(cableLinkGroupList.get(i+1).getLinkedNodeId())) &
                   (Long.parseLong(cableLinkGroupList.get(i).getCuId()) == Long.parseLong(cableLinkGroupList.get(i+1).getCuId())) &
                   (Long.parseLong(cableLinkGroupList.get(i).getLinkedCuId()) == Long.parseLong(cableLinkGroupList.get(i+1).getLinkedCuId())) &
                   (Integer.parseInt(cableLinkGroupList.get(i).getFirstCpName()) == Integer.parseInt(cableLinkGroupList.get(i+1).getFirstCpName()) - 1) &
                   (Integer.parseInt(cableLinkGroupList.get(i).getLinkedFirstCpName()) == Integer.parseInt(cableLinkGroupList.get(i+1).getLinkedFirstCpName()) - 1) &
                    (i < cableLinkGroupList.size()-2)
                   )
                {
                    maxPairNum = i+1;
                    i++;
                    k++;
                }
            groupCLGList.add(new CableLinkGroup(
                                                        cableLinkGroupList.get(minPairNum).getNodeId(),
                                                        cableLinkGroupList.get(minPairNum).getNodeName(),
                                                        cableLinkGroupList.get(minPairNum).getCuName(),
                                                        cableLinkGroupList.get(minPairNum).getCuId(),
                                                        cableLinkGroupList.get(minPairNum).getFirstCpName(),
                                                        cableLinkGroupList.get(maxPairNum).getEndCpName(),
                                                        cableLinkGroupList.get(minPairNum).getLinkedNodeId(),
                                                        cableLinkGroupList.get(minPairNum).getLinkedNodeName(),
                                                        cableLinkGroupList.get(minPairNum).getLinkedCuName(),
                                                        cableLinkGroupList.get(minPairNum).getLinkedCuId(),
                                                        cableLinkGroupList.get(minPairNum).getLinkedFirstCpName(),
                                                        cableLinkGroupList.get(maxPairNum).getLinkedEndCpName()
                                                      ));
            j = j+k;
            if (j == cableLinkGroupList.size()-2) {
                groupCLGList.add(new CableLinkGroup(
                        cableLinkGroupList.get(j+1).getNodeId(),
                        cableLinkGroupList.get(j+1).getNodeName(),
                        cableLinkGroupList.get(j+1).getCuName(),
                        cableLinkGroupList.get(j+1).getCuId(),
                        cableLinkGroupList.get(j+1).getFirstCpName(),
                        cableLinkGroupList.get(j+1).getEndCpName(),
                        cableLinkGroupList.get(j+1).getLinkedNodeId(),
                        cableLinkGroupList.get(j+1).getLinkedNodeName(),
                        cableLinkGroupList.get(j+1).getLinkedCuName(),
                        cableLinkGroupList.get(j+1).getLinkedCuId(),
                        cableLinkGroupList.get(j+1).getLinkedFirstCpName(),
                        cableLinkGroupList.get(j+1).getLinkedEndCpName()
                ));
            }
        }

        for (CableLinkGroup clG: groupCLGList) {
            System.out.println(clG.getCuName() + "(" + clG.getFirstCpName() + "-" + clG.getEndCpName() + ")   к   " +
                    clG.getLinkedCuName() + "(" + clG.getLinkedFirstCpName() + "-" + clG.getLinkedEndCpName() + ")" );
        }

        return groupCLGList;

    }

    public List<CableLinkGroup> getCableLinkGroupByCU(Long cuId) {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        Session session = serviceCableLinks.getSessionFactory().openSession();
        Query query = session.createSQLQuery
                ("SELECT \n" +
                        "  to_char(n.node_id) as \"nodeId\",\n" +
                        "  to_char(n.node_name) as \"nodeName\",\n" +
                        "  to_char(cu.cu_number) as \"cuName\",\n" +
                        "  to_char(cu.cu_id) as \"cuId\",\n" +
                        "  to_char(cp.cp_name) as \"firstCpName\",\n" +
                        "  to_char(cp.cp_name) as \"endCpName\",\n" +
                        "  to_char(ln.node_name) as \"linkedNodeName\",\n" +
                        "  to_char(ln.node_id) as \"linkedNodeId\",\n" +
                        "  to_char(lcu.cu_number) as \"linkedCuName\",\n" +
                        "  to_char(lcu.cu_id) as \"linkedCuId\",\n" +
                        "  to_char(lcp.cp_name) as \"linkedFirstCpName\",\n" +
                        "  to_char(lcp.cp_name) as \"linkedEndCpName\"\n" +
                        "FROM cable_link cl,\n" +
                        "  stub_link sl,\n" +
                        "  stub_link lsl,\n" +
                        "  connection_point cp,\n" +
                        "  connection_point lcp,\n" +
                        "  connection_unit cu,\n" +
                        "  connection_unit lcu,\n" +
                        "  node n,\n" +
                        "  node ln\n" +
                        "WHERE cl.stub_link_id      = sl.stub_link_id\n" +
                        "AND cl.linked_stub_link_id = lsl.stub_link_id\n" +
                        "AND sl.cp_id               = cp.cp_id\n" +
                        "AND lsl.cp_id              = lcp.cp_id\n" +
                        "AND sl.cu_id = cu.cu_id\n" +
                        "AND lsl.cu_id = lcu.cu_id\n" +
                        "AND sl.node_id = n.node_id\n" +
                        "AND lsl.node_id = ln.node_id\n" +
                        "AND cu.cu_id = :cuId\n" +
                        "UNION\n" +
                        "SELECT \n" +
                        "  to_char(ln.node_id) as \"nodeId\",\n" +
                        "  to_char(ln.node_name) as \"nodeName\",\n" +
                        "  to_char(lcu.cu_number) as \"cuName\",\n" +
                        "  to_char(lcu.cu_id) as \"cuId\",\n" +
                        "  to_char(lcp.cp_name) as \"firstCpName\",\n" +
                        "  to_char(lcp.cp_name) as \"endCpName\",\n" +
                        "  to_char(n.node_name) as \"linkedNodeName\",\n" +
                        "  to_char(n.node_id) as \"linkedNodeId\",\n" +
                        "  to_char(cu.cu_number) as \"linkedCuName\",\n" +
                        "  to_char(cu.cu_id) as \"linkedCuId\",\n" +
                        "  to_char(cp.cp_name) as \"linkedFirstCpName\",\n" +
                        "  to_char(cp.cp_name) as \"linkedEndCpName\"\n" +
                        "FROM cable_link cl,\n" +
                        "  stub_link sl,\n" +
                        "  stub_link lsl,\n" +
                        "  connection_point cp,\n" +
                        "  connection_point lcp,\n" +
                        "  connection_unit cu,\n" +
                        "  connection_unit lcu,\n" +
                        "  node n,\n" +
                        "  node ln\n" +
                        "WHERE cl.stub_link_id      = sl.stub_link_id\n" +
                        "AND cl.linked_stub_link_id = lsl.stub_link_id\n" +
                        "AND sl.cp_id               = cp.cp_id\n" +
                        "AND lsl.cp_id              = lcp.cp_id\n" +
                        "AND sl.cu_id = cu.cu_id\n" +
                        "AND lsl.cu_id = lcu.cu_id\n" +
                        "AND sl.node_id = n.node_id\n" +
                        "AND lsl.node_id = ln.node_id\n" +
                        "AND lcu.cu_id = :cuId\n" +
                        "ORDER BY 4,10,5").setResultTransformer(Transformers.aliasToBean(CableLinkGroup.class));
        query.setParameter("cuId", cuId);
        List<CableLinkGroup> cableLinkGroupList = query.list();

        ArrayList<CableLinkGroup> groupCLGList = new ArrayList<CableLinkGroup>();

        int minPairNum;
        int maxPairNum;
        int i;
        System.out.println("size - " + cableLinkGroupList.size());
        for (int j = 0; j < cableLinkGroupList.size()-1; j++) {
            minPairNum = j;
            maxPairNum = j;
            i = j;
            int k = 0;
            while ((Long.parseLong(cableLinkGroupList.get(i).getNodeId()) == Long.parseLong(cableLinkGroupList.get(i+1).getNodeId())) &
                    (Long.parseLong(cableLinkGroupList.get(i).getLinkedNodeId()) == Long.parseLong(cableLinkGroupList.get(i+1).getLinkedNodeId())) &
                    (Long.parseLong(cableLinkGroupList.get(i).getCuId()) == Long.parseLong(cableLinkGroupList.get(i+1).getCuId())) &
                    (Long.parseLong(cableLinkGroupList.get(i).getLinkedCuId()) == Long.parseLong(cableLinkGroupList.get(i+1).getLinkedCuId())) &
                    (Integer.parseInt(cableLinkGroupList.get(i).getFirstCpName()) == Integer.parseInt(cableLinkGroupList.get(i+1).getFirstCpName()) - 1) &
                    (Integer.parseInt(cableLinkGroupList.get(i).getLinkedFirstCpName()) == Integer.parseInt(cableLinkGroupList.get(i+1).getLinkedFirstCpName()) - 1) &
                    (i < cableLinkGroupList.size()-2)
                    )
            {
                maxPairNum = i+1;
                i++;
                k++;
            }
            groupCLGList.add(new CableLinkGroup(
                    cableLinkGroupList.get(minPairNum).getNodeId(),
                    cableLinkGroupList.get(minPairNum).getNodeName(),
                    cableLinkGroupList.get(minPairNum).getCuName(),
                    cableLinkGroupList.get(minPairNum).getCuId(),
                    cableLinkGroupList.get(minPairNum).getFirstCpName(),
                    cableLinkGroupList.get(maxPairNum).getEndCpName(),
                    cableLinkGroupList.get(minPairNum).getLinkedNodeId(),
                    cableLinkGroupList.get(minPairNum).getLinkedNodeName(),
                    cableLinkGroupList.get(minPairNum).getLinkedCuName(),
                    cableLinkGroupList.get(minPairNum).getLinkedCuId(),
                    cableLinkGroupList.get(minPairNum).getLinkedFirstCpName(),
                    cableLinkGroupList.get(maxPairNum).getLinkedEndCpName()
            ));
            j = j+k;
            if (j == cableLinkGroupList.size()-2) {
                groupCLGList.add(new CableLinkGroup(
                        cableLinkGroupList.get(j+1).getNodeId(),
                        cableLinkGroupList.get(j+1).getNodeName(),
                        cableLinkGroupList.get(j+1).getCuName(),
                        cableLinkGroupList.get(j+1).getCuId(),
                        cableLinkGroupList.get(j+1).getFirstCpName(),
                        cableLinkGroupList.get(j+1).getEndCpName(),
                        cableLinkGroupList.get(j+1).getLinkedNodeId(),
                        cableLinkGroupList.get(j+1).getLinkedNodeName(),
                        cableLinkGroupList.get(j+1).getLinkedCuName(),
                        cableLinkGroupList.get(j+1).getLinkedCuId(),
                        cableLinkGroupList.get(j+1).getLinkedFirstCpName(),
                        cableLinkGroupList.get(j+1).getLinkedEndCpName()
                ));
            }
        }

        for (CableLinkGroup clG: groupCLGList) {
            System.out.println(clG.getCuName() + "(" + clG.getFirstCpName() + "-" + clG.getEndCpName() + ")   к   " +
                    clG.getLinkedCuName() + "(" + clG.getLinkedFirstCpName() + "-" + clG.getLinkedEndCpName() + ")" );
        }

        return groupCLGList;

    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}