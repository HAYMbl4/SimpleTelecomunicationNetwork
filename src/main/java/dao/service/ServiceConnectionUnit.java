package dao.service;

import dao.interfaces.ConnectionUnitDAO;
import entity.mapping.ConnectionPoint;
import entity.mapping.ConnectionUnit;
import entity.mapping.Node;
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

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = sCU.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Получаем список всех ОКУ:");
        Query query = session.createQuery("from ConnectionUnit");
        List<ConnectionUnit> cuList = query.list();
        for (ConnectionUnit cuL: cuList) {
            logger.trace(cuL.toString());
            System.out.println(cuL.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cuList;
    }

    // используется в cuBean для получения списка ОКУ по конкретному узлу
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

    // используется в cuBean, для получения кол-ва используемых в ОКУ точек
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

    // используется в clBean, для формирования наименования ОКУ, по которому выбираются подключения
    public ConnectionUnit getCuByCuId(Long cuId) {

        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceConnectionUnit.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Получаем ОКУ по ID = " + cuId);
        Query query = session.createQuery("from ConnectionUnit where cuId = :cuId");
        query.setParameter("cuId", cuId);
        ConnectionUnit connectionUnit = (ConnectionUnit) query.iterate().next();
        logger.trace(connectionUnit.toString());
        System.out.println(connectionUnit.toString());

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return connectionUnit;
    }

    public void createConnectionUnit(ConnectionUnit connectionUnit) {

        Session session = null;

        try {
            ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
            logger.info("----------------------------------------");
            logger.trace("Открываем сессию");
            session = serviceConnectionUnit.getSessionFactory().openSession();
            session.beginTransaction();
            logger.info("----------------------------------------");
            logger.trace("Создаем запись в таблице CONNECTION_UNIT, с параметрами: " + connectionUnit.toString());
            System.out.println("Создаем запись в таблице CONNECTION_UNIT, с параметрами: " + connectionUnit.toString());
            session.save(connectionUnit);
            logger.info("----------------------------------------");
            logger.trace("Для созданного ОКУ создаем точки:");
            System.out.println("Для созданного ОКУ создаем точки:");
            for (Long i = connectionUnit.getFirstPair(); i < connectionUnit.getCapacity(); i++) {
                ConnectionPoint connectionPoint = new ConnectionPoint(i,connectionUnit);
                logger.trace(connectionPoint.toString());
                System.out.println(connectionPoint.toString());
                session.save(connectionPoint);
            }
            session.getTransaction().commit();
            System.out.println("commit");
        } catch (Exception ex) {
            logger.trace("Ошибка при создании ОКУ: ", ex);
            session.getTransaction().rollback();
            ex.printStackTrace();

        } finally {
            logger.info("----------------------------------------");
            logger.trace("Закрываем сессию");
            session.close();
        }
    }

    public void deleteConnectionUnit(ConnectionUnit connectionUnit) {

        Session session = null;

        try {
            ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
            logger.info("----------------------------------------");
            logger.trace("Открываем сессию");
            session = serviceConnectionUnit.getSessionFactory().openSession();
            session.beginTransaction();
            logger.info("----------------------------------------");
            logger.trace("Удаляем точки ОКУ: ");
            ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();
            List<ConnectionPoint> connectionPointList = serviceConnectionPoint.getListConnectionPointByCuId(connectionUnit.getCuId());
            for (int i = 0; i < connectionPointList.size(); i++) {
                logger.trace(connectionPointList.get(i).toString());
                session.delete(connectionPointList.get(i));
            }
            logger.info("----------------------------------------");
            logger.trace("Удаляем сам коннектор: ");
            session.delete(connectionUnit);
            session.getTransaction().commit();
            logger.info("----------------------------------------");
            logger.trace("ОКУ удален успешно");
        } catch (Exception ex) {
            session.getTransaction().rollback();
            logger.trace("При удалении ОКУ возникли ошибки: ", ex);
        } finally {
            logger.info("----------------------------------------");
            logger.trace("Закрываем сессию");
            session.close();
        }

    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
