package dao.service;

import dao.interfaces.NodeTypeDAO;
import entity.mapping.Node;
import entity.mapping.NodeType;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:41
 *
 */

public class ServiceNodeType implements NodeTypeDAO {

    private static final Logger logger = LoggerFactory.getLogger("progTrace");

    public List<String> getListNodeType () {

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNodeType.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Получаем cписок типов узлов: ");
        Query query = session.createQuery("select nodeTypeName from NodeType");
        List<String> nodeTypeList = query.list();
        for (String nt: nodeTypeList) {
            System.out.println(nt.toString());
            logger.trace(nt.toString());
        }

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return nodeTypeList;
    }

    public void createNodeType(NodeType nodeType) {

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNodeType.getSessionFactory().openSession();
        session.beginTransaction();
        logger.info("----------------------------------------");
        logger.trace("Создаем запись в таблице NODE_TYPE со следующими параметрами: ");
        logger.info("NODE_TYPE_NAME = " + nodeType.getNodeTypeName());
        logger.info("NODE_TYPE_SHORT_NAME = " + nodeType.getNodeTypeShortName());
        session.save(nodeType);
        session.getTransaction().commit();
        logger.info("----------------------------------------");
        logger.trace("Операция прошла успешно");
        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();
    }

    public NodeType getNodeTypeByName(String nodeTypeName) {

        ServiceNodeType serviceNodeType = new ServiceNodeType();

        logger.info("----------------------------------------");
        logger.trace("Открываем сессию");
        Session session = serviceNodeType.getSessionFactory().openSession();

        logger.info("----------------------------------------");
        logger.trace("Выполняем выборку на получения типа узла по названию: " + nodeTypeName);
        Query query = session.createQuery("from NodeType where nodeTypeName = :nodeTypeName");
        query.setParameter("nodeTypeName", nodeTypeName);
        NodeType nodeType = (NodeType) query.iterate().next();
        logger.trace(nodeType.toString());
        System.out.println(nodeType.toString());

        logger.info("----------------------------------------");
        logger.trace("Закрываем сессию");
        session.close();

        return nodeType;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
