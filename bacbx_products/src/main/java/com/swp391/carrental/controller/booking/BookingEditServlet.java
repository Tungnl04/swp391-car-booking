/*
 * Name: BookingEditServlet
 * @Author: BacBXHE186736
 * Date: 30/05/2026
 * Version: 1.0
 * Description: Handles updating and canceling bookings for customers.
 */
package com.swp391.carrental.controller.booking;

import com.swp391.carrental.model.Booking;
import com.swp391.carrental.model.Car;
import com.swp391.carrental.model.User;
import com.swp391.carrental.service.BookingService;
import com.swp391.carrental.service.VehicleService;
import com.swp391.carrental.service.PolicyService;
import com.swp391.carrental.constant.Role;
import com.swp391.carrental.exception.AppException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;

/**
 * Handles editing and canceling bookings.
 * URL: /bookings/edit, /bookings/cancel
 */
@WebServlet(name = "BookingEditServlet", urlPatterns = {"/bookings/edit", "/bookings/cancel"})
public class BookingEditServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final VehicleService vehicleService = new VehicleService();
    private final PolicyService policyService = new PolicyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/bookings/my");
            return;
        }

        try {
            int bookingId = Integer.parseInt(idParam);
            Booking booking = bookingService.getBookingById(bookingId);

            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/bookings/my");
                return;
            }

            // Security check
            if (!Role.STAFF.equals(user.getRole()) && !Role.ADMIN.equals(user.getRole()) 
                    && booking.getCustomerId() != user.getUserId()) {
                request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/views/booking/booking-edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bookings/my");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/bookings/cancel".equals(path)) {
            handleCancel(request, response, user);
        } else {
            handleEdit(request, response, user);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        String bookingIdStr = request.getParameter("bookingId");
        try {
            if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                throw new AppException("Mã đặt xe không tồn tại.");
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null) {
                throw new AppException("Đơn đặt xe không tồn tại.");
            }

            // Security Check
            boolean isStaffOrAdmin = Role.STAFF.equals(user.getRole()) || Role.ADMIN.equals(user.getRole());
            if (!isStaffOrAdmin && booking.getCustomerId() != user.getUserId()) {
                request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp")
                        .forward(request, response);
                return;
            }

            // Parse form parameters
            String startDateVal = request.getParameter("startDate");
            String startTimeVal = request.getParameter("startTime");
            String endDateVal = request.getParameter("endDate");
            String endTimeVal = request.getParameter("endTime");
            String pickupLocation = request.getParameter("pickupLocation");
            String returnLocation = request.getParameter("returnLocation");
            String notes = request.getParameter("notes");

            // Basic validation
            if (startDateVal == null || startDateVal.isEmpty()) {
                throw new AppException("Vui lòng chọn ngày bắt đầu.");
            }
            if (endDateVal == null || endDateVal.isEmpty()) {
                throw new AppException("Vui lòng chọn ngày kết thúc.");
            }
            if (pickupLocation == null || pickupLocation.trim().isEmpty()) {
                throw new AppException("Vui lòng nhập địa điểm nhận xe.");
            }
            if (returnLocation == null || returnLocation.trim().isEmpty()) {
                throw new AppException("Vui lòng nhập địa điểm trả xe.");
            }

            if (startTimeVal == null || startTimeVal.isEmpty()) {
                startTimeVal = "08:00";
            }
            if (endTimeVal == null || endTimeVal.isEmpty()) {
                endTimeVal = "08:00";
            }

            LocalDateTime startDate = LocalDateTime.parse(startDateVal + "T" + startTimeVal);
            LocalDateTime endDate = LocalDateTime.parse(endDateVal + "T" + endTimeVal);

            // Load car to re-calculate amounts
            Car car = vehicleService.getCarById(booking.getCarId());
            if (car == null) {
                throw new AppException("Xe đã chọn không khả dụng.");
            }

            // Calculate new rental days
            long rentalDays = ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate());
            if (rentalDays < 1) {
                rentalDays = 1;
            }

            BigDecimal dailyRate = car.getDailyRate();
            BigDecimal totalAmount = dailyRate.multiply(BigDecimal.valueOf(rentalDays));

            String depositPctStr = policyService.getPolicyValue("DEPOSIT_PERCENTAGE", "30");
            BigDecimal depositPct = new BigDecimal(depositPctStr);
            BigDecimal depositAmount = totalAmount.multiply(depositPct)
                    .divide(BigDecimal.valueOf(100), 0, RoundingMode.CEILING);

            // Set new values
            booking.setStartDate(startDate);
            booking.setEndDate(endDate);
            booking.setPickupLocation(pickupLocation.trim());
            booking.setReturnLocation(returnLocation.trim());
            booking.setNotes(notes != null ? notes.trim() : null);
            booking.setTotalAmount(totalAmount);
            booking.setDepositAmount(depositAmount);

            // Call update service
            bookingService.updateBooking(booking);

            request.getSession().setAttribute("successMessage", "Cập nhật đơn đặt xe thành công.");
            response.sendRedirect(request.getContextPath() + "/bookings/my");

        } catch (AppException e) {
            request.setAttribute("error", e.getMessage());
            // Pre-populate input values for editing page
            Booking b = bookingService.getBookingById(Integer.parseInt(bookingIdStr));
            request.setAttribute("booking", b);
            request.getRequestDispatcher("/WEB-INF/views/booking/booking-edit.jsp")
                    .forward(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Định dạng ngày giờ không hợp lệ.");
            Booking b = bookingService.getBookingById(Integer.parseInt(bookingIdStr));
            request.setAttribute("booking", b);
            request.getRequestDispatcher("/WEB-INF/views/booking/booking-edit.jsp")
                    .forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Thông tin yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/bookings/my");
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        try {
            String bookingIdStr = request.getParameter("bookingId");
            String reason = request.getParameter("reason");

            if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                throw new AppException("Không tìm thấy mã booking.");
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null) {
                throw new AppException("Booking không tồn tại.");
            }

            // Check security: user owns this booking or is staff/admin
            boolean isStaffOrAdmin = Role.STAFF.equals(user.getRole()) || Role.ADMIN.equals(user.getRole());
            if (!isStaffOrAdmin && booking.getCustomerId() != user.getUserId()) {
                request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp")
                        .forward(request, response);
                return;
            }

            if (reason == null || reason.trim().isEmpty()) {
                reason = "Khách hàng tự hủy";
            }

            bookingService.cancelBooking(bookingId, reason.trim());

            request.getSession().setAttribute("successMessage", "Hủy đặt xe thành công.");
            response.sendRedirect(request.getContextPath() + "/bookings/my");

        } catch (AppException e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/bookings/my");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Mã booking không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/bookings/my");
        }
    }
}
