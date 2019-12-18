//
//  WebViewController.swift
//  Eko Task
//
//  Created by apple on 12/17/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url = "https://github.com"
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webViewURL = URL(string: url)!
        webView.load(URLRequest(url: webViewURL))
        webView.allowsBackForwardNavigationGestures = true
    }
}
