package bean;

import dao.service.ServiceCableLinks;
import dao.service.ServiceConnectionPoint;
import dao.service.ServiceStubLink;
import entity.ConnectionPoint;
import entity.ConnectionPointTable;
import entity.StubLink;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import java.util.ArrayList;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:20 PM
 */

@ManagedBean(name = "cpBean")
//@RequestScoped
public class ConnectionPointBean {

    @ManagedProperty("#{param.cuId}")
    private Long cuId;

    public List<ConnectionPointTable> getListConnectionPointTable() {
        ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();

        List<ConnectionPointTable> cpTableList = new ArrayList<ConnectionPointTable>();

        // получаем список точек по коннектору
        List<ConnectionPoint> cpList = serviceConnectionPoint.getListConnectionPointByCuId(/*cuId*/2L);

        ServiceStubLink serviceStubLink = new ServiceStubLink();
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        // проходим по списку точек и ищем подключения к ней
        for (ConnectionPoint cpL: cpList) {
            System.out.println("точка = " + cpL.getCpName());
            // получаем список стабов, к которым подключена точка
            if (serviceStubLink.getStubLinkIdByCpId(cpL.getCpId()) != null) {
                List<Long> linkedStubLinkList = serviceCableLinks.getLinkedStubLinkByStubLinkId(serviceStubLink.getStubLinkIdByCpId(cpL.getCpId()));
                for (Long l: linkedStubLinkList) { // формируем название подключаемых точек
                    List<String> nameLinkedCp = new ArrayList<String>();
                    StubLink stubLink = serviceStubLink.getStubLinkByStubLinkId(l.longValue());
                    nameLinkedCp.add(stubLink.getNode().getNodeType().getNodeTypeShortName()+ "" // тип узла
                                   + stubLink.getNode().getNodeName() + "-" // номер узла
                                   + stubLink.getConnectionUnit().getCuNumber() + "-" // номер коннектора
                                   + stubLink.getConnectionPoint().getCpName() // номер точки
                    );
                for (String s: nameLinkedCp) {
                    System.out.println("Подключенные точки: " + s.toString());
                }
                // передаем собранные данные в контейнер для отображения
                cpTableList.add(new ConnectionPointTable(cpL, nameLinkedCp));
                }
            } else {
                cpTableList.add(new ConnectionPointTable(cpL,null));
            }

        }

        return null;
    }

    public Long getCuId() {
        return cuId;
    }

    public void setCuId(Long cuId) {
        this.cuId = cuId;
    }

}
