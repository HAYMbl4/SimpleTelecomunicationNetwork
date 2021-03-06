package entity.mapping;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 *
 * User: o.naumov
 * Date: 13.04.14 Time: 01:18
 *
 */

@Entity
@Table(name = "connection_point", uniqueConstraints = @UniqueConstraint(columnNames = {"cu_id", "cp_name"}))
public class ConnectionPoint implements Serializable {

    @Id()
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "GEN_CP")
    @SequenceGenerator(name = "GEN_CP", sequenceName = "GEN_CP", allocationSize = 1)
    @Column(name = "cp_id")
    private Long cpId;

    @ManyToOne(cascade = {CascadeType.REFRESH}, fetch = FetchType.LAZY, targetEntity = ConnectionUnit.class)
    @JoinColumn(name = "cu_id", nullable = false)
    private ConnectionUnit connectionUnit;

    @Column(name = "cp_name", nullable = false)
    private Long cpName;

    public ConnectionPoint() {
    }

    public ConnectionPoint(Long cpName, ConnectionUnit connectionUnit) {
        this.cpName = cpName;
        this.connectionUnit = connectionUnit;
    }

    public Long getCpId() {
        return cpId;
    }

    public void setCpId(Long cpId) {
        this.cpId = cpId;
    }

    public ConnectionUnit getConnectionUnit() {
        return connectionUnit;
    }

    public void setConnectionUnit(ConnectionUnit connectionUnit) {
        this.connectionUnit = connectionUnit;
    }

    public Long getCpName() {
        return cpName;
    }

    public void setCpName(Long cpName) {
        this.cpName = cpName;
    }

    @Override
    public String toString() {
        return "ConnectionPoint { cp_id = " + cpId + "," +
                "                cu_id = " + connectionUnit.getCuId() + "(" + connectionUnit.getNode().getNodeType().getNodeTypeShortName() +
                ""                         + connectionUnit.getNode().getNodeName() + "-" + connectionUnit.getCuNumber() + ")," +
                "                cp_name = " + cpName + "}";
    }
}
