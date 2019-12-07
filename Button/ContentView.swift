//
//  ContentView.swift
//  Button
//
//  Created by Will Townsend on 2019-12-06.
//  Copyright © 2019 Overflight. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var isLoading = false

    var body: some View {

        VStack {
            LoadingButton(
                action: {
                    print("tapped!")
                    self.startLoading()
                },
                isLoading: isLoading,
                label: {
                    Text("Hello, World!")
                }
            )
            Button("This is a long button") {
                dump("tapped")
                return
            }
        }

    }

    func startLoading() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
