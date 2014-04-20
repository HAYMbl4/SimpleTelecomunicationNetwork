package dao.service;

import dao.interfaces.ConnectionUnitDAO;
import entity.mapping.ConnectionUnit;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 01:02
 *
 */

public class ServiceConnectionUnit implements ConnectionUnitDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    public List<ConnectionUnit> getListConnectionUnit () {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();
        Session session = sCU.getSessionFactory().openSession();


        Query query = session.createQuery("from ConnectionUnit");
        List<ConnectionUnit> cuList = query.list();
        for (ConnectionUnit cuL: cuList) {
            System.out.println(cuL.toString());
        }

        session.close();

        return cuList;
    }

    public List<ConnectionUnit> getConnectionUnitByNode(Long nodeId) {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = sCU.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем ОКУ для узла с ID = " + nodeId);
        Query query = session.createQuery("from ConnectionUnit where node.nodeId = :nodeId");
        query.setParameter("nodeId",nodeId);
        List<ConnectionUnit> cuList = query.list();
        for(ConnectionUnit cuL: cuList) {
            logger.trace(cuL.toString());
            System.out.println(cuL.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cuList;
    }

    public Long getCntUsedCpByCu(Long cuId) {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = sCU.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Проверям сколько занятых точек для ОКУ с ID = " + cuId);
        Query query = session.createQuery("select count(*) from StubLink where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);
        Long cntUsedCp = (Long) query.iterate().next();

        logger.info("----------------------------------------");
        logger.trace("Занято " + cntUsedCp + " точек");
        System.out.println("Количество занятых точек для ОКУ с ID = " + cuId + " равняется: " + cntUsedCp);

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cntUsedCp;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
