//
//  LineView.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineView: View {
    @ObservedObject var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var valueSpecifier:String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var opacity:Double = 0
    @State private var currentDataNumber: Double = 0
    @State private var hideHorizontalLines: Bool = false
    
    public init(data: [Double],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                valueSpecifier: String? = "%.1f") {
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(TAColor.foregroundColor)
                    .cornerRadius(20)
                    .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
                ZStack(alignment: .topLeading) {
                    Group{
                        Text("\(currentDataNumber, specifier: valueSpecifier)")
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(x: 0, y: 0)
                            .foregroundColor(TAColor.primaryTextColor)
                            .padding([.top, .leading], 20)
                        Text(self.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.secondaryTextColor)
                            .padding(.top, 60)
                            .padding(.leading, 20)
                    }
                    ZStack{
                        GeometryReader{ reader in
                            Line(data: self.data,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width, height: reader.frame(in: .local).height)),
                                 touchLocation: self.$indicatorLocation,
                                 showIndicator: self.$hideHorizontalLines,
                                 minDataValue: .constant(self.data.onlyPoints().min() == nil ? nil : self.data.onlyPoints().min()! - 10),
                                 maxDataValue: .constant(self.data.onlyPoints().max() == nil ? nil : self.data.onlyPoints().max()! + 10),
                                 showBackground: true,
                                 gradient: self.style.gradientColor
                            )
                            .offset(x: 0, y: 0)
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 230)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 230)
                }
            }
            .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onChanged({ value in
                            self.dragLocation = value.location
                            self.indicatorLocation = CGPoint(x: max(value.location.x,0), y: 32)
                            self.opacity = 1
                            self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width, height: 230)
                            self.hideHorizontalLines = true
                        })
                        .onEnded({ value in
                            self.opacity = 0
                            self.hideHorizontalLines = false
                            self.currentDataNumber = data.onlyPoints().last ?? 0
                        })
            )
            .onAppear {
                self.currentDataNumber = data.onlyPoints().last ?? 0
            }
        }
        .frame(height: 230)
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

