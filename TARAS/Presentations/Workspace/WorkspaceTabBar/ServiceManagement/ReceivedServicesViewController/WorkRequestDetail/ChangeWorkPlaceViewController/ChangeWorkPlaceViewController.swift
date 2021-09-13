//
//  ChangeWorkPlaceViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/15.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import UITextView_Placeholder
import PanModal

protocol ChangeWorkPlaceViewControllerDelegate: class {
    func didAccept()
}

class ChangeWorkPlaceViewController: BaseViewController, View {

    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "navi-back"), for: .normal)
    }
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "navi-close"), for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.font = .bold.20
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "작업 위치"
    }
    private let placeTextView = UITextView().then {
        $0.font = .bold.18
        $0.textColor = .black
        $0.attributedPlaceholder = NSAttributedString(string: "설정된 위치 정보가 없습니다.",
        attributes: [.font: Font.bold.18,
                     .foregroundColor: UIColor.black.withAlphaComponent(0.3)])
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.isSelectable = false
        $0.textContainerInset = .zero
    }
    private let editPlaceButton = UIButton().then {
        var attributedString = NSAttributedString(string: "위치 선택",
                                                  attributes: [.font: Font.bold.14,
                                                               .foregroundColor: UIColor.purple4A3C9F,
                                                               .underlineStyle: 1,
                                                               .underlineColor: UIColor.purple4A3C9F])
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    private let allowButton = UIButton().then {
        $0.setTitle("이 위치로 수락하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.grayA5A5A5, for: .disabled)
        $0.titleLabel?.font = .bold.15
        $0.clipsToBounds = true
        $0.cornerRadius = 10
    }
    
    weak var delegate: ChangeWorkPlaceViewControllerDelegate?
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .white
        
        let titleBar = UIView()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        titleBar.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(20)
        }
        
        titleBar.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.backButton.snp.trailing).offset(16)
        }
        
        titleBar.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-26)
            $0.width.height.equalTo(20)
        }
        
        let placeContainer = UIView().then {
            $0.backgroundColor = .lightGrayF1F1F1
            $0.clipsToBounds = true
            $0.cornerRadius = 8
        }
        
        self.view.addSubview(placeContainer)
        placeContainer.snp.makeConstraints {
            $0.top.equalTo(titleBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
        }
        
        placeContainer.addSubview(self.placeTextView)
        self.placeTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-32)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        self.view.addSubview(self.editPlaceButton)
        self.editPlaceButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(placeContainer.snp.bottom).offset(20)
        }
        
        self.view.addSubview(self.allowButton)
        self.allowButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            $0.height.equalTo(60)
        }
    }
    
    func bind(reactor: ChangeWorkPlaceViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.editPlaceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
                let viewController = SelectPlaceViewController()
                viewController.reactor = reactor.reactorForSelectPlace()
                viewController.delegate = self
                let navigationController = PanModalFullNavigationController(rootViewController: viewController)
                
                self?.presentPanModal(navigationController)
            })
            .disposed(by: self.disposeBag)
        
        self.allowButton.rx.tap
            .map { Reactor.Action.accept }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.map { $0.place?.name }
            .bind(to: self.placeTextView.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.place != nil }
            .bind(to: self.allowButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.place != nil }
            .map { $0 ? UIColor.purple4A3C9F: UIColor.grayE6E6E6}
            .bind(to: self.allowButton.rx.backgroundColor)
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.place == nil }
            .map { $0 ? "위치 선택": "위치 편집" }
            .map {
                NSAttributedString(
                    string: $0,
                    attributes: [.font: Font.bold.14,
                                 .foregroundColor: UIColor.purple4A3C9F,
                                 .underlineStyle: 1,
                                 .underlineColor: UIColor.purple4A3C9F]
                )
        }
        .bind(to: self.editPlaceButton.rx.attributedTitle(for: .normal))
        .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isAccepted }
        .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didAccept()
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}

extension ChangeWorkPlaceViewController: SelectPlaceViewControllerDelegate {
    
    func didSelect(_ place: ServicePlace) {
        guard let reactor = self.reactor else { return }
        reactor.action.onNext(.update(place))
    }
}

extension ChangeWorkPlaceViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
}
