package dao.service;

import dao.interfaces.ConnectionPointDAO;
import entity.mapping.ConnectionPoint;
import entity.mapping.StubLink;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.List;
import java.util.NoSuchElementException;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 13:34
 *
 */

public class ServiceConnectionPoint implements ConnectionPointDAO {

    public List<ConnectionPoint> getListConnectionPointByCuId(Long cuId) {

        ServiceConnectionPoint sCP = new ServiceConnectionPoint();
        Session session = sCP.getSessionFactory().openSession();

        Query query = session.createQuery("from ConnectionPoint where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);

        List<ConnectionPoint> cpList = query.list();
        for (ConnectionPoint cpL: cpList) {
            System.out.println(cpL.toString());
        }

        session.close();

        return cpList;
    }

    public String usedCp(Long cpId) {

        ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();

        Session session = serviceConnectionPoint.getSessionFactory().openSession();

        Query query = session.createQuery("from StubLink where connectionPoint.cpId = :cpId");
        query.setParameter("cpId", cpId);
        try {
        StubLink stubLink = (StubLink) query.iterate().next();
            return "Подключена";
        } catch (NoSuchElementException ex) {
            return "";
        }
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
