package controller;

import models.*;
import dao.OffreDAO;
import dao.ReservationDAO;
import dao.EvaluationDAO;
import dao.ConducteurDAO;
import dao.impl.OffreDAOImpl;
import dao.impl.ReservationDAOImpl;
import dao.impl.EvaluationDAOImpl;
import dao.impl.ConducteurDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import Covoiturage.dao.factory.Factory;

@WebServlet("/Conducteur")
public class ConducteurServlet extends HttpServlet {
    
    private OffreDAO offreDAO;
    private EvaluationDAO evaluationDAO;
    private ReservationDAO reservationDAO;
    private ConducteurDAO conducteurDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            Connection connection = Factory.dbConnect();
            this.offreDAO = new OffreDAOImpl(connection);
            this.evaluationDAO = new EvaluationDAOImpl(connection);
            this.reservationDAO = new ReservationDAOImpl(connection);
            this.conducteurDAO = new ConducteurDAOImpl(connection);
        } catch (Exception e) {
            throw new ServletException("Impossible de se connecter à la base de données", e);
        }
    }    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null || 
            !"conducteur".equals(session.getAttribute("typeUtilisateur"))) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
        String page = request.getParameter("page");
        
        if (page == null || page.isEmpty()) {
            page = "dashboard";
        }
        
        switch (page) {
            case "dashboard":
                afficherDashboard(request, response, conducteur);
                break;
            case "offres":
                afficherOffres(request, response, conducteur);
                break;
            case "publier":
                afficherFormPublier(request, response, conducteur);
                break;
            case "demandes":
                afficherDemandes(request, response, conducteur);
                break;
            case "evaluations":
                afficherEvaluations(request, response, conducteur);
                break;
            case "profil":
                afficherProfil(request, response, conducteur);
                break;
            default:
                response.sendRedirect("Conducteur?page=dashboard");
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
            response.sendRedirect("Conducteur?page=dashboard");
            return;
        }
        
        switch (action) {
            case "publierOffre":
                publierOffre(request, response);
                break;
            case "annulerOffre":
                annulerOffre(request, response);
                break;
            case "marquerEffectuee":
                marquerEffectuee(request, response);
                break;
            case "confirmerReservation":
                confirmerReservation(request, response);
                break;
            case "refuserReservation":
                refuserReservation(request, response);
                break;
            case "updateProfil":
                updateProfil(request, response);
                break;
            case "updateVehicule":
                updateVehicule(request, response);
                break;
            case "updateMotDePasse":
                updateMotDePasse(request, response);
                break;
            default:
                response.sendRedirect("Conducteur?page=dashboard");
                break;
        }
    }
    
    // ========== Méthodes d'affichage ==========
    
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, 
            Conducteur conducteur) throws ServletException, IOException {
try {
Long conducteurId = conducteur.getId();

if (conducteurId == null) {
request.setAttribute("error", "Erreur: ID conducteur non trouvé");
request.setAttribute("totalOffres", 0);
request.setAttribute("offresActives", 0);
request.setAttribute("totalReservations", 0);
request.setAttribute("demandesEnAttente", 0);
} else {
// Récupérer toutes les offres du conducteur
List<Offre> offres = offreDAO.findByConducteur(conducteurId);

// Calculer les statistiques
int totalOffres = offres.size();
int offresActives = 0;
int offresCompletes = 0;
int offresTerminees = 0;

for (Offre offre : offres) {
String statut = offre.getStatut();
if ("EN_ATTENTE".equals(statut)) {
 if (offre.getPlacesDisponibles() > 0) {
     offresActives++;
 } else {
     offresCompletes++;
 }
} else if ("TERMINEE".equals(statut)) {
 offresTerminees++;
}
}

// TODO: Récupérer les réservations depuis la base de données quand ReservationDAO sera disponible
int totalReservations = 0;
int demandesEnAttente = 0;

// Si vous avez déjà un ReservationDAO, décommentez ces lignes:
// List<Reservation> reservations = ReservationDAO.findByConducteur(conducteurId);
// totalReservations = reservations.size();
// for (Reservation res : reservations) {
//     if ("EN_ATTENTE".equals(res.getStatut())) {
//         demandesEnAttente++;
//     }
// }

// Passer les données à la JSP
request.setAttribute("totalOffres", totalOffres);
request.setAttribute("offresActives", offresActives);
request.setAttribute("offresCompletes", offresCompletes);
request.setAttribute("offresTerminees", offresTerminees);
request.setAttribute("totalReservations", totalReservations);
request.setAttribute("demandesEnAttente", demandesEnAttente);

// Récupérer les dernières offres pour l'activité récente
List<Offre> dernieresOffres = new ArrayList<>();
if (offres.size() > 0) {
// Trier par date de publication décroissante et prendre les 5 dernières
dernieresOffres = offres.stream()
 .sorted((o1, o2) -> o2.getDatePublication().compareTo(o1.getDatePublication()))
 .limit(5)
 .collect(java.util.stream.Collectors.toList());
}
request.setAttribute("dernieresOffres", dernieresOffres);
}
} catch (Exception e) {
e.printStackTrace();
request.setAttribute("error", "Erreur lors du chargement des statistiques: " + e.getMessage());
request.setAttribute("totalOffres", 0);
request.setAttribute("offresActives", 0);
request.setAttribute("totalReservations", 0);
request.setAttribute("demandesEnAttente", 0);
}

request.setAttribute("page", "dashboard");
request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
}
    
    private void afficherOffres(HttpServletRequest request, HttpServletResponse response, 
            Conducteur conducteur) throws ServletException, IOException {
try {
// ✅ Vérifier que l'ID existe avant de faire la requête
Long conducteurId = conducteur.getId();
if (conducteurId == null) {
request.setAttribute("error", "Erreur: ID conducteur non trouvé");
request.setAttribute("offres", new java.util.ArrayList<>());
} else {
List<Offre> offres = offreDAO.findByConducteur(conducteurId);
request.setAttribute("offres", offres);

// Calculer les statistiques
int totalOffres = offres.size();
int offresActives = 0;
int offresCompletes = 0;
int offresTerminees = 0;
int offresAnnulees = 0;

for (Offre offre : offres) {
String statut = offre.getStatut();
if ("EN_ATTENTE".equals(statut)) {
    if (offre.getPlacesDisponibles() > 0) {
        offresActives++;
    } else {
        offresCompletes++;
    }
} else if ("TERMINEE".equals(statut)) {
    offresTerminees++;
} else if ("ANNULEE".equals(statut)) {
    offresAnnulees++;
}
}

request.setAttribute("totalOffres", totalOffres);
request.setAttribute("offresActives", offresActives);
request.setAttribute("offresCompletes", offresCompletes);
request.setAttribute("offresTerminees", offresTerminees);
request.setAttribute("offresAnnulees", offresAnnulees);
}
} catch (Exception e) {
e.printStackTrace();
request.setAttribute("error", "Erreur lors du chargement des offres: " + e.getMessage());
request.setAttribute("offres", new java.util.ArrayList<>());
}
request.setAttribute("page", "offres");
request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
}
    
    private void afficherFormPublier(HttpServletRequest request, HttpServletResponse response, 
                                     Conducteur conducteur) throws ServletException, IOException {
        request.setAttribute("page", "publier");
        request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
    }
    
    private void afficherDemandes(HttpServletRequest request, HttpServletResponse response, 
            Conducteur conducteur) throws ServletException, IOException {
try {
Long conducteurId = conducteur.getId();

if (conducteurId == null) {
request.setAttribute("error", "Erreur: ID conducteur non trouvé");
request.setAttribute("reservations", new java.util.ArrayList<>());
request.setAttribute("nbEnAttente", 0);
request.setAttribute("nbConfirmees", 0);
request.setAttribute("nbRefusees", 0);
} else {
// Récupérer toutes les réservations pour les offres du conducteur
List<Reservation> reservations = reservationDAO.findByConducteur(conducteurId);

// Calculer les statistiques par statut
int nbEnAttente = 0;
int nbConfirmees = 0;
int nbAnnulees = 0;
int nbTerminees = 0;

// Séparer les réservations par statut
List<Reservation> enAttente = new java.util.ArrayList<>();
List<Reservation> confirmees = new java.util.ArrayList<>();
List<Reservation> annulees = new java.util.ArrayList<>();
List<Reservation> terminees = new java.util.ArrayList<>();

for (Reservation res : reservations) {
String statut = res.getStatut();
if ("EN_ATTENTE".equals(statut)) {
  nbEnAttente++;
  enAttente.add(res);
} else if ("CONFIRMEE".equals(statut)) {
  nbConfirmees++;
  confirmees.add(res);
} else if ("ANNULEE".equals(statut)) {
  nbAnnulees++;
  annulees.add(res);
} else if ("TERMINEE".equals(statut)) {
  nbTerminees++;
  terminees.add(res);
}
}

// Passer les données à la JSP
request.setAttribute("reservations", reservations);
request.setAttribute("enAttente", enAttente);
request.setAttribute("confirmees", confirmees);
request.setAttribute("annulees", annulees);
request.setAttribute("terminees", terminees);
request.setAttribute("nbEnAttente", nbEnAttente);
request.setAttribute("nbConfirmees", nbConfirmees);
request.setAttribute("nbAnnulees", nbAnnulees);
request.setAttribute("nbTerminees", nbTerminees);
request.setAttribute("totalReservations", reservations.size());
}
} catch (Exception e) {
e.printStackTrace();
request.setAttribute("error", "Erreur lors du chargement des demandes: " + e.getMessage());
request.setAttribute("reservations", new java.util.ArrayList<>());
request.setAttribute("nbEnAttente", 0);
request.setAttribute("nbConfirmees", 0);
request.setAttribute("nbAnnulees", 0);
}

request.setAttribute("page", "demandes");
request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
}
    
    private void afficherEvaluations(HttpServletRequest request, HttpServletResponse response, 
                                     Conducteur conducteur) throws ServletException, IOException {
        try {
            // ✅ Vérifier que l'ID existe
            Long conducteurId = conducteur.getId();
            if (conducteurId == null) {
                request.setAttribute("error", "Erreur: ID conducteur non trouvé");
                request.setAttribute("evaluations", new ArrayList<>());
                request.setAttribute("totalEvaluations", 0);
                request.setAttribute("noteMoyenne", 0.0);
                request.setAttribute("distributionNotes", new int[6]);
            } else {
                List<Evaluation> evaluations = evaluationDAO.findByEvalue(conducteurId);
                int totalEvaluations = evaluationDAO.countEvaluationsByEvalue(conducteurId);
                Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(conducteurId);
                
                int[] distributionNotes = new int[6];
                for (Evaluation eval : evaluations) {
                    if (eval.getNote() >= 1 && eval.getNote() <= 5) {
                        distributionNotes[eval.getNote()]++;
                    }
                }
                
                request.setAttribute("evaluations", evaluations);
                request.setAttribute("totalEvaluations", totalEvaluations);
                request.setAttribute("noteMoyenne", noteMoyenne != null ? noteMoyenne : 0.0);
                request.setAttribute("distributionNotes", distributionNotes);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des évaluations: " + e.getMessage());
        }
        request.setAttribute("page", "evaluations");
        request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
    }
    
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response, 
                                Conducteur conducteur) throws ServletException, IOException {
        request.setAttribute("page", "profil");
        request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
    }
    
    // ========== Méthodes d'action POST ==========
    
    private void publierOffre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
        
        try {
            // ✅ CORRECTION CRITIQUE: Vérifier que l'ID existe
            Long conducteurId = conducteur.getId();
            if (conducteurId == null) {
                session.setAttribute("error", "Erreur: Impossible de récupérer l'ID du conducteur. Veuillez vous reconnecter.");
                response.sendRedirect("Conducteur?page=publier");
                return;
            }
            
            // Récupérer les données du formulaire
            String villeDepart = request.getParameter("villeDepart");
            String villeArrivee = request.getParameter("villeArrivee");
            String dateDepartStr = request.getParameter("dateDepart");
            String heureDepartStr = request.getParameter("heureDepart");
            String prixParPlaceStr = request.getParameter("prixParPlace");
            String nombrePlacesStr = request.getParameter("nombrePlaces");
            String commentaire = request.getParameter("description");
            
            // Validation
            if (villeDepart == null || villeDepart.isEmpty() || 
                villeArrivee == null || villeArrivee.isEmpty() ||
                dateDepartStr == null || dateDepartStr.isEmpty() ||
                heureDepartStr == null || heureDepartStr.isEmpty() ||
                prixParPlaceStr == null || prixParPlaceStr.isEmpty() ||
                nombrePlacesStr == null || nombrePlacesStr.isEmpty()) {
                
                session.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                response.sendRedirect("Conducteur?page=publier");
                return;
            }
            
            // Convertir les données
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            
            Date dateDepart = dateFormat.parse(dateDepartStr);
            Time heureDepart = new Time(timeFormat.parse(heureDepartStr).getTime());
            Double prixParPlace = Double.parseDouble(prixParPlaceStr);
            Integer placesTotales = Integer.parseInt(nombrePlacesStr);
            
            // Créer l'offre avec l'ID du conducteur
            Offre offre = new Offre(
                conducteurId,  // ✅ Utiliser l'ID vérifié
                villeDepart,
                villeArrivee,
                dateDepart,
                heureDepart,
                prixParPlace,
                placesTotales
            );
            offre.setCommentaire(commentaire);
            
            // Sauvegarder en base
            Long offreId = offreDAO.create(offre);
            
            if (offreId != null) {
                session.setAttribute("success", "Offre publiée avec succès!");
                response.sendRedirect("Conducteur?page=offres");
            } else {
                session.setAttribute("error", "Erreur lors de la publication de l'offre");
                response.sendRedirect("Conducteur?page=publier");
            }
            
        } catch (ParseException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur de format de date/heure: " + e.getMessage());
            response.sendRedirect("Conducteur?page=publier");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur de format de nombre: " + e.getMessage());
            response.sendRedirect("Conducteur?page=publier");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect("Conducteur?page=publier");
        }
    }
    
    private void annulerOffre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                Long offreId = Long.parseLong(offreIdStr);
                boolean success = offreDAO.updateStatut(offreId, "ANNULEE");
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Offre annulée avec succès!");
                } else {
                    session.setAttribute("error", "Erreur lors de l'annulation de l'offre");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Conducteur?page=offres");
    }
    
    private void marquerEffectuee(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                Long offreId = Long.parseLong(offreIdStr);
                boolean success = offreDAO.updateStatut(offreId, "TERMINEE");
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Offre marquée comme terminée!");
                } else {
                    session.setAttribute("error", "Erreur lors de la mise à jour de l'offre");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Conducteur?page=offres");
    }
    
    private void confirmerReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Mettre à jour le statut à CONFIRMEE
                boolean success = reservationDAO.updateStatut(reservationId, "CONFIRMEE");
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Réservation confirmée avec succès!");
                } else {
                    session.setAttribute("error", "Erreur lors de la confirmation");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Conducteur?page=demandes");
    }

    private void refuserReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Récupérer la réservation pour remettre les places disponibles
                Reservation reservation = reservationDAO.findById(reservationId);
                
                if (reservation != null) {
                    // Mettre à jour le statut à ANNULEE
                    boolean success = reservationDAO.updateStatut(reservationId, "ANNULEE");
                    
                    if (success) {
                        // Remettre les places disponibles
                        Offre offre = reservation.getOffre();
                        Integer nouvellePlaces = offre.getPlacesDisponibles() + reservation.getNombrePlaces();
                        offreDAO.updatePlacesDisponibles(offre.getIdOffre(), nouvellePlaces);
                        
                        HttpSession session = request.getSession();
                        session.setAttribute("success", "Réservation refusée");
                    } else {
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "Erreur lors du refus");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Conducteur?page=demandes");
    }
    
    private void updateProfil(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Récupérer l'utilisateur en session
        Conducteur conducteur = (Conducteur) request.getSession().getAttribute("utilisateur");
        
        // Vérification de sécurité
        if (conducteur == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        // 2. Récupérer les données du formulaire
        String nouveauNom = request.getParameter("nom");
        String nouveauPrenom = request.getParameter("prenom");
        String nouvelEmail = request.getParameter("email");
        String nouveauTelephone = request.getParameter("telephone");

        // 3. Mettre à jour l'objet en mémoire (très important !)
        conducteur.setNom(nouveauNom);
        conducteur.setPrenom(nouveauPrenom);
        conducteur.setEmail(nouvelEmail);
        conducteur.setTelephone(nouveauTelephone);
        
        try {
            // 4. Persister en Base de Données
            // NOTE: Votre DAO update() gère la mise à jour des champs Utilisateur et Conducteur
            conducteurDAO.update(conducteur); 
            
            // 5. Mettre à jour la session avec le nouvel objet
            request.getSession().setAttribute("utilisateur", conducteur);
            
            // 6. Redirection succès
            response.sendRedirect("Conducteur?page=profil&success=true");
            
        } catch (SQLException e) {
            // Gérer les erreurs (ex: email déjà utilisé, contrainte unique violée)
            request.setAttribute("error", "Erreur lors de la mise à jour : " + e.getMessage());
            response.sendRedirect("Conducteur?page=profil&error=true");
        }
    }
    
    private void updateVehicule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Conducteur conducteur = (Conducteur) request.getSession().getAttribute("utilisateur");
        if (conducteur == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }
        
        // Récupérer les données du véhicule
        String nouvelleMarque = request.getParameter("marqueVehicule");
        String nouveauModele = request.getParameter("modeleVehicule");
        String nouvelleImmatriculation = request.getParameter("immatriculation");
        int nouveauNombrePlaces = Integer.parseInt(request.getParameter("nombrePlaces"));

        // Mettre à jour l'objet
        conducteur.setMarqueVehicule(nouvelleMarque);
        conducteur.setModeleVehicule(nouveauModele);
        conducteur.setImmatriculation(nouvelleImmatriculation);
        conducteur.setNombrePlacesVehicule(nouveauNombrePlaces);
        
        try {
            // Persister en Base de Données
            conducteurDAO.update(conducteur); 
            
            // Mettre à jour la session
            request.getSession().setAttribute("utilisateur", conducteur);
            
            // Redirection succès
            response.sendRedirect("Conducteur?page=profil&success=true");
            
        } catch (SQLException e) {
            // Gérer les erreurs de BD
            request.setAttribute("error", "Erreur lors de la mise à jour du véhicule : " + e.getMessage());
            response.sendRedirect("Conducteur?page=profil&error=true");
        }
    }
    
    private void updateMotDePasse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Conducteur conducteur = (Conducteur) request.getSession().getAttribute("utilisateur");
        if (conducteur == null) {
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
            response.sendRedirect("Conducteur?page=profil&error=true&msg=Les mots de passe ne correspondent pas.");
            return;
        }
        
        // 2. Vérifier l'ancien mot de passe (vous aurez besoin d'une méthode de hachage/vérification)
        // NOTE: C'est un point critique de sécurité. Assurez-vous d'utiliser un hachage (ex: BCrypt)
        // Supposons ici que vous avez une méthode 'checkPassword' dans votre UtilisateurDAO.
        // Pour l'exemple, nous allons utiliser le mot de passe clair si vous ne le hachez pas
        if (!conducteur.getMotDePasse().equals(ancienMotDePasseForm)) {
            response.sendRedirect("Conducteur?page=profil&error=true&msg=Ancien mot de passe incorrect.");
            return;
        }
        
        // 3. Mettre à jour l'objet et la BD
        conducteur.setMotDePasse(nouveauMotDePasse); // Assurez-vous de HACHER ce mot de passe avant la BD!
        
        try {
            // Vous aurez besoin d'une méthode spécifique dans UtilisateurDAO pour mettre à jour UNIQUEMENT le mot de passe
            // utilisateurDAO.updateMotDePasse(conducteur.getIdUtilisateur(), nouveauMotDePasse); 
            conducteurDAO.update(conducteur); // Si update() gère aussi le mot de passe
            
            // Mettre à jour la session
            request.getSession().setAttribute("utilisateur", conducteur); 
            
            // Redirection succès
            response.sendRedirect("Conducteur?page=profil&success=true&msg=Mot de passe changé.");
            
        } catch (SQLException e) {
            response.sendRedirect("Conducteur?page=profil&error=true&msg=Erreur de BD.");
        }
    }
}