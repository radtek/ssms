update t_r_exportsql set EXPORTLINE=22,exportsql='select distinct d.programid VideoID,d.name VName,'''' Type, c.fee Price, '''' Star,'''' Dayplaynum,'''' totalPlayNum, '''' dayDownNum ,'''' totalDownNum ,to_char(to_date(d.updatetimev,''yyyy-mm-dd hh24:mi:ss''),''yyyyMMdd'') ,'''' Label,d.Vshortname Brief ,'''' Hot, decode(d.type,2,1,2) ChildCategory,''all'' FullDevice ,''''   imgurl1,''''  imgurl2,''''     cid,d.CDURATION  playtime,d.displayname Category1,p.key  Category2,p.value Tag from t_v_dprogram d,(select f.fee fee,p.servid from  t_v_propkg p left join t_v_PRODUCT f on p.dotfeecode=f.feecode) c,(select p.programid,p.cms_id,listagg(p.propertyvalue,''|'')within GROUP (order by p.programid,p.cms_id)  as value,listagg(p.propertykey,''|'')within GROUP (order by p.programid,p.cms_id)  as key from t_v_videospropertys p where exists(select 1 from t_v_dprogram d where p.programid=d.programid and d.FORMTYPE not in (6, 7) and d.PRDPACK_ID <> ''1003221'')group by p.programid,p.cms_id) p where d.prdpack_id = c.servid(+) and d.programid = p.programid(+) and p.cms_id(+) = d.cmsid and d.FORMTYPE not in (6,7) and d.PRDPACK_ID <>''1003221''
' where id=88;

delete DBVERSION where PATCHVERSION = 'MM5.0.0.0.079_SSMS' and LASTDBVERSION = 'MM5.0.0.0.075_SSMS';
commit;