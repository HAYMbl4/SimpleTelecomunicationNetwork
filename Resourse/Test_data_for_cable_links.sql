select * from node; -- 2

select * from connection_unit where node_id = 2;

select * from connection_point where cu_id = 2;

select * from stub_link;

insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 2, 2, 102);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 2, 2, 103);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 2, 2, 104);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 2, 2, 105);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 2, 2, 106);

--

select * from node; -- 5

select * from connection_unit where node_id = 5; --7

select * from connection_point where cu_id = 7;

insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 5, 7, 1002);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 5, 7, 1003);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 5, 7, 1004);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 5, 7, 1005);
insert into stub_link (stub_link_id, node_id, cu_id, cp_id) values (gen_stub_link.nextval, 5, 7, 1006);


--

select * from stub_link;

insert into cable_link (cable_link_id, stub_link_id, linked_stub_link_id) values (gen_cable_links.nextval, 2, 7);
insert into cable_link (cable_link_id, stub_link_id, linked_stub_link_id) values (gen_cable_links.nextval, 3, 8);
insert into cable_link (cable_link_id, stub_link_id, linked_stub_link_id) values (gen_cable_links.nextval, 4, 9);
insert into cable_link (cable_link_id, stub_link_id, linked_stub_link_id) values (gen_cable_links.nextval, 5, 10);
insert into cable_link (cable_link_id, stub_link_id, linked_stub_link_id) values (gen_cable_links.nextval, 6, 11);