package com.swp391.carrental.payment.constant;

import com.swp391.carrental.payment.model.Payment;

/*
 * Name: PaymentType
 * @Author: TungNLHE186756
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles business logic and operations for PaymentType.
 */

/**
 * Payment type values.
 */
public class PaymentType {
    public static final String DEPOSIT        = "DEPOSIT";
    public static final String RENTAL         = "RENTAL";
    public static final String ADDITIONAL_FEE = "ADDITIONAL_FEE";
    public static final String REFUND         = "REFUND";

    private PaymentType() {
    }
}
