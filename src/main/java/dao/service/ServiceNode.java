package dao.service;

import dao.interfaces.NodeDAO;
import entity.Node;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 23:52
 *
 */

public class ServiceNode implements NodeDAO {

    public List<Node> getListNode() {

        ServiceNode sn = new ServiceNode();
        Session session = sn.getSessionFactory().openSession();

        session.beginTransaction();

        Query query = session.createQuery("from Node");
        List<Node> nodeList = query.list();
        for (Node n: nodeList) {
            System.out.println(n.toString());
        }

        session.flush();
        session.close();

        return nodeList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }
}
