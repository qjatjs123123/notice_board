package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class bbsDAO {
	private Connection conn;
	private ResultSet rs; //어떠한 정보를 담을 수 있는 객체
	private static HashMap<Integer, Integer> head_list;
	private static HashMap<Integer, Integer> tail_list;
	private static int k = -1;
	
	public bbsDAO()
	{
		try {
			if(k == -1) {
			head_list = new HashMap<Integer, Integer>(); 
			tail_list = new HashMap<Integer, Integer>(); 
			k=0;
			}			
		}	
		catch(Exception e)
		{
			e.printStackTrace();
		}		
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
	
	public int getNext()
	{
		createConnection();
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC"; 
		
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
	          removeConnection();
	      }
		return -1; //데이터베이스 오류
	}
	
	public ArrayList<bbs> getList(int pageNumber) //라이브러리 가져오기 ctrl+shift+o
	{
		createConnection();
		if(pageNumber == 1) {
			String SQL = "Select * from bbs where bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; // 현재시간을 가져오는 MYSQL 문장
			ArrayList<bbs> list = new ArrayList<bbs>();
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1,getNext() - (pageNumber-1)*10);
				rs = pstmt.executeQuery();
				int index = 0;
				int count = 0;
				while(rs.next())
				{
					if (count == 0)
					{
						
							head_list.put(pageNumber,rs.getInt(1));
						
						count++;
					}
					bbs b = new bbs();
					b.setBbsID(rs.getInt(1));
					b.setBbsTitle(rs.getString(2));
					b.setUserID(rs.getString(3));
					b.setBbsDate(rs.getString(4));
					b.setBbsContent(rs.getString(5));
					b.setBbsAvailable(rs.getInt(6));
					list.add(b);
					index = rs.getInt(1);				
				}
				
				tail_list.put(pageNumber,index);
				
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
		
		else {
			
			if(head_list.size()<pageNumber) {
				String SQL = "Select * from bbs where bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; // 현재시간을 가져오는 MYSQL 문장
				ArrayList<bbs> list = new ArrayList<bbs>();
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					
					pstmt.setInt(1,(Integer)tail_list.get(pageNumber-1));
					rs = pstmt.executeQuery();
					int count = 0;
					int index = 0;
					while(rs.next())
					{
						if (count == 0)
						{	
							
							head_list.put(pageNumber,rs.getInt(1));
							count++;
						}
						bbs b = new bbs();
						b.setBbsID(rs.getInt(1));
						b.setBbsTitle(rs.getString(2));
						b.setUserID(rs.getString(3));
						b.setBbsDate(rs.getString(4));
						b.setBbsContent(rs.getString(5));
						b.setBbsAvailable(rs.getInt(6));
						list.add(b);
						
						index = rs.getInt(1);
					}
					
					tail_list.put(pageNumber,index);
					
					
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
			
			else {
				String SQL = "Select * from bbs where bbsID <= ? AND bbsID >= ? AND bbsAvailable = 1 ORDER BY bbsID DESC "; // 현재시간을 가져오는 MYSQL 문장
				ArrayList<bbs> list = new ArrayList<bbs>();
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(2,tail_list.get(pageNumber));
					pstmt.setInt(1,head_list.get(pageNumber));
					rs = pstmt.executeQuery();
					while(rs.next())
					{
						bbs b = new bbs();
						b.setBbsID(rs.getInt(1));
						b.setBbsTitle(rs.getString(2));
						b.setUserID(rs.getString(3));
						b.setBbsDate(rs.getString(4));
						b.setBbsContent(rs.getString(5));
						b.setBbsAvailable(rs.getInt(6));
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
		}
		
	}
	
	public boolean nextPage(int pageNumber)
	{
		createConnection();
		String SQL = "Select * from bbs where bbsID < ? AND bbsAvailable = 1"; // 현재시간을 가져오는 MYSQL 문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,getNext() - (pageNumber-1)*10);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				return true;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return false;
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) {
		head_list.clear();
		tail_list.clear();
		createConnection();
		String SQL = "Insert into bbs values (?,?,?,?,?,?)"; // 현재시간을 가져오는 MYSQL 문장
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
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
	
	public bbs getBbs(int bbsID)
	{
		createConnection();
		String SQL = "Select * from bbs where bbsID = ?"; // 현재시간을 가져오는 MYSQL 문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,bbsID);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				bbs b = new bbs();
				b.setBbsID(rs.getInt(1));
				b.setBbsTitle(rs.getString(2));
				b.setUserID(rs.getString(3));
				b.setBbsDate(rs.getString(4));
				b.setBbsContent(rs.getString(5));
				b.setBbsAvailable(rs.getInt(6));
				return b;
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return null;
	}
	
	public int delete(int bbsID) {
		head_list.clear();
		tail_list.clear();
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?"; // 현재시간을 가져오는 MYSQL 문장
		createConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
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
	
	public int MaxPageCount() {
		String SQL = "SELECT COUNT(*) FROM bbs where bbsAvailable = 1";
		createConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int num = rs.getInt(1);
				int page = num/10;
				int res = num%10;
				if (res == 0)
					return page;
				else
					return page+1;
			}
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
	
	public int update(int bbsID, String bbsTitle, String bbsContent)
	{
		String SQL = "update bbs set bbsTitle=?, bbsContent = ? where bbsID = ?"; // 현재시간을 가져오는 MYSQL 문장
		createConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
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
