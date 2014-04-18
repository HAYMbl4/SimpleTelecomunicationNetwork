package dao.service;

import dao.interfaces.CableLinksDAO;
import entity.StubLink;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;

import java.util.ArrayList;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:28 AM
 */

public class ServiceCableLinks implements CableLinksDAO {

    public List<Long> getLinkedStubLinkByStubLinkId(Long stubLinkId) {

        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        Session session = serviceCableLinks.getSessionFactory().openSession();

        List<Long> linkedStubLinkList = new ArrayList<Long>();
        Query query = session.createQuery("select linkedStubLink.stubLinkId from CableLinks where stubLink.stubLinkId = :stubLinkId");
        query.setParameter("stubLinkId",stubLinkId);
        if (query.list().size() != 0) {
           linkedStubLinkList.addAll(query.list());
        }

        query = session.createQuery("select stubLink.stubLinkId from CableLinks where linkedStubLink.stubLinkId = :stubLinkId");
        query.setParameter("stubLinkId",stubLinkId);
        if (query.list().size() != 0) {
            linkedStubLinkList.addAll(query.list());
        }

        for (Long sl: linkedStubLinkList) {
//            System.out.println(sl.toString());
        }

        session.flush();
        session.close();

        return linkedStubLinkList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
