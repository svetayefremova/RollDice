//
//  ContentView.swift
//  RollDice
//
//  Created by Yes on 27.12.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    var dices = Dices()
    
    var body: some View {
        TabView {
            PlayView()
                .tabItem {
                    Image(systemName: "cube.fill").font(.title)
                    Text("GAME").font(.title)
                }
            
            ResultsView()
                .tabItem {
                    Image(systemName: "arrow.turn.right.up").font(.title)
                    Text("HISTORY").font(.title)
                }
        }
        .accentColor(differentiateWithoutColor ? Color.black.opacity(0.7) : Color.purple)
        .environmentObject(dices)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
