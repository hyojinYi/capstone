package qna;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class QnaDAO {

	private Connection conn;
	private ResultSet rs;

	public QnaDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/QNA";
			String dbID="root";
			String dbPassword="root";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";	// 데이터베이스 오류
	}
	
	public int getNext() {
		String SQL = "SELECT qnaID FROM QNA ORDER BY qnaID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	public int write(String qnaTitle, String userID, String qnaContent) {
		String SQL = "INSERT INTO QNA VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, qnaTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, qnaContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	public ArrayList<Qna> getList(int pageNumber){	//ctrl+shift+o
		String SQL = "SELECT * FROM QNA WHERE qnaID < ? AND qnaAvailable = 1 ORDER BY qnaID DESC LIMIT 10";
		ArrayList<Qna> list = new ArrayList<Qna>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Qna qna = new Qna();
				qna.setQnaID(rs.getInt(1));
				qna.setQnaTitle(rs.getString(2));
				qna.setUserID(rs.getString(3));
				qna.setQnaDate(rs.getString(4));
				qna.setQnaContent(rs.getString(5));
				qna.setQnaAvailable(rs.getInt(6));
				list.add(qna);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM QNA WHERE qnaID < ? AND qnaAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public Qna getQna(int qnaID)
    {
            String SQL = "SELECT * FROM Qna WHERE qnaID = ?"; 
            try {
                PreparedStatement pstmt = conn.prepareStatement(SQL);
                pstmt.setInt(1, qnaID);
                rs = pstmt.executeQuery();
                if (rs.next())
                {
                	Qna qna = new Qna();
    				qna.setQnaID(rs.getInt(1));
    				qna.setQnaTitle(rs.getString(2));
    				qna.setUserID(rs.getString(3));
    				qna.setQnaDate(rs.getString(4));
    				qna.setQnaContent(rs.getString(5));
    				qna.setQnaAvailable(rs.getInt(6));
    				return qna;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; 
        }
	public int update(int qnaID, String qnaTitle, String qnaContent)
	{
	        String SQL = "UPDATE QNA SET qnaTitle = ?, qnaContent = ? WHERE qnaID = ?";
	        try {
	            PreparedStatement pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, qnaTitle);
	            pstmt.setString(2, qnaContent);
	            pstmt.setInt(3, qnaID);
	            return pstmt.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1; // 데이터베이스 오류
	   }
	
	public int delete(int qnaID) {
		String SQL = "UPDATE QNA SET qnaAvailable = 0 WHERE qnaID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, qnaID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터베이스 오류
	}
}
