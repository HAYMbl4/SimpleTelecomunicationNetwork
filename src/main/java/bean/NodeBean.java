package bean;

import dao.service.ServiceNode;
import dao.service.ServiceNodeType;
import entity.mapping.Node;
import entity.mapping.NodeType;
import org.hibernate.exception.ConstraintViolationException;

import javax.enterprise.context.SessionScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 21:46
 *
 */

@ManagedBean(name = "nodeBean")
@SessionScoped
public class NodeBean implements Serializable {

    public String nodeTypeValue = "All";
    @ManagedProperty("#{param.nodeId}")
    public Long nodeId;
    public String nodeName;
    public String region;
    public String street;
    public String house;
    public String nodeNote;
    public String resoultMess;
    public String styleMess = "hideMess";
    public String delMess;

    public List<String> getListNodeType() {
        ServiceNodeType serviceNodeType = new ServiceNodeType();
        List<String> nodeTypeList = new ArrayList<String>();
        nodeTypeList = serviceNodeType.getListNodeType();
        nodeTypeList.add("All");
        return nodeTypeList;
    }

    public List<String> getListNodeTypeForCreate() {
        ServiceNodeType serviceNodeType = new ServiceNodeType();
        return serviceNodeType.getListNodeType();
    }

    public List<Node> getListNode() {
        ServiceNode serviceNode = new ServiceNode();
        if (!nodeTypeValue.equals("All")) {
            return serviceNode.getNodeByNodeTypeName(nodeTypeValue);
        } else {
            return serviceNode.getListNode();
        }
    }

    public void createNode() {

        ServiceNode serviceNode = new ServiceNode();
        ServiceNodeType serviceNodeType = new ServiceNodeType();

        NodeType nodeType = serviceNodeType.getNodeTypeByName(nodeTypeValue);
        try {
            serviceNode.createNode(new Node (nodeName, nodeType, region, street, house, nodeNote));
            resoultMess = "Узел успешно создан";
            styleMess = "standartMess";
        } catch (ConstraintViolationException ex) {
            resoultMess = "Узел с такими параметрами уже есть!";
            styleMess = "standartMessError";
        } catch (Exception ex) {
            resoultMess = "ошибка";
            styleMess = "standartMessError";
        }

        System.out.println(resoultMess);
    }

    public void deleteNode() {

        ServiceNode serviceNode = new ServiceNode();
        Node node = serviceNode.getNodeById(nodeId);
        Long cntCu = serviceNode.cntCUinNode(node.getNodeId());

        if (cntCu == 0) {
            serviceNode.deleteNode(node);
            delMess = "Узел \"" + node.getNodeType().getNodeTypeShortName() + node.getNodeName() + "\" успешно удален";
            styleMess = "delNode";
        } else {
            delMess = "У узла \"" + node.getNodeType().getNodeTypeShortName() + node.getNodeName() + "\" есть зависимые ОКУ, колличество: " + cntCu;
            styleMess = "delNodeError";
        }

    }

    public void cleanParam() {
        nodeName = "";
        region = "";
        street = "";
        house = "";
        nodeNote = "";
        resoultMess = "";
        styleMess = "hideMess";
    }

    public String getNodeTypeValue() {
        return nodeTypeValue;
    }

    public void setNodeTypeValue(String nodeTypeValue) {
        this.nodeTypeValue = nodeTypeValue;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getHouse() {
        return house;
    }

    public void setHouse(String house) {
        this.house = house;
    }

    public String getNodeNote() {
        return nodeNote;
    }

    public void setNodeNote(String nodeNote) {
        this.nodeNote = nodeNote;
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

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }
}