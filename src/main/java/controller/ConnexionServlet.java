package controller;

import dao.impl.ConducteurDAOImpl;
import dao.impl.PassagerDAOImpl;
import dao.impl.AdministrateurDAOImpl;
import models.Conducteur;
import models.Passager;
import models.Administrateur;
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

@WebServlet("/connexion")
public class ConnexionServlet extends HttpServlet {
    
    private Connection connection;
    private ConducteurDAOImpl conducteurDAO;
    private PassagerDAOImpl passagerDAO;
    private AdministrateurDAOImpl adminDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            connection = Factory.dbConnect();
            conducteurDAO = new ConducteurDAOImpl(connection);
            passagerDAO = new PassagerDAOImpl(connection);
            adminDAO = new AdministrateurDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Erreur d'initialisation", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/connexion.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        
        if (email == null || email.trim().isEmpty() || 
            motDePasse == null || motDePasse.trim().isEmpty()) {
            request.setAttribute("erreur", "Email et mot de passe requis");
            request.getRequestDispatcher("/connexion.jsp").forward(request, response);
            return;
        }
        
        try {
            // Vérifier si c'est un conducteur
            Conducteur conducteur = conducteurDAO.findByEmail(email);
            if (conducteur != null && conducteur.getMotDePasse().equals(motDePasse) && conducteur.getEstActif()) {
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", conducteur);
                session.setAttribute("typeUtilisateur", "conducteur");
                response.sendRedirect("Conducteur?page=dashboard");  // Redirection vers le nouveau dashboard
                return;
            }
            
            // Vérifier si c'est un passager
            Passager passager = passagerDAO.findByEmail(email);
            if (passager != null && passager.getMotDePasse().equals(motDePasse) && passager.getEstActif()) {
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", passager);
                session.setAttribute("typeUtilisateur", "passager");
                response.sendRedirect("dashboardPassager.jsp");  // Préparation pour le dashboard passager
                return;
            }
            
            // Vérifier si c'est un administrateur
            Administrateur admin = adminDAO.findByEmail(email);
            if (admin != null && admin.getMotDePasse().equals(motDePasse) && admin.getEstActif()) {
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", admin);
                session.setAttribute("typeUtilisateur", "administrateur");
                response.sendRedirect("dashboardAdmin.jsp");  // Préparation pour le dashboard admin
                return;
            }
            
            // Aucun utilisateur trouvé
            request.setAttribute("erreur", "Email ou mot de passe incorrect");
            request.getRequestDispatcher("/connexion.jsp").forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("erreur", "Erreur de connexion: " + e.getMessage());
            request.getRequestDispatcher("/connexion.jsp").forward(request, response);
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