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

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "stubLink")
    private List<CableLink> clList;

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

    public List<CableLink> getClList() {
        return clList;
    }

    public void setClList(List<CableLink> clList) {
        this.clList = clList;
    }

    @Override
    public String toString() {
        return "StubLink { \n " +
                "          stub_link_id = " + stubLinkId + "\n" +
                "          node = " + node.toString() + "\n" +
                "          node_type = " + node.getNodeType().toString() + "\n" +
                "          cu = " + connectionUnit.toString() + "\n" +
                "          cp = " + connectionPoint.toString() + "\n " +
                "        }";
    }
}
