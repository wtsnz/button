//
//  CustomButton.swift
//  Button
//
//  Created by Will Townsend on 2019-12-06.
//  Copyright © 2019 Overflight. All rights reserved.
//

import SwiftUI

struct CustomButton<Label> : View where Label : View {

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

    @Environment(\.customButtonStyle) var style: AnyCustomButtonStyle

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

        let configuration = CustomButtonStyleConfiguration(
            isPressed: isPressed,
            label: AnyView(self.label())
        )

        return style.makeBody(configuration: configuration)
                    .gesture(dragGesture)
    }
}

// MARK: - Custom Environment Key

extension EnvironmentValues {
    var customButtonStyle: AnyCustomButtonStyle {
        get {
            return self[CustomButtonStyleKey.self]
        }
        set {
            self[CustomButtonStyleKey.self] = newValue
        }
    }
}

public struct CustomButtonStyleKey: EnvironmentKey {
    public static let defaultValue: AnyCustomButtonStyle = AnyCustomButtonStyle(DefaultCustomButtonStyle())
}


// MARK: - View Extension

extension View {
    public func customButtonStyle<S>(_ style: S) -> some View where S : CustomButtonStyle {
        self.environment(\.customButtonStyle, AnyCustomButtonStyle(style))
    }
}

// MARK: - Type Erased CustomButtonStyle

public struct AnyCustomButtonStyle: CustomButtonStyle {
    private let _makeBody: (CustomButtonStyle.Configuration) -> AnyView

    init<ST: CustomButtonStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }

    public func makeBody(configuration: CustomButtonStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

// MARK: - CustomButtonStyle Protocol

public protocol CustomButtonStyle {
    associatedtype Body : View

    func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = CustomButtonStyleConfiguration
}

extension CustomButtonStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}


public struct CustomButtonStyleConfiguration {
    var isPressed: Bool
    var label: AnyView
}


// MARK: - DefaultCustomButtonStyle

public struct DefaultCustomButtonStyle: CustomButtonStyle {

    public func makeBody(configuration: Self.Configuration) -> DefaultCustomButtonStyle.DefaultCustomButton {

        DefaultCustomButton(
            label: configuration.label,
            isPressed: configuration.isPressed
        )
    }

    public struct DefaultCustomButton: View {

        var label: AnyView
        var isPressed: Bool

        public var body: some View {
            label
                .foregroundColor(.blue)
                .opacity(isPressed ? 0.3 : 1.0)
        }

    }
}
