//
//  ServiceCreationViewController.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import SwiftEntryKit

class ServiceCreationViewController: BaseNavigationViewController, View {
    
    override var navigationPopGestureEnabled: Bool {
        return false
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width - 16 * 2
        $0.minimumLineSpacing = 12
        $0.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 12, right: 16)
        $0.estimatedItemSize = .init(width: width, height: 92)
        $0.itemSize = UICollectionViewFlowLayout.automaticSize
        $0.headerReferenceSize = .init(width: width, height: 48)
        $0.footerReferenceSize = .init(width: width, height: 60)
        $0.sectionHeadersPinToVisibleBounds = true
        $0.sectionFootersPinToVisibleBounds = true
    }
    private lazy var collectionView = UICollectionView.init(
        frame: .zero,
        collectionViewLayout: self.flowLayout
    ).then {
        $0.alwaysBounceVertical = true
        $0.contentInset.bottom = 108
        $0.backgroundColor = .white
        
        $0.register(ServiceCreationCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(ServiceCreationHeader.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "header")
        $0.register(ServiceCreationFooter.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: "footer")
        
        $0.dragDelegate = self.dataSource
        $0.dropDelegate = self.dataSource
        $0.dragInteractionEnabled = true
    }
    
    private var reusableDisposeBag = DisposeBag()
    private lazy var dataSource = RxCollectionViewDragAndDropSectionedReloadDataSource<ServiceUnitCreationModelSection>(
        configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath) as! ServiceCreationCell
            cell.reactor = reactor
            
            return cell
            
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                
                let title = dataSource[indexPath.section].header
                
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: "header",
                    for: indexPath) as! ServiceCreationHeader
                header.bind(title)
                
                return header
                
            case UICollectionView.elementKindSectionFooter:
                guard let self = self else { return .init(frame: .zero) }
                
                self.reusableDisposeBag = DisposeBag()
                
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: "footer",
                    for: indexPath) as! ServiceCreationFooter
                
                footer.button.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let reactor = self?.reactor else { return }
                        if reactor.templateProcess.clearKey().appendKey(by: "destinations") != nil {
                            self?.navigationPush(
                                type: ServiceCreationSelectStopViewController.self,
                                reactor: reactor.reactorForSelectStop(mode: .create),
                                animated: true,
                                bottomBarHidden: true
                            )
                        }
                    }).disposed(by: self.reusableDisposeBag)
                
                return footer
                
            default:
                return .init(frame: .zero)
            }
        }, moveItem: { [weak self] dataSource, sourceIndexPath, destinationIndexPath in
            self?.reactor?.action.onNext(.move(sourceIndexPath.row, destinationIndexPath.row))
        })
    
    private let requestButton = SRPButton("서비스 생성하기").then {
        $0.isEnabled = false
        $0.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.requestButton)
        self.requestButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "서비스 생성"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func bind() {
        super.bind()
        
        self.backButtonDisposeBag = DisposeBag()
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.dataSource.sectionModels.first?.items.isEmpty == true {
                    self.navigationPop(
                        animated: true,
                        bottomBarHidden: self.navigationPopWithBottomBarHidden
                    )
                } else {
                    //flatMapLatest로 리팩토링 필요!
                    UIAlertController.present(
                        in: self,
                        title: "서비스 생성을 취소하시겠습니까?",
                        style: .alert,
                        actions: [
                            .init(title: "아니오", style: .default),
                            .init(title: "예", style: .destructive)
                        ]).subscribe(onNext: { [weak self] selectedIndex in
                            guard let self = self else { return }
                            if selectedIndex == 1 {
    //                            self.reactor?.action.onNext(.clearCache)
                                self.navigationPop(
                                    animated: true,
                                    bottomBarHidden: self.navigationPopWithBottomBarHidden
                                )
                            }
                        }).disposed(by: self.disposeBag)
                }
            }).disposed(by: self.backButtonDisposeBag)
    }
    
    func bind(reactor: ServiceCreationViewReactor) {
        
        //Action
//        self.rx.viewDidLoad
//            .map { .clearCache }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
        
        self.requestButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Reactor.Action> in
                guard let reactor = self?.reactor else { return .empty() }
                if let repeatCount = reactor.templateProcess.value(selector: "repeat_count") {
                    //반복 획수 받기, 초기화해서 보여주기
                    print("repeat count", repeatCount)
                    let value = repeatCount.asArgument?.ui.asComponent(Int.self)?.defaultValue ?? 1
                    return ServiceCreationRepeatCountViewController.count(value: value)
                        .map { .request(repeat: $0) }
                } else {
                    return .just(.request(repeat: nil))
                }
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCreationCellReactor.self)
            .map(\.initialState)
            .map { reactor.reactorForSummary($0, mode: .update) }
            .subscribe(onNext: { [weak self] cellReactor in
                if reactor.templateProcess.peek(with: "message") != nil {
                    self?.navigationPush(
                        type: ServiceCreationSummaryViewController.self,
                        reactor: cellReactor,
                        animated: true,
                        bottomBarHidden: true
                    )
                }
            }).disposed(by: self.disposeBag)
        
        //State
        let serviceUnits = reactor.state.map(\.serviceUnits).share()
        
        serviceUnits.map { serviceUnits in
            var cellReactors = [ServiceCreationCellReactor]()
            for serviceUnit in serviceUnits {
                let destinationType: ServiceCreationCellReactor.DestinationType = {
                    if serviceUnits.last == serviceUnit {
                        return .destination
                    } else if serviceUnits.first == serviceUnit {
                        return .startingPoint
                    } else if let index = serviceUnits.firstIndex(of: serviceUnit) {
                        return .wayPoint(index)
                    }
                    return .destination
                }()
                let cellReactor = reactor.reactorForCell(serviceUnit, destinationType: destinationType)
                cellReactors.append(cellReactor)
            }
            return cellReactors
        }.map { [.init(header: "\($0.count)개의 정차지", items: $0)] }
        .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
        .disposed(by: self.disposeBag)
        
        serviceUnits.queueing(2)
            .map { ($0[0].count, $0[1].count) }
            .map { ($0 < $1 ? .orderedAscending: ($0 > $1 ? .orderedDescending: .orderedSame)) }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (result: ComparisonResult)  in
                guard let collectionView = self?.collectionView else { return }
                func scrollToBottom() {
                    let destinationItem = reactor.currentState.serviceUnits.count - 1
                    guard destinationItem >= 0 else { return }
                    let indexPath = IndexPath(item: destinationItem, section: 0)
                    collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                }
                switch result {
                case .orderedAscending:
                    scrollToBottom()
                case .orderedDescending:
                    let max = collectionView.contentSize.height - collectionView.bounds.height
                    if collectionView.contentOffset.y > max {
                        scrollToBottom()
                    }
                case .orderedSame:
                    break
                }
            }).disposed(by: self.disposeBag)
        
        serviceUnits.map { $0.isEmpty }
        .subscribe(onNext: { [weak self] isEmpty in
            self?.flowLayout.sectionInset.top = (isEmpty ? 0: 8)
        }).disposed(by: self.disposeBag)
        
        serviceUnits.map { !$0.isEmpty  }
        .bind(to: self.requestButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { !$0.serviceUnits.isEmpty && !$0.isProcessing }
        .bind(to: self.requestButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isProcessing)
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isRequestSuccess)
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                let entryName = ServiceCreationRepeatCountViewController.ViewID
                SwiftEntryKit.dismiss(.specific(entryName: entryName))
                self?.navigationPop(animated: true, bottomBarHidden: false)
                self?.tabBarController?.selectedIndex = 1
            }).disposed(by: self.disposeBag)
        
        reactor.state.map(\.errorMessage)
            .distinctUntilChanged()
            .filterNil()
            .bind(to: Toaster.rx.showToast(color: .redF80003))
            .disposed(by: self.disposeBag)
    }
}
