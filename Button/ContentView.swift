//
//  ContentView.swift
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

        return self.label()
            .foregroundColor(.blue)
            .opacity(isPressed ? 0.3 : 1.0)
            .gesture(dragGesture)
    }
}

struct ContentView: View {
    var body: some View {

        VStack {
            CustomButton(action: {
                print("tapped!")
            }, label: {
                Text("Hello, World!")
                    .padding()
                    .background(Color.red)
            })
            Button("This is a long button") {
                dump("tapped")
                return
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
