import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseFirestoreSwift
import Combine


class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    
    
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> { //add userdata to firebasedatabase
        let twitterUser = TwitterUser(from: user)
        do {
            //Encode Twitteruser to JSONdata
            let jsonData = try JSONEncoder().encode(twitterUser)
            
            //Transform JSONdata to dictionary
            guard let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to dictionary"])
            }
            
            //add data to Firestore
            return Future<Bool, Error> { promise in
                self.db.collection(self.usersPath).document(twitterUser.id).setData(data) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(true))
                    }
                }
            }
            .eraseToAnyPublisher()
        } catch {
            // error handling
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<TwitterUser, Error> { //search UID in firebasedatabse and transform data to TwitterUser type
        Future<TwitterUser, Error> { promise in
            self.db.collection(self.usersPath).document(id).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists, let data = document.data() {
                    do {
                        // tranform data
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        // decoding with JSONDecoder
                        let user = try JSONDecoder().decode(TwitterUser.self, from: jsonData)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                } else {
                    promise(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

