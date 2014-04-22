package dao.service;

import dao.interfaces.NodeTypeDAO;
import entity.mapping.Node;
import entity.mapping.NodeType;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:41
 *
 */

public class ServiceNodeType implements NodeTypeDAO {

    public List<String> getListNodeType () {

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        Session session = serviceNodeType.getSessionFactory().openSession();

        Query query = session.createQuery("select nodeTypeName from NodeType");
        List<String> nodeTypeList = query.list();
        for (String nt: nodeTypeList) {
            System.out.println(nt);
        }

        session.close();

        return nodeTypeList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
