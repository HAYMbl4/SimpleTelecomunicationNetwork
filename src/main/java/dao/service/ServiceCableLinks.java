package dao.service;

import dao.interfaces.CableLinksDAO;
import entity.mapping.CableLink;
import entity.mapping.StubLink;
import entity.view.CableLinkTable;
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
        Query query = session.createQuery("select linkedStubLink.stubLinkId from CableLink where stubLink.stubLinkId = :stubLinkId");
        query.setParameter("stubLinkId",stubLinkId);
        if (query.list().size() != 0) {
           linkedStubLinkList.addAll(query.list());
        }

        query = session.createQuery("select stubLink.stubLinkId from CableLink where linkedStubLink.stubLinkId = :stubLinkId");
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

    public List<CableLinkTable> getCableLinksByNodeId(Long nodeId) {

        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        Session session = serviceCableLinks.getSessionFactory().openSession();

        List<CableLink> cableLinkList = new ArrayList<CableLink>();
        List<CableLinkTable> cableLinkTableList = new ArrayList<CableLinkTable>();
        StubLink stubLink;
        StubLink linkedStubLink;

        // получаем список стабов, по которым будем собирать подключения
        ServiceStubLink serviceStubLink = new ServiceStubLink();
        List<StubLink> stubLinkList = serviceStubLink.getStubLinkByNodeId(nodeId);

        for (StubLink sl: stubLinkList) {
            Query query = session.createQuery("from CableLink where stubLink.stubLinkId = :stubLinkId");
            query.setParameter("stubLinkId",sl.getStubLinkId());
            if (query.list().size() != 0) {
                cableLinkList.addAll(query.list());
                // передаем данные в контейнер для отображения
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getStubLink();
                    linkedStubLink = cl.getLinkedStubLink();
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink));
                }
            }

            query = session.createQuery("from CableLink where linkedStubLink.stubLinkId = :stubLinkId");
            query.setParameter("stubLinkId",sl.getStubLinkId());
            if (query.list().size() != 0) {
                cableLinkList.addAll(query.list());
                // передаем данные в контейнер для отображения, меняя направление
                for (CableLink cl: cableLinkList) {
                    stubLink = cl.getLinkedStubLink();
                    linkedStubLink = cl.getStubLink();
                    cableLinkTableList.add(new CableLinkTable(stubLink,linkedStubLink));
                }
            }
        }

        for (CableLink cl: cableLinkList) {
            System.out.println(cl.toString());
        }

        session.flush();
        session.close();

        return cableLinkTableList;
    }

    protected SessionFactory getSessionFactory() {
        return new Configuration().configure().buildSessionFactory();
    }

}
