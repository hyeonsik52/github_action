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
    func initRecentSearchTerms(with unique: String) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        UserDefaults.standard.set([], forKey: "\(recentSearchTermsKey).\(unique)")
        return []
    }
    
    func loadRecentSearchTerms(with unique: String) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        guard let array = UserDefaults.standard.array(forKey: "\(recentSearchTermsKey).\(unique)") as? [String] else {
            return self.initRecentSearchTerms(with: unique)
        }
        return array
    }
    
    func isRecentSearchTermsEmpty(with unique: String) -> Bool {
        return self.loadRecentSearchTerms(with: unique).isEmpty
    }
    
    @discardableResult
    func saveRecentSearchTerms(_ terms: String..., with unique: String) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        var new = self.loadRecentSearchTerms(with: unique)
        new.removeAll { terms.contains($0) }
        terms.forEach {
            let trimmed = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                new.insert(trimmed, at: 0)
            }
        }
        if new.count > 10 {
            new = Array(new[0..<10])
        }
        UserDefaults.standard.set(new, forKey: "\(recentSearchTermsKey).\(unique)")
        return new
    }
    
    @discardableResult
    func removeRecentSearchTerms(_ terms: String..., with unique: String) -> [String] {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        var new = self.loadRecentSearchTerms(with: unique)
        new.removeAll { terms.contains($0) }
        UserDefaults.standard.set(new, forKey: "\(recentSearchTermsKey).\(unique)")
        return new
    }
    
    @discardableResult
    func removeRecentSearchTermsAll(with unique: String) -> [String]  {
        objc_sync_enter(self); defer{ objc_sync_exit(self) }
        let current = self.loadRecentSearchTerms(with: unique)
        self.initRecentSearchTerms(with: unique)
        return current
    }
}
