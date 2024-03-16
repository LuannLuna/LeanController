//
//  Configurable.swift
//  LeanController
//
//  Created by Luann Luna on 16/03/24.
//

import Foundation

public protocol Configurable { }

public extension Configurable {

    func with(_ configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}

extension NSObject: Configurable { }
