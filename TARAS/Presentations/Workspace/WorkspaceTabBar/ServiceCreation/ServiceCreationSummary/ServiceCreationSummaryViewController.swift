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

class ServiceCreationSummaryViewController: BaseNavigationViewController, View {
    
    override var navigationPopGestureEnabled: Bool {
        guard let reactor = self.reactor else { return false }
        return (reactor.mode == .update)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 12
        $0.contentInset.bottom = 88
        $0.alwaysBounceVertical = true
    }
    
    private let stopLabel = UILabel().then {
        $0.font = .regular[16]
        $0.textColor = .darkGray303030
    }
    private let stopSelectButton = UIButton()
    
    private let receiverLabel = UILabel().then {
        $0.font = .regular[16]
        $0.textColor = .darkGray303030
    }
    private let receiverSelectButton = UIButton()
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .lightGrayF1F1F1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let detailTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.grayC9C9C9.cgColor
        $0.layer.borderWidth = 1
        $0.textContainerInset = .init(top: 9, left: 5, bottom: 9, right: 5)
        $0.textColor = .gray666666
    }
    
    private let detailSelectButton = UIButton()
    
    private let confirmButton = SRPButton("생성하기").then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 24
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        func addSectionView(
            title: String,
            imageName: String,
            addContentView: (_ container: UIView, _ sectionView: UIView) -> Void
        ) {
            let sectionContainer = UIView()
            contentView.addArrangedSubview(sectionContainer)
            
            let sectionView = UIView()
            sectionContainer.addSubview(sectionView)
            sectionView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(42)
            }
            
            let icon = UIImageView(image: UIImage(named: imageName))
            sectionView.addSubview(icon)
            icon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.size.equalTo(24)
            }
            
            let label = UILabel().then {
                $0.font = .medium[20]
                $0.textColor = .gray666666
                $0.text = title
            }
            sectionView.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(icon.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().offset(-16)
            }
            
            addContentView(sectionContainer, sectionView)
        }
        
        addSectionView(title: "위치", imageName: "iconEtcMapMarker") { container, sectionView in
            
            let sectionContentView = UIView()
            container.addSubview(sectionContentView)
            sectionContentView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            sectionContentView.addSubview(self.stopLabel)
            self.stopLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(48)
            }
            
            let arrowImageView = UIImageView(image: .init(named: "iconBkChevronRight16"))
            sectionContentView.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.stopLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-24)
                $0.size.equalTo(16)
            }
            
            sectionContentView.addSubview(self.stopSelectButton)
            self.stopSelectButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        addSectionView(title: "작업자", imageName: "iconGySend") { container, sectionView in
            
            let sectionContentView = UIView()
            container.addSubview(sectionContentView)
            sectionContentView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            sectionContentView.addSubview(self.receiverLabel)
            self.receiverLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(48)
            }
            
            let arrowImageView = UIImageView(image: .init(named: "iconBkChevronRight16"))
            sectionContentView.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.receiverLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-24)
                $0.size.equalTo(16)
            }
            
            sectionContentView.addSubview(self.receiverSelectButton)
            self.receiverSelectButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        addSectionView(title: "요청사항", imageName: "iconGyMessage") { container, sectionView in
            
            let contentStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fill
                $0.spacing = 8
            }
            container.addSubview(contentStackView)
            contentStackView.snp.makeConstraints {
                $0.top.equalTo(sectionView.snp.bottom)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(96)
            }
            
            contentStackView.addArrangedSubview(self.imageView)
            self.imageView.snp.makeConstraints {
                $0.width.equalTo(96)
            }
            
            contentStackView.addArrangedSubview(self.detailTextView)
            
            container.addSubview(self.detailSelectButton)
            self.detailSelectButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "서비스 요청"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
                        title: "목적지 생성을 취소하시겠습니까?",
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
        
        self.detailTextView.text = reactor.initialState.serviceUnit.detail
        self.confirmButton.setTitle("\(reactor.mode.text)하기", for: .normal)
        
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
        
        self.receiverSelectButton.rx.tap
            .map { reactor.reactorForSelectReceiver(mode: .update) }
            .flatMapLatest { [weak self] reactor in
                return ServiceCreationSelectReceiverViewController.select(on: self, reactor: reactor)
            }.map(Reactor.Action.updateReceiver)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.detailSelectButton.rx.tap
            .map { reactor.reactorForDetail(mode: .update) }
            .flatMapLatest { [weak self] reactor in
                return ServiceCreationDetailViewController.update(on: self, reactor: reactor)
            }.map(Reactor.Action.updateDetail)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        let serviceUnit = reactor.state.map(\.serviceUnit).share(replay: 1)
        
        serviceUnit.map(\.stop?.name)
            .bind(to: self.stopLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        serviceUnit.map(\.receiver?.name)
            .bind(to: self.receiverLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        serviceUnit.map(\.detail)
            .bind(to: self.detailTextView.rx.text)
            .disposed(by: self.disposeBag)
        
//        serviceUnit.map(\.attachmentId)
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
//            .map { fileName -> UIImage? in
//                guard let fileName = fileName,
//                      let imageData = Caching.instance.load(fileName: fileName) else { return nil }
//                return UIImage(data: imageData)
//            }.observe(on: MainScheduler.instance)
//            .bind(to: self.imageView.rx.image)
//            .disposed(by: self.disposeBag)
        
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
