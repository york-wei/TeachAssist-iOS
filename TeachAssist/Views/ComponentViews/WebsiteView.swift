//
//  WebsiteView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI
import WebKit

struct WebsiteView: View {
    @Binding var show: Bool
    let linkSelection: LinkSelection
    let userState: UserState
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        show = false
                    }
                }) {
                    SmallButtonView(imageName: "chevron.left")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
                Spacer()
                Text(linkSelection.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                Spacer()
                Button(action: {
                }) {
                    SmallButtonView(imageName: "xmark")
                }
                .opacity(0)
            }
                .padding(.top, 40)
                .padding([.trailing, .leading], TAPadding.viewEdgePadding)
            WebView(linkSelection: linkSelection, userState: userState)
                .padding(.top, TAPadding.viewEdgePadding)
                .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .background(TAColor.backgroundColor)
    }
}

struct WebView: UIViewRepresentable {
    
    let linkSelection: LinkSelection
    let userState: UserState
    let web = WKWebView()
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self, linkSelection: linkSelection, username: userState.username, password: userState.password)
    }
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        web.allowsBackForwardNavigationGestures = true
        let request = URLRequest(url: linkSelection.url)
        web.load(request)
        web.navigationDelegate = context.coordinator
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var webView: WebView
        var linkSelection: LinkSelection
        var username: String
        var password: String
        
        var selectedLogin = false
        
        init(_ parent: WebView, linkSelection: LinkSelection, username: String, password: String) {
            self.webView = parent
            self.linkSelection = linkSelection
            self.username = username
            self.password = password
        }
                
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if webView.url == LinkSelection.teachAssist.url { //If WebView at login page
                self.webView.web.evaluateJavaScript("document.getElementsByName('username')[0].value='\(username)'", completionHandler: nil)
                self.webView.web.evaluateJavaScript("document.getElementsByName('password')[0].value='\(password)'", completionHandler: nil)
                self.webView.web.evaluateJavaScript("document.getElementsByName('submit')[0].click();", completionHandler: nil)
            } else if webView.url == LinkSelection.myBlueprint.url {
                self.webView.web.evaluateJavaScript("document.getElementsByName('UserName')[0].value='\(username)'", completionHandler: nil)
                self.webView.web.evaluateJavaScript("document.getElementsByName('Password')[0].value='\(password)'", completionHandler: nil)
                self.webView.web.evaluateJavaScript("document.getElementsByName('LoginButton')[0].click();", completionHandler: nil)
            } else if webView.url == LinkSelection.moodle.url {
                self.webView.web.evaluateJavaScript("document.getElementsByName('username')[0].value='\(username)'", completionHandler: nil)
                self.webView.web.evaluateJavaScript("document.getElementsByName('password')[0].value='\(password)'", completionHandler: nil)
            }
        }
    }
}
