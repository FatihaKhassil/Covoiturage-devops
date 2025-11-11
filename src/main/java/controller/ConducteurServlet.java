package controller;

import models.Conducteur;
import models.Offre;
import models.Evaluation;
import dao.OffreDAO;
import dao.EvaluationDAO;
import dao.impl.OffreDAOImpl;
import dao.impl.EvaluationDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
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
    
    @Override
    public void init() throws ServletException {
        try {
            Connection connection = Factory.dbConnect();
            this.offreDAO = new OffreDAOImpl(connection);
            this.evaluationDAO = new EvaluationDAOImpl(connection);
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
// List<Reservation> reservations = reservationDAO.findByConducteur(conducteurId);
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
        response.sendRedirect("Conducteur?page=demandes");
    }
    
    private void refuserReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("Conducteur?page=demandes");
    }
    
    private void updateProfil(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("Conducteur?page=profil&success=true");
    }
    
    private void updateVehicule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("Conducteur?page=profil&success=true");
    }
    
    private void updateMotDePasse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("Conducteur?page=profil&success=true");
    }
}