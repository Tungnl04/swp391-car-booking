<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Chỉnh sửa Đơn đặt xe - CarPro"/>
</jsp:include>

<div class="bk-container">
    <div class="bk-page-header">
        <div>
            <h2>Chỉnh sửa Đơn đặt xe</h2>
            <p>Thay đổi thông tin lịch trình, địa điểm nhận/trả xe hoặc ghi chú cho đơn đặt xe #${booking.bookingId}</p>
        </div>
        <a href="${pageContext.request.contextPath}/bookings/my" class="bk-btn bk-btn-outline">
            <span class="material-symbols-outlined">arrow_back</span> Quay lại danh sách
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="bk-alert bk-alert-danger" style="margin-bottom:24px;">
            <span class="material-symbols-outlined">error</span>
            <div>${error}</div>
        </div>
    </c:if>

    <div class="bk-card" style="max-width:800px; margin:0 auto;">
        <div class="bk-card-title">
            <span class="material-symbols-outlined">edit_note</span> Thông tin chỉnh sửa
        </div>

        <form method="post" action="${pageContext.request.contextPath}/bookings/edit" id="editBookingForm">
            <input type="hidden" name="bookingId" value="${booking.bookingId}"/>

            <%-- Schedule --%>
            <div class="bk-form-section" style="margin-bottom:24px;">
                <h3>Lịch trình mới</h3>
                <div class="bk-form-grid">
                    <div class="bk-form-group">
                        <label class="bk-form-label">Ngày bắt đầu</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">calendar_month</span>
                            <input type="date" name="startDate" id="startDate" class="bk-form-input" 
                                   value="${booking.startDate.toLocalDate()}" required>
                        </div>
                    </div>
                    <div class="bk-form-group">
                        <label class="bk-form-label">Giờ bắt đầu</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">schedule</span>
                            <input type="time" name="startTime" id="startTime" class="bk-form-input" 
                                   value="${booking.startDate.toLocalTime()}" required>
                        </div>
                    </div>
                    <div class="bk-form-group">
                        <label class="bk-form-label">Ngày kết thúc</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">event</span>
                            <input type="date" name="endDate" id="endDate" class="bk-form-input" 
                                   value="${booking.endDate.toLocalDate()}" required>
                        </div>
                    </div>
                    <div class="bk-form-group">
                        <label class="bk-form-label">Giờ kết thúc</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">schedule</span>
                            <input type="time" name="endTime" id="endTime" class="bk-form-input" 
                                   value="${booking.endDate.toLocalTime()}" required>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Locations --%>
            <div class="bk-form-section" style="margin-bottom:24px;">
                <h3>Địa điểm</h3>
                <div class="bk-form-grid">
                    <div class="bk-form-group">
                        <label class="bk-form-label">Điểm nhận xe</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">location_on</span>
                            <input type="text" name="pickupLocation" class="bk-form-input" 
                                   value="${booking.pickupLocation}" required>
                        </div>
                    </div>
                    <div class="bk-form-group">
                        <label class="bk-form-label">Điểm trả xe</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">pin_drop</span>
                            <input type="text" name="returnLocation" class="bk-form-input" 
                                   value="${booking.returnLocation}" required>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Notes --%>
            <div class="bk-form-group" style="margin-bottom:24px;">
                <label class="bk-form-label">Ghi chú chỉnh sửa (Tùy chọn)</label>
                <textarea name="notes" class="bk-form-textarea" rows="3" 
                          placeholder="Thêm bất kỳ yêu cầu đặc biệt hoặc ghi chú liên quan...">${booking.notes}</textarea>
            </div>

            <%-- Actions --%>
            <div class="bk-form-actions" style="justify-content: flex-end; gap: 12px;">
                <a href="${pageContext.request.contextPath}/bookings/my" class="bk-btn bk-btn-outline" style="padding:12px 24px;">
                    Hủy bỏ
                </a>
                <button type="submit" class="bk-btn bk-btn-primary" style="padding:12px 32px;">
                    <span class="material-symbols-outlined">save</span> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Set min date to today for new scheduling
    var today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').setAttribute('min', today);
    document.getElementById('endDate').setAttribute('min', today);
});
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
