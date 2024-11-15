//
//  SettingsManager.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import SwiftUI
import UIKit

extension Color {
    static var themeAccent: Color {
        SettingsManager.shared.colorAccent
    }
}

@Observable class SettingsManager {
    static let shared = SettingsManager()
    
    var colorAccent: Color {
        didSet {
            let platformColor = UIColor(colorAccent)
            let components = platformColor.cgColor.components ?? []
            UserDefaults.standard.set(components.count > 0 ? components[0] : 0, forKey: "colorAccentRed")
            UserDefaults.standard.set(components.count > 1 ? components[1] : 0, forKey: "colorAccentGreen")
            UserDefaults.standard.set(components.count > 2 ? components[2] : 0, forKey: "colorAccentBlue")
        }
    }
    
    private init() {
        let red = UserDefaults.standard.double(forKey: "colorAccentRed")
        let green = UserDefaults.standard.double(forKey: "colorAccentGreen")
        let blue = UserDefaults.standard.double(forKey: "colorAccentBlue")
        
        if red == 0 && green == 0 && blue == 0 {
            colorAccent = .pink  // Default color
        } else {
            colorAccent = Color(red: red, green: green, blue: blue)
        }
    }
}
