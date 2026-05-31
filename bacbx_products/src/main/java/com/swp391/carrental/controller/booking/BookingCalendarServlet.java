/*
 * Name: BookingCalendarServlet
 * @Author: BacBui
 * Date: 29/05/2026
 * Version: 2.0
 * Description: Displays a simple booking calendar for Staff/Admin. Shows active bookings on a monthly grid.
 */
package com.swp391.carrental.controller.booking;

import com.swp391.carrental.model.Booking;
import com.swp391.carrental.model.Car;
import com.swp391.carrental.service.BookingService;
import com.swp391.carrental.service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Booking calendar view for Staff/Admin.
 * URL: /bookings/calendar
 */
@WebServlet(name = "BookingCalendarServlet", urlPatterns = {"/bookings/calendar"})
public class BookingCalendarServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load all bookings for calendar display
        List<Booking> allBookings = bookingService.getAllBookings();
        request.setAttribute("bookings", allBookings);

        // Build car map
        Map<Integer, Car> carMap = new HashMap<>();
        for (Booking b : allBookings) {
            if (!carMap.containsKey(b.getCarId())) {
                Car car = vehicleService.getCarById(b.getCarId());
                if (car != null) {
                    carMap.put(b.getCarId(), car);
                }
            }
        }
        request.setAttribute("carMap", carMap);

        request.getRequestDispatcher("/WEB-INF/views/booking/booking-calendar.jsp")
                .forward(request, response);
    }
}
