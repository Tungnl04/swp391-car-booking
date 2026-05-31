<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Vehicle Catalog"/>
</jsp:include>
<div class="page-content">
    <div class="card">
        <div class="card-header">
            <h3>Vehicle Catalog</h3>
            <p style="margin:0;color:var(--text-secondary);font-size:14px;">Browse available vehicles for rent</p>
        </div>

        <c:if test="${not empty cars}">
            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:20px;padding:20px;">
                <c:forEach var="car" items="${cars}">
                    <div class="card" style="margin:0;overflow:hidden;">
                        <div style="height:180px;background:#f0f2f5;display:flex;align-items:center;justify-content:center;">
                            <c:set var="thumb" value="${primaryImages[car.carId]}"/>
                            <img src="${pageContext.request.contextPath}${thumb}"
                                 alt="${car.brand} ${car.model}"
                                 style="width:100%;height:180px;object-fit:cover;"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/cars/placeholder.jpg'"/>
                        </div>
                        <div style="padding:16px;">
                            <h4 style="margin:0 0 8px;">${car.brand} ${car.model}</h4>
                            <p style="margin:0 0 8px;color:var(--text-secondary);font-size:13px;">
                                ${car.year} &middot; ${car.seats} seats &middot; ${car.transmission}
                            </p>
                            <p style="margin:0 0 12px;font-size:14px;">
                                <strong><fmt:formatNumber value="${car.dailyRate}" type="number" groupingUsed="true"/> VND</strong> / day
                            </p>
                            <span class="badge badge-success">${car.status}</span>
                            <div style="margin-top:14px;">
                                <a href="${pageContext.request.contextPath}/vehicles/detail?id=${car.carId}"
                                   class="btn btn-primary" style="width:100%;text-align:center;">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty cars}">
            <div class="placeholder-content">
                <p>No vehicles are available for rent right now. Please check back later.</p>
            </div>
        </c:if>
    </div>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
