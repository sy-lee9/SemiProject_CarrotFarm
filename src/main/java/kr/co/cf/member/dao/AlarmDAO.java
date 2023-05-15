package kr.co.cf.member.dao;

import java.util.ArrayList;

import kr.co.cf.matching.dto.MatchingDTO;

public interface AlarmDAO {

	int totalCount(String userId);

	ArrayList<MatchingDTO> list(int offset, String userId);

}
