package controller;

import dao.impl.ConducteurDAOImpl;
import dao.impl.PassagerDAOImpl;
import models.Conducteur;
import models.Passager;
import models.Utilisateur;
import Covoiturage.dao.factory.Factory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {
    
    private ConducteurDAOImpl conducteurDAO;
    private PassagerDAOImpl passagerDAO;
    private Connection connection;
    
    @Override
    public void init() throws ServletException {
        try {
            connection = Factory.dbConnect();
            conducteurDAO = new ConducteurDAOImpl(connection);
            passagerDAO = new PassagerDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Erreur d'initialisation de la connexion", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Afficher le formulaire d'inscription
        request.getRequestDispatcher("/inscription.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String typeUtilisateur = request.getParameter("typeUtilisateur");
        
        try {
            if ("conducteur".equals(typeUtilisateur)) {
                inscrireConducteur(request, response);
            } else if ("passager".equals(typeUtilisateur)) {
                inscrirePassager(request, response);
            } else {
                request.setAttribute("erreur", "Type d'utilisateur invalide");
                request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("erreur", "Erreur lors de l'inscription: " + e.getMessage());
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
        }
    }
    
    private void inscrireConducteur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {

        // Récupération des champs
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String telephone = request.getParameter("telephone");
        String marqueVehicule = request.getParameter("marqueVehicule");
        String modeleVehicule = request.getParameter("modeleVehicule");
        String immatriculation = request.getParameter("immatriculation");
        int nombrePlaces = Integer.parseInt(request.getParameter("nombrePlaces"));

        // Validation
        if (nom == null || nom.trim().isEmpty() || 
            prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty()) {

            request.setAttribute("erreur", "Tous les champs obligatoires doivent être remplis");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }

        // Création du conducteur
        Conducteur conducteur = new Conducteur();
        conducteur.setNom(nom);
        conducteur.setPrenom(prenom);
        conducteur.setEmail(email);
        conducteur.setMotDePasse(motDePasse);
        conducteur.setTelephone(telephone);
        conducteur.setDateInscription(new Date());
        conducteur.setEstActif(true);
        conducteur.setMarqueVehicule(marqueVehicule);
        conducteur.setModeleVehicule(modeleVehicule);
        conducteur.setImmatriculation(immatriculation);
        conducteur.setNombrePlacesVehicule(nombrePlaces);
        conducteur.setNoteMoyenne(0.0);

        // Insertion dans la DB
        Long id = conducteurDAO.create(conducteur);

        if (id != null) {
            // Créer la session et rediriger vers le dashboard
            HttpSession session = request.getSession();
            conducteur.setIdConducteur(id);
            session.setAttribute("utilisateur", conducteur);
            session.setAttribute("typeUtilisateur", "conducteur");

            response.sendRedirect("Conducteur?page=dashboard"); // comme dans la connexion
        } else {
            request.setAttribute("erreur", "Échec de l'inscription. Veuillez réessayer.");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
        }
    }

    
    private void inscrirePassager(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String telephone = request.getParameter("telephone");

        if (nom == null || nom.trim().isEmpty() || 
            prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty()) {

            request.setAttribute("erreur", "Tous les champs obligatoires doivent être remplis");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }

        Passager passager = new Passager();
        passager.setNom(nom);
        passager.setPrenom(prenom);
        passager.setEmail(email);
        passager.setMotDePasse(motDePasse);
        passager.setTelephone(telephone);
        passager.setDateInscription(new Date());
        passager.setEstActif(true);
        passager.setNoteMoyenne(0.0);

        Long id = passagerDAO.create(passager);

        if (id != null) {
            HttpSession session = request.getSession();
            passager.setIdPassager(id);
            session.setAttribute("utilisateur", passager);
            session.setAttribute("typeUtilisateur", "passager");

            response.sendRedirect("dashboardPassager.jsp"); // comme dans la connexion
        } else {
            request.setAttribute("erreur", "Échec de l'inscription. Veuillez réessayer.");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
        }
    }

    
    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}