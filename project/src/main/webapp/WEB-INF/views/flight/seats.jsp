<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좌석 선택</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <style>
        .seat {
            display: inline-block;
            width: 50px;
            height: 50px;
            margin: 5px;
            border: 1px solid #000;
            text-align: center;
            line-height: 50px;
            cursor: pointer;
        }
        .available {
            background-color: #28a745; /* 녹색 */
        }
        .unavailable {
            background-color: #6c757d; /* 회색 */
            cursor: not-allowed;
        }
        .selected {
            background-color: #ffc107; /* 노란색 */
        }
        .row {
            display: flex;
            justify-content: center;
            margin-bottom: 10px;
        }
        .aisle {
            width: 60px; /* 복도 너비 */
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="mt-4">좌석 선택 - ${seatClass}</h2>
        <p>비행기 ID: ${flightId}</p>

        <!-- 좌석 목록 표시 -->
        <div id="seatsContainer">

            <!-- 일등석 -->
            <c:if test="${seatClass == '일등석'}">
                <c:forEach var="i" begin="1" end="10">
                    <div class="row">
                        <div class="seat ${seats[i * 2 - 2].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 2 - 2].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 2 - 2].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 2 - 1].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 2 - 1].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 2 - 1].seatNumber}
                        </div>
                    </div>
                </c:forEach>
            </c:if>

            <!-- 프레스티지석 -->
            <c:if test="${seatClass == '프레스티지석'}">
                <c:forEach var="i" begin="1" end="20">
                    <div class="row">
                        <div class="seat ${seats[i * 3 - 3].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 3 - 3].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 3 - 3].seatNumber}
                        </div>
                        <div class="aisle"></div> <!-- 복도 -->
                        <div class="seat ${seats[i * 3 - 2].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 3 - 2].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 3 - 2].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 3 - 1].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 3 - 1].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 3 - 1].seatNumber}
                        </div>
                    </div>
                </c:forEach>
            </c:if>

            <!-- 일반석 -->
            <c:if test="${seatClass == '일반석'}">
                <c:forEach var="i" begin="1" end="20">
                    <div class="row">
                        <div class="seat ${seats[i * 6 - 6].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 6].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 6].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 6 - 5].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 5].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 5].seatNumber}
                        </div>
                        <div class="aisle"></div> <!-- 복도 -->
                        <div class="seat ${seats[i * 6 - 4].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 4].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 4].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 6 - 3].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 3].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 3].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 6 - 2].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 2].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 2].seatNumber}
                        </div>
                        <div class="seat ${seats[i * 6 - 1].available ? 'available' : 'unavailable'}" data-seat-number="${seats[i * 6 - 1].seatNumber}" onclick="selectSeat(this)">
                            ${seats[i * 6 - 1].seatNumber}
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>

        <!-- 선택한 좌석 표시 -->
        <div class="mt-4">
            <h4>선택한 좌석:</h4>
            <p id="selectedSeatsDisplay"></p>
        </div>

        <!-- 선택 완료 버튼 -->
        <button class="btn btn-primary mt-4" onclick="confirmSelection()">선택 완료</button>
    </div>

    <script>
        var maxSelectableSeats = ${passengers}; // 탑승객 수
        var selectedSeats = [];

        function selectSeat(element) {
            var isAvailable = element.getAttribute('data-available') === 'true';
            if (!isAvailable) return; // 선택 불가능한 좌석

            var seatNumber = element.getAttribute('data-seat-number');
            var index = selectedSeats.indexOf(seatNumber);

            if (index === -1) {
                if (selectedSeats.length >= maxSelectableSeats) {
                    alert('최대 ' + maxSelectableSeats + '개의 좌석만 선택할 수 있습니다.');
                    return;
                }
                selectedSeats.push(seatNumber);
                element.classList.add('selected');
            } else {
                selectedSeats.splice(index, 1);
                element.classList.remove('selected');
            }
            document.getElementById('selectedSeatsDisplay').innerText = selectedSeats.join(', ');
        }

        function confirmSelection() {
            if (selectedSeats.length === 0 || selectedSeats.length !== maxSelectableSeats) {
                alert('탑승객 수에 맞게 좌석을 선택해 주세요.');
                return;
            }

            var form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/flights/confirmSeats';

            form.appendChild(createHiddenInput('flightId', '${flightId}'));
            form.appendChild(createHiddenInput('seatClass', '${seatClass}'));
            form.appendChild(createHiddenInput('passengers', '${passengers}'));
            form.appendChild(createHiddenInput('selectedSeats', selectedSeats.join(',')));

            document.body.appendChild(form);
            form.submit();
        }

        function createHiddenInput(name, value) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            return input;
        }
    </script>
</body>
</html>
