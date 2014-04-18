package dao.service;

import dao.interfaces.ConnectionUnitDAO;
import entity.ConnectionUnit;
import entity.Node;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 01:02
 *
 */

public class ServiceConnectionUnit implements ConnectionUnitDAO {

    public List<ConnectionUnit> getListConnectionUnit () {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();
        Session session = sCU.getSessionFactory().openSession();

        session.beginTransaction();

        Query query = session.createQuery("from ConnectionUnit");
        List<ConnectionUnit> cuList = query.list();
        for (ConnectionUnit cuL: cuList) {
            System.out.println(cuL.toString());
        }

        session.flush();
        session.close();

        return cuList;
    }

    public List<ConnectionUnit> getConnectionUnitByNode(Long nodeId) {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();
        Session session = sCU.getSessionFactory().openSession();

//        session.beginTransaction();

        Query query = session.createQuery("from ConnectionUnit where node.nodeId = :nodeId");
        query.setParameter("nodeId",nodeId);
        List<ConnectionUnit> cuList = query.list();

        for(ConnectionUnit cuL: cuList) {
            System.out.println(cuL.toString());
        }

        session.flush();
        session.close();

        return cuList;
    }

    public Long getCntUsedCpByCu(Long cuId) {

        ServiceConnectionUnit sCU = new ServiceConnectionUnit();
        Session session = sCU.getSessionFactory().openSession();

//        session.beginTransaction();

        Query query = session.createQuery("select count(*) from StubLink where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);
        Long cntUsedCp = (Long) query.iterate().next();

        System.out.println("Количество занятых точек для ОКУ с ID = " + cuId + " равняется: " + cntUsedCp);

        session.close();

        return cntUsedCp;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
