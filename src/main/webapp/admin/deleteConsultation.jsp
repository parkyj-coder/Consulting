<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ConsultationDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    try {
        String idStr = request.getParameter("id");
        
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            ConsultationDAO dao = new ConsultationDAO();
            boolean success = dao.deleteConsultation(id);
            
            if (success) {
                out.print("success");
            } else {
                out.print("error");
            }
        } else {
            out.print("error");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>
