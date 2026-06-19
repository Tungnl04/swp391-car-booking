package com.swp391.carrental.vehicle.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.swp391.carrental.vehicle.model.Car;
import com.swp391.carrental.vehicle.service.VehicleService;

/*
 * Name: VehicleListServlet
 * @Author: TinhHNHE172394
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Public vehicle catalog for guest and customer browsing.
 */



@WebServlet(name = "VehicleListServlet", urlPatterns = {"/vehicles"})
public class VehicleListServlet extends HttpServlet {
    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Car> cars = vehicleService.getAllCars();
        request.setAttribute("cars", cars);
        request.setAttribute("primaryImages", vehicleService.getPrimaryImageUrls(cars));
        request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-list.jsp").forward(request, response);
    }
}
