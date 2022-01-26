//
//  ServiceCreationSelectReceiverViewController.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class ServiceCreationSelectReceiverViewController: BaseNavigationViewController, View {
    
    private let topContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 12
    }
    
    private lazy var selectedUserListView = TRSTagListView().then {
        $0.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.tagListDelegate = self
        $0.isHidden = true
    }
    private let searchView = TRSSearchView(placeholder: "이름(초성) 검색", usingRecentSearchTerms: false)
    private let listPlaceholderView = TRSListPlaceholderView()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.alwaysBounceVertical = true
        $0.separatorStyle = .none
        
        $0.keyboardDismissMode = .onDrag
        
        $0.register(ServiceUnitTargetCell.self, forCellReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
        $0.backgroundView = self.listPlaceholderView
    }
    
    private let tableViewDataSource = RxTableViewSectionedReloadDataSource<ServiceUnitTargetModelSection>(
        configureCell: { dataSource, tableView, indexPath, cellReactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceUnitTargetCell
            cell.reactor = cellReactor
            return cell
        }
    )
    
    let confirmButton = SRPButton("0명 선택", appearance: .v2)
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.topContainer)
        self.topContainer.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.topContainer.addArrangedSubview(self.selectedUserListView)
        self.selectedUserListView.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        self.topContainer.addArrangedSubview(self.searchView)
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.topContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        let bottomContainer = UIView()
        self.view.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints {
            $0.top.equalTo(self.tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomContainer.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "수신자 선택"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: ServiceCreationSelectReceiverViewReactor) {
        
        //Action
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .withLatestFrom(self.searchView.searchTerm)
            .map(Reactor.Action.refresh)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.searchView.searchTerm
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .map(Reactor.Action.refresh)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceUnitTargetCellReactor.self)
            .map(\.initialState)
            .map(Reactor.Action.select)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        if reactor.mode == .create {
            self.confirmButton.rx.tap
                .map { reactor.reactorForSummary(mode: .create) }
                .subscribe(onNext: { [weak self] reactor in
                    self?.navigationPush(
                        type: ServiceCreationSummaryViewController.self,
                        reactor: reactor,
                        animated: true,
                        bottomBarHidden: true
                    )
                }).disposed(by: self.disposeBag)
        }
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.listPlaceholderView.disconnectedRetryButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                reactor.action.onNext(.refresh(term: self?.searchView.searchTerm.value))
            }).disposed(by: self.disposeBag)
        
        //State
        reactor.state.map(\.users)
            .map { [.init(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.tableViewDataSource))
            .disposed(by: self.disposeBag)
        
//        reactor.state.map(\.isLoading)
//            .distinctUntilChanged()
//            .bind(to: self.activityIndicatorView.rx.isAnimating)
//            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if !isLoading {
                    if self?.tableView.refreshControl?.isRefreshing == true {
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.refreshControl?.endRefreshing()
                        }
                    }
                }
            }).disposed(by: self.disposeBag)
        
        let selectedUsers = reactor.state.map(\.selectedUsers).share()
        
        selectedUsers.map { !$0.isEmpty }
        .bind(to: self.confirmButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        selectedUsers.map { "\($0.count)명 선택" }
        .bind(to: self.confirmButton.rx.title())
        .disposed(by: self.disposeBag)
        
        selectedUsers
            .subscribe(onNext: { [weak self] users in
                guard let self = self else { return }
                self.selectedUserListView.setTags(users)
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    animations: {
                        self.selectedUserListView.isHidden = users.isEmpty
                        self.topContainer.layoutIfNeeded()
                    },
                    completion: { success in
                        self.selectedUserListView.isHidden = users.isEmpty
                    }
                )
            }).disposed(by: self.disposeBag)
        
        reactor.state.map(\.placeholderState)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                var state = state
                if state == .resultNotFound, self?.searchView.searchTerm.value?.isEmpty ?? true {
                    state = nil
                }
                self?.listPlaceholderView.update(state)
            }).disposed(by: self.disposeBag)
    }
}

extension ServiceCreationSelectReceiverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard self.tableViewDataSource[indexPath].isEnabled else { return }
        tableView.cellForRow(at: indexPath)?.backgroundView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundView?.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 48
        if self.tableViewDataSource[indexPath].isSeparated {
            height += 8 + 1 + 8
        }
        return height
    }
}

extension ServiceCreationSelectReceiverViewController: TRSTagListViewDelegate {
    
    func tagListView(_ tagListView: TRSTagListView, didSelect model: TRSTagListViewModel) {
        //...
    }
    
    func tagListView(_ tagListView: TRSTagListView, didRemove model: TRSTagListViewModel) {
        guard let reactor = self.reactor,
              var model = reactor.currentState.selectedUsers.first(where: { $0.id == model.id })
        else { return }
        model.isSelected.toggle()
        reactor.action.onNext(.select(model: model))
    }
}
