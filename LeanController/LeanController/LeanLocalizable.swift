//
//  LeanLocalizable.swift
//  LeanController
//
//  Created by Luann Luna on 16/03/24.
//

import Foundation

enum LeanLocalizable: String {
    case title
    case placeholder

    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }
}
