package bean;

import dao.service.ServiceNode;
import entity.mapping.Node;

import javax.enterprise.context.SessionScoped;
import javax.faces.bean.ManagedBean;
import java.io.Serializable;
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

    public List<Node> getListNode() {
        ServiceNode serviceNode = new ServiceNode();
        return serviceNode.getListNode();
    }

}