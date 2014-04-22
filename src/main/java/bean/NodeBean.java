package bean;

import dao.service.ServiceNode;
import dao.service.ServiceNodeType;
import entity.mapping.Node;

import javax.enterprise.context.SessionScoped;
import javax.faces.bean.ManagedBean;
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

    public List<String> getListNodeType() {
        ServiceNodeType serviceNodeType = new ServiceNodeType();
        List<String> nodeTypeList = new ArrayList<String>();
        nodeTypeList = serviceNodeType.getListNodeType();
        nodeTypeList.add("All");
        return nodeTypeList;
    }

    public List<Node> getListNode() {
        ServiceNode serviceNode = new ServiceNode();
        System.out.println("----------------------------------------------------------- " + nodeTypeValue);
        if (!nodeTypeValue.equals("All")) {
            System.out.println("----------------------------------- hi from not ALL " + nodeTypeValue);
            return serviceNode.getNodeByNodeTypeName(nodeTypeValue);
        } else {
            System.out.println("------------------------------- hi from ALL " + nodeTypeValue);
            return serviceNode.getListNode();
        }
    }

    public String getNodeTypeValue() {
        return nodeTypeValue;
    }

    public void setNodeTypeValue(String nodeTypeValue) {
        this.nodeTypeValue = nodeTypeValue;
    }

}