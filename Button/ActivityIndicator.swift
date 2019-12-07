//
//  ActivityIndicator.swift
//  Button
//
//  Created by Will Townsend on 2019-12-06.
//  Copyright © 2019 Overflight. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style
    let color: UIColor?

    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor? = nil) {
        self.style = style
        self.color = color
    }

    func makeUIView(
        context: UIViewRepresentableContext<ActivityIndicator>
    ) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }

    func updateUIView(
        _ view: UIActivityIndicatorView,
        context: UIViewRepresentableContext<ActivityIndicator>
    ) {
        view.startAnimating()
    }

}
