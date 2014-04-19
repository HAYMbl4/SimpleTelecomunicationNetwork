package entity.view;

import entity.mapping.StubLink;

/**
 * User: Олег Наумов
 * Date: 4/20/14 Time: 1:20 AM
 */

public class CableLinkTable {

    public StubLink stubLink;
    public StubLink linkedStubLink;

    public CableLinkTable() {
    }

    public CableLinkTable(StubLink stubLink, StubLink linkedStubLink) {
        this.stubLink = stubLink;
        this.linkedStubLink = linkedStubLink;
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
}
