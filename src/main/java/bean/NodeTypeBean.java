package bean;

import dao.service.ServiceNodeType;
import entity.NodeType;

import javax.faces.bean.ManagedBean;
import java.util.List;

/**
 * Created by Олег on 4/13/14.
 */

@ManagedBean(name = "servNodeType")
public class NodeTypeBean {

    public List<NodeType> getListNodeType() {
        ServiceNodeType serviceNodeType = new ServiceNodeType();
        return serviceNodeType.getListNodeType();
    }
}
