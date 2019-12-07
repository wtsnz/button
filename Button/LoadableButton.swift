//
//  LoadableButton.swift
//  Button
//
//  Created by Will Townsend on 2019-12-06.
//  Copyright © 2019 Overflight. All rights reserved.
//

import SwiftUI

struct LoadingButton<Label> : View where Label : View {

    private enum ButtonGestureState {
        case inactive
        case pressing
        case outOfBounds

        var isPressed: Bool {
            switch self {
            case .pressing:
                return true
            default:
                return false
            }
        }
    }

    @Environment(\.loadingButtonStyle) var style: AnyLoadingButtonStyle

    @GestureState private var dragState = ButtonGestureState.inactive
    @State private var isPressed = false

    private let action: () -> Void
    private let label: () -> Label

    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    /// Declares the content and behavior of this view.
    var body: some View {

        let dragGesture = DragGesture(minimumDistance: 0)
            .updating($dragState, body: { value, state, transaction in
                let distance = sqrt(
                    abs(value.translation.height) + abs(value.translation.width)
                )

                if distance > 10 {
                    state = .outOfBounds
                } else {
                    state = .pressing
                }
            })
            .onChanged({ value in
                withAnimation(.easeInOut(duration: 0.16)) {
                    self.isPressed = self.dragState.isPressed
                }
            })
            .onEnded { _ in
                if self.isPressed {
                    self.action()
                }

                withAnimation(.easeInOut(duration: 0.16)) {
                    self.isPressed = self.dragState.isPressed
                }
            }

        let configuration = LoadingButtonStyleConfiguration(
            isPressed: isPressed,
            label: AnyView(self.label())
        )

        return style.makeBody(configuration: configuration)
                    .gesture(dragGesture)
    }
}

// MARK: - Custom Environment Key

extension EnvironmentValues {
    var loadingButtonStyle: AnyLoadingButtonStyle {
        get {
            return self[LoadingButtonStyleKey.self]
        }
        set {
            self[LoadingButtonStyleKey.self] = newValue
        }
    }
}

public struct LoadingButtonStyleKey: EnvironmentKey {
    public static let defaultValue: AnyLoadingButtonStyle = AnyLoadingButtonStyle(DefaultLoadingButtonStyle())
}


// MARK: - View Extension

extension View {
    public func loadingButtonStyle<S>(_ style: S) -> some View where S : LoadingButtonStyle {
        self.environment(\.loadingButtonStyle, AnyLoadingButtonStyle(style))
    }
}

// MARK: - Type Erased LoadingButtonStyle

public struct AnyLoadingButtonStyle: LoadingButtonStyle {
    private let _makeBody: (LoadingButtonStyle.Configuration) -> AnyView

    init<ST: LoadingButtonStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }

    public func makeBody(configuration: LoadingButtonStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

// MARK: - LoadingButtonStyle Protocol

public protocol LoadingButtonStyle {
    associatedtype Body : View

    func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = LoadingButtonStyleConfiguration
}

extension LoadingButtonStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}


public struct LoadingButtonStyleConfiguration {
    var isPressed: Bool
    var label: AnyView
}


// MARK: - DefaultLoadingButtonStyle

public struct DefaultLoadingButtonStyle: LoadingButtonStyle {

    public func makeBody(configuration: Self.Configuration) -> DefaultLoadingButtonStyle.DefaultLoadingButton {

        DefaultLoadingButton(
            label: configuration.label,
            isPressed: configuration.isPressed
        )
    }

    public struct DefaultLoadingButton: View {

        var label: AnyView
        var isPressed: Bool

        public var body: some View {
            label
                .foregroundColor(.blue)
                .opacity(isPressed ? 0.3 : 1.0)
        }

    }
}
