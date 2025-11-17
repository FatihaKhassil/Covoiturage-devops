package controller;

import models.Passager;
import models.Evaluation;
import models.Offre;
import models.Reservation;
import dao.EvaluationDAO;
import dao.OffreDAO;
import dao.ReservationDAO;
import dao.PassagerDAO;
import dao.impl.EvaluationDAOImpl;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import Covoiturage.dao.factory.Factory;
import java.util.ArrayList;

@WebServlet("/Passager")
public class PassagerServlet extends HttpServlet {
    
    private OffreDAO offreDAO;
    private ReservationDAO reservationDAO;
    private PassagerDAO passagerDAO;
    private EvaluationDAO evaluationDAO; 

    
    @Override
    public void init() throws ServletException {
        try {
            Connection connection = Factory.dbConnect();
            this.offreDAO = new OffreDAOImpl(connection);
            this.reservationDAO = new ReservationDAOImpl(connection);
            this.passagerDAO = new PassagerDAOImpl(connection);
            this.evaluationDAO = new EvaluationDAOImpl(connection); // ✅ Initialiser

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
            case "evaluerConducteur":
                evaluerConducteur(request, response);
                break;
            case "evaluations":
                afficherEvaluations(request, response, passager);
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
            case "evaluerConducteur": // ← AJOUTER CETTE LIGNE
                evaluerConducteur(request, response); // ← AJOUTER CETTE LIGNE
                break; // ← AJOUTER CETTE LIGNE
            default:
                response.sendRedirect("Passager?page=dashboard");
                break;
        }
    }
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, 
            Passager passager) throws ServletException, IOException {
try {
Long passagerId = passager.getId();

if (passagerId == null) {
request.setAttribute("error", "Erreur: ID passager non trouvé");
request.setAttribute("totalReservations", 0);
request.setAttribute("reservationsEnAttente", 0);
request.setAttribute("reservationsConfirmees", 0);
request.setAttribute("reservationsTerminees", 0);
request.setAttribute("reservationsAnnulees", 0);
request.setAttribute("offresDisponibles", 0);
} else {
// Récupérer toutes les réservations du passager
List<Reservation> reservations = reservationDAO.findByPassager(passagerId);

// ✅ Calculer les statistiques pour chaque statut
int totalReservations = reservations.size();
int reservationsEnAttente = 0;
int reservationsConfirmees = 0;
int reservationsTerminees = 0;
int reservationsAnnulees = 0;

for (Reservation res : reservations) {
String statut = res.getStatut();

if ("EN_ATTENTE".equals(statut)) {
 reservationsEnAttente++;
} else if ("CONFIRMEE".equals(statut)) {
 reservationsConfirmees++;
} else if ("TERMINEE".equals(statut)) {
 reservationsTerminees++;
} else if ("ANNULEE".equals(statut)) {
 reservationsAnnulees++;
}
}

// Récupérer les offres disponibles
List<Offre> offresDisponibles = offreDAO.findValidee();
int nbOffresDisponibles = offresDisponibles.size();

// Récupérer les 5 dernières réservations pour l'activité récente
List<Reservation> dernieresReservations = reservations.stream()
.sorted((r1, r2) -> r2.getDateReservation().compareTo(r1.getDateReservation()))
.limit(5)
.collect(Collectors.toList());

// ✅ Passer TOUS les statuts à la JSP
request.setAttribute("totalReservations", totalReservations);
request.setAttribute("reservationsEnAttente", reservationsEnAttente);
request.setAttribute("reservationsConfirmees", reservationsConfirmees);
request.setAttribute("reservationsTerminees", reservationsTerminees);
request.setAttribute("reservationsAnnulees", reservationsAnnulees);
request.setAttribute("offresDisponibles", nbOffresDisponibles);
request.setAttribute("dernieresReservations", dernieresReservations);

// Debug
System.out.println("=== DASHBOARD STATS ===");
System.out.println("Total: " + totalReservations);
System.out.println("En attente: " + reservationsEnAttente);
System.out.println("Confirmées: " + reservationsConfirmees);
System.out.println("Terminées: " + reservationsTerminees);
System.out.println("Annulées: " + reservationsAnnulees);
}
} catch (Exception e) {
e.printStackTrace();
request.setAttribute("error", "Erreur lors du chargement des statistiques: " + e.getMessage());
request.setAttribute("totalReservations", 0);
request.setAttribute("reservationsEnAttente", 0);
request.setAttribute("reservationsConfirmees", 0);
request.setAttribute("reservationsTerminees", 0);
request.setAttribute("reservationsAnnulees", 0);
request.setAttribute("offresDisponibles", 0);
}

request.setAttribute("page", "dashboard");
request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
}
    private void afficherRechercher(HttpServletRequest request, HttpServletResponse response, 
                                    Passager passager) throws ServletException, IOException {
        try {
            // Récupérer toutes les offres disponibles
            List<Offre> offres = offreDAO.findValidee();
            
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
    private void afficherHistorique(HttpServletRequest request, HttpServletResponse response, 
            Passager passager) throws ServletException, IOException {
        try {
            Long passagerId = passager.getId();

            if (passagerId == null) {
                request.setAttribute("error", "Erreur: ID passager non trouvé");
                request.setAttribute("reservations", new ArrayList<>());
            } else {
                List<Reservation> reservations = reservationDAO.findByPassager(passagerId);

                List<Reservation> historiqueReservations = reservations.stream()
                    .filter(r -> "TERMINEE".equals(r.getStatut()) || "ANNULEE".equals(r.getStatut()))
                    .sorted((r1, r2) -> r2.getDateReservation().compareTo(r1.getDateReservation()))
                    .collect(Collectors.toList());

                request.setAttribute("reservations", historiqueReservations);

                int nbTerminees = (int) historiqueReservations.stream()
                    .filter(r -> "TERMINEE".equals(r.getStatut()))
                    .count();
                int nbAnnulees = (int) historiqueReservations.stream()
                    .filter(r -> "ANNULEE".equals(r.getStatut()))
                    .count();

                request.setAttribute("nbTerminees", nbTerminees);
                request.setAttribute("nbAnnulees", nbAnnulees);
                request.setAttribute("totalHistorique", historiqueReservations.size());
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de l'historique: " + e.getMessage());
            request.setAttribute("reservations", new ArrayList<>());
        }

        request.setAttribute("page", "historique");
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
                
                // ✅ FILTRER : Seulement EN_ATTENTE et CONFIRMEE
                List<Reservation> reservationsActives = reservations.stream()
                    .filter(r -> "EN_ATTENTE".equals(r.getStatut()) || "CONFIRMEE".equals(r.getStatut()))
                    .collect(Collectors.toList());
                
                request.setAttribute("reservations", reservationsActives);

                // Calculer les statistiques seulement pour les réservations actives
                int enAttente = 0, confirmees = 0;
                for (Reservation res : reservationsActives) {
                    String statut = res.getStatut();
                    if ("EN_ATTENTE".equals(statut)) enAttente++;
                    else if ("CONFIRMEE".equals(statut)) confirmees++;
                }

                request.setAttribute("nbEnAttente", enAttente);
                request.setAttribute("nbConfirmees", confirmees);
                request.setAttribute("totalReservations", reservationsActives.size());
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des réservations: " + e.getMessage());
            request.setAttribute("reservations", new java.util.ArrayList<>());
        }

        request.setAttribute("page", "reservations");
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
            
            // Vérifier que l'offre est validée
            if (!"VALIDEE".equals(offre.getStatut())) {
                session.setAttribute("error", "Cette offre n'est pas disponible pour réservation");
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
            
            // Créer la réservation avec statut EN_ATTENTE
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
            
            if (reservationId != null) {
                // NE PAS mettre à jour les places maintenant - seulement quand confirmée
                session.setAttribute("success", "✅ Demande de réservation envoyée ! En attente de confirmation du passager.");
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
    private void afficherEvaluations(HttpServletRequest request, HttpServletResponse response, 
            Passager passager) throws ServletException, IOException {
        try {
            Long passagerId = passager.getId();
            if (passagerId == null) {
                request.setAttribute("error", "Erreur: ID passager non trouvé");
            } else {
                List<Evaluation> evaluations = evaluationDAO.findByEvalue(passagerId);
                int totalEvaluations = evaluationDAO.countEvaluationsByEvalue(passagerId);
                Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(passagerId);

                // Distribution des notes
                int[] distributionNotes = new int[6];
                for (Evaluation eval : evaluations) {
                    Integer note = eval.getNote();
                    if (note != null && note >= 1 && note <= 5) {
                        distributionNotes[note]++;
                    }
                }

                request.setAttribute("evaluations", evaluations);
                request.setAttribute("totalEvaluations", totalEvaluations);
                request.setAttribute("noteMoyenne", noteMoyenne != null ? noteMoyenne : 0.0);
                request.setAttribute("distributionNotes", distributionNotes);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des évaluations");
        }
        
        // Valeurs par défaut
        if (request.getAttribute("evaluations") == null) {
            request.setAttribute("evaluations", new ArrayList<>());
            request.setAttribute("totalEvaluations", 0);
            request.setAttribute("noteMoyenne", 0.0);
            request.setAttribute("distributionNotes", new int[6]);
        }
        
        request.setAttribute("page", "evaluations");
        request.getRequestDispatcher("dashboardPassager.jsp").forward(request, response);
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
                    String statutActuel = reservation.getStatut();
                    
                    // Annuler la réservation
                    boolean success = reservationDAO.updateStatut(reservationId, "ANNULEE");
                    
                    if (success) {
                        // ✅ Remettre les places SEULEMENT si la réservation était CONFIRMEE
                        if ("CONFIRMEE".equals(statutActuel)) {
                            Offre offre = reservation.getOffre();
                            Integer nouvellePlaces = offre.getPlacesDisponibles() + reservation.getNombrePlaces();
                            offreDAO.updatePlacesDisponibles(offre.getIdOffre(), nouvellePlaces);
                        }
                        // Si EN_ATTENTE, pas besoin de remettre les places
                        
                        HttpSession session = request.getSession();
                        session.setAttribute("success", "✅ Réservation annulée avec succès!");
                    } else {
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "❌ Erreur lors de l'annulation");
                    }
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "❌ Cette réservation ne peut pas être annulée");
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
 // Dans PassagerServlet - Ajouter cette méthode
 // Dans la méthode evaluerConducteur - Remplacer cette partie
    private void evaluerConducteur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Passager passager = (Passager) session.getAttribute("utilisateur");
        
        try {
            String reservationIdStr = request.getParameter("reservationId");
            String idConducteurStr = request.getParameter("idConducteur");
            String noteStr = request.getParameter("note");
            String commentaire = request.getParameter("commentaire");
            
            // Validation des paramètres
            if (reservationIdStr == null || reservationIdStr.isEmpty() || 
                idConducteurStr == null || idConducteurStr.isEmpty() || 
                noteStr == null || noteStr.isEmpty()) {
                session.setAttribute("error", "Données d'évaluation incomplètes");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            Long reservationId = Long.parseLong(reservationIdStr);
            Long idConducteur = Long.parseLong(idConducteurStr);
            Integer note = Integer.parseInt(noteStr);
            
            // Validation de la note
            if (note < 1 || note > 5) {
                session.setAttribute("error", "La note doit être comprise entre 1 et 5 étoiles");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            // Récupération de la réservation
            Reservation reservation = reservationDAO.findById(reservationId);
            if (reservation == null) {
                session.setAttribute("error", "Réservation non trouvée");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            // Vérification des permissions
            if (!reservation.getPassager().getId().equals(passager.getId())) {
                session.setAttribute("error", "Vous n'êtes pas autorisé à évaluer cette réservation");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            // Vérification si le trajet est terminé
            if (!"TERMINEE".equals(reservation.getStatut())) {
                session.setAttribute("error", "Vous ne pouvez évaluer que les trajets terminés");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            // ✅ VÉRIFICATION CRITIQUE : Vérifier si déjà évalué
            boolean dejaEvalue = evaluationDAO.existsForOffre(
                reservation.getOffre().getIdOffre(), 
                passager.getId(), 
                idConducteur
            );
            
            System.out.println("DEBUG - Déjà évalué: " + dejaEvalue + 
                             ", Offre: " + reservation.getOffre().getIdOffre() +
                             ", Evaluateur: " + passager.getId() +
                             ", Conducteur: " + idConducteur);
            
            if (dejaEvalue) {
                session.setAttribute("error", "Vous avez déjà évalué ce conducteur pour ce trajet");
                response.sendRedirect("Passager?page=historique");
                return;
            }
            
            // Création de l'évaluation
            Evaluation evaluation = new Evaluation();
            evaluation.setIdOffre(reservation.getOffre().getIdOffre());
            evaluation.setIdEvaluateur(passager.getId());
            evaluation.setIdEvalue(idConducteur);
            evaluation.setNote(note);
            evaluation.setCommentaire(commentaire != null ? commentaire.trim() : null);
            evaluation.setDateEvaluation(new Date());
            evaluation.setTypeEvaluateur("passager");
            
            // Enregistrement de l'évaluation
            Long evaluationId = evaluationDAO.create(evaluation);
            
            if (evaluationId != null && evaluationId > 0) {
                session.setAttribute("success", "Évaluation envoyée avec succès ! Merci pour votre retour.");
                
                // Mettre à jour le statut "déjà évalué" dans la réservation
                try {
                    reservation.setEstEvalue(true);
                    reservation.setEvaluation(evaluation);
                    // Vous pouvez aussi mettre à jour en base si nécessaire
                } catch (Exception e) {
                    System.err.println("Warning: Impossible de mettre à jour le statut d'évaluation");
                }
                
            } else {
                session.setAttribute("error", "Une erreur est survenue lors de l'enregistrement de l'évaluation");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Format de données invalide");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Une erreur technique est survenue");
        }
        
        response.sendRedirect("Passager?page=historique");
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