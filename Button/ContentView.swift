//
//  ContentView.swift
//  Button
//
//  Created by Will Townsend on 2019-12-06.
//  Copyright © 2019 Overflight. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        VStack {
            CustomButton(action: {
                print("tapped!")
            }, label: {
                Text("Hello, World!")
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
