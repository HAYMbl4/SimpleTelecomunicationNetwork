package dao.service;

import dao.interfaces.StubLinkDAO;
import entity.mapping.ConnectionPoint;
import entity.mapping.StubLink;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.NoSuchElementException;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 11:08 PM
 */

public class ServiceStubLink implements StubLinkDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    // используется в ServiceCableLinks, для получения списка стабов по конкретному ОКУ
    public List<StubLink> getStubLinksByCuId(Long cuId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceStubLink.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем стабы для ОКУ с ID = " + cuId);
        Query query = session.createQuery("from StubLink where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);
        List<StubLink> stubLinkList = query.list();
        for (StubLink sl: stubLinkList) {
            logger.info("----------------------------------------");
            logger.trace(sl.toString());
            System.out.println(sl.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return stubLinkList;
    }

    // используется в ServiceCableLinks, для получения списка стабов по конкретному узлу
    public List<StubLink> getStubLinkByNodeId(Long nodeId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceStubLink.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем стабы для Узла с ID = " + nodeId);
        Query query = session.createQuery("from StubLink where node.nodeId = :nodeId");
        query.setParameter("nodeId",nodeId);
        List<StubLink> stubLinkList = query.list();
        for (StubLink sl: stubLinkList) {
            logger.info("----------------------------------------");
            logger.trace(sl.toString());
            System.out.println(sl.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return stubLinkList;
    }

    public StubLink createStubLink(Long cpId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();
        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceStubLink.getSessionFactory().openSession();
        session.beginTransaction();

        StubLink stubLink = null;
        logger.info("----------------------------------------");
        logger.trace("Ищем стаб линк для точки с ID = " + cpId);
        System.out.println("Ищем стаб линк для точки с ID = " + cpId);
        try {
            Query query = session.createQuery("from StubLink where connectionPoint.cpId = :cpId");
            query.setParameter("cpId", cpId);
            stubLink = (StubLink) query.iterate().next();
        } catch (NoSuchElementException ex) {
            logger.info("----------------------------------------");
            logger.trace("Стаб линка нет, создаем с параметрами: ");
            System.out.println("Стаб линка нет, создаем с параметрами: ");
        }

        if (stubLink != null) {
            logger.info("----------------------------------------");
            logger.trace("Стаб линк найден: ");
            System.out.println("Стаб линк найден: ");
            logger.trace(stubLink.toString());
            System.out.println(stubLink.toString());
        } else {
            ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();
            System.out.println("look cp");
            ConnectionPoint connectionPoint = serviceConnectionPoint.getConnectionPointByCpId(cpId);
            System.out.println("cp - " + connectionPoint.toString());
            logger.trace("NODE: " + connectionPoint.getConnectionUnit().getNode().toString());
            System.out.println("NODE: " + connectionPoint.getConnectionUnit().getNode().toString());
            logger.trace("CU: " + connectionPoint.getConnectionUnit().toString());
            System.out.println("CU: " + connectionPoint.getConnectionUnit().toString());
            logger.trace("CP: " + connectionPoint.toString());
            System.out.println("CP: " + connectionPoint.toString());
            stubLink = new StubLink(connectionPoint.getConnectionUnit().getNode(),connectionPoint.getConnectionUnit(),connectionPoint);
            session.save(stubLink);
            logger.info("----------------------------------------");
            logger.trace("Стаб линк создан");
        }

        session.getTransaction().commit();
        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return stubLink;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
