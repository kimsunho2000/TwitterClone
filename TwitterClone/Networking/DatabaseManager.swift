import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine


class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    
    
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
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
}

