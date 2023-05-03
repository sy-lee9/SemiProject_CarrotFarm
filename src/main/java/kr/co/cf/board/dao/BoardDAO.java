package kr.co.cf.board.dao;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.cf.board.dto.BoardDTO;

public interface BoardDAO {

	ArrayList<BoardDTO> flist();

	int fwrite(BoardDTO dto);

	void ffileWrite(int photoIdx, String photoId);

	void fupHit(String boardIdx);

	BoardDTO fdetail(String boardIdx);

	String ffindFile(String bidx);

	int fdelete(String bidx);

	int fupdate(HashMap<String, String> params);
	
	int fatotalCount();

	ArrayList<BoardDTO> falist(int cnt, int offset);

	
	

	ArrayList<BoardDTO> nlist();

	int nwrite(BoardDTO dto);

	void nfileWrite(int photoIdx, String photoId);
	
	void nupHit(String boardIdx);

	BoardDTO ndetail(String boardIdx);

	String nfindFile(String bidx);

	int ndelete(String bidx);

	int nupdate(HashMap<String, String> params);

	
}
