//
//  LinksView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

enum LinkSelection: Identifiable {
    case teachAssist
    case myBlueprint
    case moodle
    case yrdsbTwitter
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        switch self {
        case .teachAssist:
            return "TeachAssist Website"
        case .myBlueprint:
            return "My Blueprint"
        case .moodle:
            return "Moodle"
        case .yrdsbTwitter:
            return "YRDSB Twitter"
        }
    }
    
    var url: URL {
        switch self {
        case .teachAssist:
            return URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0")!
        case .myBlueprint:
            return URL(string: "https://mypathwayplanner.yrdsb.ca/LoginFormIdentityProvider/Login.aspx?ReturnUrl=%2fLoginFormIdentityProvider%2fDefault.aspx")!
        case .moodle:
            return URL(string: "https://moodle2.yrdsb.ca/login/index.php")!
        case .yrdsbTwitter:
            return URL(string: "https://twitter.com/yrdsb")!
        }
    }
}

struct LinksView: View {
    @Binding var show: Bool
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                // Top bar
                HStack(alignment: .center) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        show = false
                    }) {
                        SmallButtonView(imageName: "xmark")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.07))
                    Spacer()
                    Text("Student Links")
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
                
                ZStack {
                    Rectangle()
                        .foregroundColor(TAColor.foregroundColor)
                        .cornerRadius(20)
                        .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
                    VStack {
                        ForEach([LinkSelection.teachAssist, LinkSelection.myBlueprint, LinkSelection.moodle, LinkSelection.yrdsbTwitter]) { linkSelection in
                            Button(action: {
                                viewModel.didTapLink(selection: linkSelection)
                            }) {
                                ArrowButtonView(label: linkSelection.name)
                            }
                            if linkSelection != .yrdsbTwitter {
                                Divider()
                            }
                        }
                    }
                    .padding([.top, .bottom], 10)
                }
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            }
            
            if viewModel.showWebsiteView {
                WebsiteView(show: $viewModel.showWebsiteView, linkSelection: viewModel.currentSelection, userState: viewModel.userState)
                    .transition(.move(edge: .trailing))
                    .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .background(TAColor.backgroundColor)
    }
}

extension LinksView {
    class ViewModel: ObservableObject {
        let userState: UserState
        @Published var currentSelection: LinkSelection = .teachAssist
        @Published var showWebsiteView: Bool = false
        
        init(userState: UserState) {
            self.userState = userState
        }
        
        func didTapLink(selection: LinkSelection) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            currentSelection = selection
            withAnimation {
                showWebsiteView = true
            }
        }
    }
}
