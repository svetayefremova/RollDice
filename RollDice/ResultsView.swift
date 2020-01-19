//
//  ResultsView.swift
//  RollDice
//
//  Created by Yes on 27.12.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var dices: Dices
        
    var body: some View {
        NavigationView {
            List {
                ForEach(dices.data.sorted(by: { $0.createdAt > $1.createdAt })) { dice in
                    HStack {
                        Text("\(dice.createdAt):")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text("\(dice.result)")
                            .font(.headline)
                    }
                }
            }
            .navigationBarTitle("History")
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
