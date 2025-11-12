package controller;

import models.Passager;
import models.Offre;
import models.Reservation;
import dao.OffreDAO;
import dao.ReservationDAO;
import dao.PassagerDAO;
import dao.impl.OffreDAOImpl;
import dao.impl.ReservationDAOImpl;
import dao.impl.PassagerDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import Covoiturage.dao.factory.Factory;

@WebServlet("/Passager")
public class PassagerServlet extends HttpServlet {
    
    private OffreDAO offreDAO;
    private ReservationDAO reservationDAO;
    private PassagerDAO passagerDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            Connection connection = Factory.dbConnect();
            this.offreDAO = new OffreDAOImpl(connection);
            this.reservationDAO = new ReservationDAOImpl(connection);
            this.passagerDAO = new PassagerDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Impossible de se connecter à la base de données", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null || 
            !"passager".equals(session.getAttribute("typeUtilisateur"))) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        Passager passager = (Passager) session.getAttribute("utilisateur");
        String page = request.getParameter("page");
        
        if (page == null || page.isEmpty()) {
            page = "dashboard";
        }
        
        switch (page) {
            case "dashboard":
                afficherDashboard(request, response, passager);
                break;
            case "rechercher":
                afficherRechercher(request, response, passager);
                break;
            case "reservations":
                afficherReservations(request, response, passager);
                break;
            case "historique":
                afficherHistorique(request, response, passager);
                break;
            case "profil":
                afficherProfil(request, response, passager);
                break;
            default:
                response.sendRedirect("Passager?page=dashboard");
                break;
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
            response.sendRedirect("Passager?page=dashboard");
            return;
        }
        
        switch (action) {
            case "reserver":
                reserverTrajet(request, response);
                break;
            case "annulerReservation":
                annulerReservation(request, response);
                break;
            case "updateProfil":
                updateProfil(request, response);
                break;
            case "updateMotDePasse":
                updateMotDePasse(request, response);
                break;
            default:
                response.sendRedirect("Passager?page=dashboard");
                break;
        }
    }
    
    // ========== Méthodes d'affichage ==========
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, 
                                   Passager passager) throws ServletException, IOException {
        try {
            Long passagerId = passager.getId();
            
            if (passagerId == null) {
                request.setAttribute("error", "Erreur: ID passager non trouvé");
                request.setAttribute("totalReservations", 0);
                request.setAttribute("reservationsActives", 0);
                request.setAttribute("reservationsTerminees", 0);
                request.setAttribute("offresDisponibles", 0);
            } else {
                // Récupérer toutes les réservations du passager
                List<Reservation> reservations = reservationDAO.findByPassager(passagerId);
                
                // Calculer les statistiques
                int totalReservations = reservations.size();
                int reservationsActives = 0;
                int reservationsTerminees = 0;
                int reservationsAnnulees = 0;
                
                for (Reservation res : reservations) {
                    String statut = res.getStatut();
                    if ("CONFIRMEE".equals(statut)) {
                        reservationsActives++;
                    } else if ("TERMINEE".equals(statut)) {
                        reservationsTerminees++;
                    } else if ("ANNULEE".equals(statut)) {
                        reservationsAnnulees++;
                    }
                }
                
                // Récupérer les offres disponibles
                List<Offre> offresDisponibles = offreDAO.findEnAttente();
                int nbOffresDisponibles = offresDisponibles.size();
                
                // Récupérer les dernières réservations pour l'activité récente
                List<Reservation> dernieresReservations = reservations.stream()
                    .sorted((r1, r2) -> r2.getDateReservation().compareTo(r1.getDateReservation()))
                    .limit(5)
                    .collect(Collectors.toList());
                
                // Passer les données à la JSP
                request.setAttribute("totalReservations", totalReservations);
                request.setAttribute("reservationsActives", reservationsActives);
                request.setAttribute("reservationsTerminees", reservationsTerminees);
                request.setAttribute("reservationsAnnulees", reservationsAnnulees);
                request.setAttribute("offresDisponibles", nbOffresDisponibles);
                request.setAttribute("dernieresReservations", dernieresReservations);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des statistiques: " + e.getMessage());
            request.setAttribute("totalReservations", 0);
            request.setAttribute("reservationsActives", 0);
            request.setAttribute("reservationsTerminees", 0);
            request.setAttribute("offresDisponibles", 0);
        }
        
        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
    }
    
    private void afficherRechercher(HttpServletRequest request, HttpServletResponse response, 
                                    Passager passager) throws ServletException, IOException {
        try {
            // Récupérer toutes les offres disponibles
            List<Offre> offres = offreDAO.findEnAttente();
            
            // Filtrage (si des paramètres de recherche sont fournis)
            String villeDepart = request.getParameter("villeDepart");
            String villeArrivee = request.getParameter("villeArrivee");
            String dateDepart = request.getParameter("dateDepart");
            
            if (villeDepart != null && !villeDepart.isEmpty()) {
                offres = offres.stream()
                    .filter(o -> o.getVilleDepart().equalsIgnoreCase(villeDepart))
                    .collect(Collectors.toList());
            }
            
            if (villeArrivee != null && !villeArrivee.isEmpty()) {
                offres = offres.stream()
                    .filter(o -> o.getVilleArrivee().equalsIgnoreCase(villeArrivee))
                    .collect(Collectors.toList());
            }
            
            if (dateDepart != null && !dateDepart.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date searchDate = sdf.parse(dateDepart);
                offres = offres.stream()
                    .filter(o -> {
                        String offreDate = sdf.format(o.getDateDepart());
                        String searchDateStr = sdf.format(searchDate);
                        return offreDate.equals(searchDateStr);
                    })
                    .collect(Collectors.toList());
            }
            
            request.setAttribute("offres", offres);
            request.setAttribute("villeDepart", villeDepart);
            request.setAttribute("villeArrivee", villeArrivee);
            request.setAttribute("dateDepart", dateDepart);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la recherche: " + e.getMessage());
            request.setAttribute("offres", new java.util.ArrayList<>());
        }
        
        request.setAttribute("page", "rechercher");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
    }
    
    private void afficherReservations(HttpServletRequest request, HttpServletResponse response, 
                                      Passager passager) throws ServletException, IOException {
        try {
            Long passagerId = passager.getId();
            
            if (passagerId == null) {
                request.setAttribute("error", "Erreur: ID passager non trouvé");
                request.setAttribute("reservations", new java.util.ArrayList<>());
            } else {
                List<Reservation> reservations = reservationDAO.findByPassager(passagerId);
                request.setAttribute("reservations", reservations);
                
                // Calculer les statistiques
                int confirmees = 0, annulees = 0, terminees = 0;
                for (Reservation res : reservations) {
                    String statut = res.getStatut();
                    if ("CONFIRMEE".equals(statut)) confirmees++;
                    else if ("ANNULEE".equals(statut)) annulees++;
                    else if ("TERMINEE".equals(statut)) terminees++;
                }
                
                request.setAttribute("nbConfirmees", confirmees);
                request.setAttribute("nbAnnulees", annulees);
                request.setAttribute("nbTerminees", terminees);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des réservations: " + e.getMessage());
            request.setAttribute("reservations", new java.util.ArrayList<>());
        }
        
        request.setAttribute("page", "reservations");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
    }
    
    private void afficherHistorique(HttpServletRequest request, HttpServletResponse response, 
                                    Passager passager) throws ServletException, IOException {
        try {
            Long passagerId = passager.getId();
            
            if (passagerId == null) {
                request.setAttribute("error", "Erreur: ID passager non trouvé");
                request.setAttribute("historiqueReservations", new java.util.ArrayList<>());
            } else {
                // Récupérer seulement les réservations terminées
                List<Reservation> reservations = reservationDAO.findByPassager(passagerId);
                List<Reservation> historique = reservations.stream()
                    .filter(r -> "TERMINEE".equals(r.getStatut()))
                    .sorted((r1, r2) -> r2.getDateReservation().compareTo(r1.getDateReservation()))
                    .collect(Collectors.toList());
                
                request.setAttribute("historiqueReservations", historique);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de l'historique: " + e.getMessage());
            request.setAttribute("historiqueReservations", new java.util.ArrayList<>());
        }
        
        request.setAttribute("page", "historique");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
    }
    
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response, 
                                Passager passager) throws ServletException, IOException {
        request.setAttribute("page", "profil");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
    }
    
    // ========== Méthodes d'action POST ==========
    
    private void reserverTrajet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Passager passager = (Passager) session.getAttribute("utilisateur");
        
        try {
            Long passagerId = passager.getId();
            if (passagerId == null) {
                session.setAttribute("error", "Erreur: Impossible de récupérer l'ID du passager");
                response.sendRedirect("Passager?page=rechercher");
                return;
            }
            
            // Récupérer les données du formulaire
            String offreIdStr = request.getParameter("offreId");
            String nombrePlacesStr = request.getParameter("nombrePlaces");
            String messagePassager = request.getParameter("message");
            
            if (offreIdStr == null || offreIdStr.isEmpty() || 
                nombrePlacesStr == null || nombrePlacesStr.isEmpty()) {
                session.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                response.sendRedirect("Passager?page=rechercher");
                return;
            }
            
            Long offreId = Long.parseLong(offreIdStr);
            Integer nombrePlaces = Integer.parseInt(nombrePlacesStr);
            
            // Récupérer l'offre
            Offre offre = offreDAO.findById(offreId);
            
            if (offre == null) {
                session.setAttribute("error", "Offre introuvable");
                response.sendRedirect("Passager?page=rechercher");
                return;
            }
            
            // Vérifier la disponibilité
            if (!offre.verifierDisponibilite(nombrePlaces)) {
                session.setAttribute("error", "Pas assez de places disponibles");
                response.sendRedirect("Passager?page=rechercher");
                return;
            }
            
            // Calculer le prix total
            Double prixTotal = offre.getPrixParPlace() * nombrePlaces;
            
            // Créer la réservation
            Reservation reservation = new Reservation();
            reservation.setOffre(offre);
            reservation.setPassager(passager);
            reservation.setNombrePlaces(nombrePlaces);
            reservation.setPrixTotal(prixTotal);
            reservation.setStatut("EN_ATTENTE");
            reservation.setDateReservation(new Date());
            reservation.setMessagePassager(messagePassager);
            
            // Sauvegarder la réservation
            Long reservationId = reservationDAO.create(reservation);
            // ///////////////////////////////////////////////////////
            /////////////////////////////////////////////////////
            ////////////////////////////////////
            ///
            ///
            
            if (reservationId != null) {
                // Mettre à jour les places disponibles
                offre.mettreAJourPlaces(nombrePlaces);
                offreDAO.update(offre);
                
                session.setAttribute("success", "Réservation effectuée avec succès!");
                response.sendRedirect("Passager?page=reservations");
            } else {
                session.setAttribute("error", "Erreur lors de la réservation");
                response.sendRedirect("Passager?page=rechercher");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect("Passager?page=rechercher");
        }
    }
    
    private void annulerReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Récupérer la réservation
                Reservation reservation = reservationDAO.findById(reservationId);
                
                if (reservation != null && reservation.peutEtreAnnulee()) {
                    // Annuler la réservation
                    boolean success = reservationDAO.updateStatut(reservationId, "ANNULEE");
                    
                    if (success) {
                        // Remettre les places disponibles
                        Offre offre = reservation.getOffre();
                        Integer nouvellePlaces = offre.getPlacesDisponibles() + reservation.getNombrePlaces();
                        offreDAO.updatePlacesDisponibles(offre.getIdOffre(), nouvellePlaces);
                        
                        HttpSession session = request.getSession();
                        session.setAttribute("success", "Réservation annulée avec succès!");
                    } else {
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "Erreur lors de l'annulation");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Passager?page=reservations");
    }
    
    private void updateProfil(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Récupérer l'utilisateur en session
        Passager passager = (Passager) request.getSession().getAttribute("utilisateur");
        
        // Vérification de sécurité
        if (passager == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        // 2. Récupérer les données du formulaire
        String nouveauNom = request.getParameter("nom");
        String nouveauPrenom = request.getParameter("prenom");
        String nouvelEmail = request.getParameter("email");
        String nouveauTelephone = request.getParameter("telephone");

        // 3. Mettre à jour l'objet en mémoire (très important !)
        passager.setNom(nouveauNom);
        passager.setPrenom(nouveauPrenom);
        passager.setEmail(nouvelEmail);
        passager.setTelephone(nouveauTelephone);
        
        try {
            // 4. Persister en Base de Données
            // NOTE: Votre DAO update() gère la mise à jour des champs Utilisateur et passager
            passagerDAO.update(passager); 
            
            // 5. Mettre à jour la session avec le nouvel objet
            request.getSession().setAttribute("utilisateur", passager);
            
            // 6. Redirection succès
            response.sendRedirect("passager?page=profil&success=true");
            
        } catch (SQLException e) {
            // Gérer les erreurs (ex: email déjà utilisé, contrainte unique violée)
            request.setAttribute("error", "Erreur lors de la mise à jour : " + e.getMessage());
            response.sendRedirect("passager?page=profil&error=true");
        }
    }
    
    private void updateMotDePasse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Passager passager = (Passager) request.getSession().getAttribute("utilisateur");
        if (passager == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        // Récupérer les mots de passe
        String ancienMotDePasseForm = request.getParameter("ancienMotDePasse");
        String nouveauMotDePasse = request.getParameter("nouveauMotDePasse");
        String confirmerMotDePasse = request.getParameter("confirmerMotDePasse");

        // 1. Vérification côté serveur (Sécurité)
        if (!nouveauMotDePasse.equals(confirmerMotDePasse)) {
            // Les mots de passe ne correspondent pas
            response.sendRedirect("Passager?page=profil&error=true&msg=Les mots de passe ne correspondent pas.");
            return;
        }
        
        // 2. Vérifier l'ancien mot de passe (vous aurez besoin d'une méthode de hachage/vérification)
        // NOTE: C'est un point critique de sécurité. Assurez-vous d'utiliser un hachage (ex: BCrypt)
        // Supposons ici que vous avez une méthode 'checkPassword' dans votre UtilisateurDAO.
        // Pour l'exemple, nous allons utiliser le mot de passe clair si vous ne le hachez pas
        if (!passager.getMotDePasse().equals(ancienMotDePasseForm)) {
            response.sendRedirect("Passager?page=profil&error=true&msg=Ancien mot de passe incorrect.");
            return;
        }
        
        // 3. Mettre à jour l'objet et la BD
        passager.setMotDePasse(nouveauMotDePasse); // Assurez-vous de HACHER ce mot de passe avant la BD!
        
        try {
            // Vous aurez besoin d'une méthode spécifique dans UtilisateurDAO pour mettre à jour UNIQUEMENT le mot de passe
            // utilisateurDAO.updateMotDePasse(passager.getIdUtilisateur(), nouveauMotDePasse); 
            passagerDAO.update(passager); // Si update() gère aussi le mot de passe
            
            // Mettre à jour la session
            request.getSession().setAttribute("utilisateur", passager); 
            
            // Redirection succès
            response.sendRedirect("Passager?page=profil&success=true&msg=Mot de passe changé.");
            
        } catch (SQLException e) {
            response.sendRedirect("Passager?page=profil&error=true&msg=Erreur de BD.");
        }
    }
}