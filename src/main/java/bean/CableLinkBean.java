package bean;

import dao.service.ServiceCableLinks;
import dao.service.ServiceConnectionUnit;
import dao.service.ServiceNode;
import entity.mapping.ConnectionUnit;
import entity.mapping.Node;
import entity.view.CableLinkGroup;
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

    @ManagedProperty("#{param.cuId}")
    private Long cuId;

    public List<CableLinkTable> getListCableLinkByNode() {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        System.out.println("Получаем подключения, для узла, по ID = " + nodeId);
        return serviceCableLinks.getCableLinksByNodeId(nodeId);
    }

    public List<CableLinkTable> getListCableLinkByCu() {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        System.out.println("Получаем подключения, для ОКУ, по ID = " + cuId);
        return serviceCableLinks.getCableLinksByCuId(cuId);
    }

    public String getNodeNameById() {
        ServiceNode serviceNode = new ServiceNode();
        Node node = serviceNode.getNodeById(nodeId);
        return node.getNodeType().getNodeTypeShortName()+node.getNodeName();
    }

    public String getCuNameById() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        ConnectionUnit connectionUnit = serviceConnectionUnit.getCuByCuId(cuId);
        return connectionUnit.getNode().getNodeType().getNodeTypeShortName() + connectionUnit.getNode().getNodeName() + "-" +
                connectionUnit.getCuNumber();
    }

    public List<CableLinkGroup> getListGroupCableLinkByNode() {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        return serviceCableLinks.getCableLinkGroupByNode(nodeId);
    }

    public List<CableLinkGroup> getListGroupCableLinkByCU() {
        ServiceCableLinks serviceCableLinks = new ServiceCableLinks();
        return serviceCableLinks.getCableLinkGroupByCU(cuId);
    }

    public List<ConnectionUnit> getListConnectionUnit() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getListConnectionUnit();
    }

    public ConnectionUnit getCuById() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getCuByCuId(cuId);
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }

    public Long getCuId() {
        return cuId;
    }

    public void setCuId(Long cuId) {
        this.cuId = cuId;
    }

}
