public class Personne {

	private String num;
	private String nom;
	private String prenom;
	private int age;

	public Personne(String num, String nom, String prenom, int age) {
		this.num = num;
		this.nom = nom;
		this.prenom = prenom;
		this.age = age;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public String getPrenom() {
		return prenom;
	}

	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}
}
