<%@ page import="password.pwm.config.option.SelectableContextMode" %>
<%@ page import="password.pwm.config.profile.LdapProfile" %>
<%@ page import="password.pwm.error.PwmException" %>
<%@ page import="password.pwm.http.JspUtility" %>
<%@ page import="password.pwm.http.PwmRequest" %>
<%@ page import="password.pwm.util.java.StringUtil" %>
<%@ page import="password.pwm.config.PwmSetting" %>
<%@ page import="password.pwm.PwmConstants" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Map" %>
<%--
  ~ Password Management Servlets (PWM)
  ~ http://www.pwm-project.org
  ~
  ~ Copyright (c) 2006-2009 Novell, Inc.
  ~ Copyright (c) 2009-2017 The PWM Project
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  --%>

<%@ taglib uri="pwm" prefix="pwm" %>
<%
    SelectableContextMode selectableContextMode = SelectableContextMode.NONE;
    Map<String,LdapProfile> ldapProfiles = Collections.emptyMap();
    String selectedProfileParam = "";
    LdapProfile selectedProfile = null;
    Map<String,String> selectableContexts = null;
    boolean showContextSelector = false;
    try {
        final PwmRequest pwmRequest = PwmRequest.forRequest(request, response);
        selectableContextMode = pwmRequest.getConfig().readSettingAsEnum(PwmSetting.LDAP_SELECTABLE_CONTEXT_MODE,SelectableContextMode.class);
        ldapProfiles = pwmRequest.getConfig().getLdapProfiles();
        selectedProfileParam = pwmRequest.readParameterAsString(PwmConstants.PARAM_LDAP_PROFILE);
        selectedProfile = pwmRequest.getConfig().getLdapProfiles().containsKey(selectedProfileParam)
                ? pwmRequest.getConfig().getLdapProfiles().get(selectedProfileParam)
                : pwmRequest.getConfig().getDefaultLdapProfile();
        selectableContexts = selectedProfile.getSelectableContexts(pwmRequest.getPwmApplication());
        showContextSelector = selectableContextMode == SelectableContextMode.SHOW_CONTEXTS && selectedProfile != null && selectableContexts.size() > 0;
    } catch (PwmException e) {
        /* noop */
    }
%>
<% if (selectableContextMode != SelectableContextMode.NONE && ldapProfiles.size() > 1) { %>
<h2 class="loginFieldLabel"><label for="<%=PwmConstants.PARAM_LDAP_PROFILE%>"><pwm:display key="Field_LdapProfile"/></label></h2>
<div class="formFieldWrapper">
    <select name="<%=PwmConstants.PARAM_LDAP_PROFILE%>" id="<%=PwmConstants.PARAM_LDAP_PROFILE%>" class="selectfield" title="<pwm:display key="Field_LdapProfile"/>">
        <% for (final String profileID : ldapProfiles.keySet()) { %>
        <% final String displayName = ldapProfiles.get(profileID).getDisplayName(JspUtility.locale(request)); %>
        <option value="<%=profileID%>"<%=(profileID.equals(selectedProfileParam))?" selected=\"selected\"":""%>><%=StringUtil.escapeHtml(
                displayName)%></option>
        <% } %>
    </select>
</div>
<% } %>
<div style="display: <%=showContextSelector?"inherit":"none"%>" id="contextSelectorWrapper">
    <h2 class="loginFieldLabel"><label for="<%=PwmConstants.PARAM_CONTEXT%>"><pwm:display key="Field_Location"/></label></h2>
    <div class="formFieldWrapper">
        <select name="<%=PwmConstants.PARAM_CONTEXT%>" id="<%=PwmConstants.PARAM_CONTEXT%>" class="selectfield" title="<pwm:display key="Field_Location"/>">
            <% for (final String key : selectableContexts.keySet()) { %>
            <option value="<%=StringUtil.escapeHtml(key)%>"><%=StringUtil.escapeHtml(selectableContexts.get(key))%></option>
            <% } %>
        </select>
    </div>
</div>
