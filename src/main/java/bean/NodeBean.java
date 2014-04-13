package bean;

import dao.service.ServiceNode;
import entity.Node;

import javax.faces.bean.ManagedBean;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 21:46
 *
 */

@ManagedBean(name = "nodeBean")
public class NodeBean {

    public List<Node> getListNode() {
        ServiceNode serviceNode = new ServiceNode();
        return serviceNode.getListNode();
    }

}