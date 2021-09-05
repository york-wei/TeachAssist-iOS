//
//  TrendView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct TrendView: View {
    let averageTrend: [Double]
    let kTrend: [Double]
    let tTrend: [Double]
    let cTrend: [Double]
    let aTrend: [Double]
    let noTrendsAvailable: Bool
    
    init(course: Course) {
        var averageTrend = [Double]()
        var kTrend = [Double]()
        var tTrend = [Double]()
        var cTrend = [Double]()
        var aTrend = [Double]()
        var kSum = 0.0
        var kWeightSum = 0.0
        var tSum = 0.0
        var tWeightSum = 0.0
        var cSum = 0.0
        var cWeightSum = 0.0
        var aSum = 0.0
        var aWeightSum = 0.0
        var oSum = 0.0
        var oWeightSum = 0.0
        var fSum = 0.0
        var fWeightSum = 0.0
        for evaluation in course.evaluations {
            var kAverage: Double?
            var tAverage: Double?
            var cAverage: Double?
            var aAverage: Double?
            var oAverage: Double?
            var fAverage: Double?
            if let kPercent = evaluation.knowledge.percent,
               let kWeight = evaluation.knowledge.weight,
               kWeight > 0 {
                kSum += kPercent * kWeight
                kWeightSum += kWeight
                kTrend.append(kSum / kWeightSum)
            }
            if kWeightSum != 0 {
                kAverage = kSum / kWeightSum
            }
            if let tPercent = evaluation.thinking.percent,
               let tWeight = evaluation.thinking.weight,
               tWeight > 0 {
                tSum += tPercent * tWeight
                tWeightSum += tWeight
                tTrend.append(tSum / tWeightSum)
            }
            if tWeightSum != 0 {
                tAverage = tSum / tWeightSum
            }
            if let cPercent = evaluation.communication.percent,
               let cWeight = evaluation.communication.weight,
               cWeight > 0 {
                cSum += cPercent * cWeight
                cWeightSum += cWeight
                cTrend.append(cSum / cWeightSum)
            }
            if cWeightSum != 0 {
                cAverage = cSum / cWeightSum
            }
            if let aPercent = evaluation.application.percent,
               let aWeight = evaluation.application.weight,
               aWeight > 0 {
                aSum += aPercent * aWeight
                aWeightSum += aWeight
                aTrend.append(aSum / aWeightSum)
            }
            if aWeightSum != 0 {
                aAverage = aSum / aWeightSum
            }
            if let oPercent = evaluation.other.percent,
               let oWeight = evaluation.other.weight,
               oWeight > 0 {
                oSum += oPercent * oWeight
                oWeightSum += oWeight
            }
            if oWeightSum != 0 {
                oAverage = oSum / oWeightSum
            }
            if let fPercent = evaluation.final.percent,
               let fWeight = evaluation.final.weight,
               fWeight > 0 {
                fSum += fPercent * fWeight
                fWeightSum += fWeight
            }
            if fWeightSum != 0 {
                fAverage = fSum / fWeightSum
            }
            var kCourseWeight = course.knowledge.weight ?? 0
            var tCourseWeight = course.thinking.weight ?? 0
            var cCourseWeight = course.communication.weight ?? 0
            var aCourseWeight = course.application.weight ?? 0
            var oCourseWeight = course.other.weight ?? 0
            var fCourseWeight = course.final.weight ?? 0
            if kWeightSum == 0 || kAverage == nil {
                kCourseWeight = 0
            }
            if tWeightSum == 0 || tAverage == nil {
                tCourseWeight = 0
            }
            if cWeightSum == 0 || cAverage == nil {
                cCourseWeight = 0
            }
            if aWeightSum == 0 || aAverage == nil {
                aCourseWeight = 0
            }
            if oWeightSum == 0 || oAverage == nil {
                oCourseWeight = 0
            }
            if fWeightSum == 0 || fAverage == nil {
                fCourseWeight = 0
            }
            if(kCourseWeight + tCourseWeight + cCourseWeight + aCourseWeight + oCourseWeight + fCourseWeight != 0) {
                averageTrend.append((((kAverage ?? 0) * kCourseWeight) + ((tAverage ?? 0) * tCourseWeight) + ((cAverage ?? 0) * cCourseWeight) + ((aAverage ?? 0) * aCourseWeight) + ((oAverage ?? 0) * oCourseWeight) + ((fAverage ?? 0) * fCourseWeight)) / (kCourseWeight + tCourseWeight + cCourseWeight + aCourseWeight + oCourseWeight + fCourseWeight))
            }
        }
        self.averageTrend = averageTrend
        self.kTrend = kTrend
        self.tTrend = tTrend
        self.cTrend = cTrend
        self.aTrend = aTrend
        noTrendsAvailable = averageTrend.count < 2 &&
            kTrend.count < 2 && tTrend.count < 2 && cTrend.count < 2 && aTrend.count < 2
    }
    
    var body: some View {
        if noTrendsAvailable {
            Text("No Trends Available")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(TAColor.primaryTextColor)
                .padding([.top, .bottom, .trailing, .leading], TAPadding.viewEdgePadding)
        } else {
            VStack(spacing: 15) {
                if averageTrend.count > 1 {
                    LineView(data: averageTrend, title: "Course Average", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
                }
                if kTrend.count > 1 {
                    LineView(data: kTrend, title: "Knowledge", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
                }
                if tTrend.count > 1 {
                    LineView(data: tTrend, title: "Thinking", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
                }
                if cTrend.count > 1 {
                    LineView(data: cTrend, title: "Communication", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
                }
                if aTrend.count > 1 {
                    LineView(data: aTrend, title: "Application", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
                }
            }
            .padding([.top, .bottom, .trailing, .leading], TAPadding.viewEdgePadding)
        }
    }
}
