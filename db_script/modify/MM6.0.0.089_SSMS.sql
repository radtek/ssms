
   update t_r_exportsql set EXPORTSQL='select PID, DEVICE_ID, DEVICE_NAME, CONTENTID, CONTENTNAME, RESOURCEID, ID, ABSOLUTEPATH, URL, PROGRAMSIZE, CREATEDATE, PROSUBMITDATE, MATCH, VERSION, PERMISSION, ISCDN, VERSIONNAME, PICTURE1, PICTURE2, PICTURE3, PICTURE4, CLIENTID, PKGNAME,  replace(replace(VERSIONDESC,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as   VERSIONDESC , CDNURL, ISWHITELIST, CAFLAG, CADEV, CAORG, CAVALIDATEDATE, WAPURL, MOURL, CERMD5, MD5CODE, PCURL, WWWURL, THIRDCOLLECT from t_a_cm_device_resource' where id=100;            
   commit;
   
   update t_r_exportsql set EXPORTSQL='select ID, NAME, CATENAME, APPCATENAME, APPCATEID, SPNAME, ICPCODE, ICPSERVID, CONTENTTAG, SINGER, PRICE, EXPIRE, AUDITIONURL, replace(replace(INTRODUCTION,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as INTRODUCTION, NAMELETTER, SINGERLETTER, DOWNLOADTIMES, SETTIMES, BIGCATENAME, CONTENTID, COMPANYID, PRODUCTID, KEYWORDS, CREATEDATE, MARKETDATE, LUPDDATE, LANGUAGE, WWWPROPAPICTURE1, WWWPROPAPICTURE2, WWWPROPAPICTURE3, CLIENTPREVIEWPICTURE1, CLIENTPREVIEWPICTURE2, CLIENTPREVIEWPICTURE3, CLIENTPREVIEWPICTURE4, PROVIDER, HANDBOOK, MANUAL, HANDBOOKPICTURE, USERGUIDE, USERGUIDEPICTURE, GAMEVIDEO, LOGO1, LOGO2, LOGO3, CARTOONPICTURE, DEVICENAME, DEVICENAME02, DEVICENAME03, DEVICENAME04, DEVICENAME05, DEVICENAME06, DEVICENAME07, DEVICENAME08, DEVICENAME09, DEVICENAME10, DEVICENAME11, DEVICENAME12, DEVICENAME13, DEVICENAME14, DEVICENAME15, DEVICENAME16, DEVICENAME17, DEVICENAME18, DEVICENAME19, DEVICENAME20, DAYSEARCHTIMES, WEEKSEARCHTIMES, MONTHSEARCHTIMES, SEARCHTIMES, DAYSCANTIMES, WEEKSCANTIMES, MONTHSCANTIMES, SCANTIMES, DAYORDERTIMES, WEEKORDERTIMES, MONTHORDERTIMES, ORDERTIMES, DAYCOMMENTTIMES, WEEKCOMMENTTIMES, MONTHCOMMENTTIMES, COMMENTTIMES, DAYMARKTIMES, WEEKMARKTIMES, MONTHMARKTIMES, MARKTIMES, DAYCOMMENDTIMES, WEEKCOMMENDTIMES, MONTHCOMMENDTIMES, COMMENDTIMES, DAYCOLLECTTIMES, WEEKCOLLECTTIMES, MONTHCOLLECTTIMES, COLLECTTIMES, AVERAGEMARK, ISSUPPORTDOTCARD, PROGRAMSIZE, PROGRAMID, ONLINETYPE, VERSION, PICTURE1, PICTURE2, PICTURE3, PICTURE4, PICTURE5, PICTURE6, PICTURE7, PICTURE8, PLATFORM, CHARGETIME, LOGO4, BRAND, SERVATTR, SUBTYPE, PVCID, CITYID, FULLDEVICENAME, MATCH_DEVICEID, EXPPRICE, FULLDEVICEID, MODAYORDERTIMES, PLUPDDATE, OTHERNET, RICHAPPDESC, ADVERTPIC, PRICETYPE, COMPAREDNUMBER, replace(replace(FUNCDESC,to_char(chr(13)),'''') ,to_char(chr(10)),'''')FUNCDESC, MSTATUS, LOGO5, LOGO6, ISMMTOEVENT, COPYRIGHTFLAG, MAPNAME, CHANNELDISPTYPE from t_r_gcontent' where id=99;            
   commit; 
   
   update t_r_exportsql set EXPORTSQL='select ID, PROGRAMID, CMS_ID, PROPERTYKEY, replace(replace(PROPERTYVALUE,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as   PROPERTYVALUE, LUPDATE, EXETIME from t_v_videosPropertys' where id=98;           
  commit;
  
   update t_r_exportsql set EXPORTSQL='select ID,PROGRAMID,CMSID,NAME,NAME1,NAME2,CREATETIMEV,UPDATETIMEV,PUBLISHTIMEV,PRDPACK_ID,PRODUCT_ID,CATEGORY,TYPE,SERIALCONTENTID,SERIALSEQUENCE,SERIALCOUNT,FORMTYPE,COPYRIGHTTYPE,VIDEONAME,VSHORTNAME,VAUTHOR,DIRECTRECFLAG,AREA,TERMINAL,WAY,PUBLISH,KEYWORD,CDURATION,DISPLAYTYPE,DISPLAYNAME,ASSIST,LIVESTATUS,LUPDATE,EXETIME,AUTHORIZATIONWAY,MIGUPUBLISH,BCLICENSE,INFLUENCE,ORIPUBLISH,SUBSERIAL_IDS,FEETYPE, replace(replace(DETAIL,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as DETAIL from t_v_dprogram' where id=97;      
   commit;
   
   update t_r_exportsql set EXPORTSQL='select AUTHORID, AUTHORNAME,  replace(replace(AUTHORDESC,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as   AUTHORDESC, ISORIGINAL, ISPUBLISH  from T_RB_AUTHOR_NEW' where id=95;           
  commit;
  
   update t_r_exportsql set EXPORTSQL='select BOOKID, BOOKNAME, KEYWORD, LONGRECOMMEND, SHORTRECOMMEND,  replace(replace(DESCRIPTION,to_char(chr(13)),'''') ,to_char(chr(10)),'''') as  DESCRIPTION, AUTHORID, TYPEID, INTIME, CHARGETYPE, FEE, ISFINISH, WORDCOUNT, CHAPTERCOUNT, FREECHAPTERCOUNT from t_rb_book_new where delflag=0' where id=94;           
  commit;