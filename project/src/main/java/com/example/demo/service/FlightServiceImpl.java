package com.example.demo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.demo.dto.FlightDto;
import com.example.demo.dto.MemberDto;
import com.example.demo.dto.ReservationDto;
import com.example.demo.dto.SeatDto;
import com.example.demo.mapper.FlightMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.AirplanesDto;
import com.example.demo.dto.AirportsDto;

@Service("fs")
public class FlightServiceImpl implements FlightService {

	@Autowired
	private FlightMapper fmapper;
	
	@Override
	public List<AirportsDto> getAllAirports() { 
		return fmapper.findAllAirports();
	}
	
	public List<FlightDto> getAvailableFlightsByDate(String date) {
		return fmapper.getAvailableFlightsByDate(date);
	}
	
	// findFlights 메서드 수정: seatClass와 passengers 추가
	
	@Override
	public List<FlightDto> findFlights(
			String departure, String arrival, String departureDate,
			String arrivalDate, String seatClass, Integer passengers) {
		Map<String, Object> params = new HashMap<>();
		params.put("departure", departure);
		params.put("arrival", arrival);
		params.put("departureDate", departureDate);
		params.put("arrivalDate", arrivalDate);
		params.put("seatClass", seatClass);
		params.put("passengers", passengers);
		
		List<FlightDto> flights = fmapper.findFlightsWithFilters(params);
		
		// availableSeats 계산 및 설정
		for (FlightDto flight : flights) {
			int availableSeats = fmapper.countAvailableSeats(flight.getFlightId());
			flight.setAvailableSeats(availableSeats);
			
			// 좌석 옵션 조회 및 설정
			List<SeatDto> seatOptions = fmapper.getSeatsByFlightIdAndClass(flight.getFlightId(), seatClass);
			flight.setSeatOptions(seatOptions);
		}
		
		return flights;
	}
	
	@Override
	public List<FlightDto> getAvailableFlights() {
		return fmapper.getAllFlights();
	}
	
	@Override
	public List<SeatDto> getSeatsByFlightId(int flightId) {
		return fmapper.getSeatsByFlightId(flightId);
	}
	
	@Override
	public List<SeatDto> getAvailableSeats(int flightId, String seatClass) {
		return fmapper.getAvailableSeatsByFlightAndClass(flightId, seatClass);
	}
	
	// LoginService.java (또는 다른 서비스 클래스)
	@Override
	public MemberDto getMemberInfoByUserId(String userid) {
		return fmapper.getMemberByUserId(userid);  // mapper는 MyBatis 또는 다른 방식의 DAO
	}
	
	@Override
	public FlightDto getgoingFlightInfoByFlightId(String goingFlightId) {
		return fmapper.getFlightByGoingFlightId(goingFlightId);  // mapper는 MyBatis 또는 다른 방식의 DAO
	}
	
	@Override
	public FlightDto getreturnFlightInfoByFlightId(String returnFlightId) {
		return fmapper.getFlightByReturnFlightId(returnFlightId);  // mapper는 MyBatis 또는 다른 방식의 DAO
	}
	
	@Override
	public int addReservation(
			String userId, String flightId, String seatClass,
			String passengerType, String pnr, String sung, String name) {
		ReservationDto reservation = new ReservationDto();
		reservation.setUserid(userId);
		reservation.setFlightId(Integer.parseInt(flightId));
		reservation.setSeatClass(seatClass);
		reservation.setPassengerType(passengerType);
		reservation.setPnr(pnr);
		reservation.setSung(sung);
		reservation.setName(name);
		
		// 예약 저장 후 reservationId를 받아옴
		fmapper.addReservation(reservation);
		int reservationId = reservation.getReservationId();
		
		if (reservationId > 0) {
			return reservationId;
		}
		else {
			throw new RuntimeException("Reservation creation failed.");
		}
	}
	
	@Override
	public int getSeatIdBySeatNumber(String seatNumber) {
		Integer seatId = fmapper.getSeatIdBySeatNumber(seatNumber);
		if (seatId == null || seatId == 0) {
			throw new RuntimeException("Invalid seat number: " + seatNumber);
		}
		
		return seatId;
	}
	
	public void addSeatToReservation(int reservationId, int seatId) {
		fmapper.addSeatToReservation(reservationId, seatId);  // mapper에서 처리
	}
	
	@Override
	public void updateSeatAvailability(int flightId, int seatId) {
		fmapper.updateSeatAvailability(flightId, seatId);
	}
	
	@Override
	public void addFlight(String departureAirport, String arrivalAirport, String departureTime, String arrivalTime, int airplaneId) {
		FlightDto flight = new FlightDto();
		flight.setDepartureAirport(departureAirport);
		flight.setArrivalAirport(arrivalAirport);
		flight.setDepartureTime(departureTime);
		flight.setArrivalTime(arrivalTime);
		flight.setAirplaneId(airplaneId);
		
		fmapper.addFlight(flight);
	}
	
	@Override
	public List<AirplanesDto> getAllAirplanes() {
		return fmapper.findAllAirplanes();
	}
	
	@Override
	public void addSeatsForFlight() {
		fmapper.addSeatsForFlight();
	}
	
	
}