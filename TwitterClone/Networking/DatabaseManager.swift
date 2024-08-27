import Foundation
import Firebase
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
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> { //search UID in firebasedatabse and transform data to TwitterUser type
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
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> {
            promise in
            self.db.collection(self.usersPath).document(id).updateData(updateFields) {
                error in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool, Error> {
        var data: [String: Any] = [:]
        
        do {
            // Encode tweet to JSON data
            let jsonData = try JSONEncoder().encode(tweet)
            
            // Transform JSON data to dictionary
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to dictionary"])
            }
            
            // Assign the dictionary to the data variable
            data = jsonDictionary
            
        } catch {
            // Error handling
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // Return a Future Publisher to perform the database operation
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            // Save the tweet data to the database
            self.db.collection(self.tweetsPath).document(tweet.id).setData(data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func collectionTweets(retreiveTweets forUserID: String) -> AnyPublisher<[Tweet], Error> {
        Future<[Tweet], Error> { promise in
            // Firestore 쿼리 실행
            self.db.collection(self.tweetsPath)
                .whereField("author.id", isEqualTo: forUserID)
                .getDocuments { querySnapshot, error in
                    // Firestore 쿼리 실패 시 에러 반환
                    if let error = error {
                        promise(.failure(error))
                        return
                    }

                    // 쿼리 결과가 없는 경우 에러 반환
                    guard let documents = querySnapshot?.documents else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                        return
                    }

                    // JSONDecoder를 사용하여 문서 데이터를 Tweet 객체로 변환
                    let decoder = JSONDecoder()
                    let tweets: [Tweet] = documents.compactMap { document in
                        do {
                            // Firestore 문서 데이터를 JSON으로 변환
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                            // JSON 데이터를 Tweet 객체로 디코딩
                            let tweet = try decoder.decode(Tweet.self, from: data)
                            return tweet
                        } catch {
                            print("Failed to decode document: \(error)")
                            return nil
                        }
                    }

                    // 성공적으로 트윗 배열 반환
                    promise(.success(tweets))
                }
        }
        .eraseToAnyPublisher()
    }

}
