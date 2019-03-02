package com.aspire.dotcard.basecomic;


import java.util.Calendar;
import java.util.Date;
import java.util.Timer;

import com.aspire.common.config.ConfigFactory;
import com.aspire.common.config.ModuleConfig;
import com.aspire.common.log.proxy.JLogger;
import com.aspire.common.log.proxy.LoggerFactory;
import com.aspire.dotcard.basemusic.config.BaseMusicConfig;

import com.aspire.ponaadmin.web.util.DateUtil;

public class BaseComicLoadTimer
{
	
	private static BaseComicLoadTimer instance = new BaseComicLoadTimer();
    /**
     * ���췽��
     */
    private BaseComicLoadTimer ()
    {

    }
public static BaseComicLoadTimer getInstance(){
	return instance;
}
    /**
     * ��¼��־��ʵ������
     */
    private static JLogger LOG = LoggerFactory.getLogger(BaseComicLoadTimer.class) ;

    /**
     * ��ʼ����������timer
     */
    public  void start ()
    {
        //ϵͳĬ�ϵĻ�������ͬ��ִ��ʱ�� 5:00
        int hour = 5;
        int minute = 0;
        //���������л�ȡ����ֵ
        try
        {
        	ModuleConfig module = ConfigFactory.getSystemConfig().getModuleConfig(
			"dmbase");
            String BaseMusiSynStartTime = module.getItemValue("BaseComicSynStartTime") ;
            hour = Integer.parseInt(BaseMusiSynStartTime.split(":")[0]);
            minute = Integer.parseInt(BaseMusiSynStartTime.split(":")[1]);
        }
        catch (Exception ex)
        {
            LOG.error("���������л�ȡ��������ͬ����ʱ��BaseComicSynStartTime����������");
        }
        if(hour<0||hour>23)
        {
            //����ֵ����ȷ����ʹ��Ĭ��ֵ
            hour = 5 ;
        }
        if(minute<0||minute>59)
        {
            //����ֵ����ȷ����ʹ��Ĭ��ֵ
            minute = 0 ;
        }

        //���ʱ��Ϊһ��24Сʱ
        long taskIntervalMS = (long) (24 * 60 * 60 * 1000) ;
        Timer timer = new Timer(true) ;
        Date firstStartTime = null;
        try
        {
            //ȡ��ǰʱ��
            Date date = new Date();
            //�����һ����������ʱ��
            firstStartTime = getOneTimeByHourAndMinute(date,hour,minute);
            //�����һ������ʱ�����ڵ�ǰʱ�䣬��Ҫ�ѵ�һ������ʱ���һ��
            if(firstStartTime.before(date))
            {
                Calendar calendar = Calendar.getInstance();          
                calendar.add(Calendar.DAY_OF_YEAR, 1);
                Date tommorrow = calendar.getTime();                
                firstStartTime = getOneTimeByHourAndMinute(tommorrow,hour,minute);
            }
        }
        catch (Exception ex)
        {
            //����ʱ�����쳣�����õ�ǰ��ʱ��ɣ������������û��bug������쳣Ӧ���ǲ����ܳ��ֵ�
            firstStartTime = new Date();
        }    
        timer.schedule(new BaseComicLoadTask(), firstStartTime, taskIntervalMS) ;
        //timer.schedule(new BaseComicLoadTask(), 1000, taskIntervalMS) ;
        if (LOG.isDebugEnabled())
        {
            LOG.debug("schedule a BaseComicLoadTask,first start time is:" + firstStartTime) ;
        }
    }

    /**
     * ��ȡһ��ĳ��ָ��ʱ���time
     * @param date Date
     * @param hour int
     * @return Date
     * @throws Exception
     */
    private static Date getOneTimeByHourAndMinute(Date date,int hour,int minute)
    {
        String c = DateUtil.formatDate(date,"yyyyMMdd");
        if(hour<10)
        {
            c = c + '0';
        }
        c = c + hour + minute + "00" ;
        return DateUtil.stringToDate(c,"yyyyMMddHHmmss");
    }

//    public static void main(String[] args)
//    {
//        try
//        {
//            Date date = new Date();
//            Date firstStartTime = getOneTimeByHourAndMinute(date,3,0);
//            System.out.println(firstStartTime) ;
//            if(firstStartTime.before(date))
//            {
//                Calendar calendar = Calendar.getInstance();               
//                calendar.add(Calendar.DAY_OF_YEAR, 1);
//                Date tommorrow = calendar.getTime();                
//                firstStartTime = getOneTimeByHourAndMinute(tommorrow,3,0);
//                System.out.println("firstStartTime===="+firstStartTime) ;
//            }            
//        }
//        catch (Exception ex)
//        {
//
//        }
//    }
}