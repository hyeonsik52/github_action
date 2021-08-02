//
//  RealmManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import RealmSwift
import RxCocoa
import RxSwift

class RealmManager: NSObject {
    static let shared = RealmManager()
    
    let openRelay = BehaviorRelay<Bool?>(value: nil)
    
    // 램 얻기
    var realm: Realm? {
        return try? Realm()
    }
    
    // 램 열기
    func openRealm(_ fileUrl: URL? = nil) {
        
        autoreleasepool {
            
            let realmConfig = initConfiguration(fileUrl)
            Realm.Configuration.defaultConfiguration = realmConfig
            
            Realm.asyncOpen(configuration: realmConfig) { [unowned self] result in
                switch result {
                case .success:
                    Log.info("[Realm] Opened")
                    self.openRelay.accept(true)
                case .failure(let error):
                    Log.error("[Realm] \(error.localizedDescription)")
                    self.realmVersionRecovery(realmConfig)
                }
            }
        }
    }
    
    // 초기 설정
    private func initConfiguration(_ fileUrl: URL? = nil) -> Realm.Configuration {
        
        //암호화 키 준비
        //let encryptionKey = EncryptionUtil.loadRealmEncryptionKey()
        
        //램 암호화 및 사용할 테이블 설정
        var realmConfig = Realm.Configuration.defaultConfiguration
        //realmConfig.encryptionKey = encryptionKey
        //realmConfig.objectTypes = [];
        
        realmConfig.fileURL = fileUrl ?? Realm.Configuration.defaultConfiguration.fileURL
        
        //마이그레이션
        realmConfig = realmMigration(realmConfig)
        
        //무조건 압축
        realmConfig.shouldCompactOnLaunch = { totalBytes, usedBytes in
            return (Double(usedBytes) / Double(totalBytes)) >= 0.5
        }
        
        return realmConfig
    }
    
    // 마이그레이션
    private func realmMigration(_ config: Realm.Configuration) -> Realm.Configuration {
        
        var returnConfig = config
        
        returnConfig.schemaVersion = Info.DBVersion
        returnConfig.migrationBlock = { migration, oldSchemaVersion in
            
            // 램 내의 모델이나 속성이 추가,변경,삭제될 때 반드시 마이그레이션하고 버전별로 내역 표시
            // 낮은버전 -> 높은버전
            
            /*
             if oldSchemaVersion < (수정된버전) {
             (이전 버전으로부터 수정된 내역)
             }
             */
        }
        
        return returnConfig
    }
    
    // 회복 가능한 오류에 대한 처리
    private var realmVersionRecoveryTryCount: Int = 0
    private func realmVersionRecovery(_ config: Realm.Configuration) {
        realmVersionRecoveryTryCount += 1
        do {
            var realmConfig = config
            realmConfig.schemaVersion += 1
            _ = try Realm(configuration: realmConfig)
            Realm.Configuration.defaultConfiguration = realmConfig
            Log.warning("""
                Realm Version Recovery
                
                
                
                Stable Vesrion is \(realmConfig.schemaVersion)
                
                
                
                """)
                self.openRelay.accept(true)
        } catch let error as NSError {
            guard realmVersionRecoveryTryCount < 3 else {
                Log.error("""
                    Error opening realm
                    
                    \(error.localizedDescription)
                    
                    = Fatal Error : Migration of error content is required =
                    
                    """)
                
                self.openRelay.accept(false)
                //                exit(0)
                return
            }
            Log.warning("""
                Error opening realm
                
                \(error.localizedDescription)
                
                = Try Version Recovery: \(realmVersionRecoveryTryCount) =
                
                """)
            realmVersionRecovery(config)
        }
    }
    
    // All Util
    func allObjects<Element: Object>(_ type: Element.Type) -> Results<Element> {
        let realm = try! Realm()
        return realm.objects(type)
    }
    
    // MARK: - Realm Write -
    
    // 절대 중첩되면 안됨
    // ex) 클로저 내에서 클로저를 호출
    /// 기본 램 쓰기
    @discardableResult
    func realmWrite(
        info: String = #function, _
        closure: @escaping (Realm) -> Bool
    ) -> Bool {
        
        objc_sync_enter(self)
        defer {objc_sync_exit(self)}
        
        Log.debug("""
            [Realm] RealmTransaction Synchronized
            
            🚩 is MainThread: \(Thread.current.isMainThread)
            🚩 Thread: \(Thread.current)
            🚩 Call Info: \(info)
            """)
        
        do {
            if let realm = realm {
                try realm.write {
                    if closure(realm) == false {
                        // 램 쓰기 중 강제 중단
                        let userInfo = [NSLocalizedDescriptionKey: "Interrupted Realm Write"]
                        throw NSError(domain: "TW_REALM", code: -1, userInfo: userInfo)
                    }
                }
            } else {
                let userInfo = [NSLocalizedDescriptionKey: "Error Load Realm"]
                throw NSError(domain: "TW_REALM", code: -1, userInfo: userInfo)
            }
        } catch let error as NSError {
            Log.error("Error write Realm: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    @discardableResult
    func realmWrite(
        info: String = #function,
        _ closure: @escaping (Realm) -> Void
    ) -> Bool {
        
        return self.realmWrite { realm -> Bool in
            closure(realm)
            return true
        }
    }
}
