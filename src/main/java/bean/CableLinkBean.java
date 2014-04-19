package bean;

import dao.service.ServiceCableLinks;
import entity.view.CableLinkTable;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import java.io.Serializable;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/20/14 Time: 1:35 AM
 */

@ManagedBean(name = "clBean")
@RequestScoped
public class CableLinkBean implements Serializable {

    @ManagedProperty("#{param.nodeId}")
    private Long nodeId;

    public List<CableLinkTable> getListCableLinkByNode() {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        System.out.println("Получаем подключения по ID = " + nodeId);
        return serviceCableLinks.getCableLinksByNodeId(nodeId);
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }
}
