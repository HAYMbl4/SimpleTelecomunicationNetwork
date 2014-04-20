package dao.service;

import dao.interfaces.StubLinkDAO;
import entity.mapping.StubLink;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 11:08 PM
 */

public class ServiceStubLink implements StubLinkDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

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

    //todo: пока не используется, но будет нужен, при создании подкючения, возможно при просмотре подключений по точке

    public Long getStubLinkIdByCpId(Long cpId) {
//
//        ServiceStubLink serviceStubLink = new ServiceStubLink();
//
//        logger.info("----------------------------------------");
//        logger.trace("Открываем сессию");
//        Session session = serviceStubLink.getSessionFactory().openSession();
//
//        Long stubLinkId;
//        try {
//        Query query = session.createQuery("select stubLinkId from StubLink where connectionPoint.cpId = :cpId");
//        query.setParameter("cpId", cpId);
//            stubLinkId = (Long) query.iterate().next();
//        System.out.println("Для точки с ID = " + cpId + " подобран стаб с ID " + stubLinkId);
//        } catch (Exception ex) {
//            stubLinkId = null;
//        }
//
//        logger.info("----------------------------------------");
//        logger.trace("Закрываем сессию");
//        session.close();
//
        return null;
    }

    // Скорее всего данный метод не понадобится

    public StubLink getStubLinkByStubLinkId(Long stubLinkId) {
//
//        ServiceStubLink serviceStubLink = new ServiceStubLink();
//        Session session = serviceStubLink.getSessionFactory().openSession();
//
//        session.beginTransaction();
//
//        Query query = session.createQuery("from StubLink where stubLinkId = :stubLinkId");
//        query.setParameter("stubLinkId",stubLinkId);
//        StubLink stubLink = (StubLink) query.iterate().next();
//
//        System.out.println(stubLink.toString());
//
//        session.close();
//
        return null;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
