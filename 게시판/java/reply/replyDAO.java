package reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import bbs.bbs;

public class replyDAO {
	private Connection conn;
	private ResultSet rs; //어떠한 정보를 담을 수 있는 객체
	
	public replyDAO()
	{	
	}
	
	public void createConnection() {
		
		try {
			String dbURL= "jdbc:mysql://localhost:3306/bbs?useUnicode=true&characterEncoding=utf8";
			String dbID = "root";
			String dbPassword = "0199";
			Class.forName("org.gjt.mm.mysql.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);//conn객체에 커넥션 정보저장	
			
		}	
		catch(Exception e)
		{

			e.printStackTrace();
		}		
	}
	
	public void removeConnection() {
		if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
	}
	
	public int getFirst()
	{
		createConnection();
		String SQL = "SELECT replyID FROM reply ORDER BY replyID ASC"; 
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getInt(1); //나온결과에서 첫번째 값 + 1
			return 1;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -1; //데이터베이스 오류
	}
	
	public String getUserID(int replyID) {
		createConnection();
		String SQL = "SELECT userID FROM reply WHERE replyID = ?"; 
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, replyID);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getString(1); //나온결과에서 첫번째 값 + 1
			return "0";
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return "-1"; //데이터베이스 오류
	}
	
	public int getNext()
	{
		
		String SQL = "SELECT replyID FROM reply ORDER BY replyID DESC"; 
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getInt(1) + 1; //나온결과에서 첫번째 값 + 1
			return 1;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			
	      }
		return -1; //데이터베이스 오류
	}
	
	public String getDate()
	{
		createConnection();
		String SQL = "SELECT NOW()"; // 현재시간을 가져오는 MYSQL 문장
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getString(1);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return ""; //데이터베이스 오류
	}
	
	public int write(int bbsID,String userID,String replyContent) {
		createConnection();
		String SQL = "Insert into reply values (?,?,?,?,?,?)"; // 현재시간을 가져오는 MYSQL 문장
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, userID);
			pstmt.setString(4, replyContent);
			pstmt.setString(5, getDate());
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -1; //데이터베이스 오류
		
	}
	
	public int getLast(int bbsID) //라이브러리 가져오기 ctrl+shift+o
	{
		createConnection();
		String SQL = "Select * from reply where replyID < ? AND replyAvailable = 1 AND bbsID = ? ORDER BY replyID DESC LIMIT 10"; // 현재시간을 가져오는 MYSQL 문장
		int index = 0;
		try {
			int num = getNext();
			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,num); // getNext() => 다음 저장될 ID번호, getNext() - (pageNumber-1)*10 => 1~10으로 정규화
			pstmt.setInt(2, bbsID);			
			rs = pstmt.executeQuery(); //select문 쿼리 실행
			while(rs.next())
			{
				reply b = new reply(); //bbs객체 생성 후 b에 할당
				b.setBbsID(rs.getInt(1));
				index = rs.getInt(2);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return index;
	}
	
	public ArrayList<reply> getList(int bbsID, int index) //라이브러리 가져오기 ctrl+shift+o
	{
		createConnection();
		String SQL = "Select * from reply where replyID < ? AND replyAvailable = 1 AND bbsID = ? ORDER BY replyID DESC LIMIT 10"; // 현재시간을 가져오는 MYSQL 문장
		ArrayList<reply> list = new ArrayList<reply>();
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			if(index == -1) {
				pstmt.setInt(1, getNext()); // getNext() => 다음 저장될 ID번호, getNext() - (pageNumber-1)*10 => 1~10으로 정규화
				pstmt.setInt(2, bbsID);
			}
			else {
				pstmt.setInt(1, index);
				pstmt.setInt(2, bbsID);
			}
					
			
			rs = pstmt.executeQuery(); //select문 쿼리 실행
			while(rs.next())
			{
				reply b = new reply(); //bbs객체 생성 후 b에 할당
				b.setBbsID(rs.getInt(1));
				b.setReplyID(rs.getInt(2));
				b.setUserID(rs.getString(3));
				b.setReplyContent(rs.getString(4));
				b.setReplyDate(rs.getString(5));
				b.setReplyAvailable(rs.getInt(6));
				list.add(b);
			}
		}
		catch(Exception e)
		{			
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return list;
	}
	
	public int delete(int replyID) {
		createConnection();
		String SQL = "update reply set replyAvailable = 0 where replyID = ?"; // 현재시간을 가져오는 MYSQL 문장
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, replyID);
			return pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -1; //데이터베이스 오류
	}
	
}
