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

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
