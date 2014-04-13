package dao.service;

import dao.interfaces.NodeTypeDAO;
import entity.NodeType;
import org.hibernate.Query;
        import org.hibernate.Session;
        import org.hibernate.SessionFactory;
        import org.hibernate.cfg.Configuration;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:41
 *
 */

public class ServiceNodeType implements NodeTypeDAO {

    public List<NodeType> getListNodeType () {

        List<NodeType> nodeTypeList = null;

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        Session session = serviceNodeType.getSessionFactory().openSession();
        session.beginTransaction();

        Query query = session.createQuery("from NodeType");
        nodeTypeList = query.list();
        for (NodeType nt: nodeTypeList) {
            System.out.println(nt.toString());
        }

        session.flush();
        session.close();

        return nodeTypeList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
