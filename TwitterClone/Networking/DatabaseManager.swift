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
    let followingPath: String = "followings"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, any Error> { //add userdata to firebasedatabase
        let twitterUser = TwitterUser(from: user)
        do {
            //Encode Twitteruser to JSONdata
            let jsonData = try JSONEncoder().encode(twitterUser)
            
            //Transform JSONdata to dictionary
            guard let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to dictionary"])
            }
            
            //add data to Firestore
            return Future<Bool, any Error> { promise in
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
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, any Error> { //search UID in firebasedatbase and transform data to TwitterUser type
        Future<TwitterUser, any Error> { promise in
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
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, any Error> {
        Future<Bool, any Error> {
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
    
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool, any Error> {
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
        return Future<Bool, any Error> { [weak self] promise in
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
    
    func collectionUsers(search query: String) -> AnyPublisher<[TwitterUser], any Error> {
        Future<[TwitterUser], any Error> { promise in
            self.db.collection(self.usersPath)
                .whereField("username", isEqualTo: query)
                .getDocuments { querySnapshot, Error in
                    if let Error = Error {
                        promise(.failure(Error))
                        return
                    }
                    guard let documents = querySnapshot?.documents else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                        return
                    }
                    let decoder = JSONDecoder()
                    let twitterUsers: [TwitterUser] = documents.compactMap { document in
                        do {
                            // Firestore 문서 데이터를 JSON으로 변환
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                            // JSON 데이터를 Tweet 객체로 디코딩
                            let twitterUser = try decoder.decode(TwitterUser.self, from: data)
                            return twitterUser
                        } catch {
                            print("Failed to decode document: \(error)")
                            return nil
                        }
                    }
                    promise(.success(twitterUsers))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func collectionTweets(retreiveTweets forUserID: String) -> AnyPublisher<[Tweet], any Error> {
        Future<[Tweet], any Error> { promise in
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
    
    func collectionFollowings(isFollower: String, following: String) -> Future<Bool, any Error> {
        return Future { promise in
            self.db.collection(self.followingPath)
                .whereField("follower", isEqualTo: isFollower)
                .whereField("following", isEqualTo: following)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        // 에러가 발생하면 promise에 에러를 전달
                        promise(.failure(error))
                    } else {
                        // 팔로워수를 확인하여 0이 아니면 true, 0이면 false 반환
                        let isFollowing = snapshot?.count != 0
                        promise(.success(isFollowing))
                    }
                }
        }
    }
    
    func collectionFollowings(follower: String, following: String) -> AnyPublisher<Bool, any Error> {
        return Future { promise in
            let db = self.db

            // 팔로잉 관계 데이터 추가
            let followingData = [
                "follower": follower,
                "following": following
            ]

            //팔로잉 관계 추가
            db.collection(self.followingPath).document().setData(followingData) { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                //팔로잉 한 사용자의 followingCount 증가
                db.collection(self.usersPath).document(follower).updateData([
                    "followingCount": FieldValue.increment(Int64(1))
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }

                    //팔로잉 당한 사용자의 followerCount 증가
                    db.collection(self.usersPath).document(following).updateData([
                        "followersCount": FieldValue.increment(Int64(1))
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(true))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func collectionFollowings(delete follower: String, following: String) -> AnyPublisher<Bool, any Error> {
        return Future { promise in
            
            self.db.collection(self.usersPath).document(follower).updateData([ //팔로잉 한 사용자의 followingCount 감소
                "followingCount": FieldValue.increment(Int64(-1))
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                self.db.collection(self.usersPath).document(following).updateData([ //팔로잉 당한 사용자의 followerCount 감소
                    "followersCount": FieldValue.increment(Int64(-1))
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(true))
                    }
                }
            }
            
            self.db.collection(self.followingPath)
                .whereField("follower", isEqualTo: follower)
                .whereField("following", isEqualTo: following)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        // 에러가 발생하면 promise에 에러를 전달
                        promise(.failure(error))
                    } else if let documents = snapshot?.documents, !documents.isEmpty {
                        let batch = self.db.batch() // Firestore 배치 작업을 시작합니다.
                        
                        // 문서들에 대해 필드를 삭제하는 작업 수행
                        for document in documents {
                            batch.updateData([
                                "follower": FieldValue.delete(),
                                "following": FieldValue.delete()
                            ], forDocument: document.reference)
                        }
                        
                        // 배치 작업을 커밋하여 필드 삭제 처리
                        batch.commit { batchError in
                            if let batchError = batchError {
                                promise(.failure(batchError))
                            } else {
                                // 배치 작업 완료 후 문서에 남아있는 데이터 확인
                                for document in documents {
                                    document.reference.getDocument { (updatedDocument, error) in
                                        if let updatedDocument = updatedDocument, updatedDocument.exists {
                                            // 남은 데이터가 없으면 문서 삭제
                                            if updatedDocument.data()?.isEmpty == true {
                                                document.reference.delete { deleteError in
                                                    if let deleteError = deleteError {
                                                        promise(.failure(deleteError))
                                                    } else {
                                                        // 삭제가 성공하면 true 반환
                                                        promise(.success(true))
                                                    }
                                                }
                                            } else {
                                                // 문서에 남아있는 데이터가 있으면 true 반환
                                                promise(.success(true))
                                            }
                                        } else if let error = error {
                                            promise(.failure(error))
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // 삭제할 문서가 없는 경우
                        promise(.success(false)) // 아무 문서도 삭제되지 않음
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    }

