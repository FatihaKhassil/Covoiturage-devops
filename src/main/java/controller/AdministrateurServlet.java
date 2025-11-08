package controller;

import dao.impl.AdministrateurDAOImpl;
import models.Administrateur;
import Covoiturage.dao.factory.Factory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@WebServlet("/testAdmin")
public class AdministrateurServlet extends HttpServlet {
    
    private AdministrateurDAOImpl adminDAO;
    private Connection connection;
    
    @Override
    public void init() throws ServletException {
        try {
            connection = Factory.dbConnect();
            adminDAO = new AdministrateurDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Erreur d'initialisation de la connexion", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.equals("liste")) {
                listerAdministrateurs(request, response);
            } else if (action.equals("details")) {
                afficherDetails(request, response);
            } else if (action.equals("formulaire")) {
                afficherFormulaire(request, response);
            } else if (action.equals("supprimer")) {
                supprimerAdministrateur(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("erreur", "Erreur SQL: " + e.getMessage());
            request.getRequestDispatcher("/testAdmin.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            if (action.equals("creer")) {
                creerAdministrateur(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("erreur", "Erreur lors de la création: " + e.getMessage());
            request.getRequestDispatcher("/testAdmin.jsp").forward(request, response);
        }
    }
    
    private void listerAdministrateurs(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        List<Administrateur> administrateurs = adminDAO.findAll();
        request.setAttribute("administrateurs", administrateurs);
        request.setAttribute("action", "liste");
        request.getRequestDispatcher("/testAdmin.jsp").forward(request, response);
    }
    
    private void afficherDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        Administrateur admin = adminDAO.findById(id);
        
        if (admin != null) {
            request.setAttribute("admin", admin);
            request.setAttribute("action", "details");
        } else {
            request.setAttribute("erreur", "Administrateur introuvable avec l'ID: " + id);
        }
        
        request.getRequestDispatcher("/testAdmin.jsp").forward(request, response);
    }
    
    private void afficherFormulaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("action", "formulaire");
        request.getRequestDispatcher("/testAdmin.jsp").forward(request, response);
    }
    
    private void creerAdministrateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String telephone = request.getParameter("telephone");
        
        Administrateur admin = new Administrateur();
        admin.setNom(nom);
        admin.setPrenom(prenom);
        admin.setEmail(email);
        admin.setMotDePasse(motDePasse);
        admin.setTelephone(telephone);
        admin.setDateInscription(new Date());
        admin.setEstActif(true);
        
        Long id = adminDAO.create(admin);
        
        if (id != null) {
            request.setAttribute("succes", "Administrateur créé avec succès! ID: " + id);
        } else {
            request.setAttribute("erreur", "Échec de la création de l'administrateur");
        }
        
        // Rediriger vers la liste
        listerAdministrateurs(request, response);
    }
    
    private void supprimerAdministrateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        boolean supprime = adminDAO.delete(id);
        
        if (supprime) {
            request.setAttribute("succes", "Administrateur supprimé avec succès!");
        } else {
            request.setAttribute("erreur", "Échec de la suppression");
        }
        
        // Rediriger vers la liste
        listerAdministrateurs(request, response);
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