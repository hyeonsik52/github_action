//
//  FindAccountIdResultViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class FindAccountIdResultViewController: BaseViewController, ReactorKit.View {

    enum Text {
        static let FAIRVC_1 = "로그인하기"
    }
    
    private let findAccountView = FindAccountIdResultView()
    private let nextButton = TRSButton(Text.FAIRVC_1)
    

    // MARK: - Life Cycles
    
    override func setupConstraints() {

        self.view.addSubview(self.findAccountView)
        self.findAccountView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.top.equalTo(self.findAccountView.snp.bottom)
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    // MARK: - ReactorKit
    
    func bind(reactor: FindAccountIdResultViewReactor) {
        
        // Action
        self.nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.findAccountView.findPasswordButton.rx.tap
            .map(reactor.reactorForFindPassword)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = FindAccountIdViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state
            .subscribe(onNext: { [weak self] ids in
                self?.findAccountView.bind(ids: ids)
            }).disposed(by: self.disposeBag)
    }
}
