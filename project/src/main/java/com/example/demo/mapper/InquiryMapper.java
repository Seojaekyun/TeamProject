package com.example.demo.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.InquiryDto;
import com.example.demo.dto.StateCountDto;

@Mapper
public interface InquiryMapper {
	ArrayList<InquiryDto> list();
	void writeOk(InquiryDto idto);
	void readnum(String id);
	InquiryDto content(String id);
	void updateOk(InquiryDto idto);
	void delete(String id);
	List<StateCountDto> listCountsPerState();
	ArrayList<InquiryDto> ilist();
	void updateAnswer(int inquiryId, String answerText);
	void answer(int inquiryId, String answerText);
	
}
