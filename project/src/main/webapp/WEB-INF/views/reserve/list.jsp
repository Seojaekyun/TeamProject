<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>나의 예약 정보</title>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
    }
    section {
        display: flex;
        max-width: 1200px;
        margin: auto;
        justify-content: space-between;
    }
    #sec1 #tables {
        display: flex;
        justify-content: space-between;
        width: 60%;
    }
    #sec2 #tables {
        display: flex;
        justify-content: space-between;
        width: 100%;
    }
    #sec1 .table-container {
        width: 100%;
        background-color: white;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 20px;
        height: 340px;
    }
    #sec2 .table-container {
        width: 33%;
        background-color: white;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 20px;
        height: 340px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
        font-size: 12px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #000A8E;
        color: white;
        text-transform: uppercase;
    }
    td {
        background-color: #f9f9f9;
    }
    caption {
        font-size: 16px;
        font-weight: bold;
        padding: 10px;
        background-color: #000A8E;
        color: white;
        text-align: left;
    }
    #sec1 #cal {
        width: 39%;
        height: 340px;
        background-color: white;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
    }
    .ui-datepicker {
    	margin: auto;
        width: 95% !important;
        height: 95%;
    }
    .ui-datepicker td {
        text-align: center;
        padding: 8px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
    }
    .ui-datepicker td:hover {
        background-color: #4CAF50;
        color: white;
    }
    .ui-datepicker th {
        background-color: #000A8E;
        color: white;
    }
    .ui-datepicker-header {
        background-color: #4CAF50;
        color: white;
        border: none;
    }
    #selectedDate {
        font-size: 16px;
        font-weight: bold;
        color: #333;
    }
    .pagination {
        text-align: center;
        margin-top: 20px;
    }
    .pagination a {
        display: inline-block;
        padding: 5px 10px;
        margin: 0 3px;
        background-color: #4CAF50;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 12px;
    }
    .pagination a.active, .pagination span.active {
        background-color: #333;
        color: white;
        cursor: default;
        text-decoration: none;
    }
    .pagination span {
        display: inline-block;
        padding: 5px 10px;
        margin: 0 3px;
        background-color: #4CAF50;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 12px;
        cursor: default;
    }
    #clsd {
        background: #000A8E;
        color: white;
        border-radius: 5px;
        padding: 10px 15px;
        border: none;
        cursor: pointer;
        margin-bottom: 10px;
        width: 150px;
    }
    section a {
    	text-decoration: none;
    	color: #0d0582;
    }
    section a:hover {
    	font-weight: bold;
    	text-decoration: none;
    }
</style>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>

<body>
<div width="100%" style="text-align: center"><h2>예약관리</h2></div>
<!-- Section 1: 날짜 필터링된 예약 내역 (달력 포함) -->
<section id="sec1">
	<div id="tables">
		<!-- 전체 항공편 테이블 -->
		<div class="table-container" id="allFlights">
			<table>
				<caption>전체 예약</caption>
				<tr>
					<th>항공편명</th>
					<th>출항시간</th>
					<th>예약석</th>
				</tr>
				<c:forEach var="rsv" items="${rsvList}">
					<tr>
						<td>${rsv.flightId}</td>
						<td></td>
						<td></td>
					</tr>

				</c:forEach>
				<c:if test="${empty rsvList}">
					<tr>
						<td colspan="3">예약 데이터가 없습니다.</td>
					</tr>
				</c:if>
			</table>
			<!-- 페이지네이션 -->
			<div class="pagination">
				<c:if test="${totalPages > 1}">
					<!-- 이전 페이지 버튼 -->
					<c:if test="${currentPage > 3}">
						<a href="javascript:void(0);" onclick="loadAllPage(${currentPage - 3});">이전3</a>
					</c:if>
					<!-- 페이지 번호 표시 -->
					<c:set var="startPage" value="${currentPage - 1}" />
					<c:set var="endPage" value="${currentPage + 1}" />
					<c:if test="${startPage < 1}">
						<c:set var="startPage" value="1" />
						<c:set var="endPage" value="3" />
					</c:if>
					<c:if test="${endPage > totalPages}">
						<c:set var="endPage" value="${totalPages}" />
						<c:set var="startPage" value="${totalPages - 2}" />
						<c:if test="${startPage < 1}">
							<c:set var="startPage" value="1" />
						</c:if>
					</c:if>
					<c:forEach begin="${startPage}" end="${endPage}" var="i">
						<c:choose>
							<c:when test="${i == currentPage}">
								<span class="active">${i}</span>
							</c:when>
							<c:otherwise>
								<a href="javascript:void(0);" onclick="loadAllPage(${i});">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<!-- 다음 페이지 버튼 -->
					<c:if test="${currentPage +3 < totalPages}">
						<a href="javascript:void(0);" onclick="loadAllPage(${currentPage + 3});">다음3</a>
					</c:if>
				</c:if>
			</div>
		</div>
	</div>
</section>

<script>
	var gmpPage = 1;
	var icnPage = 1;
	var otherPage = 1;
	var currentPage = 1; // 전체 예약 내역의 현재 페이지
	$(function() {
		$("#datepicker").datepicker({
			inline: true,
			dateFormat: 'yy-mm-dd',
			defaultDate: null,
			onSelect: function(dateText) {
				$("#selectedDate").text('선택한 날짜: ' + dateText);
				sessionStorage.setItem("selectedDate", dateText);
				// 페이지 번호 초기화
				gmpPage = 1;
				icnPage = 1;
				otherPage = 1;
				currentPage = 1;
				// 각 테이블의 첫 페이지 로드
				loadPage(1, 'gmp', dateText);
				loadPage(1, 'icn', dateText);
				loadPage(1, 'other', dateText);
				loadAllPage(1, dateText);
			}
		});
		var savedDate = sessionStorage.getItem("selectedDate");
		if (savedDate) {
			$("#selectedDate").text('선택한 날짜: ' + savedDate);
			$("#datepicker").datepicker('setDate', savedDate);
			// 페이지 번호 초기화
			gmpPage = 1;
			icnPage = 1;
			otherPage = 1;
			currentPage = 1;
			// 저장된 날짜로 데이터 로드
			loadPage(1, 'gmp', savedDate);
			loadPage(1, 'icn', savedDate);
			loadPage(1, 'other', savedDate);
			loadAllPage(1, savedDate);
		}
		else {
			$("#selectedDate").text('');
			$("#datepicker").datepicker('setDate', null);
			// 페이지 번호 초기화
			gmpPage = 1;
			icnPage = 1;
			otherPage = 1;
			currentPage = 1;
			// 전체 데이터 로드
			loadPage(1, 'gmp');
			loadPage(1, 'icn');
			loadPage(1, 'other');
			loadAllPage(1);
		}
	});
	function loadPage(page, table, selectedDate) {
		if (typeof selectedDate === 'undefined') {
			selectedDate = sessionStorage.getItem("selectedDate");
		}
			// 페이지 번호 업데이트
		if (table === 'gmp') {
				gmpPage = page;
		}
		else if (table === 'icn') {
			icnPage = page;
		}
		else if (table === 'other') {
			otherPage = page;
		}
		var data = {
			gmpPage: gmpPage,
			icnPage: icnPage,
			otherPage: otherPage,
			page: currentPage // 전체 예약 내역의 현재 페이지
		};
		if (selectedDate && selectedDate !== "") {
			data.selectedDate = selectedDate;
		}
		else {
			sessionStorage.removeItem("selectedDate");
		}
		$.ajax({
			url: "/admin/reserveList",
			type: "GET",
			data: data,
			success: function(response) {
				var newGmpFlights = $(response).find("#gmpFlights").html();
				var newIcnFlights = $(response).find("#icnFlights").html();
				var newOtherFlights = $(response).find("#otherFlights").html();
				$("#gmpFlights").html(newGmpFlights);
				$("#icnFlights").html(newIcnFlights);
				$("#otherFlights").html(newOtherFlights);
			},
			error: function(error) {
				console.log("데이터 가져오기 실패:", error);
			}
		});
	}
	function loadAllPage(page, selectedDate) {
		if (typeof selectedDate === 'undefined') {
			selectedDate = sessionStorage.getItem("selectedDate");
		}
		currentPage = page;
		var data = {
			page: currentPage,
			gmpPage: gmpPage,
			icnPage: icnPage,
			otherPage: otherPage
		};
		if (selectedDate && selectedDate !== "") {
			data.selectedDate = selectedDate;
		}
		$.ajax({
			url: "/admin/reserveList",
			type: "GET",
			data: data,
			success: function(response) {
				var newAllFlights = $(response).find("#allFlights").html();
				$("#allFlights").html(newAllFlights);
			},
			error: function(error) {
				console.log("데이터 가져오기 실패:", error);
			}
		});
	}
	function clearDate() {
		sessionStorage.removeItem("selectedDate");
		$("#selectedDate").text('');
		$("#datepicker").datepicker('setDate', null);
		// 페이지 번호 초기화
		gmpPage = 1;
		icnPage = 1;
		otherPage = 1;
		currentPage = 1;
		// 전체 데이터 로드
		loadPage(1, 'gmp');
		loadPage(1, 'icn');
		loadPage(1, 'other');
		loadAllPage(1);
	}
</script>
</body>
</html>