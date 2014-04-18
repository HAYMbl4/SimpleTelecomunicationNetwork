package entity;

import javax.persistence.*;
import java.io.Serializable;

/**
 * User: Олег Наумов
 * Date: 4/16/14 Time: 9:29 AM
 */

@Entity
@Table(name = "cable_links")
public class CableLinks implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "GEN_CABLE_LINKS")
    @SequenceGenerator(name = "GEN_CABLE_LINKS", sequenceName = "GEN_CABLE_LINKS", allocationSize = 1)
    @Column(name = "cable_links_id")
    private Long cableLinksId;

    @ManyToOne(cascade = CascadeType.REFRESH, fetch = FetchType.LAZY, targetEntity = StubLink.class)
    @JoinColumn(name = "stub_link_id")
    private StubLink stubLink;

    @ManyToOne(cascade = CascadeType.REFRESH, fetch = FetchType.LAZY, targetEntity = StubLink.class)
    @JoinColumn(name = "liked_stub_link_id")
    private StubLink linkedStubLink;

    public CableLinks() {
    }

    public CableLinks(StubLink stubLink, StubLink linkedStubLink) {
        this.stubLink = stubLink;
        this.linkedStubLink = linkedStubLink;
    }

    public Long getCableLinksId() {
        return cableLinksId;
    }

    public void setCableLinksId(Long cableLinksId) {
        this.cableLinksId = cableLinksId;
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
