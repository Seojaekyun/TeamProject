package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.example.demo.dto.MemberDto;
import com.example.demo.dto.ReservationDto;
import com.example.demo.mapper.MemberMapper;
import com.example.demo.mapper.ReservationMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
@Qualifier("ms2")
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	private MemberMapper mapper;
	@Autowired
	private ReservationMapper rmapper;
	
	@Override
	public String member() {
		return "/member/member";
	}
	
	@Override
	public String useridCheck(String userid) {
		return mapper.useridCheck(userid);
	}
	
	@Override
	public String memberOk(MemberDto mdto) {
		mapper.memberOk(mdto);
		return "redirect:/login/login";
	}
	
	@Override
	public List<MemberDto> getAllMembers() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String rlist(HttpSession session, HttpServletRequest request, Model model) {
	    String userid = (String) session.getAttribute("userid");

	    if (userid == null || userid.isEmpty()) {
	        return "redirect:/login";
	    }

	    // 선택한 날짜 파라미터 가져오기
	    String selectedDate = request.getParameter("selectedDate");

	    // 페이지 번호와 한 페이지에 보여줄 항목 수
	    int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
	    int itemsPerPage = 10;  // 한 페이지에 보여줄 항목 수
	    int offset = (page - 1) * itemsPerPage;  // OFFSET 계산

	    // 유저의 그룹화된 예약 리스트 가져오기 (페이징 적용 및 선택된 날짜 기준으로 필터링)
	    List<Map<String, Object>> rsvClist;
	    if (selectedDate != null && !selectedDate.isEmpty()) {
	        rsvClist = rmapper.getRsvcfacByDate(userid, selectedDate, itemsPerPage, offset); // 날짜에 따른 필터링
	    } else {
	        rsvClist = rmapper.getRsvcfac(userid, itemsPerPage, offset);  // 모든 예약 리스트
	    }

	    // charge 정보 가져오기
	    Map<String, Object> chargeSums = rmapper.getSumOfCharges(userid);

	    // 전체 예약 수 가져오기
	    int totalReservations;
	    if (selectedDate != null && !selectedDate.isEmpty()) {
	        totalReservations = rmapper.getTotalRsvcByDate(userid, selectedDate);  // 날짜에 따른 총 예약 수
	    } else {
	        totalReservations = rmapper.getTotalRsvc(userid);  // 모든 예약의 총 수
	    }

	    int totalPages = (int) Math.ceil((double) totalReservations / itemsPerPage);  // 전체 페이지 수 계산

	    // JSP로 데이터 전달
	    model.addAttribute("rsvClist", rsvClist);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("totalCharge", chargeSums.get("totalCharge"));
	    model.addAttribute("totalChargePay", chargeSums.get("totalChargePay"));
	    model.addAttribute("selectedDate", selectedDate);  // 선택한 날짜를 모델에 추가

	    return "/reserve/list";  // 예약 리스트 JSP 페이지로 이동
	}



	
}