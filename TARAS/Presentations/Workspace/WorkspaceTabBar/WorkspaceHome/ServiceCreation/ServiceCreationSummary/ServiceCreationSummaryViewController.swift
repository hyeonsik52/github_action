//
//  ServiceCreationSummaryViewController.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/02.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import UITextView_Placeholder

class ServiceCreationSummaryViewController: BaseNavigationViewController, View {
    
    override var navigationPopGestureEnabled: Bool {
        guard let reactor = self.reactor else { return false }
        return (reactor.mode == .update)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 12
        $0.contentInset.bottom = 88
        $0.alwaysBounceVertical = true
        $0.keyboardDismissMode = .onDrag
    }
    
    let stopLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .darkGray303030
        $0.textAlignment = .right
    }
    private let stopSelectButton = UIButton()
    
    let workWaitingSwitchContainer = UIView().then {
        $0.isHidden = true
    }
    let workWaitingSwitch = UISwitch().then {
        $0.onTintColor = .purple4A3C9F
    }
    
    var loadingTypeSwitchContainer = UIView().then {
        $0.isHidden = true
    }
    let loadingTypeSwitch = UISwitch().then {
        $0.onTintColor = .purple4A3C9F
    }
    let loadingTypeSwitchStateLabel = UILabel().then {
        $0.font = .regular[16]
        $0.textColor = .grayA0A0A0
        $0.textAlignment = .right
    }
    
    let detailTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .lightGrayF0F0F0
        $0.textContainerInset = .init(top: 17, left: 13, bottom: 17, right: 13)
        $0.font = .regular[16]
        $0.placeholder = "요청사항을 입력해주세요"
    }
    
    var receiverListContainer = UIView().then {
        $0.isHidden = true
    }
    let receiverLabel = UILabel().then {
        $0.font = .regular[16]
        $0.textColor = .darkGray303030
        $0.numberOfLines = 0
        $0.textAlignment = .right
    }
    private let receiverSelectButton = UIButton()
    
    let confirmButton = SRPButton("정차지 추가")
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        func addSectionView(
            title: String,
            container: UIView? = nil,
            addContentView: (_ container: UIView, _ titleView: UIView, _ sectionView: UIView) -> Void
        ) {
            let sectionContainer = container ?? UIView()
            contentView.addArrangedSubview(sectionContainer)
            
            let sectionView = UIView()
            sectionContainer.addSubview(sectionView)
            sectionView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            
            let label = UILabel().then {
                $0.font = .regular[16]
                $0.textColor = .gray666666
                $0.text = title
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            sectionView.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
            }
            
            addContentView(sectionContainer, label, sectionView)
        }
        
        addSectionView(title: "정차지") { container, titleView, sectionView in
            
            sectionView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
            }
            
            sectionView.addSubview(self.stopLabel)
            self.stopLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.greaterThanOrEqualTo(titleView.snp.trailing)
            }
            
            let arrowImageView = UIImageView(image: .init(named: "enterRightSmall")).then {
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            sectionView.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.stopLabel.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().offset(-16)
                $0.size.equalTo(12)
            }
            
            sectionView.addSubview(self.stopSelectButton)
            self.stopSelectButton.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(self.stopLabel)
                $0.trailing.equalTo(arrowImageView)
            }
        }
        
        addSectionView(
            title: "상/하차",
            container: self.loadingTypeSwitchContainer
        ) { container, titleView, sectionView in
            
            sectionView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
            }
            
            sectionView.addSubview(self.loadingTypeSwitchStateLabel)
            self.loadingTypeSwitchStateLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.greaterThanOrEqualTo(titleView.snp.trailing)
            }
            
            sectionView.addSubview(self.loadingTypeSwitch)
            self.loadingTypeSwitch.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.loadingTypeSwitchStateLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
        
        addSectionView(
            title: "작업대기",
            container: self.workWaitingSwitchContainer
        ) { container, titleView, sectionView in
            
            sectionView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
            }
            
            sectionView.addSubview(self.workWaitingSwitch)
            self.workWaitingSwitch.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.greaterThanOrEqualTo(titleView.snp.trailing)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }

        addSectionView(title: "요청사항") { container, titleView, sectionView in

            container.addSubview(self.detailTextView)
            self.detailTextView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(self.detailTextView.snp.width).multipliedBy(0.6)
            }
        }
        
        addSectionView(
            title: "수신자",
            container: self.receiverListContainer
        ) { container, titleView, sectionView in
            
            sectionView.snp.makeConstraints {
                $0.bottom.equalToSuperview().priority(.low)
            }
            
            container.addSubview(self.receiverLabel)
            self.receiverLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.centerY.equalToSuperview()
                $0.leading.greaterThanOrEqualTo(titleView.snp.trailing)
                $0.bottom.lessThanOrEqualToSuperview()
            }
            
            let arrowImageView = UIImageView(image: .init(named: "enterRightSmall")).then {
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            container.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(14)
                $0.leading.equalTo(self.receiverLabel.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().offset(-16)
                $0.size.equalTo(12)
            }
            
            container.addSubview(self.receiverSelectButton)
            self.receiverSelectButton.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(self.receiverLabel)
                $0.trailing.equalTo(arrowImageView)
            }
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        let padding = (height == 0 ? -24: -(height+8))
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(padding)
        }
        self.scrollView.contentInset.bottom = 60 - padding
    }
    
    override func bind() {
        super.bind()
        
        guard let reactorMode = reactor?.mode else { return }
        
        self.backButtonDisposeBag = DisposeBag()
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch reactorMode {
                case .create:
                    //flatMapLatest로 리팩토링 필요!
                    UIAlertController.present(
                        in: self,
                        title: "정차지 추가를 취소하시겠습니까?",
                        style: .alert,
                        actions: [
                            .init(title: "아니오", style: .default),
                            .init(title: "예", style: .destructive)
                        ]).subscribe(onNext: { [weak self] selectedIndex in
                            guard let self = self else { return }
                            if selectedIndex == 1 {
                                self.navigationPop(
                                    to: ServiceCreationViewController.self,
                                    animated: true,
                                    bottomBarHidden: self.navigationPopWithBottomBarHidden
                                )
                            }
                        }).disposed(by: self.disposeBag)
                case .update:
                    self.navigationPop(
                        animated: true,
                        bottomBarHidden: self.navigationPopWithBottomBarHidden
                    )
                }
            }).disposed(by: self.backButtonDisposeBag)
    }
    
    func bind(reactor: ServiceCreationSummaryViewReactor) {
        
        let title = "정차지 \(reactor.mode.text)"
        self.title = title
        self.confirmButton.setTitle(title, for: .normal)
        
        let serivceUnit = reactor.initialState.serviceUnit
        self.detailTextView.text = serivceUnit.detail
        self.workWaitingSwitch.isOn = serivceUnit.isWorkWaiting ?? false
        self.loadingTypeSwitch.isOn = serivceUnit.isLoadingStop ?? false
        
        //Action
        self.confirmButton.rx.tap
            .map { Reactor.Action.confirm }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.stopSelectButton.rx.tap
            .map { reactor.reactorForSelectStop(mode: .update) }
            .flatMapLatest { [weak self] reactor in
                return ServiceCreationSelectStopViewController.select(on: self, reactor: reactor)
            }.map(Reactor.Action.updateStop)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.workWaitingSwitch.rx.isOn
            .skip(until: self.rx.viewDidAppear)
            .map(Reactor.Action.updateIsWorkWaiting)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.loadingTypeSwitch.rx.isOn
            .skip(until: self.rx.viewDidAppear)
            .map(Reactor.Action.updateIsLoadingStop)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.receiverSelectButton.rx.tap
            .map { reactor.reactorForSelectReceiver(mode: .update) }
            .flatMapLatest { [weak self] reactor in
                return ServiceCreationSelectReceiverViewController.select(on: self, reactor: reactor)
            }.map(Reactor.Action.updateReceivers)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.merge(
            self.detailTextView.rx.didBeginEditing.asObservable(),
            self.detailTextView.rx.text.map {_ in () }
        ).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let textView = self.detailTextView
            if let selectedRange = textView.selectedTextRange {
                let cursorRect = textView.caretRect(for: selectedRange.start)
                let rect = textView.convert(cursorRect, to: self.scrollView)
                self.scrollView.scrollRectToVisible(rect, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        self.detailTextView.rx.text
            .map(Reactor.Action.updateDetail)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        let serviceUnit = reactor.state.map(\.serviceUnit).share()
        
        serviceUnit.map(\.stop?.name)
            .bind(to: self.stopLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        serviceUnit.map { $0.isWorkWaiting == nil }
        .bind(to: self.workWaitingSwitchContainer.rx.isHidden)
        .disposed(by: self.disposeBag)
        
        serviceUnit.map { $0.isLoadingStop == nil }
        .bind(to: self.loadingTypeSwitchContainer.rx.isHidden)
        .disposed(by: self.disposeBag)
        
        serviceUnit.compactMap(\.isLoadingStop)
            .distinctUntilChanged()
            .bind(to: self.loadingTypeSwitch.rx.isOn)
            .disposed(by: self.disposeBag)
        
        serviceUnit.compactMap(\.isLoadingStop)
            .map { $0 ? "상차": "하차" }
            .bind(to: self.loadingTypeSwitchStateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        serviceUnit.compactMap(\.isWorkWaiting)
            .distinctUntilChanged()
            .bind(to: self.workWaitingSwitch.rx.isOn)
            .disposed(by: self.disposeBag)
        
        serviceUnit.map(\.detail)
            .bind(to: self.detailTextView.rx.text)
            .disposed(by: self.disposeBag)
        
        let receivers = serviceUnit.map(\.receivers).share()
        
        receivers.map {
            let paragraph = NSMutableParagraphStyle().then {
                $0.lineSpacing = 8
                $0.alignment = .right
            }
            let attributedString = NSMutableAttributedString(
                string: $0.map(\.name).joined(separator: "\n"),
                attributes: [.paragraphStyle: paragraph]
            )
            return attributedString
        }.bind(to: self.receiverLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        
        receivers.map(\.isEmpty)
            .bind(to: self.receiverListContainer.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isConfirmed)
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationPop(
                    to: ServiceCreationViewController.self,
                    animated: true,
                    bottomBarHidden: true
                )
            }).disposed(by: self.disposeBag)
    }
}
