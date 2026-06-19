package com.swp391.carrental.user.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.carrental.user.constant.Role;
import com.swp391.carrental.user.model.User;

/*
 * Name: RolePermissionsServlet
 * @Author: AnhNNHE160896
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for RolePermissionsServlet.
 */



/**
 * Handles role permissions management (Admin only).
 * URL: /roles
 */
@WebServlet(name = "RolePermissionsServlet", urlPatterns = {"/roles"})
public class RolePermissionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Load role permissions data
        request.getRequestDispatcher("/WEB-INF/views/user/role-permissions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Update role permissions
        response.sendRedirect(request.getContextPath() + "/roles");
    }
}

