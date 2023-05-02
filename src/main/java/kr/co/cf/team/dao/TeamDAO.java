package kr.co.cf.team.dao;

import java.util.HashMap;

import org.springframework.web.multipart.MultipartFile;

import kr.co.cf.team.dto.TeamDTO;

public interface TeamDAO {

	int overlay(String teamName);

	int teamRegist(TeamDTO teamDTO);

}
