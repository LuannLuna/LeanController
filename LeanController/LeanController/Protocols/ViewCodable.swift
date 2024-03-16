//
//  ViewCodable.swift
//  LeanController
//
//  Created by Luann Luna on 16/03/24.
//

import Foundation

protocol ViewCodable {
    func setup()
    func setupViews()
    func setupAnchors()
    func setupLayouts()
}

extension ViewCodable {

    func setup() {
        setupViews()
        setupAnchors()
        setupLayouts()
    }

    func setupLayouts() {}

}
