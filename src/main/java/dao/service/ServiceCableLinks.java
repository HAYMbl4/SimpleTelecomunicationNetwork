package dao.service;

import dao.interfaces.CableLinksDAO;
import entity.mapping.CableLink;
import entity.mapping.StubLink;
import entity.view.CableLinkTable;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:28 AM
 */

public class ServiceCableLinks implements CableLinksDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    // пока не используется, может понадобится

    public List<Long> getLinkedStubLinkByStubLinkId(Long stubLinkId) {
//
//        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
//        Session session = serviceCableLinks.getSessionFactory().openSession();
//
//        List<Long> linkedStubLinkList = new ArrayList<Long>();
//        Query query = session.createQuery("select linkedStubLink.stubLinkId from CableLink where stubLink.stubLinkId = :stubLinkId");
//        query.setParameter("stubLinkId",stubLinkId);
//        if (query.list().size() != 0) {
//           linkedStubLinkList.addAll(query.list());
//        }
//
//        query = session.createQuery("select stubLink.stubLinkId from CableLink where linkedStubLink.stubLinkId = :stubLinkId");
//        query.setParameter("stubLinkId",stubLinkId);
//        if (query.list().size() != 0) {
//            linkedStubLinkList.addAll(query.list());
//        }
//
//        for (Long sl: linkedStubLinkList) {
////            System.out.println(sl.toString());
//        }
//
//        session.close();
//
        return null;
    }

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

        // без этого SOUT начинает кидать ошибку "Exception in thread "main" org.hibernate.LazyInitializationException: could not initialize proxy - no Session"
        // todo: почему???
        for (CableLinkTable clT: cableLinkTableList) {
            System.out.println("clTable - " + clT.getStubLink().toString() + " - " + clT.getLinkedStubLink().toString() + clT.getStubLink().getNode().getNodeType().getNodeTypeShortName() + " - " +
                    clT.getLinkedStubLink().getNode().getNodeType().getNodeTypeShortName());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cableLinkTableList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
