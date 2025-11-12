package controller;

import dao.impl.*;
import models.*;
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
import java.util.List;

@WebServlet("/Admin")
public class AdminServlet extends HttpServlet {
    
    private Connection connection;
    private AdministrateurDAOImpl adminDAO;
    private UtilisateurDAOImpl utilisateurDAO;
    private ConducteurDAOImpl conducteurDAO;
    private PassagerDAOImpl passagerDAO;
    private OffreDAOImpl offreDAO;
    private ReservationDAOImpl reservationDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            connection = Factory.dbConnect();
            this.adminDAO = new AdministrateurDAOImpl(connection);
            this.utilisateurDAO = new UtilisateurDAOImpl(connection);
            this.conducteurDAO = new ConducteurDAOImpl(connection);
            this.passagerDAO = new PassagerDAOImpl(connection);
            this.offreDAO = new OffreDAOImpl(connection);
            this.reservationDAO = new ReservationDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Erreur d'initialisation de la connexion", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null || 
            !"administrateur".equals(session.getAttribute("typeUtilisateur"))) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        Administrateur admin = (Administrateur) session.getAttribute("utilisateur");
        String page = request.getParameter("page");
        
        if (page == null || page.isEmpty()) {
            page = "dashboard";
        }
        
        try {
            switch (page) {
                case "dashboard":
                    afficherDashboard(request, response, admin);
                    break;
                case "utilisateurs":
                    afficherUtilisateurs(request, response, admin);
                    break;
                case "validation":
                    afficherValidation(request, response, admin);
                    break;
                case "rapports":
                    afficherRapports(request, response, admin);
                    break;
                case "profil":
                    request.setAttribute("page", "profil");
                    request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect("Admin?page=dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur SQL: " + e.getMessage());
            request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect("Admin?page=dashboard");
            return;
        }
        
        try {
            switch (action) {
                case "bloquerUtilisateur":
                    bloquerUtilisateur(request, response);
                    break;
                case "debloquerUtilisateur":
                    debloquerUtilisateur(request, response);
                    break;
                case "validerOffre":
                    validerOffre(request, response);
                    break;
                case "rejeterOffre":
                    rejeterOffre(request, response);
                    break;
                case "genererRapport":
                    genererRapport(request, response);
                    break;
                default:
                    response.sendRedirect("Admin?page=dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect("Admin?page=dashboard");
        }
    }
    
    // ========== Méthodes d'affichage ==========
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, 
            Administrateur admin) throws ServletException, IOException, SQLException {
        
        // Consulter les statistiques globales
        int totalUtilisateurs = utilisateurDAO.findAll().size();
        int totalConducteurs = conducteurDAO.findAll().size();
        int totalPassagers = passagerDAO.findAll().size();
        int totalOffres = offreDAO.findAll().size();
        int totalReservations = reservationDAO.findAll().size();
        
        // Offres en attente de validation
        List<Offre> offresEnAttente = offreDAO.findEnAttente();
        int offresEnAttenteCount = offresEnAttente.size();
        
        // Statistiques des offres
        int offresActives = 0;
        int offresTerminees = 0;
        int offresAnnulees = 0;
        
        List<Offre> toutesOffres = offreDAO.findAll();
        for (Offre offre : toutesOffres) {
            String statut = offre.getStatut();
            if ("VALIDEE".equals(statut)) {
                offresActives++;
            } else if ("TERMINEE".equals(statut)) {
                offresTerminees++;
            } else if ("ANNULEE".equals(statut)) {
                offresAnnulees++;
            }
        }
        
        // Calculer le revenu total
        double revenuTotal = 0;
        for (Reservation res : reservationDAO.findAll()) {
            if ("CONFIRMEE".equals(res.getStatut()) || "TERMINEE".equals(res.getStatut())) {
                revenuTotal += res.getPrixTotal();
            }
        }
        
        // Passer les données à la JSP
        request.setAttribute("totalUtilisateurs", totalUtilisateurs);
        request.setAttribute("totalConducteurs", totalConducteurs);
        request.setAttribute("totalPassagers", totalPassagers);
        request.setAttribute("totalOffres", totalOffres);
        request.setAttribute("totalReservations", totalReservations);
        request.setAttribute("offresEnAttenteCount", offresEnAttenteCount);
        request.setAttribute("offresActives", offresActives);
        request.setAttribute("offresTerminees", offresTerminees);
        request.setAttribute("offresAnnulees", offresAnnulees);
        request.setAttribute("revenuTotal", revenuTotal);
        
        // Activités récentes (dernières offres)
        List<Offre> dernieresOffres = toutesOffres.stream()
            .sorted((o1, o2) -> o2.getDatePublication().compareTo(o1.getDatePublication()))
            .limit(5)
            .collect(java.util.stream.Collectors.toList());
        request.setAttribute("dernieresOffres", dernieresOffres);
        
        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
    }
    
    private void afficherUtilisateurs(HttpServletRequest request, HttpServletResponse response, 
            Administrateur admin) throws ServletException, IOException, SQLException {
        
        List<Conducteur> conducteurs = conducteurDAO.findAll();
        List<Passager> passagers = passagerDAO.findAll();
        
        request.setAttribute("conducteurs", conducteurs);
        request.setAttribute("passagers", passagers);
        request.setAttribute("totalConducteurs", conducteurs.size());
        request.setAttribute("totalPassagers", passagers.size());
        
        // Compter les actifs/inactifs
        long conducteursActifs = conducteurs.stream().filter(Utilisateur::getEstActif).count();
        long passagersActifs = passagers.stream().filter(Utilisateur::getEstActif).count();
        
        request.setAttribute("conducteursActifs", conducteursActifs);
        request.setAttribute("passagersActifs", passagersActifs);
        request.setAttribute("conducteursInactifs", conducteurs.size() - conducteursActifs);
        request.setAttribute("passagersInactifs", passagers.size() - passagersActifs);
        
        request.setAttribute("page", "utilisateurs");
        request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
    }
    
    private void afficherValidation(HttpServletRequest request, HttpServletResponse response, 
            Administrateur admin) throws ServletException, IOException, SQLException {
        
        List<Offre> offresEnAttente = offreDAO.findEnAttente();
        
        request.setAttribute("offresEnAttente", offresEnAttente);
        request.setAttribute("totalEnAttente", offresEnAttente.size());
        
        request.setAttribute("page", "validation");
        request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
    }
    
    private void afficherRapports(HttpServletRequest request, HttpServletResponse response, 
            Administrateur admin) throws ServletException, IOException, SQLException {
        
        // Statistiques pour les rapports
        List<Offre> toutesOffres = offreDAO.findAll();
        List<Reservation> toutesReservations = reservationDAO.findAll();
        
        request.setAttribute("totalOffres", toutesOffres.size());
        request.setAttribute("totalReservations", toutesReservations.size());
        
        request.setAttribute("page", "rapports");
        request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
    }
    
    // ========== Méthodes d'action POST ==========
    
    private void bloquerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String userIdStr = request.getParameter("userId");
        HttpSession session = request.getSession();
        
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdStr);
                
                Utilisateur utilisateur = utilisateurDAO.findById(userId);
                if (utilisateur != null) {
                    utilisateur.setEstActif(false);
                    utilisateurDAO.update(utilisateur);
                    session.setAttribute("success", "✅ Utilisateur bloqué avec succès");
                } else {
                    session.setAttribute("error", "❌ Utilisateur introuvable");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "❌ ID utilisateur invalide");
            }
        } else {
            session.setAttribute("error", "❌ Aucun utilisateur spécifié");
        }
        
        response.sendRedirect("Admin?page=utilisateurs");
    }
    
    private void debloquerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String userIdStr = request.getParameter("userId");
        HttpSession session = request.getSession();
        
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdStr);
                
                Utilisateur utilisateur = utilisateurDAO.findById(userId);
                if (utilisateur != null) {
                    utilisateur.setEstActif(true);
                    utilisateurDAO.update(utilisateur);
                    session.setAttribute("success", "✅ Utilisateur débloqué avec succès");
                } else {
                    session.setAttribute("error", "❌ Utilisateur introuvable");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "❌ ID utilisateur invalide");
            }
        } else {
            session.setAttribute("error", "❌ Aucun utilisateur spécifié");
        }
        
        response.sendRedirect("Admin?page=utilisateurs");
    }
    
    private void validerOffre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String offreIdStr = request.getParameter("offreId");
        HttpSession session = request.getSession();
        
        if (offreIdStr != null && !offreIdStr.isEmpty()) {
            try {
                Long offreId = Long.parseLong(offreIdStr);
                
                // Changer le statut de EN_ATTENTE à VALIDEE
                boolean success = offreDAO.updateStatut(offreId, "VALIDEE");
                
                if (success) {
                    session.setAttribute("success", "✅ Offre #" + offreId + " validée avec succès");
                } else {
                    session.setAttribute("error", "❌ Impossible de valider l'offre #" + offreId);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "❌ ID d'offre invalide");
            }
        } else {
            session.setAttribute("error", "❌ Aucune offre spécifiée");
        }
        
        response.sendRedirect("Admin?page=validation");
    }
    
    private void rejeterOffre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String offreIdStr = request.getParameter("offreId");
        String motif = request.getParameter("motif");
        HttpSession session = request.getSession();
        
        if (offreIdStr != null && !offreIdStr.isEmpty()) {
            try {
                Long offreId = Long.parseLong(offreIdStr);
                
                // Changer le statut à ANNULEE
                boolean success = offreDAO.updateStatut(offreId, "ANNULEE");
                
                if (success) {
                    String message = "❌ Offre #" + offreId + " rejetée";
                    if (motif != null && !motif.trim().isEmpty()) {
                        message += " - Motif: " + motif;
                    }
                    session.setAttribute("success", message);
                } else {
                    session.setAttribute("error", "❌ Impossible de rejeter l'offre #" + offreId);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "❌ ID d'offre invalide");
            }
        } else {
            session.setAttribute("error", "❌ Aucune offre spécifiée");
        }
        
        response.sendRedirect("Admin?page=validation");
    }
    
    private void genererRapport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String typeRapport = request.getParameter("typeRapport");
        String periode = request.getParameter("periode");
        HttpSession session = request.getSession();
        
        // Pour l'instant, on affiche juste un message de confirmation
        // Vous pouvez implémenter la génération réelle de rapports plus tard
        String message = "📊 Rapport généré: " + 
                        (typeRapport != null ? typeRapport : "Général") + 
                        " - Période: " + 
                        (periode != null ? periode : "Non spécifiée");
        
        session.setAttribute("success", message);
        response.sendRedirect("Admin?page=rapports");
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