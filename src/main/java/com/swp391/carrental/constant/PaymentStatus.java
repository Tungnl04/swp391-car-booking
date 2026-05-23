/*
 * Name: PaymentStatus
 * @Author: TungNLHE186756
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles business logic and operations for PaymentStatus.
 */
package com.swp391.carrental.constant;

/**
 * Payment status values.
 */
public class PaymentStatus {
    public static final String PENDING   = "PENDING";
    public static final String COMPLETED = "COMPLETED";
    public static final String FAILED    = "FAILED";
    public static final String REFUNDED  = "REFUNDED";

    private PaymentStatus() {
    }
}
