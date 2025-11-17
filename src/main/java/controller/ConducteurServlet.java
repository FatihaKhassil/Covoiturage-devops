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
            case "evaluerPassager":
                evaluerPassager(request, response);
                break;
            case "terminerReservation":
                terminerReservation(request, response);
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
            Long conducteurId = conducteur.getId();
            if (conducteurId == null) {
                request.setAttribute("error", "Erreur: ID conducteur non trouvé");
                request.setAttribute("offres", new java.util.ArrayList<>());
            } else {
                List<Offre> offres = offreDAO.findByConducteur(conducteurId);
                request.setAttribute("offres", offres);
                // Calculer les statistiques simplement
                int totalOffres = offres.size();
                int offresActives = 0;      // VALIDEE
                int offresTerminees = 0;    // TERMINEE
                int offresAnnulees = 0;     // ANNULEE
                int offresEnAttente = 0;    // EN_ATTENTE

                for (Offre offre : offres) {
                    String statut = offre.getStatut();
                    if ("VALIDEE".equals(statut)) {
                        offresActives++;
                    } else if ("TERMINEE".equals(statut)) {
                        offresTerminees++;
                    } else if ("ANNULEE".equals(statut)) {
                        offresAnnulees++;
                    } else if ("EN_ATTENTE".equals(statut)) {
                        offresEnAttente++;
                    }
                }

                request.setAttribute("totalOffres", totalOffres);
                request.setAttribute("offresActives", offresActives);
                request.setAttribute("offresTerminees", offresTerminees);
                request.setAttribute("offresAnnulees", offresAnnulees);
                request.setAttribute("offresEnAttente", offresEnAttente);
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
                request.setAttribute("reservations", new ArrayList<>());
                request.setAttribute("enAttente", new ArrayList<>());
                request.setAttribute("confirmees", new ArrayList<>());
                request.setAttribute("annulees", new ArrayList<>());
                request.setAttribute("terminees", new ArrayList<>());
                request.setAttribute("nbEnAttente", 0);
                request.setAttribute("nbConfirmees", 0);
                request.setAttribute("nbAnnulees", 0);
                request.setAttribute("nbTerminees", 0);
                request.setAttribute("totalReservations", 0);
            } else {
                // ✅ CORRECTION: Récupérer TOUTES les réservations pour le conducteur
                List<Reservation> reservations = reservationDAO.findByConducteur(conducteurId);
                
                System.out.println("=== DEBUG: Réservations trouvées pour conducteur " + conducteurId + ": " + reservations.size());

                // ✅ Initialiser les listes AVANT la boucle
                List<Reservation> enAttente = new ArrayList<>();
                List<Reservation> confirmees = new ArrayList<>();
                List<Reservation> annulees = new ArrayList<>();
                List<Reservation> terminees = new ArrayList<>();

                // ✅ Parcourir TOUTES les réservations et les classer par statut
                for (Reservation res : reservations) {
                    String statut = res.getStatut();
                    System.out.println("DEBUG: Réservation ID=" + res.getIdReservation() + 
                                     ", Statut=" + statut + 
                                     ", Passager=" + (res.getPassager() != null ? res.getPassager().getNom() : "null"));
                    
                    // ✅ CORRECTION: Normaliser le statut (trim + uppercase)
                    if (statut != null) {
                        statut = statut.trim().toUpperCase();
                        
                        if ("EN_ATTENTE".equals(statut)) {
                            enAttente.add(res);
                            System.out.println("  -> Ajouté à EN_ATTENTE");
                        } else if ("CONFIRMEE".equals(statut)) {
                            confirmees.add(res);
                            System.out.println("  -> Ajouté à CONFIRMEE");
                        } else if ("ANNULEE".equals(statut)) {
                            annulees.add(res);
                            System.out.println("  -> Ajouté à ANNULEE");
                        } else if ("TERMINEE".equals(statut)) {
                            terminees.add(res);
                            System.out.println("  -> Ajouté à TERMINEE");
                        } else {
                            System.out.println("  -> STATUT INCONNU: " + statut);
                        }
                    } else {
                        System.out.println("  -> STATUT NULL!");
                    }
                }

                // ✅ Passer TOUTES les données à la JSP
                request.setAttribute("reservations", reservations);
                request.setAttribute("enAttente", enAttente);
                request.setAttribute("confirmees", confirmees);
                request.setAttribute("annulees", annulees);
                request.setAttribute("terminees", terminees);
                request.setAttribute("nbEnAttente", enAttente.size());
                request.setAttribute("nbConfirmees", confirmees.size());
                request.setAttribute("nbAnnulees", annulees.size());
                request.setAttribute("nbTerminees", terminees.size());
                request.setAttribute("totalReservations", reservations.size());
                
                System.out.println("=== DEBUG STATS FINALES ===");
                System.out.println("En Attente: " + enAttente.size());
                System.out.println("Confirmées: " + confirmees.size());
                System.out.println("Annulées: " + annulees.size());
                System.out.println("Terminées: " + terminees.size());
                System.out.println("Total: " + reservations.size());
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERREUR dans afficherDemandes: " + e.getMessage());
            request.setAttribute("error", "Erreur lors du chargement des demandes: " + e.getMessage());
            request.setAttribute("reservations", new ArrayList<>());
            request.setAttribute("enAttente", new ArrayList<>());
            request.setAttribute("confirmees", new ArrayList<>());
            request.setAttribute("annulees", new ArrayList<>());
            request.setAttribute("terminees", new ArrayList<>());
            request.setAttribute("nbEnAttente", 0);
            request.setAttribute("nbConfirmees", 0);
            request.setAttribute("nbAnnulees", 0);
            request.setAttribute("nbTerminees", 0);
            request.setAttribute("totalReservations", 0);
        }

        request.setAttribute("page", "demandes");
        request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
    }
    
    private void afficherEvaluations(HttpServletRequest request, HttpServletResponse response, 
            Conducteur conducteur) throws ServletException, IOException {
try {
Long conducteurId = conducteur.getId();
if (conducteurId == null) {
request.setAttribute("error", "Erreur: ID conducteur non trouvé");
request.setAttribute("evaluations", new ArrayList<>());
request.setAttribute("totalEvaluations", 0);
request.setAttribute("noteMoyenne", 0.0);
request.setAttribute("distributionNotes", new int[6]);
} else {
// ✅ CORRECTION: Récupérer les évaluations où le conducteur est ÉVALUÉ (id_evalue)
List<Evaluation> evaluations = evaluationDAO.findByEvalue(conducteurId);
int totalEvaluations = evaluationDAO.countEvaluationsByEvalue(conducteurId);
Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(conducteurId);

// Distribution des notes
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

// Debug
System.out.println("=== DEBUG EVALUATIONS CONDUCTEUR ===");
System.out.println("ID Conducteur: " + conducteurId);
System.out.println("Évaluations trouvées: " + evaluations.size());
System.out.println("Note moyenne: " + noteMoyenne);
}
} catch (Exception e) {
e.printStackTrace();
request.setAttribute("error", "Erreur lors du chargement des évaluations: " + e.getMessage());
request.setAttribute("evaluations", new ArrayList<>());
request.setAttribute("totalEvaluations", 0);
request.setAttribute("noteMoyenne", 0.0);
request.setAttribute("distributionNotes", new int[6]);
}
request.setAttribute("page", "evaluations");
request.getRequestDispatcher("dashboardConducteur.jsp").forward(request, response);
}
    
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response, 
            Conducteur conducteur) throws ServletException, IOException {
try {
Long conducteurId = conducteur.getId();

// Récupérer les statistiques réelles
List<Offre> offres = offreDAO.findByConducteur(conducteurId);

// Calculer le nombre de trajets effectués (offres terminées)
int nombreTrajets = 0;
int nombrePassagers = 0;

for (Offre offre : offres) {
if ("TERMINEE".equals(offre.getStatut())) {
 nombreTrajets++;
 // Récupérer le nombre de passagers pour cette offre
 List<Reservation> reservations = reservationDAO.findByOffre(offre.getIdOffre());
 for (Reservation res : reservations) {
     if ("CONFIRMEE".equals(res.getStatut()) || "TERMINEE".equals(res.getStatut())) {
         nombrePassagers += res.getNombrePlaces();
     }
 }
}
}

// Récupérer la note moyenne
Double noteMoyenne = evaluationDAO.calculateNoteMoyenne(conducteurId);
if (noteMoyenne == null) {
noteMoyenne = 0.0;
}

// Passer les données à la JSP
request.setAttribute("nombreTrajets", nombreTrajets);
request.setAttribute("nombrePassagers", nombrePassagers);
request.setAttribute("noteMoyenne", noteMoyenne);

} catch (Exception e) {
e.printStackTrace();
// En cas d'erreur, utiliser des valeurs par défaut
request.setAttribute("nombreTrajets", 0);
request.setAttribute("nombrePassagers", 0);
request.setAttribute("noteMoyenne", conducteur.getNoteMoyenne());
}

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
    private void terminerReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Mettre à jour le statut de la réservation à TERMINEE
                boolean success = reservationDAO.updateStatut(reservationId, "TERMINEE");
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "✅ Trajet marqué comme terminé !");
                } else {
                    session.setAttribute("error", "❌ Erreur lors de la mise à jour");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        response.sendRedirect("Conducteur?page=demandes");
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
            System.out.println("=== DÉBUT confirmerReservation ===");
            System.out.println("Reservation ID reçu: " + reservationIdStr);
            
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Récupérer la réservation
                Reservation reservation = reservationDAO.findById(reservationId);
                System.out.println("Réservation trouvée: " + (reservation != null));
                
                if (reservation != null) {
                    System.out.println("Statut actuel: " + reservation.getStatut());
                    System.out.println("Nombre de places: " + reservation.getNombrePlaces());
                    
                    if ("EN_ATTENTE".equals(reservation.getStatut())) {
                        // Vérifier qu'il y a assez de places
                        Offre offre = reservation.getOffre();
                        System.out.println("Offre ID: " + offre.getIdOffre());
                        System.out.println("Places disponibles: " + offre.getPlacesDisponibles());
                        System.out.println("Places demandées: " + reservation.getNombrePlaces());
                        
                        if (offre.verifierDisponibilite(reservation.getNombrePlaces())) {
                            // Mettre à jour le statut à CONFIRMEE
                            System.out.println("Tentative de confirmation...");
                            boolean success = reservationDAO.updateStatut(reservationId, "CONFIRMEE");
                            System.out.println("Mise à jour statut réussie: " + success);
                            
                            if (success) {
                                // ✅ Maintenant on met à jour les places disponibles
                                Integer nouvellePlaces = offre.getPlacesDisponibles() - reservation.getNombrePlaces();
                                System.out.println("Nouvelles places disponibles: " + nouvellePlaces);
                                
                                boolean updatePlacesSuccess = offreDAO.updatePlacesDisponibles(offre.getIdOffre(), nouvellePlaces);
                                System.out.println("Mise à jour places réussie: " + updatePlacesSuccess);
                                
                                HttpSession session = request.getSession();
                                if (updatePlacesSuccess) {
                                    session.setAttribute("success", "✅ Réservation confirmée avec succès!");
                                } else {
                                    session.setAttribute("error", "⚠️ Réservation confirmée mais erreur mise à jour places");
                                }
                            } else {
                                HttpSession session = request.getSession();
                                session.setAttribute("error", "❌ Erreur lors de la confirmation du statut");
                            }
                        } else {
                            System.out.println("Pas assez de places disponibles");
                            HttpSession session = request.getSession();
                            session.setAttribute("error", "❌ Plus assez de places disponibles");
                        }
                    } else {
                        System.out.println("Statut incorrect pour confirmation: " + reservation.getStatut());
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "❌ Cette réservation ne peut pas être confirmée (statut: " + reservation.getStatut() + ")");
                    }
                } else {
                    System.out.println("Réservation non trouvée");
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "❌ Réservation introuvable");
                }
            } else {
                System.out.println("Aucun ID de réservation reçu");
                HttpSession session = request.getSession();
                session.setAttribute("error", "❌ Aucune réservation spécifiée");
            }
        } catch (Exception e) {
            System.err.println("ERREUR dans confirmerReservation: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        System.out.println("=== FIN confirmerReservation ===");
        response.sendRedirect("Conducteur?page=demandes");
    }
    
    private void refuserReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            String motifRefus = request.getParameter("motif");
            
            System.out.println("=== DÉBUT refuserReservation ===");
            System.out.println("Reservation ID reçu: " + reservationIdStr);
            System.out.println("Motif reçu: " + motifRefus);
            
            if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
                Long reservationId = Long.parseLong(reservationIdStr);
                
                // Récupérer la réservation
                Reservation reservation = reservationDAO.findById(reservationId);
                System.out.println("Réservation trouvée: " + (reservation != null));
                
                if (reservation != null) {
                    String statutActuel = reservation.getStatut();
                    System.out.println("Statut actuel: " + statutActuel);
                    
                    // Mettre à jour le statut à ANNULEE
                    System.out.println("Tentative d'annulation...");
                    boolean success = reservationDAO.updateStatut(reservationId, "ANNULEE");
                    System.out.println("Mise à jour statut réussie: " + success);
                    
                    if (success) {
                        // ✅ Si la réservation était CONFIRMEE, remettre les places
                        if ("CONFIRMEE".equals(statutActuel)) {
                            Offre offre = reservation.getOffre();
                            Integer nouvellePlaces = offre.getPlacesDisponibles() + reservation.getNombrePlaces();
                            System.out.println("Remise des places - nouvelles places: " + nouvellePlaces);
                            
                            boolean updatePlacesSuccess = offreDAO.updatePlacesDisponibles(offre.getIdOffre(), nouvellePlaces);
                            System.out.println("Mise à jour places réussie: " + updatePlacesSuccess);
                        }
                        
                        HttpSession session = request.getSession();
                        String message = "❌ Réservation refusée";
                        if (motifRefus != null && !motifRefus.trim().isEmpty()) {
                            message += " - Motif: " + motifRefus;
                        }
                        session.setAttribute("success", message);
                    } else {
                        System.out.println("Échec de la mise à jour du statut");
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "❌ Erreur lors du refus");
                    }
                } else {
                    System.out.println("Réservation non trouvée");
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "❌ Réservation introuvable");
                }
            } else {
                System.out.println("Aucun ID de réservation reçu");
                HttpSession session = request.getSession();
                session.setAttribute("error", "❌ Aucune réservation spécifiée");
            }
        } catch (Exception e) {
            System.err.println("ERREUR dans refuserReservation: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        System.out.println("=== FIN refuserReservation ===");
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
 // Dans ConducteurServlet - Ajouter cette méthode
    private void evaluerPassager(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Conducteur conducteur = (Conducteur) session.getAttribute("utilisateur");
        
        try {
            String reservationIdStr = request.getParameter("reservationId");
            String idPassagerStr = request.getParameter("idPassager");
            String noteStr = request.getParameter("note");
            String commentaire = request.getParameter("commentaire");
            
            if (reservationIdStr == null || idPassagerStr == null || noteStr == null) {
                session.setAttribute("error", "Données d'évaluation manquantes");
                response.sendRedirect("Conducteur?page=demandes");
                return;
            }
            
            Long reservationId = Long.parseLong(reservationIdStr);
            Long idPassager = Long.parseLong(idPassagerStr);
            Integer note = Integer.parseInt(noteStr);
            
            // Vérifier que la note est valide
            if (note < 1 || note > 5) {
                session.setAttribute("error", "La note doit être entre 1 et 5");
                response.sendRedirect("Conducteur?page=demandes");
                return;
            }
            
            // Récupérer la réservation pour avoir l'ID de l'offre
            Reservation reservation = reservationDAO.findById(reservationId);
            if (reservation == null) {
                session.setAttribute("error", "Réservation introuvable");
                response.sendRedirect("Conducteur?page=demandes");
                return;
            }
            
            // Vérifier que le conducteur peut évaluer cette réservation
            if (!reservation.getOffre().getIdConducteur().equals(conducteur.getId())) {
                session.setAttribute("error", "Vous ne pouvez pas évaluer cette réservation");
                response.sendRedirect("Conducteur?page=demandes");
                return;
            }
            
            // CORRECTION : Utiliser l'instance evaluationDAO correctement
            boolean evaluationExiste = evaluationDAO.existsForOffre(
                reservation.getOffre().getIdOffre(), 
                conducteur.getId(), 
                idPassager
            );
            
            if (evaluationExiste) {
                session.setAttribute("error", "Vous avez déjà évalué ce passager pour ce trajet");
                response.sendRedirect("Conducteur?page=demandes");
                return;
            }
            
            // Créer l'évaluation
            Evaluation evaluation = new Evaluation();
            evaluation.setIdOffre(reservation.getOffre().getIdOffre());
            evaluation.setIdEvaluateur(conducteur.getId());
            evaluation.setIdEvalue(idPassager);
            evaluation.setNote(note);
            evaluation.setCommentaire(commentaire);
            evaluation.setDateEvaluation(new Date());
            
            Long evaluationId = evaluationDAO.create(evaluation);
            
            if (evaluationId != null) {
                session.setAttribute("success", "✅ Évaluation envoyée avec succès !");
            } else {
                session.setAttribute("error", "❌ Erreur lors de l'envoi de l'évaluation");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }
        
        response.sendRedirect("Conducteur?page=demandes");
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