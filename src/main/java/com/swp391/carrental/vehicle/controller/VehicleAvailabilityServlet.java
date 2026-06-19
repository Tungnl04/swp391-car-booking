package com.swp391.carrental.vehicle.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/*
 * Name: VehicleAvailabilityServlet
 * @Author: TinhHNHE172394
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for VehicleAvailabilityServlet.
 */


@WebServlet(name = "VehicleAvailabilityServlet", urlPatterns = {"/vehicles/availability"})
public class VehicleAvailabilityServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Parse date range and show available cars
        request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-availability.jsp").forward(request, response);
    }
}

