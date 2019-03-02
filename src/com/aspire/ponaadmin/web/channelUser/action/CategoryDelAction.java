package com.aspire.ponaadmin.web.channelUser.action ;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aspire.common.config.ConfigFactory;
import com.aspire.common.config.ModuleConfig;
import com.aspire.common.db.DAOException;
import com.aspire.common.exception.BOException;
import com.aspire.common.log.proxy.JLogger;
import com.aspire.common.log.proxy.LoggerFactory;
import com.aspire.dotcard.syncAndroid.dc.jms.MSGType;
import com.aspire.dotcard.syncAndroid.ssms.SSMSDAO;
import com.aspire.ponaadmin.common.usermanager.UserManagerBO;
import com.aspire.ponaadmin.web.BaseAction;
import com.aspire.ponaadmin.web.channelUser.util.Common;
import com.aspire.ponaadmin.web.constant.Constants;
import com.aspire.ponaadmin.web.constant.ResourceConstants;
import com.aspire.ponaadmin.web.repository.Category;
import com.aspire.ponaadmin.web.repository.CategoryBO;
import com.aspire.ponaadmin.web.repository.Repository;
import com.aspire.ponaadmin.web.repository.RepositoryBOCode;
import com.aspire.ponaadmin.web.repository.RepositoryConstants;

/**
 * <p>ɾ�������Action</p>
 * <p>Copyright (c) 2003-2005 ASPire TECHNOLOGIES (SHENZHEN) LTD All Rights Reserved</p>
 * @author shidr
 * @version 1.0.1.0
 * @since 1.0.1.0
 */
public class CategoryDelAction extends BaseAction
{

    /**
     * ��־����
     */
    private static final JLogger LOG = LoggerFactory.getLogger(CategoryDelAction.class) ;

    /**
     *
     * @param mapping ActionMapping
     * @param form ActionForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ActionForward
     * @throws BOException
     * @todo Implement this com.aspire.ponaadmin.web.BaseAction method
     */
    public ActionForward doPerform (ActionMapping mapping, ActionForm form,
                                    HttpServletRequest request,
                                    HttpServletResponse response)
        throws BOException
    {
    	if(request.getSession() == null || UserManagerBO.getInstance()
    			.getUserSessionVO(request.getSession()) == null){
    		this.saveMessages(request, "�û�δ��½���ߵ�½�ѳ�ʱ��");
    		request.setAttribute(Constants.PARA_GOURL, "index.jsp");
    		 request.setAttribute("loginResult", new Integer(Common.LOGINRESULT));
    		return mapping.findForward(Common.LOGIN_HINT_CHANNELUSER);
    	}
        LOG.debug("doPerform()");
        String categoryID = this.getParameter(request, "categoryID");
        String pCategoryID = this.getParameter(request, "pCategoryID");
        String cgyPath=this.getParameter(request, "cgyPath");
        
        
        
        
        //cgyPath=cgyPath.substring(0, cgyPath.lastIndexOf("&gt;&gt;"));
        cgyPath=cgyPath.substring(0, cgyPath.lastIndexOf(">>"));
        String actionType = "ɾ������";
        String actionTarget = "";
        String actionDesc = "";
        boolean actionResult = true;
        String forward = null;
        try
        {
        	// ��ȡ������Ϣ
            Category category = ( Category ) Repository.getInstance()
                                                       .getNode(categoryID,
                                                          RepositoryConstants.TYPE_CATEGORY);
            actionTarget = CategoryBO.getInstance().getCategory(categoryID).getName();
            CategoryBO.getInstance().delCategory(pCategoryID, category);
            this.saveMessages(request, "RESOURCE_CATE_RESULT_002") ;
            request.setAttribute(Constants.PARA_GOURL,
                                 "../../web/channelUser/categoryInfo.do?categoryID=" +
                                 pCategoryID+"&cgyPath="+cgyPath) ;
            request.setAttribute(Constants.PARA_REFRESH_TREE_KEY, pCategoryID) ;
            
            request.setAttribute("del_node_cgyPath", this.getParameter(request, "cgyPath")) ;
            
            forward = Constants.FORWARD_COMMON_SUCCESS ;


            //����ӵ���Ϣ����,��������޸Ļ��ܵĶ���Ҫ֪ͨ���������ģ��Ȱ����ݼӵ�T_a_messages����Ȼ��ר���̷߳�����Ϣ��
			ModuleConfig module = ConfigFactory.getSystemConfig().getModuleConfig("syncAndroid");
			String rootCategoryId = module.getItemValue("ROOT_CATEGORYID");
			String operateCategoryId = module.getItemValue("OPERATE_ROOT_CATEGORYID");//������Ʒ���Ż��������µ���Ӫ����
            if(SSMSDAO.getInstance().isAndroidCategory(categoryID, rootCategoryId)
            	||SSMSDAO.getInstance().isOperateCategory(categoryID, operateCategoryId)){//modify by aiyan 2013-05-18	 
//            	Catogoryid	����	String	����ID
//            	Action	����	String	0���½�
//            	1������������Ϣ�����������չ�ֶΣ�
//            	9��ɾ��
//            	Transactionid	����	String	��������ID�����ڴ���ͬһ��������ʱʹ�á�

            	try {
					SSMSDAO.getInstance().addMessages(MSGType.CatogoryModifyReq, categoryID+":9");
				} catch (DAOException e) {
					// TODO Auto-generated catch block
					LOG.error("�޸Ļ��ܼ�¼��Ϣ�ǳ��������޸ĵĻ���ID:"+categoryID,e);					
				}
            }
            
        }
        catch(BOException e)
        {
            LOG.error(e);
            if(e.getErrorCode() == RepositoryBOCode.CATEGORY_CONTENT_EXISTED)
            {
                //����Դ���ӻ��ܴ��ڣ�����ɾ����
                actionDesc = "�����²�Ϊ��";
                this.saveMessages(request, "RESOURCE_CATE_BO_CHECK_002") ;
            }
            else
            {
                this.saveMessages(request, ResourceConstants.WEB_ERR_SYSTEM) ;
            }
            actionResult = false;
            forward = Constants.FORWARD_COMMON_FAILURE;
        }
        //д������־
        this.actionLog(request, actionType, actionTarget, actionResult, actionDesc);
        return mapping.findForward(forward);
    }
}
