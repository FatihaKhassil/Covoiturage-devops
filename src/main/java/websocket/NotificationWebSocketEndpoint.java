package websocket; 

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

// Le chemin que le client utilisera pour se connecter : ws://host/app/notifications/42
@ServerEndpoint("/notifications/{userId}")
public class NotificationWebSocketEndpoint {

    // Map Thread-Safe pour lier l'ID utilisateur (String) à sa Session active
    private static final Map<String, Session> userSessions = new ConcurrentHashMap<>();

    // Appelé à l'ouverture d'une nouvelle connexion
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) {
        System.out.println("WebSocket ouvert pour l'utilisateur : " + userId);
        // Enregistrement de la session pour pouvoir lui envoyer des messages plus tard
        userSessions.put(userId, session);
    }

    // Appelé à la fermeture d'une connexion
    @OnClose
    public void onClose(@PathParam("userId") String userId) {
        System.out.println("WebSocket fermé pour l'utilisateur : " + userId);
        // Retrait de la session de la Map
        userSessions.remove(userId);
    }

    // Appelé en cas d'erreur
    @OnError
    public void onError(Throwable throwable) {
        System.err.println("Erreur WebSocket: " + throwable.getMessage());
    }

    /*
     * Méthode statique utilitaire pour envoyer des notifications de n'importe où
     * (Servlets, Services, etc.)
     */
    public static void sendNotificationToUser(Long userId, String jsonMessage) {
        String userIdStr = String.valueOf(userId);
        Session session = userSessions.get(userIdStr);

        if (session != null && session.isOpen()) {
            try {
                // Envoi Asynchrone (ne bloque pas le thread appelant)
                session.getAsyncRemote().sendText(jsonMessage);
            } catch (Exception e) {
                System.err.println("Échec de l'envoi de la notif à " + userIdStr + " : " + e.getMessage());
            }
        }
    }
}