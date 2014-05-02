package bean;

import dao.service.ServiceNode;
import entity.mapping.ConnectionUnit;
import dao.service.ServiceConnectionUnit;
import entity.mapping.Node;
import entity.view.ConnectionUnitTable;
import org.hibernate.exception.ConstraintViolationException;

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
    public Node node;
    public Long cuNumber;
    public Long firstPair;
    public Long capacity;
    public String resoultMess;
    public String styleMess = "hideMess";
    public String delMess;

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

    public void createConnectionUnit() {

        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        ServiceNode serviceNode = new ServiceNode();

        System.out.println("Подбираем Узел по ID - " + nodeId);
        ConnectionUnit connectionUnit = new ConnectionUnit(serviceNode.getNodeById(nodeId),cuNumber,firstPair,capacity);
        if (serviceConnectionUnit.findCuByIND(connectionUnit)) {
            resoultMess = "ОКУ с такими параметрами уже есть!";
            styleMess = "createNodeError";
        } else {
            serviceConnectionUnit.createConnectionUnit(connectionUnit);
            resoultMess = "ОКУ успешно создано";
            styleMess = "createNode";
        }
    }

    public void cleanParam() {
        cuNumber = null;
        firstPair = null;
        capacity = null;
        resoultMess = "";
        styleMess = "hideMess";
    }

    public Node getNode() {
        ServiceNode serviceNode = new ServiceNode();
        return serviceNode.getNodeById(nodeId);
    }

    public void setNode(Node node) {
        this.node = node;
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }

    public Long getCuNumber() {
        return cuNumber;
    }

    public void setCuNumber(Long cuNumber) {
        this.cuNumber = cuNumber;
    }

    public Long getFirstPair() {
        return firstPair;
    }

    public void setFirstPair(Long firstPair) {
        this.firstPair = firstPair;
    }

    public Long getCapacity() {
        return capacity;
    }

    public void setCapacity(Long capacity) {
        this.capacity = capacity;
    }

    public String getResoultMess() {
        return resoultMess;
    }

    public void setResoultMess(String resoultMess) {
        this.resoultMess = resoultMess;
    }

    public String getStyleMess() {
        return styleMess;
    }

    public void setStyleMess(String styleMess) {
        this.styleMess = styleMess;
    }

    public String getDelMess() {
        return delMess;
    }

    public void setDelMess(String delMess) {
        this.delMess = delMess;
    }
}
