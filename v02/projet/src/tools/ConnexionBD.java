package tools;
import java.sql.*;

import metier.Personne;

public class ConnexionBD {
	
	private Connection cn;
	private Statement st;
	private ResultSet rs;
	
	public ConnexionBD() throws ClassNotFoundException {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		String url = "jdbc:oracle:thin:@gloin:1521:iut";
		String login = "nicotb";
		String mdp = "1109012777W";
		
		try {
			cn = DriverManager.getConnection(url, login, mdp);
			st = cn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = st.executeQuery("SELECT * FROM Personnes ORDER BY agePersonne DESC NULLS LAST");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public Personne premier() {
		try {
			if(!rs.first()) {
				throw new Exception("pas de résultats");
			}
		}
		catch (Exception e1) {
			e1.printStackTrace();
		}
		
		return recupPers();
	}
	
	public Personne prev() {
		try {
			if(!rs.previous()) {
				rs.next();
				throw new Exception("pas de résultats");
			}
		}
		catch (Exception e1) {
			e1.printStackTrace();
		}
		
		return recupPers();
	}
	
	public Personne next() {
		try {
			if(!rs.next()) {
				rs.previous();
				throw new Exception("pas de résultats");
			}
		}
		catch (Exception e1) {
			e1.printStackTrace();
		}
		
		return recupPers();
	}
	
	public Personne dernier() {
		try {
			if(!rs.last()) {
				throw new Exception("pas de résultats");
			}
		}
		catch (Exception e1) {
			e1.printStackTrace();
		}
		
		return recupPers();
	}
	
	public void deconnexion() {
		try {
			cn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public Personne recupPers() {
		int age = 0;
		String num = null, nom = null, prenom = null;
		
		try {
			num = rs.getString("codePersonne");
			nom = rs.getString("nomPersonne");
			prenom = rs.getString("prenomPersonne");
			
			age = rs.getInt("agePersonne");
			if(rs.wasNull()) {
				age = -99;
			}
		}
		catch (Exception e) {
			System.out.println("recup impossible");
		}
		
		return new Personne(num, nom, prenom, age);
		
	}

}
