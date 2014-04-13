package bean;

import dao.service.ServiceConnectionPoint;
import entity.ConnectionPoint;

import javax.faces.bean.ManagedBean;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:20 PM
 */

@ManagedBean(name = "cpBean")
public class ConnectionPointBean {

    public List<ConnectionPoint> getListConnectionPoint() {
        ServiceConnectionPoint serviceConnectionPoint = new ServiceConnectionPoint();
        return serviceConnectionPoint.getListConnectionPoint();
    }

}
