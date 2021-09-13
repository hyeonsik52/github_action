//
//  HelpViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import SnapKit
import Then
import WebKit

class HelpViewController: BaseNavigatableViewController {
    
    lazy var webView = WKWebView().then {
        $0.navigationDelegate = self
    }
    
    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.webView.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints {
            $0.size.equalTo(76)
            $0.center.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - 도움말 주소
        self.request(url: "http://www.twinny.co.kr")
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "도움말"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    func request(url: String) {
        self.webView.load(URLRequest(url: URL(string: url)!))
    }
}

extension HelpViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
}
