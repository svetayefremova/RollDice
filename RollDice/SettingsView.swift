//
//  SettingsView.swift
//  RollDice
//
//  Created by Yes on 27.12.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sides: String
    @Binding var dices: String
    @Binding var rollNumbers: [Int]
    @Binding var total: Int
    
    @State private var selectedSides: String = ""
    @State private var selectedDices: String = ""
    
    var count: Int {
        return Int(selectedDices) ?? 1
    }
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .center) {
                        Text("Dices: ")
                        TextField("dices", text: self.$selectedDices)
                    }
                    
                    HStack(alignment: .center) {
                        Text("Sides: ")
                        TextField("sides", text: self.$selectedSides)
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
        
    func dismiss() {
        sides = selectedSides
        dices = selectedDices
        rollNumbers = [Int](repeating: 1, count: Int(dices) ?? 1)
        total = 0
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(sides: .constant("6"), dices: .constant("1"), rollNumbers: .constant([1]), total: .constant(0))
    }
}
