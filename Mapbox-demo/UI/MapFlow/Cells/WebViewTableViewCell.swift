//
//  WebViewTableViewCell.swift
//  Mapbox-demo
//
//  Created by Sander on 31.03.2021.
//

import UIKit
import WebKit

protocol ContentHeightUpdatable: class {
    func updateContentHeight(_ height: CGFloat, cellTag: Int)
}

class WebViewTableViewCell: UITableViewCell {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    var openUrl: ((URL) -> Void)?
    
    var htmlContent: String? {
        didSet {
            let html = """
           <!doctype html>
           <html>
            <head><meta charset=\"UTF-8\"><title>Document</title><meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\">
               <style>
                 body {
                   font-family: -apple-system;
                   font-size: 14pt;
                   margin: 0;
                 }
               </style>
             </head>
             <body>
               \(htmlContent.orEmpty)
             </body>
           </html>
           """
                
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    weak var delegate: ContentHeightUpdatable?
}

extension WebViewTableViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let scrollHeight = webView.scrollView.contentSize.height
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let height = height as? CGFloat {
                        self.delegate?.updateContentHeight(max(height, scrollHeight), cellTag: self.tag)
                    } else {
                        NSLog("error finished loading === \(error.debugDescription)")
                    }
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let url = navigationAction.request.url {
                openUrl?(url)
            }
            
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
