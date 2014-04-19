package entity.mapping;

import entity.mapping.Node;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:18
 *
 */

@Entity
@Table(name = "node_type")
public class NodeType implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "GEN_NODE_TYPE")
    @SequenceGenerator(name = "GEN_NODE_TYPE", sequenceName = "GEN_NODE_TYPE", allocationSize = 1)
    @Column(name = "node_type_id")
    private Long nodeTypeId;

    @Column(name = "node_type_name", nullable = false)
    private String nodeTypeName;

    @Column(name = "node_type_short_name", nullable = true)
    private String nodeTypeShortName;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "nodeType")
    private List<Node> nodeList;

    public NodeType() {
    }

    public Long getNodeTypeId() {
        return nodeTypeId;
    }

    public void setNodeTypeId(Long nodeTypeId) {
        this.nodeTypeId = nodeTypeId;
    }

    public String getNodeTypeName() {
        return nodeTypeName;
    }

    public void setNodeTypeName(String nodeTypeName) {
        this.nodeTypeName = nodeTypeName;
    }

    public String getNodeTypeShortName() {
        return nodeTypeShortName;
    }

    public void setNodeTypeShortName(String nodeTypeShortName) {
        this.nodeTypeShortName = nodeTypeShortName;
    }

    public List<Node> getNodeList() {
        return nodeList;
    }

    public void setNodeList(List<Node> nodeList) {
        this.nodeList = nodeList;
    }

    @Override
    public String toString() {
        return "NodeType {nodeTypeId = " + nodeTypeId + ", nodeTypeName = " + nodeTypeName + ", nodeTypeShortName = " + nodeTypeShortName + "}";
    }

}
