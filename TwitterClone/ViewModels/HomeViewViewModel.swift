//
//  HomeViewViewModel.swift
//  TwitterClone
//
//  Created by 김선호 on 8/2/24.
//

import Foundation
import Combine

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    
    
    
    
    
    func retreiveUser() { 
        DatabaseManager.shared.collectionUsers(retrieve: <#T##String#>)
    }
}
