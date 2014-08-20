package entity.view;

import entity.mapping.StubLink;

/**
 * User: Олег Наумов
 * Date: 4/20/14 Time: 1:20 AM
 */

public class CableLinkTable {

    public StubLink stubLink;
    public StubLink linkedStubLink;
    public Long stubLinkPair;
    public Long linkedStubLinkPair;


    public CableLinkTable() {
    }

    public CableLinkTable(StubLink stubLink, StubLink linkedStubLink, Long stubLinkPair, Long linkedStubLinkPair) {
        this.stubLink = stubLink;
        this.linkedStubLink = linkedStubLink;
        this.stubLinkPair = stubLinkPair;
        this.linkedStubLinkPair = linkedStubLinkPair;
    }

    public StubLink getStubLink() {
        return stubLink;
    }

    public void setStubLink(StubLink stubLink) {
        this.stubLink = stubLink;
    }

    public StubLink getLinkedStubLink() {
        return linkedStubLink;
    }

    public void setLinkedStubLink(StubLink linkedStubLink) {
        this.linkedStubLink = linkedStubLink;
    }

    public Long getStubLinkPair() {
        return stubLinkPair;
    }

    public void setStubLinkPair(Long stubLinkPair) {
        this.stubLinkPair = stubLinkPair;
    }

    public Long getLinkedStubLinkPair() {
        return linkedStubLinkPair;
    }

    public void setLinkedStubLinkPair(Long linkedStubLinkPair) {
        this.linkedStubLinkPair = linkedStubLinkPair;
    }

}
