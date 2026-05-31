/*
 * Name: HomeServlet
 * @Author: BacBXHE186736
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for HomeServlet.
 */
package com.swp391.carrental.controller.booking;

import com.swp391.carrental.service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("featuredCars", vehicleService.getCarsByStatus("AVAILABLE"));
        request.getRequestDispatcher("/WEB-INF/views/booking/home.jsp").forward(request, response);
    }
}

