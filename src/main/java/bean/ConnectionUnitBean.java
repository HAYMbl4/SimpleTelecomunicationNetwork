package bean;

import entity.ConnectionUnit;
import dao.service.ServiceConnectionUnit;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:11 PM
 */

@ManagedBean(name = "cuBean")
@RequestScoped
public class ConnectionUnitBean {

    @ManagedProperty("#{param.nodeId}")
    private Long nodeId;

    @ManagedProperty("#{param.cuId}")
    private Long cuId;

    public List<ConnectionUnit> getListConnectionUnit() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getListConnectionUnit();
    }

    @PostConstruct
    public List<ConnectionUnit> getConnectionUnitByNode() {

        List<ConnectionUnit> listCU = null;

        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        if (nodeId != null) {
           listCU = serviceConnectionUnit.getConnectionUnitByNode(nodeId);
        }

        return listCU;
    }

    public Long getCntUsedCpByCu () {

        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getCntUsedCpByCu(cuId);
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
