package bean;

import dao.service.ServiceNode;
import entity.mapping.ConnectionUnit;
import dao.service.ServiceConnectionUnit;
import entity.mapping.Node;
import entity.view.ConnectionUnitTable;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:11 PM
 */

@ManagedBean(name = "cuBean")
@RequestScoped
public class ConnectionUnitBean implements Serializable {

    @ManagedProperty("#{param.nodeId}")
    private Long nodeId;

    public List<ConnectionUnit> getListConnectionUnit() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getListConnectionUnit();
    }

    public List<ConnectionUnitTable> getListConnectionUnitTable() {

        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        List<ConnectionUnit> listCU = serviceConnectionUnit.getConnectionUnitByNode(nodeId);
        List<ConnectionUnitTable> listCUTable = new ArrayList<ConnectionUnitTable>();
        for (ConnectionUnit lCU: listCU) {
            Long freePair = lCU.getCapacity() - serviceConnectionUnit.getCntUsedCpByCu(lCU.getCuId());
            listCUTable.add(new ConnectionUnitTable(lCU,freePair));
        }
        return listCUTable;
    }

    public String getNodeNameById() {
        ServiceNode serviceNode = new ServiceNode();
        Node node = serviceNode.getNodeById(nodeId);
        return node.getNodeType().getNodeTypeShortName()+node.getNodeName();
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }

}
