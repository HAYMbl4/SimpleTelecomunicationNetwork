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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_NODE_TYPE"  MINVALUE 10 MAXVALUE 9999 INCREMENT BY 1 START WITH 10 CACHE 20 NOORDER  NOCYCLE;
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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_NODE"  MINVALUE 100 MAXVALUE 9999999 INCREMENT BY 1 START WITH 100 CACHE 20 NOORDER  NOCYCLE;
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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_CU"  MINVALUE 100 MAXVALUE 999999999 INCREMENT BY 1 START WITH 100 CACHE 20 NOORDER  NOCYCLE;
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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_CP"  MINVALUE 10000 MAXVALUE 999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE;
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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_STUB_LINK"  MINVALUE 1000 MAXVALUE 99999999 INCREMENT BY 1 START WITH 1000 CACHE 20 NOORDER  NOCYCLE;
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

CREATE SEQUENCE  "ARGUS_TASK"."GEN_CABLE_LINKS"  MINVALUE 100 MAXVALUE 999999999 INCREMENT BY 1 START WITH 100 CACHE 20 NOORDER  NOCYCLE ;
/

--/////////////////////////////////////////////////////////////////////////// --
--/////////////////////////////////////////////////////////////////////////// --
--/////////////////////////////////////////////////////////////////////////// --
--------------------------------------------------------------------------------
-- TABLE WITH SEAMPLE SCRIPT
--------------------------------------------------------------------------------

CREATE TABLE INV_OPERATION_TEXT 
    (
        TABLE_NAME VARCHAR2(32),
        ACTION VARCHAR2(64),
        SCRIPT VARCHAR2(4000)
    );
/

--------------------------------------------------------------------------------
-- NODE_TYPE
--------------------------------------------------------------------------------

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('NODE_TYPE', '������� ��� ����','DECLARE 
    -- ���������
    L_NODE_TYPE_NAME VARCHAR2(64) := :L_NODE_TYPE_NAME; 
    L_NODE_TYPE_SHORT_NAME VARCHAR2(6) := :L_NODE_TYPE_SHORT_NAME;
BEGIN
    INSERT INTO NODE_TYPE(NODE_TYPE_ID, NODE_TYPE_NAME, NODE_TYPE_SHORT_NAME) VALUES (GEN_NODE_TYPE.NEXTVAL,L_NODE_TYPE_NAME,L_NODE_TYPE_SHORT_NAME);
END;
/');

--------------------------------------------------------------------------------
-- NODE
--------------------------------------------------------------------------------

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('NODE', '������� ����','DECLARE 
    L_NODE_NAME VARCHAR2(128) NOT NULL := :L_NODE_NAME;
    L_NODE_TYPE_ID NUMBER NOT NULL := :L_NODE_TYPE_ID;
    L_REGION_NAME VARCHAR2(256) NOT NULL := :L_REGION_NAME;
    L_STREET_NAME VARCHAR2(256) := :L_STREET_NAME;
    L_HOUSE VARCHAR2(16) := :L_HOUSE;
    L_NODE_NOTE VARCHAR2(1024) := :L_NODE_NOTE;
BEGIN
INSERT INTO NODE(NODE_ID, NODE_NAME, NODE_TYPE_ID, REGION_NAME, STREET_NAME, HOUSE, NODE_NOTE) 
    VALUES (GEN_NODE.NEXTVAL, L_NODE_NAME, L_NODE_TYPE_ID, L_REGION_NAME, L_STREET_NAME, L_HOUSE, L_NODE_NOTE);    
END;
/');
    
--------------------------------------------------------------------------------    
-- CONNECTION_UNIT + CONNECTION_POINT
--------------------------------------------------------------------------------

-- create CU

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('CONNECTION_UNIT', '������� ���, ��� �������� ��� ������������� ��������� �����','DECLARE
    L_NODE_ID NUMBER NOT NULL := :L_NODE_ID;
    L_CU_NUMBER NUMBER NOT NULL := :L_CU_NUMBER;
    L_FIRST_PAIR NUMBER NOT NULL := 0;
    L_CAPACITY NUMBER NOT NULL := :L_CAPACITY;
BEGIN
    -- ������ ���
    INSERT INTO CONNECTION_UNIT(CU_ID, NODE_ID, CU_NUMBER, FIRST_PAIR, CAPACITY) 
        VALUES (GEN_CU.NEXTVAL, L_NODE_ID, L_CU_NUMBER, L_FIRST_PAIR, L_CAPACITY);
    -- ������� ����� ���
    DECLARE 
    L_CP_NAME NUMBER := 0;
    BEGIN
        WHILE(L_CP_NAME < X.L_CAPACITY) LOOP
            INSERT INTO CONNECTION_POINT (CP_ID, CU_ID, CP_NAME) VALUES (GEN_CP.NEXTVAL, X.CU_ID, L_CP_NAME);
            L_CP_NAME := L_CP_NAME + 1;
        END LOOP;
    END;
END;
/');

-- select CU by Node

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('CONNECTION_UNIT', '������� ���, �� ����������� ����','SELECT 
      NT.NODE_TYPE_SHORT_NAME||N.NODE_NAME AS "NODE_NAME",
      N.REGION_NAME||'', ''||N.STREET_NAME||'', ''||N.HOUSE AS "ADDRESS",
      CU.CU_NUMBER,
      CU.FIRST_PAIR,
      CU.CAPACITY
FROM 
      CONNECTION_UNIT CU,
      NODE N,
      NODE_TYPE NT
WHERE
      CU.NODE_ID = N.NODE_ID
      AND N.NODE_TYPE_ID = NT.NODE_TYPE_ID
      AND CU.NODE_ID = :NODE_ID;
/');

--------------------------------------------------------------------------------
-- CABLE_LINK
--------------------------------------------------------------------------------

-- create cable link

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('CABLE_LINK', '������� �����������','DECLARE
    L_CP_ID NUMBER NOT NULL := 781;
    L_LINKED_CP_ID NUMBER NOT NULL := 1631;
    --
    L_NODE_ID NUMBER;
    L_CU_ID NUMBER;
    L_LINKED_NODE_ID NUMBER;
    L_LINKED_CU_ID NUMBER;    
    L_STUB_LINK_ID NUMBER;
    L_LINKED_STUB_LINK_ID NUMBER;
BEGIN
    -- ��������� ���� �� STUB_LINK ��� ����� L_CP_ID
    BEGIN
    SELECT STUB_LINK_ID INTO L_STUB_LINK_ID FROM STUB_LINK WHERE CP_ID = L_CP_ID;
    DBMS_OUTPUT.PUT_LINE(''L_STUB_LINK_ID from select -''||L_STUB_LINK_ID);
    EXCEPTION WHEN NO_DATA_FOUND THEN   
        -- ����: CU_ID BY L_CP_ID
        SELECT CU_ID INTO L_CU_ID FROM CONNECTION_POINT WHERE CP_ID = L_CP_ID;
        DBMS_OUTPUT.PUT_LINE(''L_CU_ID from select - ''||L_CU_ID);
        -- ����: NODE_ID BY L_CU_ID
        SELECT NODE_ID INTO L_NODE_ID FROM CONNECTION_UNIT WHERE CU_ID = L_CU_ID;
        DBMS_OUTPUT.PUT_LINE(''L_NODE_ID from select - ''||L_NODE_ID);
        -- ������� STUB_LINK
        L_STUB_LINK_ID := GEN_STUB_LINK.NEXTVAL;
        INSERT INTO STUB_LINK(STUB_LINK_ID, NODE_ID, CU_ID, CP_ID) VALUES (L_STUB_LINK_ID, L_NODE_ID, L_CU_ID, L_CP_ID);        
    END;
    
    -- ��������� ���� �� STUB_LINK ��� ����� L_LINKED_CP_ID
    BEGIN
    SELECT STUB_LINK_ID INTO L_LINKED_STUB_LINK_ID FROM STUB_LINK WHERE CP_ID = L_LINKED_CP_ID;
    EXCEPTION WHEN NO_DATA_FOUND THEN     
        -- ����: LINKED_CU_ID BY L_LINKED_CP_ID
        SELECT CU_ID INTO L_LINKED_CU_ID FROM CONNECTION_POINT WHERE CP_ID = L_LINKED_CP_ID;
        -- ����: LINKED_NODE_ID BY L_LINKED_CU_ID
        SELECT NODE_ID INTO L_LINKED_NODE_ID FROM CONNECTION_UNIT WHERE CU_ID = L_LINKED_CU_ID;  
        
        -- ������� STUB_LINK
        L_LINKED_STUB_LINK_ID := GEN_STUB_LINK.NEXTVAL;
        INSERT INTO STUB_LINK(STUB_LINK_ID, NODE_ID, CU_ID, CP_ID) VALUES (L_LINKED_STUB_LINK_ID, L_LINKED_NODE_ID, L_LINKED_CU_ID, L_LINKED_CP_ID);    
    END;
    
    -- ������� CABLE_LINK
    
    INSERT INTO CABLE_LINK(CABLE_LINK_ID, STUB_LINK_ID, LINKED_STUB_LINK_ID) VALUES (11, L_STUB_LINK_ID, L_LINKED_STUB_LINK_ID);
    
END;
/');

-- select all cable links by node

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('CABLE_LINK', '������� ��� ����������� ��� ����','SELECT 
  nt.node_type_short_name||n.node_name||''-''||cu.cu_number as "cuName",
  cp.cp_name as "firstCpName",
  cp.cp_name as "endCpName",
  lnt.node_type_short_name||ln.node_name||''-''||lcu.cu_number as "linkedCuName",
  lcp.cp_name as "linkedFirstCpName",
  lcp.cp_name as "linkedEndCpName"
FROM cable_link cl,
  stub_link sl,
  stub_link lsl,
  connection_point cp,
  connection_point lcp,
  connection_unit cu,
  connection_unit lcu,
  node n,
  node ln,
  node_type nt,
  node_type lnt
WHERE cl.stub_link_id      = sl.stub_link_id
AND cl.linked_stub_link_id = lsl.stub_link_id
AND sl.cp_id               = cp.cp_id
AND lsl.cp_id              = lcp.cp_id
AND sl.cu_id = cu.cu_id
AND lsl.cu_id = lcu.cu_id
AND sl.node_id = n.node_id
AND lsl.node_id = ln.node_id
AND n.node_type_id = nt.node_type_id
AND ln.node_type_id = lnt.node_type_id
AND n.node_id = :nodeId
UNION
SELECT 
  nt.node_type_short_name||ln.node_name||''-''||lcu.cu_number as "cuName",
  lcp.cp_name as "firstCpName",
  lcp.cp_name as "endCpName",
  lnt.node_type_short_name||n.node_name||''-''||cu.cu_number as "linkedCuName",
  cp.cp_name as "linkedFirstCpName",
  cp.cp_name as "linkedEndCpName"
FROM cable_link cl,
  stub_link sl,
  stub_link lsl,
  connection_point cp,
  connection_point lcp,
  connection_unit cu,
  connection_unit lcu,
  node n,
  node ln,
  node_type nt,
  node_type lnt
WHERE cl.stub_link_id      = sl.stub_link_id
AND cl.linked_stub_link_id = lsl.stub_link_id
AND sl.cp_id               = cp.cp_id
AND lsl.cp_id              = lcp.cp_id
AND sl.cu_id = cu.cu_id
AND lsl.cu_id = lcu.cu_id
AND sl.node_id = n.node_id
AND lsl.node_id = ln.node_id
AND n.node_type_id = nt.node_type_id
AND ln.node_type_id = lnt.node_type_id
AND ln.node_id = :nodeId
ORDER BY 1,2,5;
/');

-- select all cable links by cu

INSERT INTO INV_OPERATION_TEXT (TABLE_NAME, ACTION, SCRIPT)
    VALUES ('CABLE_LINK', '������� ��� ����������� ��� ���','SELECT 
  nt.node_type_short_name||n.node_name||''-''||cu.cu_number as "cuName",
  cp.cp_name as "firstCpName",
  cp.cp_name as "endCpName",
  lnt.node_type_short_name||ln.node_name||''-''||lcu.cu_number as "linkedCuName",
  lcp.cp_name as "linkedFirstCpName",
  lcp.cp_name as "linkedEndCpName"
FROM cable_link cl,
  stub_link sl,
  stub_link lsl,
  connection_point cp,
  connection_point lcp,
  connection_unit cu,
  connection_unit lcu,
  node n,
  node ln,
  node_type nt,
  node_type lnt
WHERE cl.stub_link_id      = sl.stub_link_id
AND cl.linked_stub_link_id = lsl.stub_link_id
AND sl.cp_id               = cp.cp_id
AND lsl.cp_id              = lcp.cp_id
AND sl.cu_id = cu.cu_id
AND lsl.cu_id = lcu.cu_id
AND sl.node_id = n.node_id
AND lsl.node_id = ln.node_id
AND n.node_type_id = nt.node_type_id
AND ln.node_type_id = lnt.node_type_id
AND cu.cu_id = :cuId
UNION
SELECT 
  nt.node_type_short_name||ln.node_name||''-''||lcu.cu_number as "cuName",
  lcp.cp_name as "firstCpName",
  lcp.cp_name as "endCpName",
  lnt.node_type_short_name||n.node_name||''-''||cu.cu_number as "linkedCuName",
  cp.cp_name as "linkedFirstCpName",
  cp.cp_name as "linkedEndCpName"
FROM cable_link cl,
  stub_link sl,
  stub_link lsl,
  connection_point cp,
  connection_point lcp,
  connection_unit cu,
  connection_unit lcu,
  node n,
  node ln,
  node_type nt,
  node_type lnt
WHERE cl.stub_link_id      = sl.stub_link_id
AND cl.linked_stub_link_id = lsl.stub_link_id
AND sl.cp_id               = cp.cp_id
AND lsl.cp_id              = lcp.cp_id
AND sl.cu_id = cu.cu_id
AND lsl.cu_id = lcu.cu_id
AND sl.node_id = n.node_id
AND lsl.node_id = ln.node_id
AND n.node_type_id = nt.node_type_id
AND ln.node_type_id = lnt.node_type_id
AND lcu.cu_id = :cuId
ORDER BY 1,2,5;
/');

-- ////////////////////////////////////////////////////////////////////////// --
-- insert test data
-- ////////////////////////////////////////////////////////////////////////// --

-- node_type

Insert into NODE_TYPE (NODE_TYPE_ID,NODE_TYPE_NAME,NODE_TYPE_SHORT_NAME) values ('31','Test2','T2');
Insert into NODE_TYPE (NODE_TYPE_ID,NODE_TYPE_NAME,NODE_TYPE_SHORT_NAME) values ('6','Cross','Cr');
Insert into NODE_TYPE (NODE_TYPE_ID,NODE_TYPE_NAME,NODE_TYPE_SHORT_NAME) values ('7','Case','C');

-- node

Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('2','1000','6','Saint-Petersburg','pr. Bolshevikov','40',null);
Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('3','2000','6','Saint-Petersburg','str. Kosay','3',null);
Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('4','3000','6','Saint-Petersburg','p. Ostrovskogo','76',null);
Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('5','100','7','Saint-Petersburg','pr. Bolshevikov','44',null);
Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('6','200','7','Saint-Petersburg','str. Kosay','10',null);
Insert into NODE (NODE_ID,NODE_NAME,NODE_TYPE_ID,REGION_NAME,STREET_NAME,HOUSE,NODE_NOTE) values ('7','300','7','Saint-Petersburg','p. Ostrovskogo','67',null);

-- connection_unit

Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('2','2','23','0','100');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('3','2','34','0','200');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('4','3','78','0','400');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('5','4','48','0','100');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('6','5','178','0','100');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('7','5','26','0','300');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('8','6','236','0','100');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('9','7','67','0','100');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('28','2','67','67','6');
Insert into CONNECTION_UNIT (CU_ID,NODE_ID,CU_NUMBER,FIRST_PAIR,CAPACITY) values ('29','2','56','56','4');

-- connection_point

Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('102','2','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('103','2','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('104','2','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('105','2','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('106','2','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('107','2','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('108','2','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('109','2','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('110','2','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('111','2','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('112','2','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('113','2','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('114','2','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('115','2','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('116','2','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('117','2','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('118','2','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('119','2','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('120','2','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('121','2','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('122','2','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('123','2','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('124','2','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('125','2','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('126','2','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('127','2','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('128','2','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('129','2','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('130','2','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('131','2','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('132','2','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('133','2','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('134','2','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('135','2','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('136','2','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('137','2','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('138','2','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('139','2','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('140','2','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('141','2','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('142','2','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('143','2','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('144','2','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('145','2','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('146','2','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('147','2','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('148','2','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('149','2','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('150','2','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('151','2','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('152','2','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('153','2','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('154','2','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('155','2','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('156','2','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('157','2','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('158','2','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('159','2','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('160','2','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('161','2','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('162','2','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('163','2','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('164','2','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('165','2','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('166','2','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('167','2','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('168','2','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('169','2','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('170','2','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('171','2','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('172','2','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('173','2','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('174','2','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('175','2','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('176','2','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('177','2','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('178','2','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('179','2','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('180','2','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('181','2','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('182','2','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('183','2','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('184','2','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('185','2','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('186','2','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('187','2','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('188','2','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('189','2','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('190','2','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('191','2','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('192','2','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('193','2','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('194','2','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('195','2','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('196','2','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('197','2','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('198','2','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('199','2','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('200','2','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('201','2','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('202','3','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('203','3','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('204','3','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('205','3','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('206','3','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('207','3','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('208','3','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('209','3','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('210','3','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('211','3','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('212','3','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('213','3','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('214','3','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('215','3','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('216','3','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('217','3','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('218','3','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('219','3','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('220','3','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('221','3','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('222','3','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('223','3','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('224','3','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('225','3','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('226','3','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('227','3','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('228','3','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('229','3','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('230','3','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('231','3','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('232','3','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('233','3','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('234','3','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('235','3','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('236','3','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('237','3','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('238','3','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('239','3','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('240','3','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('241','3','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('242','3','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('243','3','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('244','3','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('245','3','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('246','3','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('247','3','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('248','3','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('249','3','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('250','3','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('251','3','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('252','3','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('253','3','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('254','3','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('255','3','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('256','3','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('257','3','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('258','3','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('259','3','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('260','3','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('261','3','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('262','3','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('263','3','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('264','3','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('265','3','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('266','3','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('267','3','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('268','3','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('269','3','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('270','3','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('271','3','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('272','3','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('273','3','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('274','3','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('275','3','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('276','3','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('277','3','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('278','3','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('279','3','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('280','3','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('281','3','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('282','3','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('283','3','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('284','3','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('285','3','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('286','3','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('287','3','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('288','3','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('289','3','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('290','3','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('291','3','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('292','3','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('293','3','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('294','3','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('295','3','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('296','3','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('297','3','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('298','3','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('299','3','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('300','3','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('301','3','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('302','3','100');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('303','3','101');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('304','3','102');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('305','3','103');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('306','3','104');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('307','3','105');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('308','3','106');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('309','3','107');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('310','3','108');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('311','3','109');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('312','3','110');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('313','3','111');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('314','3','112');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('315','3','113');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('316','3','114');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('317','3','115');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('318','3','116');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('319','3','117');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('320','3','118');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('321','3','119');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('322','3','120');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('323','3','121');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('324','3','122');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('325','3','123');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('326','3','124');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('327','3','125');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('328','3','126');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('329','3','127');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('330','3','128');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('331','3','129');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('332','3','130');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('333','3','131');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('334','3','132');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('335','3','133');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('336','3','134');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('337','3','135');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('338','3','136');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('339','3','137');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('340','3','138');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('341','3','139');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('342','3','140');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('343','3','141');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('344','3','142');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('345','3','143');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('346','3','144');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('347','3','145');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('348','3','146');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('349','3','147');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('350','3','148');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('351','3','149');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('352','3','150');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('353','3','151');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('354','3','152');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('355','3','153');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('356','3','154');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('357','3','155');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('358','3','156');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('359','3','157');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('360','3','158');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('361','3','159');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('362','3','160');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('363','3','161');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('364','3','162');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('365','3','163');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('366','3','164');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('367','3','165');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('368','3','166');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('369','3','167');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('370','3','168');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('371','3','169');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('372','3','170');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('373','3','171');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('374','3','172');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('375','3','173');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('376','3','174');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('377','3','175');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('378','3','176');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('379','3','177');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('380','3','178');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('381','3','179');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('382','3','180');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('383','3','181');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('384','3','182');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('385','3','183');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('386','3','184');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('387','3','185');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('388','3','186');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('389','3','187');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('390','3','188');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('391','3','189');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('392','3','190');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('393','3','191');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('394','3','192');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('395','3','193');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('396','3','194');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('397','3','195');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('398','3','196');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('399','3','197');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('400','3','198');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('401','3','199');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('402','4','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('403','4','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('404','4','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('405','4','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('406','4','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('407','4','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('408','4','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('409','4','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('410','4','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('411','4','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('412','4','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('413','4','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('414','4','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('415','4','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('416','4','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('417','4','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('418','4','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('419','4','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('420','4','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('421','4','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('422','4','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('423','4','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('424','4','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('425','4','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('426','4','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('427','4','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('428','4','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('429','4','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('430','4','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('431','4','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('432','4','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('433','4','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('434','4','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('435','4','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('436','4','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('437','4','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('438','4','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('439','4','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('440','4','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('441','4','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('442','4','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('443','4','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('444','4','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('445','4','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('446','4','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('447','4','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('448','4','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('449','4','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('450','4','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('451','4','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('452','4','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('453','4','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('454','4','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('455','4','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('456','4','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('457','4','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('458','4','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('459','4','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('460','4','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('461','4','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('462','4','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('463','4','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('464','4','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('465','4','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('466','4','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('467','4','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('468','4','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('469','4','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('470','4','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('471','4','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('472','4','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('473','4','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('474','4','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('475','4','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('476','4','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('477','4','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('478','4','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('479','4','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('480','4','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('481','4','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('482','4','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('483','4','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('484','4','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('485','4','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('486','4','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('487','4','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('488','4','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('489','4','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('490','4','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('491','4','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('492','4','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('493','4','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('494','4','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('495','4','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('496','4','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('497','4','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('498','4','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('499','4','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('500','4','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('501','4','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('502','4','100');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('503','4','101');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('504','4','102');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('505','4','103');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('506','4','104');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('507','4','105');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('508','4','106');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('509','4','107');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('510','4','108');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('511','4','109');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('512','4','110');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('513','4','111');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('514','4','112');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('515','4','113');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('516','4','114');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('517','4','115');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('518','4','116');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('519','4','117');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('520','4','118');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('521','4','119');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('522','4','120');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('523','4','121');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('524','4','122');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('525','4','123');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('526','4','124');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('527','4','125');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('528','4','126');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('529','4','127');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('530','4','128');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('531','4','129');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('532','4','130');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('533','4','131');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('534','4','132');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('535','4','133');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('536','4','134');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('537','4','135');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('538','4','136');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('539','4','137');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('540','4','138');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('541','4','139');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('542','4','140');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('543','4','141');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('544','4','142');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('545','4','143');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('546','4','144');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('547','4','145');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('548','4','146');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('549','4','147');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('550','4','148');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('551','4','149');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('552','4','150');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('553','4','151');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('554','4','152');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('555','4','153');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('556','4','154');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('557','4','155');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('558','4','156');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('559','4','157');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('560','4','158');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('561','4','159');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('562','4','160');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('563','4','161');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('564','4','162');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('565','4','163');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('566','4','164');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('567','4','165');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('568','4','166');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('569','4','167');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('570','4','168');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('571','4','169');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('572','4','170');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('573','4','171');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('574','4','172');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('575','4','173');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('576','4','174');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('577','4','175');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('578','4','176');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('579','4','177');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('580','4','178');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('581','4','179');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('582','4','180');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('583','4','181');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('584','4','182');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('585','4','183');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('586','4','184');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('587','4','185');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('588','4','186');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('589','4','187');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('590','4','188');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('591','4','189');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('592','4','190');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('593','4','191');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('594','4','192');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('595','4','193');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('596','4','194');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('597','4','195');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('598','4','196');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('599','4','197');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('600','4','198');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('601','4','199');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('602','4','200');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('603','4','201');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('604','4','202');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('605','4','203');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('606','4','204');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('607','4','205');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('608','4','206');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('609','4','207');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('610','4','208');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('611','4','209');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('612','4','210');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('613','4','211');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('614','4','212');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('615','4','213');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('616','4','214');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('617','4','215');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('618','4','216');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('619','4','217');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('620','4','218');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('621','4','219');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('622','4','220');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('623','4','221');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('624','4','222');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('625','4','223');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('626','4','224');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('627','4','225');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('628','4','226');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('629','4','227');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('630','4','228');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('631','4','229');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('632','4','230');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('633','4','231');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('634','4','232');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('635','4','233');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('636','4','234');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('637','4','235');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('638','4','236');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('639','4','237');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('640','4','238');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('641','4','239');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('642','4','240');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('643','4','241');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('644','4','242');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('645','4','243');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('646','4','244');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('647','4','245');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('648','4','246');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('649','4','247');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('650','4','248');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('651','4','249');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('652','4','250');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('653','4','251');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('654','4','252');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('655','4','253');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('656','4','254');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('657','4','255');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('658','4','256');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('659','4','257');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('660','4','258');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('661','4','259');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('662','4','260');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('663','4','261');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('664','4','262');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('665','4','263');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('666','4','264');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('667','4','265');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('668','4','266');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('669','4','267');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('670','4','268');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('671','4','269');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('672','4','270');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('673','4','271');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('674','4','272');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('675','4','273');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('676','4','274');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('677','4','275');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('678','4','276');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('679','4','277');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('680','4','278');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('681','4','279');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('682','4','280');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('683','4','281');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('684','4','282');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('685','4','283');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('686','4','284');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('687','4','285');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('688','4','286');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('689','4','287');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('690','4','288');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('691','4','289');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('692','4','290');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('693','4','291');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('694','4','292');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('695','4','293');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('696','4','294');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('697','4','295');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('698','4','296');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('699','4','297');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('700','4','298');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('701','4','299');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('702','4','300');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('703','4','301');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('704','4','302');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('705','4','303');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('706','4','304');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('707','4','305');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('708','4','306');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('709','4','307');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('710','4','308');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('711','4','309');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('712','4','310');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('713','4','311');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('714','4','312');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('715','4','313');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('716','4','314');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('717','4','315');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('718','4','316');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('719','4','317');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('720','4','318');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('721','4','319');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('722','4','320');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('723','4','321');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('724','4','322');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('725','4','323');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('726','4','324');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('727','4','325');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('728','4','326');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('729','4','327');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('730','4','328');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('731','4','329');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('732','4','330');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('733','4','331');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('734','4','332');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('735','4','333');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('736','4','334');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('737','4','335');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('738','4','336');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('739','4','337');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('740','4','338');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('741','4','339');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('742','4','340');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('743','4','341');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('744','4','342');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('745','4','343');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('746','4','344');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('747','4','345');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('748','4','346');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('749','4','347');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('750','4','348');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('751','4','349');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('752','4','350');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('753','4','351');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('754','4','352');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('755','4','353');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('756','4','354');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('757','4','355');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('758','4','356');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('759','4','357');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('760','4','358');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('761','4','359');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('762','4','360');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('763','4','361');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('764','4','362');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('765','4','363');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('766','4','364');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('767','4','365');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('768','4','366');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('769','4','367');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('770','4','368');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('771','4','369');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('772','4','370');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('773','4','371');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('774','4','372');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('775','4','373');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('776','4','374');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('777','4','375');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('778','4','376');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('779','4','377');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('780','4','378');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('781','4','379');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('782','4','380');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('783','4','381');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('784','4','382');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('785','4','383');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('786','4','384');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('787','4','385');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('788','4','386');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('789','4','387');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('790','4','388');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('791','4','389');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('792','4','390');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('793','4','391');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('794','4','392');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('795','4','393');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('796','4','394');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('797','4','395');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('798','4','396');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('799','4','397');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('800','4','398');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('801','4','399');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('802','5','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('803','5','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('804','5','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('805','5','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('806','5','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('807','5','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('808','5','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('809','5','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('810','5','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('811','5','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('812','5','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('813','5','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('814','5','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('815','5','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('816','5','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('817','5','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('818','5','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('819','5','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('820','5','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('821','5','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('822','5','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('823','5','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('824','5','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('825','5','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('826','5','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('827','5','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('828','5','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('829','5','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('830','5','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('831','5','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('832','5','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('833','5','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('834','5','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('835','5','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('836','5','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('837','5','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('838','5','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('839','5','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('840','5','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('841','5','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('842','5','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('843','5','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('844','5','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('845','5','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('846','5','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('847','5','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('848','5','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('849','5','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('850','5','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('851','5','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('852','5','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('853','5','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('854','5','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('855','5','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('856','5','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('857','5','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('858','5','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('859','5','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('860','5','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('861','5','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('862','5','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('863','5','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('864','5','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('865','5','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('866','5','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('867','5','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('868','5','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('869','5','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('870','5','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('871','5','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('872','5','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('873','5','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('874','5','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('875','5','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('876','5','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('877','5','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('878','5','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('879','5','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('880','5','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('881','5','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('882','5','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('883','5','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('884','5','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('885','5','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('886','5','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('887','5','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('888','5','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('889','5','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('890','5','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('891','5','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('892','5','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('893','5','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('894','5','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('895','5','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('896','5','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('897','5','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('898','5','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('899','5','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('900','5','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('901','5','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('902','6','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('903','6','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('904','6','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('905','6','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('906','6','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('907','6','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('908','6','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('909','6','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('910','6','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('911','6','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('912','6','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('913','6','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('914','6','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('915','6','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('916','6','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('917','6','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('918','6','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('919','6','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('920','6','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('921','6','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('922','6','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('923','6','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('924','6','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('925','6','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('926','6','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('927','6','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('928','6','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('929','6','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('930','6','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('931','6','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('932','6','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('933','6','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('934','6','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('935','6','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('936','6','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('937','6','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('938','6','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('939','6','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('940','6','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('941','6','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('942','6','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('943','6','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('944','6','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('945','6','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('946','6','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('947','6','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('948','6','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('949','6','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('950','6','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('951','6','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('952','6','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('953','6','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('954','6','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('955','6','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('956','6','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('957','6','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('958','6','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('959','6','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('960','6','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('961','6','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('962','6','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('963','6','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('964','6','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('965','6','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('966','6','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('967','6','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('968','6','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('969','6','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('970','6','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('971','6','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('972','6','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('973','6','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('974','6','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('975','6','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('976','6','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('977','6','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('978','6','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('979','6','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('980','6','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('981','6','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('982','6','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('983','6','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('984','6','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('985','6','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('986','6','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('987','6','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('988','6','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('989','6','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('990','6','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('991','6','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('992','6','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('993','6','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('994','6','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('995','6','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('996','6','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('997','6','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('998','6','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('999','6','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1000','6','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1001','6','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1002','7','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1003','7','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1004','7','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1005','7','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1006','7','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1007','7','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1008','7','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1009','7','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1010','7','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1011','7','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1012','7','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1013','7','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1014','7','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1015','7','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1016','7','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1017','7','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1018','7','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1019','7','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1020','7','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1021','7','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1022','7','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1023','7','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1024','7','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1025','7','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1026','7','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1027','7','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1028','7','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1029','7','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1030','7','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1031','7','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1032','7','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1033','7','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1034','7','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1035','7','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1036','7','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1037','7','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1038','7','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1039','7','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1040','7','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1041','7','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1042','7','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1043','7','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1044','7','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1045','7','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1046','7','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1047','7','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1048','7','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1049','7','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1050','7','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1051','7','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1052','7','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1053','7','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1054','7','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1055','7','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1056','7','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1057','7','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1058','7','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1059','7','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1060','7','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1061','7','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1062','7','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1063','7','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1064','7','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1065','7','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1066','7','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1067','7','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1068','7','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1069','7','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1070','7','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1071','7','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1072','7','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1073','7','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1074','7','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1075','7','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1076','7','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1077','7','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1078','7','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1079','7','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1080','7','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1081','7','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1082','7','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1083','7','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1084','7','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1085','7','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1086','7','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1087','7','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1088','7','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1089','7','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1090','7','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1091','7','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1092','7','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1093','7','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1094','7','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1095','7','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1096','7','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1097','7','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1098','7','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1099','7','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1100','7','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1101','7','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1102','7','100');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1103','7','101');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1104','7','102');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1105','7','103');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1106','7','104');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1107','7','105');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1108','7','106');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1109','7','107');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1110','7','108');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1111','7','109');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1112','7','110');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1113','7','111');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1114','7','112');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1115','7','113');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1116','7','114');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1117','7','115');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1118','7','116');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1119','7','117');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1120','7','118');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1121','7','119');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1122','7','120');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1123','7','121');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1124','7','122');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1125','7','123');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1126','7','124');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1127','7','125');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1128','7','126');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1129','7','127');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1130','7','128');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1131','7','129');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1132','7','130');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1133','7','131');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1134','7','132');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1135','7','133');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1136','7','134');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1137','7','135');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1138','7','136');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1139','7','137');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1140','7','138');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1141','7','139');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1142','7','140');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1143','7','141');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1144','7','142');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1145','7','143');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1146','7','144');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1147','7','145');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1148','7','146');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1149','7','147');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1150','7','148');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1151','7','149');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1152','7','150');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1153','7','151');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1154','7','152');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1155','7','153');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1156','7','154');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1157','7','155');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1158','7','156');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1159','7','157');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1160','7','158');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1161','7','159');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1162','7','160');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1163','7','161');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1164','7','162');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1165','7','163');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1166','7','164');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1167','7','165');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1168','7','166');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1169','7','167');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1170','7','168');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1171','7','169');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1172','7','170');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1173','7','171');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1174','7','172');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1175','7','173');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1176','7','174');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1177','7','175');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1178','7','176');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1179','7','177');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1180','7','178');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1181','7','179');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1182','7','180');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1183','7','181');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1184','7','182');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1185','7','183');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1186','7','184');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1187','7','185');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1188','7','186');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1189','7','187');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1190','7','188');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1191','7','189');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1192','7','190');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1193','7','191');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1194','7','192');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1195','7','193');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1196','7','194');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1197','7','195');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1198','7','196');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1199','7','197');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1200','7','198');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1201','7','199');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1202','7','200');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1203','7','201');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1204','7','202');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1205','7','203');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1206','7','204');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1207','7','205');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1208','7','206');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1209','7','207');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1210','7','208');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1211','7','209');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1212','7','210');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1213','7','211');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1214','7','212');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1215','7','213');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1216','7','214');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1217','7','215');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1218','7','216');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1219','7','217');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1220','7','218');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1221','7','219');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1222','7','220');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1223','7','221');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1224','7','222');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1225','7','223');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1226','7','224');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1227','7','225');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1228','7','226');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1229','7','227');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1230','7','228');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1231','7','229');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1232','7','230');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1233','7','231');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1234','7','232');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1235','7','233');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1236','7','234');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1237','7','235');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1238','7','236');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1239','7','237');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1240','7','238');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1241','7','239');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1242','7','240');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1243','7','241');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1244','7','242');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1245','7','243');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1246','7','244');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1247','7','245');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1248','7','246');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1249','7','247');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1250','7','248');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1251','7','249');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1252','7','250');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1253','7','251');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1254','7','252');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1255','7','253');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1256','7','254');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1257','7','255');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1258','7','256');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1259','7','257');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1260','7','258');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1261','7','259');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1262','7','260');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1263','7','261');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1264','7','262');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1265','7','263');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1266','7','264');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1267','7','265');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1268','7','266');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1269','7','267');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1270','7','268');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1271','7','269');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1272','7','270');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1273','7','271');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1274','7','272');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1275','7','273');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1276','7','274');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1277','7','275');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1278','7','276');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1279','7','277');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1280','7','278');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1281','7','279');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1282','7','280');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1283','7','281');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1284','7','282');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1285','7','283');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1286','7','284');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1287','7','285');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1288','7','286');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1289','7','287');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1290','7','288');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1291','7','289');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1292','7','290');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1293','7','291');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1294','7','292');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1295','7','293');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1296','7','294');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1297','7','295');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1298','7','296');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1299','7','297');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1300','7','298');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1301','7','299');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1302','8','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1303','8','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1304','8','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1305','8','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1306','8','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1307','8','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1308','8','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1309','8','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1310','8','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1311','8','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1312','8','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1313','8','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1314','8','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1315','8','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1316','8','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1317','8','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1318','8','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1319','8','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1320','8','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1321','8','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1322','8','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1323','8','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1324','8','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1325','8','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1326','8','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1327','8','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1328','8','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1329','8','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1330','8','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1331','8','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1332','8','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1333','8','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1334','8','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1335','8','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1336','8','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1337','8','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1338','8','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1339','8','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1340','8','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1341','8','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1342','8','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1343','8','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1344','8','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1345','8','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1346','8','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1347','8','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1348','8','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1349','8','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1350','8','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1351','8','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1352','8','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1353','8','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1354','8','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1355','8','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1356','8','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1357','8','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1358','8','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1359','8','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1360','8','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1361','8','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1362','8','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1363','8','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1364','8','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1365','8','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1366','8','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1367','8','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1368','8','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1369','8','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1370','8','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1371','8','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1372','8','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1373','8','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1374','8','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1375','8','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1376','8','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1377','8','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1378','8','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1379','8','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1380','8','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1381','8','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1382','8','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1383','8','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1384','8','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1385','8','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1386','8','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1387','8','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1388','8','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1389','8','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1390','8','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1391','8','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1392','8','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1393','8','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1394','8','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1395','8','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1396','8','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1397','8','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1398','8','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1399','8','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1400','8','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1401','8','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1402','9','0');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1403','9','1');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1404','9','2');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1405','9','3');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1406','9','4');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1407','9','5');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1408','9','6');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1409','9','7');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1410','9','8');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1411','9','9');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1412','9','10');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1413','9','11');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1414','9','12');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1415','9','13');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1416','9','14');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1417','9','15');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1418','9','16');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1419','9','17');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1420','9','18');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1421','9','19');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1422','9','20');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1423','9','21');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1424','9','22');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1425','9','23');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1426','9','24');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1427','9','25');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1428','9','26');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1429','9','27');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1430','9','28');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1431','9','29');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1432','9','30');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1433','9','31');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1434','9','32');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1435','9','33');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1436','9','34');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1437','9','35');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1438','9','36');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1439','9','37');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1440','9','38');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1441','9','39');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1442','9','40');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1443','9','41');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1444','9','42');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1445','9','43');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1446','9','44');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1447','9','45');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1448','9','46');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1449','9','47');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1450','9','48');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1451','9','49');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1452','9','50');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1453','9','51');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1454','9','52');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1455','9','53');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1456','9','54');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1457','9','55');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1458','9','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1459','9','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1460','9','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1461','9','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1462','9','60');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1463','9','61');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1464','9','62');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1465','9','63');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1466','9','64');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1467','9','65');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1468','9','66');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1469','9','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1470','9','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1471','9','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1472','9','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1473','9','71');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1474','9','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1475','9','73');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1476','9','74');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1477','9','75');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1478','9','76');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1479','9','77');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1480','9','78');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1481','9','79');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1482','9','80');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1483','9','81');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1484','9','82');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1485','9','83');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1486','9','84');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1487','9','85');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1488','9','86');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1489','9','87');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1490','9','88');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1491','9','89');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1492','9','90');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1493','9','91');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1494','9','92');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1495','9','93');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1496','9','94');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1497','9','95');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1498','9','96');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1499','9','97');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1500','9','98');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1501','9','99');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1570','28','72');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1571','29','56');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1572','29','57');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1573','29','58');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1574','29','59');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1565','28','67');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1566','28','68');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1567','28','69');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1568','28','70');
Insert into CONNECTION_POINT (CP_ID,CU_ID,CP_NAME) values ('1569','28','71');

-- stub_link

Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('2','2','2','102');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('3','2','2','103');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('4','2','2','104');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('5','2','2','105');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('6','2','2','106');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('108','2','2','108');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('110','2','2','109');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('200','2','2','114');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('202','2','2','115');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('204','2','2','116');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('210','2','2','118');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('208','2','2','119');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('104','2','2','120');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('21','2','2','149');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('100','2','3','202');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('106','2','3','238');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('102','3','4','402');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('105','3','4','427');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('201','3','4','432');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('203','3','4','433');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('205','3','4','434');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('211','3','4','436');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('209','3','4','437');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('207','3','4','438');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('101','4','5','829');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('107','4','5','869');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('1','5','6','1001');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('7','5','7','1002');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('8','5','7','1003');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('9','5','7','1004');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('10','5','7','1005');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('11','5','7','1006');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('109','5','7','1008');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('111','5','7','1009');
Insert into STUB_LINK (STUB_LINK_ID,NODE_ID,CU_ID,CP_ID) values ('103','5','7','1035');

-- cable_link

Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('1','1','2');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('2','2','7');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('3','3','8');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('4','4','9');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('5','5','10');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('6','6','11');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('11','100','101');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('12','102','103');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('13','104','105');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('34','104','207');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('15','106','107');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('16','108','109');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('17','110','111');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('31','200','201');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('32','202','203');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('33','204','205');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('35','208','209');
Insert into CABLE_LINK (CABLE_LINK_ID,STUB_LINK_ID,LINKED_STUB_LINK_ID) values ('36','210','211');