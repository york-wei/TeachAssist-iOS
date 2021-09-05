//
//  LinksView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

enum LinkSelection {
    case teachAssist
    case myBlueprint
    case moodle
    case yrdsbTwitter
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
                
                VStack(spacing: 15) {
                    Button(action: {
                        viewModel.didTapLink(selection: .teachAssist)
                    }) {
                        LinkButtonView(label: "TeachAssist Website")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.02))
                    Button(action: {
                        viewModel.didTapLink(selection: .myBlueprint)
                    }) {
                        LinkButtonView(label: "My Blueprint")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.02))
                    Button(action: {
                        viewModel.didTapLink(selection: .moodle)
                    }) {
                        LinkButtonView(label: "Moodle")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.02))
                    Button(action: {
                        viewModel.didTapLink(selection: .yrdsbTwitter)
                    }) {
                        LinkButtonView(label: "YRDSB Twitter")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.02))
                }
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            }
            
            if viewModel.showWebsiteView {
                VStack {
                    HStack { Spacer() }
                    Spacer()
                }
                .transition(.move(edge: .trailing))
                .background(Color.red)
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
            currentSelection = selection
            withAnimation {
                showWebsiteView = true
            }
        }
    }
}
