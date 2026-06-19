package com.swp391.carrental.report.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/*
 * Name: VehicleUtilizationReportServlet
 * @Author: TamTTMHE190340
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for VehicleUtilizationReportServlet.
 */


@WebServlet(name = "VehicleUtilizationReportServlet", urlPatterns = {"/reports/vehicle-utilization"})
public class VehicleUtilizationReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Generate vehicle utilization report
        request.getRequestDispatcher("/WEB-INF/views/report/vehicle-utilization-report.jsp").forward(request, response);
    }
}

