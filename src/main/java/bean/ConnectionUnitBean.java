package bean;

import entity.ConnectionUnit;
import dao.service.ServiceConnectionUnit;

import javax.faces.bean.ManagedBean;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/13/14 Time: 10:11 PM
 */

@ManagedBean(name = "cuBean")
public class ConnectionUnitBean {

    public List<ConnectionUnit> getListConnectionUnit() {
        ServiceConnectionUnit serviceConnectionUnit = new ServiceConnectionUnit();
        return serviceConnectionUnit.getListConnectionUnit();
    }

}
