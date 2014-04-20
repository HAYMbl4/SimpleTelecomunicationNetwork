package dao.service;

import dao.interfaces.NodeDAO;
import entity.mapping.Node;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 23:52
 *
 */

public class ServiceNode implements NodeDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    public List<Node> getListNode() {

//        Logger logger = Logger.getLogger("progTrace");

        ServiceNode sn = new ServiceNode();
        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = sn.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выбираем все записи из таблицы NODE");
        Query query = session.createQuery("from Node");
        List<Node> nodeList = query.list();

        logger.info("----------------------------------------");
        logger.trace("Для отображения выбрали следующие записи:");
        for (Node n: nodeList) {
            logger.trace(n.toString());
            System.out.println(n.toString());
        }
        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return nodeList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }
}
