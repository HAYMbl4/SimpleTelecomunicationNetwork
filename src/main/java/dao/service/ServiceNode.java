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

    // Используется в nodeBean, для получения списка узлов, когда выбран параметр "All"
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

    // Используется в nodeBean, для получения списка узлов, по конкретному типу узла
    public List<Node> getNodeByNodeTypeName(String nodeTypeName) {

        ServiceNode serviceNode = new ServiceNode();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNode.getSessionFactory().openSession();

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

    // используется в cuBean, для формирования Наименования узла
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

    public void createNode(Node node) {

        ServiceNode serviceNode = new ServiceNode();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNode.getSessionFactory().openSession();
        session.beginTransaction();
        logger.info("----------------------------------------");
        logger.trace("Создаем запись в таблице NODE, с парметрами: ");
        logger.info(node.toString());
        session.save(node);
        session.getTransaction().commit();

        logger.info("----------------------------------------");
        logger.trace("Операция прошла успешно");

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

    }

    public void deleteNode(Node node) {

        Session session = null;

        try {
            ServiceNode serviceNode = new ServiceNode();

            logger.info("----------------------------------------");
            logger.trace("Открываем сессию");
            session = serviceNode.getSessionFactory().openSession();
            session.beginTransaction();
            logger.info("----------------------------------------");
            logger.trace("Удаляем запись из таблице NODE: ");
            logger.trace(node.toString());
            session.delete(node);
            session.getTransaction().commit();
            logger.info("----------------------------------------");
            logger.trace("Операция прошла успешно");
        } catch (Exception ex) {
            logger.info("----------------------------------------");
            logger.trace("Возникла ошибка: ", ex);
            session.getTransaction().rollback();
        } finally {
            logger.info("----------------------------------------");
            logger.trace("Закрываем сессию");
            session.close();
        }
    }

    // используется в nodeBean для проверки наличия у узла ОКУ, перед удалением
    public Long cntCUinNode(Long nodeId) {

        ServiceNode serviceNode = new ServiceNode();
        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNode.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выполняем запрос на получения кол-ва ОКУ, которые есть в узле с ID = " + nodeId);
        Query query = session.createQuery("select count(*) from ConnectionUnit where node.nodeId = :nodeId");
        query.setParameter("nodeId", nodeId);
        Long cntCu = (Long) query.iterate().next();
        logger.trace("У узла есть " + cntCu + " ОКУ");
        System.out.println("У узла есть " + cntCu + " ОКУ");

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return cntCu;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }
}
