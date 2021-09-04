//
//  RefreshControl.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-30.
//

// Taken from https://prafullkumar77.medium.com/how-to-making-pure-swiftui-pull-to-refresh-b497d3639ee5

import SwiftUI

struct RefreshControl: View {
    var coordinateSpace: CoordinateSpace
    var onRefresh: () -> Void
    @State var refresh: Bool = false
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: coordinateSpace).midY > 60) {
                Spacer()
                    .onAppear {
                        if refresh == false {
                            onRefresh()
                        }
                        refresh = true
                    }
            } else if (geo.frame(in: coordinateSpace).maxY < 1) {
                Spacer()
                    .onAppear {
                        refresh = false
                    }
            }
            ZStack(alignment: .center) {
                if refresh {
                    ProgressView()
                } else {
                    ForEach(0..<8) { tick in
                          VStack {
                              Rectangle()
                                .fill(Color(UIColor.tertiaryLabel))
                                .opacity((Int((geo.frame(in: coordinateSpace).midY)/7) < tick) ? 0 : 1)
                                  .frame(width: 3, height: 7)
                                .cornerRadius(3)
                              Spacer()
                      }.rotationEffect(Angle.degrees(Double(tick)/(8) * 360))
                   }.frame(width: 20, height: 20, alignment: .center)
                }
            }.frame(width: geo.size.width)
        }
        .padding(.top, -20)
    }
}
