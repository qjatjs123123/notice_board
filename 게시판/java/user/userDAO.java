package user;

import java.sql.Connection;
import encript.BCrypt;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.SHA256;


public class userDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs; //어떠한 정보를 담을 수 있는 객체
	
	public userDAO()
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
	
	
	public boolean id_check(String id) {
		createConnection();
		String SQL = "SELECT * FROM user";			
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(id.equals(rs.getString("userID"))){
					return false;
				}
			}
			return true;			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return true;		
	}
	
	public int join(user user) {	
		createConnection();
		String SQL = "Insert into user values(?,?,?,?,?,?)";	
		String userNum = user.getFirstnum()+user.getSecondnum();
		
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,user.getId());
			pstmt.setString(2, BCrypt.hashpw(userNum, BCrypt.gensalt(9)));
			pstmt.setString(3, BCrypt.hashpw(user.getPasswd(), BCrypt.gensalt(10)));
			pstmt.setString(4,user.getName());
			pstmt.setString(5,user.getEmail());
			pstmt.setString(6, SHA256.getSHA256(user.getEmail()));
			
			return pstmt.executeUpdate(); //executeupdate는 select제외하고 모든 것에 사용
			
		}catch(Exception e) {
			System.out.print(e);
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -1;		
	}
	
	public int login(String userID, String userPassword)
	{
		createConnection();
		String SQL = "SELECT userPassword FROM user where userID = ?";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(BCrypt.checkpw(userPassword, rs.getString(1)))
					return 1;
				else
					return 0;
			}
			return -1;
		} catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -2;
	}
	
	public String findId(String name, String firstnum, String secondnum) {
		createConnection();
		String SQL = "SELECT userID, userNum from user where userName = ?";
		String userNum = firstnum+secondnum;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,name);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				if(BCrypt.checkpw(userNum, rs.getString(2))) {
					return rs.getString(1);
				}					
			}
			return "-1";
		} catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return "-2";
		
	}
	
	public String getUserEmail(String id) {
		createConnection();
		String SQL = "SELECT userEmail from user where userID = ?";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,id);
			rs = pstmt.executeQuery();
			
			if(rs.next())
				return rs.getString(1);
			else
				return "0";
		}catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return "-1";
		
	}
	
	public String getUserEmail(String id, String firstnum, String secondnum, String email) {
		createConnection();
		String SQL = "SELECT userEmail,userNum from user where userID = ? and userEmail = ?";
		String userNum = firstnum+secondnum;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,id);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				if(BCrypt.checkpw(userNum, rs.getString(2)))
					return rs.getString(1);
			}
			return "0";
		}catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return "-1";
		
	}
	
	public int ChangePassword(String id, String passwd) {
		createConnection();
		String SQL = "UPDATE user SET userPassword = ? WHERE userID= ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, BCrypt.hashpw(passwd, BCrypt.gensalt(10)));
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			
			
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			removeConnection();
	      }
		return -1;
		
	}
	
}
