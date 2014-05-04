package dao.service;

import dao.interfaces.ConnectionPointDAO;
import entity.mapping.ConnectionPoint;
import entity.mapping.StubLink;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.NoSuchElementException;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 13:34
 *
 */

public class ServiceConnectionPoint implements ConnectionPointDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    // используется в ServiceCU для удаляения ОКУ
    public List<ConnectionPoint> getListConnectionPointByCuId(Long cuId) {

        ServiceConnectionPoint sCP = new ServiceConnectionPoint();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = sCP.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем точки для ОКУ с ID: " + cuId);
        Query query = session.createQuery("from ConnectionPoint where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);

        List<ConnectionPoint> cpList = query.list();
        for (ConnectionPoint cpL: cpList) {
            logger.trace(cpL.toString());
            System.out.println(cpL.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cpList;
    }

    public String usedCp(Long cpId) {

        ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceConnectionPoint.getSessionFactory().openSession();

        String usedCp;

        logger.info("----------------------------------------");
        logger.trace("Проверяем имеет ли пара подключения");
        Query query = session.createQuery("from StubLink where connectionPoint.cpId = :cpId");
        query.setParameter("cpId", cpId);
        try {
        StubLink stubLink = (StubLink) query.iterate().next();
            usedCp =  "Подключена";
            logger.trace("Пара с ID = " + cpId + " - имеет подключения");
        } catch (NoSuchElementException ex) {
            usedCp = "";
            logger.trace("Пара с ID = " + cpId + " - не имеет подключений");
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return usedCp;

    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
