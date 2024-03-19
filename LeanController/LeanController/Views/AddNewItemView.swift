//
//  AddNewItemView.swift
//  LeanController
//
//  Created by Luann Luna on 19/03/24.
//

import UIKit

class AddNewItemView: UIView {
    private typealias Strings = LeanLocalizable

    private lazy var view = UIView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 44
        )
    ).with {
        $0.backgroundColor = .lightText
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var textField = UITextField(frame: view.frame).with {
        $0.leftView = UIView(frame: view.frame).with {
            $0.widthAnchor.constraint(equalToConstant: 10).isActive = true
        }
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupView(placeholder: String, delegate: UITextFieldDelegate) {
        textField.placeholder = placeholder
        textField.delegate = delegate
    }
}

extension AddNewItemView: ViewCodable {
    func setupViews() {
        addSubview(view)
        view.addSubview(textField)
    }
    
    func setupAnchors() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
    }
}
