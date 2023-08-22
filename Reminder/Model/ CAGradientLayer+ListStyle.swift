//
//   CAGradientLayer+ListStyle.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 16/08/2023.
//

import UIKit

extension CAGradientLayer {
    
    //Because you declare the function in an extension on CAGradientLayer,
    //the capitalized Self in the return type refers to the CAGradientLayer type.
    static func gradiantLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}
