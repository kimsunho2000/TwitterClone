import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine


class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    
    
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser) // install cocoapods and modified pods file
            .map {
                _ in return true
            }
            .eraseToAnyPublisher()
    }
}
