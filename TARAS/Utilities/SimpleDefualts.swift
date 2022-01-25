//
//  SimpleDefualts.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/24.
//

import Foundation

class SimpleDefualts {
    static let shared = SimpleDefualts()
    
    private let recentSearchTermsKey = "kr.co.twinny.taras.search.terms.recent"
    
    @discardableResult
    func initRecentSearchTerms() -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        UserDefaults.standard.set([], forKey: recentSearchTermsKey)
        return []
    }
    
    func loadRecentSearchTerms() -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        guard let array = UserDefaults.standard.array(forKey: recentSearchTermsKey) as? [String] else {
            return self.initRecentSearchTerms()
        }
        return array
    }
    
    var isRecentSearchTermsEmpty: Bool {
        return self.loadRecentSearchTerms().isEmpty
    }
    
    @discardableResult
    func saveRecentSearchTerms(_ terms: String...) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        var new = self.loadRecentSearchTerms()
        new.removeAll { terms.contains($0) }
        terms.forEach { new.insert($0, at: 0) }
        if new.count > 10 {
            new = Array(new[0..<10])
        }
        UserDefaults.standard.set(new, forKey: recentSearchTermsKey)
        return new
    }
    
    @discardableResult
    func removeRecentSearchTerms(_ terms: String...) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        var new = self.loadRecentSearchTerms()
        new.removeAll { terms.contains($0) }
        UserDefaults.standard.set(new, forKey: recentSearchTermsKey)
        return new
    }
    
    @discardableResult
    func removeRecentSearchTermsAll() -> [String]  {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        let current = self.loadRecentSearchTerms()
        self.initRecentSearchTerms()
        return current
    }
}
