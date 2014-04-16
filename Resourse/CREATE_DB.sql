--------------------------------------------------------------------------------
-- TABLE FOR TYPE NODE
--------------------------------------------------------------------------------

DROP TABLE NODE_TYPE PURGE;
/

CREATE TABLE NODE_TYPE 
  (
    NODE_TYPE_ID         NUMBER PRIMARY KEY,
    NODE_TYPE_NAME       VARCHAR2(64) NOT NULL,
    NODE_TYPE_SHORT_NAME VARCHAR2(6)
  );
/  

CREATE INDEX UNQ_NODE_TYPE ON NODE_TYPE(NODE_TYPE_NAME);
/

--------------------------------------------------------------------------------
-- TABLE FOR NODE
--------------------------------------------------------------------------------

DROP TABLE NODE PURGE;
/

CREATE TABLE NODE 
  (
    NODE_ID       NUMBER PRIMARY KEY,    
    NODE_NAME     VARCHAR2(128) NOT NULL,
    NODE_TYPE_ID  NUMBER NOT NULL,
    REGION_NAME   VARCHAR2(256),
    STREET_NAME   VARCHAR2(256),
    HOUSE         VARCHAR2(16),
    NODE_NOTE     VARCHAR2(1024)
  );
/

ALTER TABLE NODE ADD CONSTRAINT FK_NODE_TPYE 
  FOREIGN KEY (NODE_TYPE_ID) REFERENCES NODE_TYPE(NODE_TYPE_ID);
/

CREATE UNIQUE INDEX UNQ_NODE ON NODE(NODE_NAME, NODE_TYPE_ID, REGION_NAME);
/

--------------------------------------------------------------------------------
-- TABLE FOR CONNECTION UNIT
--------------------------------------------------------------------------------

DROP TABLE CONNECTION_UNIT PURGE;
/

CREATE TABLE CONNECTION_UNIT 
  (
    CU_ID      NUMBER PRIMARY KEY,
    NODE_ID    NUMBER NOT NULL,
    CU_NUMBER  NUMBER NOT NULL,
    FIRST_PAIR NUMBER NOT NULL,
    CAPACITY   NUMBER NOT NULL
  );
/

ALTER TABLE CONNECTION_UNIT ADD CONSTRAINT FK_NODE 
  FOREIGN KEY (NODE_ID) REFERENCES NODE(NODE_ID);
/

CREATE UNIQUE INDEX UNQ_CU ON CONNECTION_UNIT(NODE_ID, CU_NUMBER);
/

--------------------------------------------------------------------------------
-- TABLE FOR CONNECTION POINT
--------------------------------------------------------------------------------

DROP TABLE CONNECTION_POINT PURGE;
/

CREATE TABLE CONNECTION_POINT 
  (
    CP_ID    NUMBER PRIMARY KEY,
    CU_ID    NUMBER NOT NULL,
    CP_NAME  NUMBER NOT NULL
  );
/

ALTER TABLE CONNECTION_POINT ADD CONSTRAINT FK_CU 
  FOREIGN KEY (CU_ID) REFERENCES CONNECTION_UNIT(CU_ID);
/

CREATE UNIQUE INDEX UNQ_CP ON CONNECTION_POINT(CU_ID, CP_NAME);
/

--------------------------------------------------------------------------------
-- TABLE FOR STUB LINKS
--------------------------------------------------------------------------------

DROP TABLE STUB_LINK PURGE;
/

CREATE TABLE STUB_LINK
  (
    STUB_LINK_ID NUMBER PRIMARY KEY,
    NODE_ID NUMBER NOT NULL,
    CU_ID NUMBER NOT NULL,
    CP_ID NUMBER NOT NULL
  );
/

ALTER TABLE STUB_LINK ADD CONSTRAINT FK_SL_NODE 
  FOREIGN KEY (NODE_ID) REFERENCES NODE(NODE_ID);
/

ALTER TABLE STUB_LINK ADD CONSTRAINT FK_SL_CU 
  FOREIGN KEY (CU_ID) REFERENCES CONNECTION_UNIT(CU_ID);
/

ALTER TABLE STUB_LINK ADD CONSTRAINT FK_SL_CP 
  FOREIGN KEY (CP_ID) REFERENCES CONNECTION_POINT(CP_ID);
/

CREATE UNIQUE INDEX UNQ_SL ON STUB_LINK(NODE_ID, CU_ID, CP_ID);
/

--------------------------------------------------------------------------------
-- TABLE FOR CABLE LINKS
--------------------------------------------------------------------------------

DROP TABLE CABLE_LINK PURGE;
/

CREATE TABLE CABLE_LINK
  (
    CABLE_LINK_ID NUMBER PRIMARY KEY,
    STUB_LINK_ID NUMBER NOT NULL,
    LINKED_STUB_LINK_ID NUMBER NOT NULL
  );
/

ALTER TABLE CABLE_LINK ADD CONSTRAINT FK_CL_STUB_LINK 
  FOREIGN KEY (STUB_LINK_ID) REFERENCES STUB_LINK(STUB_LINK_ID);
/

ALTER TABLE UNQ_CL ADD CONSTRAINT FK_CL_LINKED_STUB_LINK 
  FOREIGN KEY (LINKED_STUB_LINK_ID) REFERENCES STUB_LINK(STUB_LINK_ID);
/

CREATE UNIQUE INDEX UNQ_CL ON CABLE_LINK(STUB_LINK_ID, LINKED_STUB_LINK_ID);
/