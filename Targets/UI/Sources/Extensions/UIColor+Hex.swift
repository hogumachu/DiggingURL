//
//  UIColor+Hex.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

extension UIColor {
    
    public convenience init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        if hexString.count == 6 {
            var hexNumber: UInt64 = 0
            let scanner = Scanner(string: hexString)
            guard scanner.scanHexInt64(&hexNumber) else { return nil }
            let r, g, b: CGFloat
            r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else if hexString.count == 8 {
            var hexNumber: UInt64 = 0
            let scanner = Scanner(string: hexString)
            guard scanner.scanHexInt64(&hexNumber) else { return nil }
            let r, g, b, a: CGFloat
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            return nil
        }
    }
    
    public var hexString: String {
        let components = cgColor.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = components?[2] ?? 0
        let a = components?[3] ?? 0
        let hexString = String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255)),
            lroundf(Float(a * 255))
        )
        return hexString
    }
    
}
