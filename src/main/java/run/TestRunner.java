package run;

import dao.service.ServiceNodeType;

/**
 *
 * User: o.naumov
 * Date: 12.04.14 Time: 14:41
 *
 */
public class TestRunner {

    public static void main (String[] args) {

        ServiceNodeType servNodeType = new ServiceNodeType();
        servNodeType.getListNodeType();

//        ServiceNode servNode = new ServiceNode();
//        servNode.getListNode();

//        ServiceConnectionUnit servCU = new ServiceConnectionUnit();
//        servCU.getListConnectionUnit();

//        ServiceConnectionPoint servCP = new ServiceConnectionPoint();
//        servCP.getConnectionPointList();

    }

}
