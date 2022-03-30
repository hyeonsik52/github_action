//
//  ServiceCreationDetailViewController.swift
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

class ServiceCreationDetailViewController: BaseNavigationViewController, View {
    
    private let addImageButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "iconBkPlus"), for: .normal)
        $0.setBackgroundColor(color: .lightGrayF1F1F1, forState: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    private let imageContainer = UIView().then {
        $0.isHidden = true
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private let removeButton = UIButton().then {
        $0.setImage(UIImage(named: "iconBkExCircle"), for: .normal)
    }
    
    private(set) lazy var detailTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.grayC9C9C9.cgColor
        $0.layer.borderWidth = 1
        $0.textContainerInset = .init(top: 9, left: 5, bottom: 9, right: 5)
        $0.textColor = .gray666666
        $0.placeholder = "요청사항을 입력해 주세요."
        $0.placeholderColor = .gray787878
        $0.delegate = self
    }
    
    let confirmButton = SRPButton("입력 완료").then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let contentStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 8
        }
        self.view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(96)
        }
        
        let imageStackView = UIStackView().then {
            $0.distribution = .fill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        contentStackView.addArrangedSubview(imageStackView)
        imageStackView.snp.makeConstraints {
            $0.width.equalTo(96)
        }
        
        imageStackView.addArrangedSubview(self.addImageButton)
        imageStackView.addArrangedSubview(self.imageContainer)
        
        self.imageContainer.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.imageContainer.addSubview(self.removeButton)
        self.removeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        contentStackView.addArrangedSubview(self.detailTextView)
        
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
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        let padding = (height == 0 ? -24: -(height+8))
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(padding)
        }
    }
    
    func bind(reactor: ServiceCreationDetailViewReactor) {
        
        //Placeholder
        self.detailTextView.text = reactor.serviceUnit.detail
//        if let fileName = reactor.serviceUnit.attachmentId {
//            DispatchQueue.global(qos: .userInteractive).async {
//                guard let imageData = Caching.instance.load(fileName: fileName),
//                      let iamge = UIImage(data: imageData) else { return }
//                DispatchQueue.main.async { [weak self] in
//                    self?.imageView.image = iamge
//                    self?.imageContainer.isHidden = false
//                    self?.addImageButton.isHidden = true
//                }
//            }
//        }
        
        //Action
//        self.addImageButton.rx.tap
//            .do(onNext: { [weak self] in
//                self?.view.endEditing(true)
//            }).flatMap {
//                UIAlertController.show(
//                    .actionSheet,
//                    title: "사진 첨부하기",
//                    items: ["카메라", "앨범에서 사진 선택"]
//                )
//            }.flatMap { [weak self] (index, _) -> Observable<PhotoInfo> in
//                if index == 0 {
//                    return PhotoPickerController.takePhoto(viewController: self)
//                } else {
//                    return AlbumViewController.pickPhoto(viewController: self)
//                }
//            }.map(\.fileName)
//            .map(Reactor.Action.setPicture)
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//        
//        self.removeButton.rx.tap
//            .map { .setPicture(nil) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap
            .withLatestFrom(self.detailTextView.rx.text)
            .map(Reactor.Action.confirm)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
//        let picture = reactor.state.map(\.picture).share()
//
//        picture.map { $0 == nil }
//        .bind(to: self.imageContainer.rx.isHidden)
//        .disposed(by: self.disposeBag)
//
//        picture.map { $0 != nil }
//        .bind(to: self.addImageButton.rx.isHidden)
//        .disposed(by: self.disposeBag)
        
//        picture
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
//            .map { fileName -> UIImage? in
//                guard let fileName = fileName,
//                      let imageData = Caching.instance.load(fileName: fileName) else { return nil }
//                return UIImage(data: imageData)
//            }.observe(on: MainScheduler.instance)
//            .bind(to: self.imageView.rx.image)
//            .disposed(by: self.disposeBag)
        
        if reactor.mode == .create {
            reactor.state.map(\.isConfirmed)
                .distinctUntilChanged()
                .filter { $0 == true }
                .map {_ in reactor.reactorForSummary(mode: .create) }
                .subscribe(onNext: { [weak self] reactor in
                    self?.navigationPush(
                        type: ServiceCreationSummaryViewController.self,
                        reactor: reactor,
                        animated: true,
                        bottomBarHidden: true
                    )
                }).disposed(by: self.disposeBag)
        }
    }
}

extension ServiceCreationDetailViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.shouldChangeText(in: range, replacementText: text, policy: .requestMessage)
    }
}
