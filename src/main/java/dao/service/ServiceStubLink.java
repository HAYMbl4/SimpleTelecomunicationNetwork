package dao.service;

import dao.interfaces.StubLinkDAO;
import entity.StubLink;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;

import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 11:08 PM
 */

public class ServiceStubLink implements StubLinkDAO {

    public List<StubLink> getStubLinksByCuId(Long cuId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();
        Session session = serviceStubLink.getSessionFactory().openSession();

//        session.beginTransaction();

        Query query = session.createQuery("from StubLink where connectionUnit.cuId = :cuId");
        query.setParameter("cuId",cuId);
        List<StubLink> stubLinkList = query.list();
        for (StubLink sl: stubLinkList) {
            System.out.println(sl.toString());
        }

//        session.flush();
        session.close();

        return stubLinkList;

    }

    public Long getStubLinkIdByCpId(Long cpId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();
        Session session = serviceStubLink.getSessionFactory().openSession();

//        session.beginTransaction();

        Long stubLinkId;
        try {
        Query query = session.createQuery("select stubLinkId from StubLink where connectionPoint.cpId = :cpId");
        query.setParameter("cpId", cpId);
            stubLinkId = (Long) query.iterate().next();
        System.out.println("Для точки с ID = " + cpId + " подобран стаб с ID " + stubLinkId);
        } catch (Exception ex) {
            stubLinkId = null;
        }

        session.flush();
        session.close();

        return stubLinkId;
    }

    public StubLink getStubLinkByStubLinkId(Long stubLinkId) {

        ServiceStubLink serviceStubLink = new ServiceStubLink();
        Session session = serviceStubLink.getSessionFactory().openSession();

        session.beginTransaction();

        Query query = session.createQuery("from StubLink where stubLinkId = :stubLinkId");
        query.setParameter("stubLinkId",stubLinkId);
        StubLink stubLink = (StubLink) query.iterate().next();

        System.out.println(stubLink.toString());

        session.flush();
        session.close();

        return stubLink;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
