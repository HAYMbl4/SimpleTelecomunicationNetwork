package entity.mapping;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 12:48
 *
 */

@Entity
@Table(name = "connection_unit"/*, uniqueConstraints = @UniqueConstraint(columnNames = {"node_id", "cu_number"})*/)
public class ConnectionUnit implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "GEN_CU")
    @SequenceGenerator(name = "GEN_CU", sequenceName = "GEN_CU", allocationSize = 1)
    @Column(name = "cu_id")
    private Long cuId;

    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = Node.class)
    @JoinColumn(name = "node_id")
    private Node node;

    @Column(name = "cu_number",nullable = false)
    private Long cuNumber;

    @Column(name = "first_pair", nullable = false)
    private Long firstPair;

    @Column(name = "capacity", nullable = false)
    private Long capacity;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "connectionUnit")
    private List<ConnectionPoint> cpList;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "connectionUnit")
    private List<StubLink> slList;

    public ConnectionUnit() {
    }

    public ConnectionUnit(Node node, Long cuNumber, Long firstPair, Long capacity) {
        this.node = node;
        this.cuNumber = cuNumber;
        this.firstPair = firstPair;
        this.capacity = capacity;
    }

    public Long getCuId() {
        return cuId;
    }

    public void setCuId(Long cuId) {
        this.cuId = cuId;
    }

    public Node getNode() {
        return node;
    }

    public void setNode(Node node) {
        this.node = node;
    }

    public Long getCuNumber() {
        return cuNumber;
    }

    public void setCuNumber(Long cuNumber) {
        this.cuNumber = cuNumber;
    }

    public Long getFirstPair() {
        return firstPair;
    }

    public void setFirstPair(Long firstPair) {
        this.firstPair = firstPair;
    }

    public Long getCapacity() {
        return capacity;
    }

    public void setCapacity(Long capacity) {
        this.capacity = capacity;
    }

    @Override
    public String toString() {
        return "connection_unit {cu_id = " + cuId + "," +
                "                node_id = " + node.getNodeId() + "("+ node.getNodeType().getNodeTypeShortName() + "" + node.getNodeName() +")," +
                "                cu_number = " + cuNumber + "," +
                "                firstPair = " + firstPair + "," +
                "                capacity = " + capacity;
    }

}
