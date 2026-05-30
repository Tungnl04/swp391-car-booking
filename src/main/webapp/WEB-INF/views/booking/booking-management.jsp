<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("dateTimeFormatter", java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Booking Management"/>
</jsp:include>
<div class="page-content">
    <div class="card">
        <div class="card-header"><h3>Booking Management</h3></div>
        <c:if test="${not empty bookings}">
            <table class="table">
                <thead><tr><th>ID</th><th>Customer</th><th>Car</th><th>Start</th><th>End</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>${b.bookingId}</td>
                            <td>User #${b.customerId}</td>
                            <td>Car #${b.carId}</td>
                            <td>${b.startDate != null ? b.startDate.format(dateTimeFormatter) : ''}</td>
                            <td>${b.endDate != null ? b.endDate.format(dateTimeFormatter) : ''}</td>
                            <td><fmt:formatNumber value="${b.totalAmount}" pattern="#,##0"/> VND</td>
                            <td><span class="badge badge-${b.status == 'PENDING' ? 'pending' : b.status == 'CONFIRMED' ? 'confirmed' : b.status == 'COMPLETED' ? 'completed' : 'cancelled'}">${b.status}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'CONFIRMED'}">
                                        <c:choose>
                                            <c:when test="${contractedBookingIds.contains(b.bookingId)}">
                                                <a href="${pageContext.request.contextPath}/contracts/detail?bookingId=${b.bookingId}" class="btn btn-outline" style="padding:4px 10px;font-size:12px;">View Contract</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/contracts/detail?bookingId=${b.bookingId}" class="btn btn-primary" style="padding:4px 10px;font-size:12px;">Prepare Contract</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size:12px;color:var(--text-secondary);">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty bookings}"><div class="placeholder-content"><p>No bookings found.</p></div></c:if>
    </div>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
