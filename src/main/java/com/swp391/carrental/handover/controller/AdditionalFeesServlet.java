package com.swp391.carrental.handover.controller;

import com.swp391.carrental.booking.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.swp391.carrental.booking.model.Booking;
import com.swp391.carrental.contract.dao.ContractDAO;
import com.swp391.carrental.contract.model.RentalContract;
import com.swp391.carrental.handover.dao.ReturnDAO;
import com.swp391.carrental.handover.model.VehicleHandover;
import com.swp391.carrental.handover.model.VehicleReturn;
import com.swp391.carrental.handover.service.HandoverService;
import com.swp391.carrental.handover.service.ReturnService;
import com.swp391.carrental.user.dao.UserDAO;
import com.swp391.carrental.user.model.User;
import com.swp391.carrental.vehicle.dao.CarDAO;
import com.swp391.carrental.vehicle.model.Car;
import java.math.BigDecimal;
import java.sql.SQLException;

/*
 * Name: AdditionalFeesServlet
 * @Author: TamTTMHE190340
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles HTTP requests and responses for AdditionalFeesServlet.
 */
@WebServlet(name = "AdditionalFeesServlet", urlPatterns = {"/additional-fees"})
public class AdditionalFeesServlet extends HttpServlet {

    private final ReturnService returnService = new ReturnService();
    private final ReturnDAO returnDAO = new ReturnDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final CarDAO carDAO = new CarDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String bookingIdStr = request.getParameter("bookingId");
            String carIdStr = request.getParameter("carId");

            if (bookingIdStr != null && carIdStr != null) {

                int bookingId = Integer.parseInt(bookingIdStr);
                int carId = Integer.parseInt(carIdStr);

                Booking booking = bookingDAO.findById(bookingId);
                Car car = carDAO.findById(carId);
                request.setAttribute("booking", booking);
                request.setAttribute("car", car);
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("carId", carId);

                if (booking != null) {
                    User customer = userDAO.findById(booking.getCustomerId());
                    request.setAttribute("customer", customer);
                }

                VehicleReturn returns = returnDAO.findByBookingId(bookingId);
                if (returns != null) {
                    request.setAttribute("vehicleReturn", returns);
                    request.setAttribute("lateFee", returns.getLateFee());
                    request.setAttribute("extraKmFee", returns.getExtraKmFee());
                    request.setAttribute("damageFee", returns.getDamageFee());
                    request.setAttribute("cleaningFee", returns.getCleaningFee());
                    request.setAttribute("lostItemFee", returns.getLostItemFee());
                    request.setAttribute("totalAdditionalFee", returns.getTotalAdditionalFee());
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi tải dữ liệu phụ thu: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/handover/additional-fees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("save".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                VehicleReturn returns = returnDAO.findByBookingId(bookingId);

                if (returns == null) {
                    throw new ServletException("Return record not found");
                }

                String lateFeeStr = request.getParameter("lateFee");
                String extraKmFeeStr = request.getParameter("extraKmFee");
                String damageFeeStr = request.getParameter("damageFee");
                String cleaningFeeStr = request.getParameter("cleaningFee");
                String lostItemFeeStr = request.getParameter("lostItemFee");
                String totalAdditionalFeeStr = request.getParameter("totalAdditionalFee");

                BigDecimal lateFee = safeBigDecimal(lateFeeStr);
                BigDecimal extraKmFee = safeBigDecimal(extraKmFeeStr);
                BigDecimal damageFee = safeBigDecimal(damageFeeStr);
                BigDecimal cleaningFee = safeBigDecimal(cleaningFeeStr);
                BigDecimal lostItemFee = safeBigDecimal(lostItemFeeStr);
                BigDecimal totalAdditionalFee = safeBigDecimal(totalAdditionalFeeStr);

                returns.setLateFee(lateFee);
                returns.setExtraKmFee(extraKmFee);
                returns.setDamageFee(damageFee);
                returns.setCleaningFee(cleaningFee);
                returns.setLostItemFee(lostItemFee);
                returns.setTotalAdditionalFee(totalAdditionalFee);

                returnService.updateReturnVehicle(returns);
                request.getSession().setAttribute("notification", "Đã lưu và áp dụng phụ thu vào đơn hàng!");

                response.sendRedirect(request.getContextPath() + "/returns");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }
    }

    private BigDecimal safeBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(value);
    }
}
