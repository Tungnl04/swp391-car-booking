/*
 * Name: BookingStatus
 * @Author: BacBXHE186736
 * Date: 23/05/2026
 * Version: 1.0
 * Description: Handles business logic and operations for BookingStatus.
 */
package com.swp391.carrental.constant;

/**
 * Booking status values.
 */
public class BookingStatus {
    public static final String PENDING            = "PENDING";
    public static final String CONFIRMED          = "CONFIRMED";
    public static final String REJECTED           = "REJECTED";
    public static final String CANCELLED          = "CANCELLED";
    public static final String IN_PROGRESS        = "IN_PROGRESS";
    public static final String COMPLETED          = "COMPLETED";
    public static final String NO_SHOW            = "NO_SHOW";
    public static final String PENDING_SETTLEMENT = "PENDING_SETTLEMENT";

    private BookingStatus() {
    }
}
