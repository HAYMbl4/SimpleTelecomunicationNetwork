package bean;

import dao.service.ServiceNodeType;
import entity.mapping.NodeType;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import java.io.Serializable;
import java.util.List;

/**
 * Created by Олег on 4/13/14.
 */

@ManagedBean(name = "servNodeType")
@ViewScoped
public class NodeTypeBean implements Serializable {

    public List<NodeType> getListNodeType() {
        ServiceNodeType serviceNodeType = new ServiceNodeType();
        return serviceNodeType.getListNodeType();
    }
}
