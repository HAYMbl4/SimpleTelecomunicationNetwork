package dao.service;

import dao.interfaces.ConnectionPointDAO;
import entity.ConnectionPoint;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 13:34
 *
 */

public class ServiceConnectionPoint implements ConnectionPointDAO {

    public List<ConnectionPoint> getListConnectionPoint() {

        ServiceConnectionPoint sCP = new ServiceConnectionPoint();
        Session session = sCP.getSessionFactory().openSession();

        session.beginTransaction();

        Query query = session.createQuery("from ConnectionPoint");

        List<ConnectionPoint> cpList = query.list();
        for (ConnectionPoint cpL: cpList) {
            System.out.println(cpL.toString());
        }

        session.flush();
        session.close();

        return cpList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
