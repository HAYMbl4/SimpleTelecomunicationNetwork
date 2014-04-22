package entity.mapping;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 10:27 PM
 */

@Entity
@Table(name = "stub_link")
public class StubLink implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "GEN_STUB_LINK")
    @SequenceGenerator(name = "GEN_STUB_LINK", sequenceName = "GEN_STUB_LINK", allocationSize = 1)
    @Column(name = "stub_link_id")
    private Long stubLinkId;

    @JoinColumn(name = "node_id")
    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = Node.class)
    private Node node;

    @JoinColumn(name = "cu_id")
    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = ConnectionUnit.class)
    private ConnectionUnit connectionUnit;

    @JoinColumn(name = "cp_id")
    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = ConnectionPoint.class)
    private ConnectionPoint connectionPoint;

    public StubLink() {
    }

    public StubLink(Node node, ConnectionUnit connectionUnit, ConnectionPoint connectionPoint) {
        this.node = node;
        this.connectionUnit = connectionUnit;
        this.connectionPoint = connectionPoint;
    }

    public Long getStubLinkId() {
        return stubLinkId;
    }

    public void setStubLinkId(Long stubLinkId) {
        this.stubLinkId = stubLinkId;
    }

    public Node getNode() {
        return node;
    }

    public void setNode(Node node) {
        this.node = node;
    }

    public ConnectionUnit getConnectionUnit() {
        return connectionUnit;
    }

    public void setConnectionUnit(ConnectionUnit connectionUnit) {
        this.connectionUnit = connectionUnit;
    }

    public ConnectionPoint getConnectionPoint() {
        return connectionPoint;
    }

    public void setConnectionPoint(ConnectionPoint connectionPoint) {
        this.connectionPoint = connectionPoint;
    }

    @Override
    public String toString() {
        return "StubLink { " +
                " stub_link_id = " + stubLinkId + "," +
                " node = " + node.getNodeType().getNodeTypeShortName() + node.getNodeName() + "," +
                " cu = " + connectionUnit.getCuNumber() + "," +
                " cp = " + connectionPoint.getCpName() + " }";
    }
}
