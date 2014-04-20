package entity.mapping;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 23:40
 *
 */

@Entity
@Table(name = "node")
public class Node implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "GEN_NODE")
    @SequenceGenerator(name = "GEN_NODE", sequenceName = "GEN_NODE", allocationSize = 1)
    @Column(name = "node_id")
    private Long nodeId;

    @Column(name = "node_name", nullable = false)
    private String nodeName;

    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = NodeType.class)
    @JoinColumn(name = "node_type_id")
    private NodeType nodeType;

    @Column(name = "region_name", nullable = true)
    private String regionName;

    @Column(name = "street_name", nullable = true)
    private String streetName;

    @Column(name = "house", nullable = true)
    private String house;

    @Column(name = "node_note", nullable = true)
    private String nodeNote;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "node")
    private List<ConnectionUnit> cuList;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "node")
    private List<StubLink> slList;

    public Node() {
    }

    public Node(String nodeName, NodeType nodeType, String regionName, String streetName, String house, String nodeNote) {
        this.nodeName = nodeName;
        this.nodeType = nodeType;
        this.regionName = regionName;
        this.streetName = streetName;
        this.house = house;
        this.nodeNote = nodeNote;
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public NodeType getNodeType() {
        return nodeType;
    }

    public void setNodeType(NodeType nodeType) {
        this.nodeType = nodeType;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public String getStreetName() {
        return streetName;
    }

    public void setStreetName(String streetName) {
        this.streetName = streetName;
    }

    public String getHouse() {
        return house;
    }

    public void setHouse(String house) {
        this.house = house;
    }

    public String getNodeNote() {
        return nodeNote;
    }

    public void setNodeNote(String nodeNote) {
        this.nodeNote = nodeNote;
    }

    public List<ConnectionUnit> getCuList() {
        return cuList;
    }

    public void setCuList(List<ConnectionUnit> cuList) {
        this.cuList = cuList;
    }

    public List<StubLink> getSlList() {
        return slList;
    }

    public void setSlList(List<StubLink> slList) {
        this.slList = slList;
    }

    @Override
    public String toString() {
        return "Node { node_id = " + nodeId + "," +
                "      node_name = " + nodeName + "," +
                "      node_type_id = " + nodeType.getNodeTypeId() + " (" + nodeType.getNodeTypeName() + ")," +
                "      region_name = " + regionName + "," +
                "      street_name = " + streetName + "," +
                "      house = " + house + "," +
                "      node_note = " + nodeNote + "}";
    }

}
