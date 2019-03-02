/* Generated by Together */

package com.aspire.common.config;

/**
 * <p>Title: Poralt OAM</p>
 * <p>Description: Portal OAM Program file</p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: Aspire Technologies</p>
 * @author He Chengshou
 * @version 1.0
 */
// @CheckItem@ OPT-hecs-20040202 ���Ӻ궨�幦��

public class Attribute
    implements java.io.Serializable
{
    private static final long serialVersionUID = 1L;
    private org.jdom.Attribute attribute = null;

    public Attribute(String name, String value)
    {
        attribute = new org.jdom.Attribute(name, value);
    }

    public String getName()
    {
        return attribute.getName();
    }

    /**
     * ���غ��滻ǰ������ֵ
     * @return
     */
    public String getOrigValue()
    {
        return attribute.getValue();
    }

    /**
     * ���غ��滻�������ֵ
     * @return
     */
    public String getValue()
    {
        MarcoDef marco = MarcoDef.getInstance();
        String value = attribute.getValue();
        return marco.replaceByMarco(value);
    }

    public void setValue(String value)
    {
        attribute.setValue(value);
    }

}