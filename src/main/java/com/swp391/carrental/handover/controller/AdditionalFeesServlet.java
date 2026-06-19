package com.swp391.carrental.handover.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.carrental.booking.model.Booking;

/*
 * Name: AdditionalFeesServlet
 * @Author: TamTTMHE190340
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for AdditionalFeesServlet.
 */


@WebServlet(name = "AdditionalFeesServlet", urlPatterns = {"/additional-fees"})
public class AdditionalFeesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Load additional fees for a booking/return
        request.getRequestDispatcher("/WEB-INF/views/handover/additional-fees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Calculate and save additional fees (BR-07)
        response.sendRedirect(request.getContextPath() + "/additional-fees");
    }
}

