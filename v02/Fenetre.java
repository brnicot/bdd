import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Fenetre extends JFrame implements ActionListener, WindowListener {

	private JButton btSuiv;
	private JButton btPrec;
	private JButton btPrem;
	private JButton btDer;
	private JButton btRecherche;
	private JButton btTous;
	private JButton btVider;
	private JButton btEnregistrer;
	private JButton btModifier;
	private JButton btSupprimer;

	private JTextField txtNum;
	private JTextField txtNom;
	private JTextField txtPrenom;
	private JTextField txtAge;
	private JTextField txtAgeMinimum;

	public Fenetre() {
		setTitle("exercice JDBC");
		setBounds(500, 500, 200, 250);
		Container contentPane = getContentPane();

		JPanel panRecherche = new JPanel();
		JPanel panAffichage = new JPanel(new GridLayout(5, 1));
		JPanel panModification = new JPanel();

		panRecherche.setBackground(Color.lightGray);
		panModification.setBackground(Color.lightGray);

		JPanel panNum = new JPanel();
		JPanel panNom = new JPanel();
		JPanel panPrenom = new JPanel();
		JPanel panAge = new JPanel();
		JPanel panNavigation = new JPanel();
		JLabel labNum = new JLabel("Code personne");
		JLabel labNom = new JLabel("Nom personne");
		JLabel labPrenom = new JLabel("Prenom personne");
		JLabel labAge = new JLabel("Age personne");
		panNum.add(labNum);
		txtNum = new JTextField(15);
		panNum.add(txtNum);
		panNom.add(labNom);
		txtNom = new JTextField(15);
		panNom.add(txtNom);
		panPrenom.add(labPrenom);
		txtPrenom = new JTextField(15);
		panPrenom.add(txtPrenom);
		panAge.add(labAge);
		txtAge = new JTextField(15);
		panAge.add(txtAge);
		btSuiv = new JButton(">");
		btPrec = new JButton("<");
		btPrem = new JButton("|<");
		btDer = new JButton(">|");
		panNavigation.add(btPrem);
		panNavigation.add(btPrec);
		panNavigation.add(btSuiv);
		panNavigation.add(btDer);
		panAffichage.add(panNum);
		panAffichage.add(panNom);
		panAffichage.add(panPrenom);
		panAffichage.add(panAge);
		panAffichage.add(panNavigation);

		JLabel labRecherche = new JLabel("Personnes agées de plus de : ");
		panRecherche.add(labRecherche);
		txtAgeMinimum = new JTextField(15);
		panRecherche.add(txtAgeMinimum);
		btRecherche = new JButton("Rechercher");
		panRecherche.add(btRecherche);
		btTous = new JButton("Tous");
		panRecherche.add(btTous);

		btVider = new JButton("Vider formulaire");
		panModification.add(btVider);
		btEnregistrer = new JButton("Enregister nouveau");
		panModification.add(btEnregistrer);
		btModifier = new JButton("Modifier");
		panModification.add(btModifier);
		btSupprimer = new JButton("Supprimer");
		panModification.add(btSupprimer);

		// contentPane.add(panRecherche,"North");
		contentPane.add(panAffichage);
		// contentPane.add(panModification,"South");
		pack();

		btPrem.addActionListener(this);
		btPrec.addActionListener(this);
		btSuiv.addActionListener(this);
		btDer.addActionListener(this);
		btRecherche.addActionListener(this);
		btTous.addActionListener(this);
		btVider.addActionListener(this);
		btEnregistrer.addActionListener(this);
		btModifier.addActionListener(this);
		btSupprimer.addActionListener(this);

		addWindowListener(this);
		setVisible(true);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource() == btPrec)
			System.out.println("précédent");
		if (e.getSource() == btPrem)
			System.out.println("premier");
		if (e.getSource() == btSuiv)
			System.out.println("suivant");
		if (e.getSource() == btDer)
			System.out.println("dernier");

		// if (e.getSource() == btRecherche)
		// System.out.println("rechercher");
		// if (e.getSource() == btTous)
		// System.out.println("tous");

		// if (e.getSource() == btVider)
		// System.out.println("vider");
		// if (e.getSource() == btEnregistrer)
		// System.out.println("enregistrer");
		// if (e.getSource() == btModifier)
		// System.out.println("modifier");
		// if (e.getSource() == btSupprimer)
		// System.out.println("supprimer");
	}

	public void windowClosing(WindowEvent arg0) {
		System.out.println("Au revoir !");
		System.exit(0);
	}

	public void windowActivated(WindowEvent arg0) {
	}

	public void windowClosed(WindowEvent arg0) {
	}

	public void windowDeactivated(WindowEvent arg0) {
	}

	public void windowDeiconified(WindowEvent arg0) {
	}

	public void windowIconified(WindowEvent arg0) {
	}

	public void windowOpened(WindowEvent arg0) {
	}

	public static void main(String[] args) {
		Fenetre f = new Fenetre();
	}

}
