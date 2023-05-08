package kr.co.cf.board.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.co.cf.board.dto.BoardDTO;
import kr.co.cf.matching.dto.MatchingDTO;

public interface BoardDAO {

	ArrayList<BoardDTO> flist();

	ArrayList<BoardDTO> falist(int cnt, int offset);
	
	int fatotalCount();
	
	int fwrite(BoardDTO dto);

	void ffileWrite(int photoIdx, String photoId);

	void fupHit(String boardIdx);

	BoardDTO fdetail(String boardIdx);

	String ffindFile(String bidx);

	int fdelete(String bidx);

	int fupdate(HashMap<String, String> params);
	
	String fuserRight(String loginId);
	
	ArrayList<BoardDTO> fcommentList(String bidx);

	void fcommentWrite(HashMap<String, String> params);

	void fcommentDelete(String commentIdx);

	BoardDTO fcommentGet(String commentIdx);

	void fcommentUpdate(HashMap<String, String> params);


	
	

	ArrayList<BoardDTO> nlist();
	
	ArrayList<BoardDTO> nalist(int cnt, int offset);
	
	int natotalCount();

	int nwrite(BoardDTO dto);

	void nfileWrite(int photoIdx, String photoId);
	
	void nupHit(String boardIdx);

	BoardDTO ndetail(String boardIdx);

	String nfindFile(String bidx);

	int ndelete(String bidx);

	int nupdate(HashMap<String, String> params);

	String userRight(String loginId);

	
	
	
	
	
	
	
	
	
	
	
	ArrayList<BoardDTO> ilist();
	
	ArrayList<BoardDTO> ialist(int cnt, int offset);
	
	int iatotalCount();

	int iwrite(BoardDTO dto);

	void ifileWrite(int photoIdx, String photoId);
	
	void iupHit(String boardIdx);

	BoardDTO idetail(String boardIdx);

	String ifindFile(String bidx);

	int idelete(String bidx);

	int iupdate(HashMap<String, String> params);

	String iuserRight(String loginId);

}
