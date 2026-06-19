package com.swp391.carrental.report.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.swp391.carrental.booking.dao.BookingDAO;
import com.swp391.carrental.core.exception.AppException;
import com.swp391.carrental.payment.dao.PaymentDAO;
import com.swp391.carrental.payment.model.Payment;
import com.swp391.carrental.vehicle.model.Car;

/*
 * Name: ReportService
 * @Author: TamTTMHE190340
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Contains business logic for ReportService.
 */



/**
 * Service for generating reports.
 */
public class ReportService {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Generate revenue report data for a date range.
     * Returns a map with summary fields.
     */
    public Map<String, Object> generateRevenueReport(LocalDate startDate, LocalDate endDate) {
        // TODO: Implement full revenue report with date filtering
        Map<String, Object> report = new HashMap<>();
        try {
            List<Payment> allPayments = paymentDAO.findAll();

            BigDecimal totalRevenue = BigDecimal.ZERO;
            int totalTransactions = 0;

            for (Payment p : allPayments) {
                if ("COMPLETED".equals(p.getStatus())) {
                    totalRevenue = totalRevenue.add(p.getAmount());
                    totalTransactions++;
                }
            }

            report.put("totalRevenue", totalRevenue);
            report.put("totalTransactions", totalTransactions);
            report.put("startDate", startDate);
            report.put("endDate", endDate);
            report.put("payments", allPayments);

        } catch (SQLException e) {
            throw new AppException("Failed to generate revenue report.", e);
        }
        return report;
    }

    /**
     * Generate vehicle utilization report.
     * TODO: Implement with actual metrics (days rented / total days).
     */
    public Map<String, Object> generateVehicleUtilizationReport() {
        Map<String, Object> report = new HashMap<>();
        // TODO: Calculate utilization per car
        // utilization = days_rented / total_days_in_period * 100
        report.put("message", "Vehicle utilization report - to be implemented");
        return report;
    }
}
