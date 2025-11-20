package controller;

import dao.impl.*;
import java.util.Map;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

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
        
        try {
            // Consulter les statistiques globales
            List<Utilisateur> allUsers = utilisateurDAO.findAll();
            List<Conducteur> allConducteurs = conducteurDAO.findAll();
            List<Passager> allPassagers = passagerDAO.findAll();
            List<Offre> allOffres = offreDAO.findAll();
            List<Reservation> allReservations = reservationDAO.findAll();
            
            int totalUtilisateurs = allUsers.size();
            int totalConducteurs = allConducteurs.size();
            int totalPassagers = allPassagers.size();
            int totalOffres = allOffres.size();
            int totalReservations = allReservations.size();
            
            // Debug logs
            System.out.println("=== STATISTIQUES DASHBOARD ===");
            System.out.println("Total Utilisateurs: " + totalUtilisateurs);
            System.out.println("Total Conducteurs: " + totalConducteurs);
            System.out.println("Total Passagers: " + totalPassagers);
            System.out.println("Total Offres: " + totalOffres);
            System.out.println("Total Réservations: " + totalReservations);
            
            // Offres en attente de validation
            List<Offre> offresEnAttente = offreDAO.findEnAttente();
            int offresEnAttenteCount = offresEnAttente.size();
            
            System.out.println("Offres en attente: " + offresEnAttenteCount);
            
            // Statistiques des offres par statut
            int offresActives = 0;
            int offresTerminees = 0;
            int offresAnnulees = 0;
            
            for (Offre offre : allOffres) {
                String statut = offre.getStatut();
                if ("VALIDEE".equals(statut)) {
                    offresActives++;
                } else if ("TERMINEE".equals(statut)) {
                    offresTerminees++;
                } else if ("ANNULEE".equals(statut)) {
                    offresAnnulees++;
                }
            }
            
            System.out.println("Offres actives: " + offresActives);
            System.out.println("Offres terminées: " + offresTerminees);
            System.out.println("Offres annulées: " + offresAnnulees);
            
            // Calculer le revenu total
            double revenuTotal = 0.0;
            for (Reservation res : allReservations) {
                String statut = res.getStatut();
                if ("CONFIRMEE".equals(statut) || "TERMINEE".equals(statut)) {
                    revenuTotal += res.getPrixTotal();
                }
            }
            
            System.out.println("Revenu total: " + revenuTotal + " DH");
            
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
            
            // Activités récentes (dernières 5 offres)
            List<Offre> dernieresOffres = allOffres.stream()
                .sorted((o1, o2) -> o2.getDatePublication().compareTo(o1.getDatePublication()))
                .limit(5)
                .collect(java.util.stream.Collectors.toList());
            
            request.setAttribute("dernieresOffres", dernieresOffres);
            
            System.out.println("Dernières offres: " + dernieresOffres.size());
            System.out.println("==============================\n");
            
            request.setAttribute("page", "dashboard");
            request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("ERREUR SQL dans afficherDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des statistiques: " + e.getMessage());
            request.setAttribute("page", "dashboard");
            request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
        }
    }
    
    private void afficherUtilisateurs(HttpServletRequest request, HttpServletResponse response, 
            Administrateur admin) throws ServletException, IOException, SQLException {
        
        List<Conducteur> conducteurs = conducteurDAO.findAll();
        List<Passager> passagers = passagerDAO.findAll();
        
        //Calculer et mettre à jour les notes moyennes depuis la base de données
        EvaluationDAOImpl evaluationDAO = new EvaluationDAOImpl(connection);
        
        for (Conducteur conducteur : conducteurs) {
            Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(conducteur.getIdUtilisateur());
            conducteur.setNoteMoyenne(noteMoyenne != null ? noteMoyenne : 0.0);
            
            // Debug
            System.out.println("Conducteur " + conducteur.getNom() + " - Note: " + noteMoyenne);
        }
        
        for (Passager passager : passagers) {
            Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(passager.getIdUtilisateur());
            passager.setNoteMoyenne(noteMoyenne != null ? noteMoyenne : 0.0);
            
            // Debug
            System.out.println("Passager " + passager.getNom() + " - Note: " + noteMoyenne);
            evaluationDAO.debugEvaluationsForPassager(passager.getIdUtilisateur());
        }
        
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
        
        try {
            // ===== RÉCUPÉRATION DES DONNÉES =====
            List<Offre> toutesOffres = offreDAO.findAll();
            List<Reservation> toutesReservations = reservationDAO.findAll();
            List<Utilisateur> tousUtilisateurs = utilisateurDAO.findAll();
            List<Conducteur> tousConducteurs = conducteurDAO.findAll();
            List<Passager> tousPassagers = passagerDAO.findAll();
            
            EvaluationDAOImpl evaluationDAO = new EvaluationDAOImpl(connection);
            List<Evaluation> toutesEvaluations = evaluationDAO.findAll();
            
            // ===== STATISTIQUES GÉNÉRALES =====
            request.setAttribute("totalOffres", toutesOffres.size());
            request.setAttribute("totalReservations", toutesReservations.size());
            request.setAttribute("totalUtilisateurs", tousUtilisateurs.size());
            request.setAttribute("totalConducteurs", tousConducteurs.size());
            request.setAttribute("totalPassagers", tousPassagers.size());
            
            // ===== STATISTIQUES OFFRES PAR STATUT =====
            int offresValidees = 0;
            int offresEnAttente = 0;
            int offresTerminees = 0;
            int offresAnnulees = 0;
            
            for (Offre offre : toutesOffres) {
                String statut = offre.getStatut();
                if ("VALIDEE".equals(statut)) offresValidees++;
                else if ("EN_ATTENTE".equals(statut)) offresEnAttente++;
                else if ("TERMINEE".equals(statut)) offresTerminees++;
                else if ("ANNULEE".equals(statut)) offresAnnulees++;
            }
            
            request.setAttribute("offresValidees", offresValidees);
            request.setAttribute("offresEnAttente", offresEnAttente);
            request.setAttribute("offresTerminees", offresTerminees);
            request.setAttribute("offresAnnulees", offresAnnulees);
            
            // ===== STATISTIQUES RÉSERVATIONS PAR STATUT =====
            int reservationsConfirmees = 0;
            int reservationsTerminees = 0;
            int reservationsAnnulees = 0;
            int reservationsEnAttente = 0;
            
            double revenuConfirme = 0.0;
            double revenuTermine = 0.0;
            double revenuTotal = 0.0;
            
            for (Reservation res : toutesReservations) {
                String statut = res.getStatut();
                double prix = res.getPrixTotal();
                
                if ("CONFIRMEE".equals(statut)) {
                    reservationsConfirmees++;
                    revenuConfirme += prix;
                    revenuTotal += prix;
                } else if ("TERMINEE".equals(statut)) {
                    reservationsTerminees++;
                    revenuTermine += prix;
                    revenuTotal += prix;
                } else if ("ANNULEE".equals(statut)) {
                    reservationsAnnulees++;
                } else if ("EN_ATTENTE".equals(statut)) {
                    reservationsEnAttente++;
                }
            }
            
            request.setAttribute("reservationsConfirmees", reservationsConfirmees);
            request.setAttribute("reservationsTerminees", reservationsTerminees);
            request.setAttribute("reservationsAnnulees", reservationsAnnulees);
            request.setAttribute("reservationsEnAttente", reservationsEnAttente);
            request.setAttribute("revenuConfirme", revenuConfirme);
            request.setAttribute("revenuTermine", revenuTermine);
            request.setAttribute("revenuTotal", revenuTotal);
            
            // ===== STATISTIQUES ÉVALUATIONS =====
            int totalEvaluations = toutesEvaluations.size();
            double satisfactionMoyenne = 0.0;
            int evaluations5etoiles = 0;
            int evaluations4etoiles = 0;
            int evaluations3etoiles = 0;
            int evaluations2etoiles = 0;
            int evaluations1etoile = 0;
            
            if (totalEvaluations > 0) {
                int sommeNotes = 0;
                for (Evaluation eval : toutesEvaluations) {
                    int note = eval.getNote();
                    sommeNotes += note;
                    
                    if (note == 5) evaluations5etoiles++;
                    else if (note == 4) evaluations4etoiles++;
                    else if (note == 3) evaluations3etoiles++;
                    else if (note == 2) evaluations2etoiles++;
                    else if (note == 1) evaluations1etoile++;
                }
                satisfactionMoyenne = (double) sommeNotes / totalEvaluations;
            }
            
            request.setAttribute("totalEvaluations", totalEvaluations);
            request.setAttribute("satisfactionMoyenne", satisfactionMoyenne);
            request.setAttribute("evaluations5etoiles", evaluations5etoiles);
            request.setAttribute("evaluations4etoiles", evaluations4etoiles);
            request.setAttribute("evaluations3etoiles", evaluations3etoiles);
            request.setAttribute("evaluations2etoiles", evaluations2etoiles);
            request.setAttribute("evaluations1etoile", evaluations1etoile);
            
            // ===== TAUX ET RATIOS =====
            double tauxReussite = toutesOffres.size() > 0 ? 
                (offresTerminees * 100.0 / toutesOffres.size()) : 0;
            double tauxAnnulation = toutesOffres.size() > 0 ? 
                (offresAnnulees * 100.0 / toutesOffres.size()) : 0;
            double tauxConversion = toutesOffres.size() > 0 ? 
                (toutesReservations.size() * 100.0 / toutesOffres.size()) : 0;
            double ratioPassagersConducteurs = tousConducteurs.size() > 0 ? 
                (double) tousPassagers.size() / tousConducteurs.size() : 0;
            
            request.setAttribute("tauxReussite", tauxReussite);
            request.setAttribute("tauxAnnulation", tauxAnnulation);
            request.setAttribute("tauxConversion", tauxConversion);
            request.setAttribute("ratioPassagersConducteurs", ratioPassagersConducteurs);
            
            // ===== STATISTIQUES TEMPORELLES (30 derniers jours) =====
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -30);
            Date il30Jours = cal.getTime();
            
            int offres30j = 0;
            int reservations30j = 0;
            int utilisateurs30j = 0;
            double revenus30j = 0.0;
            
            for (Offre offre : toutesOffres) {
                if (offre.getDatePublication() != null && 
                    offre.getDatePublication().after(il30Jours)) {
                    offres30j++;
                }
            }
            
            for (Reservation res : toutesReservations) {
                if (res.getDateReservation() != null && 
                    res.getDateReservation().after(il30Jours)) {
                    reservations30j++;
                    if ("CONFIRMEE".equals(res.getStatut()) || "TERMINEE".equals(res.getStatut())) {
                        revenus30j += res.getPrixTotal();
                    }
                }
            }
            
            for (Utilisateur user : tousUtilisateurs) {
                if (user.getDateInscription() != null && 
                    user.getDateInscription().after(il30Jours)) {
                    utilisateurs30j++;
                }
            }
            
            request.setAttribute("offres30j", offres30j);
            request.setAttribute("reservations30j", reservations30j);
            request.setAttribute("utilisateurs30j", utilisateurs30j);
            request.setAttribute("revenus30j", revenus30j);
            
            // ===== TOP CONDUCTEURS (par nombre de trajets terminés) =====
            Map<Long, Integer> trajetsParConducteur = new HashMap<>();
            for (Offre offre : toutesOffres) {
                if ("TERMINEE".equals(offre.getStatut())) {
                    trajetsParConducteur.put(offre.getIdConducteur(), 
                        trajetsParConducteur.getOrDefault(offre.getIdConducteur(), 0) + 1);
                }
            }
            
            List<Map.Entry<Long, Integer>> topConducteursEntries = 
                trajetsParConducteur.entrySet().stream()
                    .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                    .limit(5)
                    .collect(java.util.stream.Collectors.toList());
            
            List<Conducteur> topConducteurs = new ArrayList<>();
            for (Map.Entry<Long, Integer> entry : topConducteursEntries) {
                for (Conducteur c : tousConducteurs) {
                    if (c.getIdUtilisateur().equals(entry.getKey())) {
                        topConducteurs.add(c);
                        break;
                    }
                }
            }
            
            request.setAttribute("topConducteurs", topConducteurs);
            request.setAttribute("trajetsParConducteur", trajetsParConducteur);
            
            // ===== TOP TRAJETS (par nombre de réservations) =====
            Map<String, Integer> reservationsParTrajet = new HashMap<>();
            for (Reservation res : toutesReservations) {
                if (res.getOffre() != null) {
                    String trajet = res.getOffre().getVilleDepart() + " → " + 
                                   res.getOffre().getVilleArrivee();
                    reservationsParTrajet.put(trajet, 
                        reservationsParTrajet.getOrDefault(trajet, 0) + 1);
                }
            }
            
            List<Map.Entry<String, Integer>> topTrajets = 
                reservationsParTrajet.entrySet().stream()
                    .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                    .limit(5)
                    .collect(java.util.stream.Collectors.toList());
            
            request.setAttribute("topTrajets", topTrajets);
            
            // ===== MOYENNE DE PLACES PAR OFFRE =====
            double moyennePlacesDisponibles = 0.0;
            double moyennePlacesReservees = 0.0;
            
            if (toutesOffres.size() > 0) {
                int totalPlacesDisponibles = 0;
                int totalPlacesReservees = 0;
                
                for (Offre offre : toutesOffres) {
                    totalPlacesDisponibles += offre.getPlacesDisponibles();
                    totalPlacesReservees += (offre.getPlacesTotales() - offre.getPlacesDisponibles());
                }
                
                moyennePlacesDisponibles = (double) totalPlacesDisponibles / toutesOffres.size();
                moyennePlacesReservees = (double) totalPlacesReservees / toutesOffres.size();
            }
            
            request.setAttribute("moyennePlacesDisponibles", moyennePlacesDisponibles);
            request.setAttribute("moyennePlacesReservees", moyennePlacesReservees);
            
            // ===== REVENU MOYEN PAR RÉSERVATION =====
            double revenuMoyenParReservation = toutesReservations.size() > 0 ? 
                revenuTotal / toutesReservations.size() : 0;
            
            request.setAttribute("revenuMoyenParReservation", revenuMoyenParReservation);
            
            // Debug
            System.out.println("=== RAPPORT STATISTIQUES ===");
            System.out.println("Offres: " + toutesOffres.size() + " | Terminées: " + offresTerminees);
            System.out.println("Réservations: " + toutesReservations.size() + " | Confirmées: " + reservationsConfirmees);
            System.out.println("Revenu total: " + revenuTotal + " DH");
            System.out.println("Satisfaction moyenne: " + String.format("%.2f", satisfactionMoyenne) + "/5");
            System.out.println("Taux de conversion: " + String.format("%.1f", tauxConversion) + "%");
            System.out.println("============================\n");
            
            request.setAttribute("page", "rapports");
            request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("ERREUR SQL dans afficherRapports: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la génération du rapport: " + e.getMessage());
            request.setAttribute("page", "rapports");
            request.getRequestDispatcher("dashboardAdmin.jsp").forward(request, response);
        }
    }

    
    
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
                    session.setAttribute("success", "Utilisateur bloqué avec succès");
                } else {
                    session.setAttribute("error", "Utilisateur introuvable");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }
        } else {
            session.setAttribute("error", "Aucun utilisateur spécifié");
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
                
                boolean success = offreDAO.updateStatut(offreId, "VALIDEE");
                
                if (success) {
                    session.setAttribute("success", " Offre #" + offreId + " validée avec succès");
                } else {
                    session.setAttribute("error", " Impossible de valider l'offre #" + offreId);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", " ID d'offre invalide");
            }
        } else {
            session.setAttribute("error", " Aucune offre spécifiée");
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
                
                
                boolean success = offreDAO.updateStatut(offreId, "ANNULEE");
                
                if (success) {
                    String message = " Offre #" + offreId + " rejetée";
                    if (motif != null && !motif.trim().isEmpty()) {
                        message += " - Motif: " + motif;
                    }
                    session.setAttribute("success", message);
                } else {
                    session.setAttribute("error", " Impossible de rejeter l'offre #" + offreId);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID d'offre invalide");
            }
        } else {
            session.setAttribute("error", "Aucune offre spécifiée");
        }
        
        response.sendRedirect("Admin?page=validation");
    }
    
    private void genererRapport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String typeRapport = request.getParameter("typeRapport");
        String periode = request.getParameter("periode");
        HttpSession session = request.getSession();
        
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