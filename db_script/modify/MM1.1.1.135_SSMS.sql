-- Add/modify columns 
alter table T_SYNC_TACTIC_MOTO add SUBTYPE VARCHAR2(2);
-- Add comments to the columns 
comment on column T_SYNC_TACTIC_MOTO.SUBTYPE
  is '12 MOTOӦ��,16 htcӦ��';


update t_sync_tactic_moto t set t.subtype='12';


create or replace view v_cm_motoext as
select t.appid,
         t.bcontenttype,
         t.btype,
         t.developername,
         t.onlinedate,
         e.typename,
         e.stypename
    from s_cm_content_motoext t, s_cm_ext_moto_type e
   where t.btype = e.stypeid
   and t.thirdapptype = '12' and e.thirdapptype='12';


create or replace view v_cm_htcext as
select t.appid,
         t.bcontenttype,
         t.btype,
         t.developername,
         t.onlinedate,
         e.typename,
         e.stypename
    from s_cm_content_motoext t, s_cm_ext_moto_type e
   where t.btype = e.stypeid
   and t.thirdapptype = '16' and e.thirdapptype='16';


create table CM_CONTENT_HTCEXT as select * from v_cm_htcext ;




create or replace view ppms_v_cm_content as
select a.typename,
       b.catalogid,
       b.name as cateName,
       c.contentid,
       c.name,
       decode(c.thirdapptype,
              '10',
              c.oviappid,
              '12',
              c.oviappid,
	      '16',
              c.oviappid,
              c.contentcode) ContentCode,
       c.Keywords,
       decode(c.status,
              '0006',
              decode(f.status, 2, '0006', 5, '0008'),
              '1006',
              decode(f.status, 2, '0006', 5, '0008'),
              '0015',
              decode(f.status || f.substatus, '61', '0006', '0008'),
              '1015',
              decode(f.status || f.substatus, '61', '0006', '0008')) as status,
       decode(c.status, '0015', 'L', '1015', 'L', d.servattr) as ServAttr,
       c.createdate,
       decode(c.status,
              '0006',
              f.onlinedate,
              '1006',
              f.onlinedate,
              f.SubOnlineDate) as marketdate,
       --ȫ��ȡonlinedate��ʡ��ȡSubOnlineDate
       d.servicecode as icpservid,
       d.ProductID,
       e.apcode as icpcode,
       e.companyid,
       decode(c.thirdapptype,
              '12',
              (select max(m.developername)
                 from s_cm_content_motoext m
                where c.oviappid = m.appid
                  and m.thirdapptype = '12'),
              '16',
              (select max(m.developername)
                 from s_cm_content_motoext m
                where c.oviappid = m.appid
                  and m.thirdapptype = '16'),
              decode(c.companyid,
                     '116216',
                     '2010MM��ҵ�ƻ�����Ӧ��չʾ',
                     e.companyname)) as companyname,
       substr(f.paymethod, 2, 1) as isSupportDotcard,
       greatest(c.lupddate, f.lastupdatedate, f.contentlupddate, e.lupddate) as plupddate,
       c.conlupddate as lupddate, -----����Ӧ�ø���ʱ��
       decode(c.thirdapptype, '7', '2', f.chargeTime) chargeTime,
       decode(c.thirdapptype, '13', '1', '14', '1', c.thirdapptype) thirdapptype,
       c.pvcid,
       c.citysid as cityid,
       decode(f.chargetime ||
              decode(c.chargetype, '01', '02', c.chargetype) || c.contattr ||
              e.operationsmode || c.thirdapptype,
              '102G01',
              '1',
              '102G02',
              '1',
              '102G05',
              '1',
              '102G012',
              '1',
              '0') as othernet
  from cm_content_type    a,
       cm_catalog         b,
       cm_content         c,
       v_om_product       d,
       v_valid_company    e,
       OM_PRODUCT_CONTENT f --
 where a.contenttype = b.contenttype
   and b.catalogid = c.catalogid
   and c.companyid = e.companyid ----ap����
   and (c.status = '0006' or c.status = '1006' or f.status = 5 or
       ((f.substatus = '1' or f.substatus = '0') and
       (c.status = '0015' or c.status = '1015') and (f.status = 6)))
      ----Ӧ�����û��������û���ʡ������/����
   and d.AuditStatus = '0003' ----��Ʒ���ͨ��
   and d. ProductStatus in ('2', '3', '5') ----��Ʒ���߼Ʒ�or���Ʒ�or ����
   and f.ID = d.ID ----���ɲ�Ʒ
   and c.contentid = f.contentid ----��Ʒ��ID���������ݱ���
   and d.startdate <= sysdate
   and (d.paytype = 0 or d.paytype is null)
   and (c.thirdapptype in ('1', '2', '7', '11', '12', '13', '14','16') or
       (c.thirdapptype = '5' and c.Jilstatus = '1'));



create or replace view ppms_v_service as
select p.contentid,
       v1.apcode as icpcode,
       v1.CompanyName as spname,
       v1.ShortName as spshortname,
       v2.ServiceCode as icpservid,
       v2.ProductName as servname,
       decode(v2.ProductStatus, '2', 'A', '3', 'B', '4', 'P', '5', 'E') as SERVSTATUS,
       decode(v2.ACCESSMODEID,
              '00',
              'S',
              '01',
              'W',
              '02',
              'M',
              '10',
              'A',
              '05',
              'E') as umflag,
       decode(v2.ServiceType, 1, 8, 2, 9) as servtype,
       v2.ChargeType as ChargeType,
       v2.paytype,
       v2.Fee as mobileprice,
       V2.PayMode_card as dotcardprice,
       decode(c.thirdapptype,
              '11',
              c.pkgfee||'',
              decode(p.chargetime || v2.paytype,
                     '20',
                     p.feedesc,
                     v2.chargedesc)) as chargeDesc,
       v2.ProviderType,
       v2.servattr,
       v2.Description as servdesc,
       v1.apcode || '_' || v2.ServiceCode as pksid,
       v2.LUPDDate
  from v_valid_company    v1,
       v_om_product       v2,
       OM_PRODUCT_CONTENT p,
       cm_content         c
 where p.contentid = c.contentid
   and c.companyid = v1.companyid
   and p.id = v2.id
   and (c.thirdapptype in ('1', '2','6','7','11','12','13','14','16') or (c.thirdapptype = '5' and c.Jilstatus = '1') )
  UNION ALL
 select
       t.contentid,
       t.icpcode,
       t.spname,
       null,
       t.icpservid,
       t.servname,
       'A',--���߼Ʒ�
       null,
       --8,
       t.servflag,--����Ϸ���ۿ�����
       '0'||t.chargetype as chargetype,--����Ϸ���Ʒ�����
       null,
       t.mobileprice,
        t.ptypeid,--����Ϸ��֧����ʽ
       t.chargedesc,--����Ϸ���ʷ�����
       'B',
       'G',--ȫ��ҵ��
       t.servtype,--����Ϸ��ҵ������
       t.firsttype,--����Ϸ���׷�����
       t.lupddate
  from t_game_service_new t;



insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (662, '606785201', 'all', '0', null, 0, 'ϵͳ.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (666, '606785202', 'all', '0', null, 0, '����.�Ż�', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (669, '606785203', 'all', '0', null, 0, 'Ӱ��.��Ƶ', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (673, '606785204', 'all', '0', null, 0, '����.���', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (677, '606785205', 'all', '0', null, 0, '����.֧��', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (667, '606785206', 'all', '0', null, 0, '��ͨ.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (649, '606785207', 'all', '0', null, 0, '�鼮.�Ķ�', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (650, '606785208', 'all', '0', null, 0, 'ѧϰ.�׽�', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (651, '606785209', 'all', '0', null, 0, '����.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (652, '606785210', 'all', '0', null, 0, '��ֽ.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (653, '606785211', 'all', '0', null, 0, '����.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (654, '606785212', 'all', '0', null, 0, '����.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (655, '606785213', 'all', '0', null, 0, 'Ȥζ.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (656, '606785214', 'all', '0', null, 0, '�칫.Ч��', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (657, '606785215', 'all', '0', null, 0, '�罻.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (658, '606785216', 'all', '0', null, 0, '����.ҽ��', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (659, '606785217', 'all', '0', null, 0, '����.����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (660, '606785218', 'all', '0', null, 0, '����ð��', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (661, '606785219', 'all', '0', null, 0, '�������', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (663, '606785220', 'all', '0', null, 0, 'ս�Ծ�Ӫ', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (664, '606785221', 'all', '0', null, 0, '��������', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (665, '606785223', 'all', '0', null, 0, '��ͯ����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (668, '606785225', 'all', '0', null, 0, '������Ϸ', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (670, '606785227', 'all', '0', null, 0, '���ֽ���', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (671, '606785228', 'all', '0', null, 0, '��������', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (672, '606785230', 'all', '0', null, 0, 'ģ����Ϸ', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (674, '606785231', 'all', '0', null, 0, '��ɫ����', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (675, '606785232', 'all', '0', null, 0, '�����˶�', '2013-01-24 15:22:28', null, '16');
insert into T_SYNC_TACTIC_MOTO (ID, CATEGORYID, CONTENTTYPE, UMFLAG, CONTENTTAG, TAGRELATION, APPCATENAME, CRATETIME, LASTUPDATETIME, SUBTYPE)
values (676, '606785233', 'all', '0', null, 0, '�������', '2013-01-24 15:22:28', null, '16');



insert into dbversion(DBSEQ,DBVERSION,LASTDBVERSION,PATCHVERSION) values (SEQ_DB_VERSION.nextval,'1.0.0.0','MM1.1.1.129_SSMS','MM1.1.1.135_SSMS');


commit;