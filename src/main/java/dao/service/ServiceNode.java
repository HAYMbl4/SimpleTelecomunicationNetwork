package dao.service;

import dao.interfaces.NodeDAO;
import entity.mapping.Node;
import entity.mapping.NodeType;
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

    public List<Node> getNodeByNodeTypeName(String nodeTypeName) {

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNodeType.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Получаем список узлов по типу: " + nodeTypeName);
        Query query = session.createQuery("from NodeType where nodeTypeName = :nodeTypeName");
        query.setParameter("nodeTypeName",nodeTypeName);
        NodeType nodeType = (NodeType) query.iterate().next();
        List<Node> nodeList = nodeType.getNodeList();
        for (Node n: nodeList) {
            logger.trace(n.toString());
            System.out.println(n.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return nodeList;
    }

    public Node getNodeById(Long nodeId) {

        ServiceNode serviceNode = new ServiceNode();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNode.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Получаем узел по ID = " + nodeId);
        Query query = session.createQuery("from Node where nodeId = :nodeId");
        query.setParameter("nodeId", nodeId);
        Node node = (Node) query.iterate().next();
        logger.trace(node.toString());
        System.out.println(node.toString());

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return node;

    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }
}
