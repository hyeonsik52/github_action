//
//  User.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

struct User: Identifiable {
    
    var id: String
    
    var userName: String
    var displayName: String
    
    var email: String?
    var phonenumber: String?
    
    var joinedWorkspaces: [Workspace]?
}

extension User: FragmentModel {
    
    init(_ fragment: UserFragment) {
        
        self.id = fragment.id
        
        self.userName = fragment.username
        self.displayName = fragment.displayName
        
        self.email = fragment.email
        self.phonenumber = fragment.phoneNumber
        
        self.joinedWorkspaces = fragment.joinedWorkspaces?.edges
            .compactMap(\.?.node?.fragments.workspaceForUserFragment)
            .map(Workspace.init) ?? []
    }
    
    init(alt fragment: UserForWorkspaceFragment) {
        
        self.id = fragment.id
        
        self.userName = fragment.username
        self.displayName = fragment.displayName
        
        self.email = fragment.email
        self.phonenumber = fragment.phoneNumber
    }
}
