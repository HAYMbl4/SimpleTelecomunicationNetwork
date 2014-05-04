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
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink,stubLink.getConnectionPoint().getCpName(),linkedStubLink.getConnectionPoint().getCpName()));
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
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink,stubLink.getConnectionPoint().getCpName(),linkedStubLink.getConnectionPoint().getCpName()));
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
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink,stubLink.getConnectionPoint().getCpName(),linkedStubLink.getConnectionPoint().getCpName()));
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
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink,stubLink.getConnectionPoint().getCpName(),linkedStubLink.getConnectionPoint().getCpName()));
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

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}