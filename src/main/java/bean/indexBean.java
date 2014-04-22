package bean;

import dao.service.ServiceNodeType;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Олег on 4/13/14.
 */

@ManagedBean(name = "indexBean")
@RequestScoped
public class IndexBean implements Serializable {

    public boolean viewNodeType = true;
    public boolean viewNodeName = true;
    public boolean viewRegion = true;
    public boolean viewStreet = true;
    public boolean viewHouse = true;

    public boolean isViewNodeType() {
        return viewNodeType;
    }

    public void setViewNodeType(boolean viewNodeType) {
        this.viewNodeType = viewNodeType;
    }

    public boolean isViewNodeName() {
        return viewNodeName;
    }

    public void setViewNodeName(boolean viewNodeName) {
        this.viewNodeName = viewNodeName;
    }

    public boolean isViewRegion() {
        return viewRegion;
    }

    public void setViewRegion(boolean viewRegion) {
        this.viewRegion = viewRegion;
    }

    public boolean isViewStreet() {
        return viewStreet;
    }

    public void setViewStreet(boolean viewStreet) {
        this.viewStreet = viewStreet;
    }

    public boolean isViewHouse() {
        return viewHouse;
    }

    public void setViewHouse(boolean viewHouse) {
        this.viewHouse = viewHouse;
    }

}
