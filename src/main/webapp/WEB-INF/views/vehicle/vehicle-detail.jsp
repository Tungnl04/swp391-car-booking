<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Vehicle Detail"/>
</jsp:include>
<div class="page-content">
    <c:if test="${not empty car}">
        <div class="card">
            <div class="card-header" style="flex-wrap:wrap;gap:10px;">
                <div>
                    <h3 style="margin:0;">${car.brand} ${car.model} (${car.year})</h3>
                    <p style="margin:4px 0 0;color:var(--text-secondary);">${car.licensePlate}</p>
                </div>
                <span class="badge badge-${car.status == 'AVAILABLE' ? 'success' : car.status == 'RENTED' ? 'warning' : car.status == 'MAINTENANCE' ? 'danger' : 'secondary'}">
                    ${car.status}
                </span>
                <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-outline">Back to Catalog</a>
            </div>

            <c:if test="${not empty images}">
                <div style="padding:20px;">
                    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:12px;">
                        <c:forEach var="image" items="${images}">
                            <div>
                                <img src="${pageContext.request.contextPath}${image.imageUrl}"
                                     alt="${image.caption}"
                                     style="width:100%;height:160px;object-fit:cover;border-radius:8px;"
                                     onerror="this.style.display='none'"/>
                                <c:if test="${image.primary}">
                                    <span class="badge badge-primary" style="margin-top:6px;">Primary</span>
                                </c:if>
                                <c:if test="${not empty image.caption}">
                                    <p style="margin:6px 0 0;font-size:12px;color:var(--text-secondary);">${image.caption}</p>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;padding:0 20px 20px;">
                <table class="table">
                    <tr><td><strong>Color</strong></td><td>${car.color}</td></tr>
                    <tr><td><strong>Seats</strong></td><td>${car.seats}</td></tr>
                    <tr><td><strong>Transmission</strong></td><td>${car.transmission}</td></tr>
                    <tr><td><strong>Fuel Type</strong></td><td>${car.fuelType}</td></tr>
                    <tr><td><strong>Location</strong></td><td>${car.location}</td></tr>
                    <tr><td><strong>Mileage</strong></td><td><fmt:formatNumber value="${car.mileage}" type="number" groupingUsed="true"/> km</td></tr>
                    <tr><td><strong>Features</strong></td><td>${car.features}</td></tr>
                    <tr><td><strong>Description</strong></td><td>${car.description}</td></tr>
                </table>

                <div class="card" style="margin:0;padding:16px;background:var(--bg-secondary, #f8f9fb);">
                    <h4 style="margin-top:0;">Rental Pricing</h4>
                    <p style="margin:0 0 8px;">
                        Daily rate:
                        <strong><fmt:formatNumber value="${car.dailyRate}" type="number" groupingUsed="true"/> VND</strong>
                    </p>
                    <p style="margin:0 0 8px;">
                        Deposit (1 day, ${depositPercentage}%):
                        <strong><fmt:formatNumber value="${depositAmount}" type="number" groupingUsed="true"/> VND</strong>
                    </p>
                    <p style="margin:0;font-size:12px;color:var(--text-secondary);">
                        Deposit is calculated from the rental total according to system policy.
                    </p>
                    <c:if test="${car.status == 'AVAILABLE' && sessionScope.currentUser != null}">
                        <a href="${pageContext.request.contextPath}/bookings/create?carId=${car.carId}"
                           class="btn btn-primary" style="margin-top:16px;width:100%;text-align:center;">Book Now</a>
                    </c:if>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${empty car}">
        <div class="card">
            <div class="placeholder-content">
                <h2>Vehicle not found</h2>
                <p>${not empty error ? error : 'The requested vehicle does not exist or has been removed.'}</p>
                <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">Return to Catalog</a>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
