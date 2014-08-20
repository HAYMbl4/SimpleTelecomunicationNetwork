package bean;

import dao.service.ServiceConnectionPoint;
import entity.mapping.ConnectionPoint;
import entity.view.ConnectionPointSelect;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: Олег Наумов
 * Date: 5/5/14 Time: 1:41 PM
 */

@ManagedBean(name = "cpBean")
@RequestScoped
public class ConnectionPointBean {

    @ManagedProperty("#{param.cuId}")
    public Long cuId;

    public List<ConnectionPointSelect> cpSelectList;

    public List<ConnectionPointSelect> getListConnectionPoint() {

        cpSelectList = new ArrayList<ConnectionPointSelect>();

        ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();
        List<ConnectionPoint> cpList = serviceConnectionPoint.getListConnectionPointByCuId(cuId);
        for (ConnectionPoint cpL: cpList) {
            cpSelectList.add(new ConnectionPointSelect(cpL,false));
        }

        return cpSelectList;
    }

    public void getSelectedRow() {
        System.out.println("getSelectedRow");
        for (ConnectionPointSelect cpS: cpSelectList) {
            System.out.println("what in cpS: " + cpS.getConnectionPoint().toString());
            if (cpS.isSelected()) {
                System.out.println("selected! - " + cpS.getConnectionPoint().toString());
            } else {
                System.out.println(" un selected! - " + cpS.getConnectionPoint().toString());
            }
        }
    }

    public void setCpSelectList(List<ConnectionPointSelect> cpSelectList) {
        this.cpSelectList = cpSelectList;
    }

    public Long getCuId() {
        return cuId;
    }

    public void setCuId(Long cuId) {
        this.cuId = cuId;
    }

}
