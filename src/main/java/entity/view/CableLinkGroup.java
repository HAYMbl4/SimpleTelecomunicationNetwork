package entity.view;

/**
 * User: Олег Наумов
 * Date: 5/4/14 Time: 1:42 PM
 */

public class CableLinkGroup {

    String nodeId;
    String nodeName;
    String cuName;
    String cuId;
    String firstCpName;
    String endCpName;
    String linkedNodeId;
    String linkedNodeName;
    String linkedCuName;
    String linkedCuId;
    String linkedFirstCpName;
    String linkedEndCpName;

    public CableLinkGroup() {
    }

    public CableLinkGroup(String nodeId, String nodeName, String cuName, String cuId, String firstCpName, String endCpName, String linkedNodeId, String linkedNodeName, String linkedCuName, String linkedCuId, String linkedFirstCpName, String linkedEndCpName) {
        this.nodeId = nodeId;
        this.nodeName = nodeName;
        this.cuName = cuName;
        this.cuId = cuId;
        this.firstCpName = firstCpName;
        this.endCpName = endCpName;
        this.linkedNodeId = linkedNodeId;
        this.linkedNodeName = linkedNodeName;
        this.linkedCuName = linkedCuName;
        this.linkedCuId = linkedCuId;
        this.linkedFirstCpName = linkedFirstCpName;
        this.linkedEndCpName = linkedEndCpName;
    }

    public String getNodeId() {
        return nodeId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public String getCuName() {
        return cuName;
    }

    public void setCuName(String cuName) {
        this.cuName = cuName;
    }

    public String getCuId() {
        return cuId;
    }

    public void setCuId(String cuId) {
        this.cuId = cuId;
    }

    public String getFirstCpName() {
        return firstCpName;
    }

    public void setFirstCpName(String firstCpName) {
        this.firstCpName = firstCpName;
    }

    public String getEndCpName() {
        return endCpName;
    }

    public void setEndCpName(String endCpName) {
        this.endCpName = endCpName;
    }

    public String getLinkedNodeId() {
        return linkedNodeId;
    }

    public void setLinkedNodeId(String linkedNodeId) {
        this.linkedNodeId = linkedNodeId;
    }

    public String getLinkedNodeName() {
        return linkedNodeName;
    }

    public void setLinkedNodeName(String linkedNodeName) {
        this.linkedNodeName = linkedNodeName;
    }

    public String getLinkedCuName() {
        return linkedCuName;
    }

    public void setLinkedCuName(String linkedCuName) {
        this.linkedCuName = linkedCuName;
    }

    public String getLinkedCuId() {
        return linkedCuId;
    }

    public void setLinkedCuId(String linkedCuId) {
        this.linkedCuId = linkedCuId;
    }

    public String getLinkedFirstCpName() {
        return linkedFirstCpName;
    }

    public void setLinkedFirstCpName(String linkedFirstCpName) {
        this.linkedFirstCpName = linkedFirstCpName;
    }

    public String getLinkedEndCpName() {
        return linkedEndCpName;
    }

    public void setLinkedEndCpName(String linkedEndCpName) {
        this.linkedEndCpName = linkedEndCpName;
    }
}
