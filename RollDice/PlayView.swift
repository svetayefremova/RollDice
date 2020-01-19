//
//  PlayView.swift
//  RollDice
//
//  Created by Yes on 27.12.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct DiceBoxes: View {
    var dicesCount: Int
    var rollNumbers: [Int]
    let color = Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.8)
    
    var body: some View {
        ForEach(0..<self.dicesCount, id: \.self) { index in
            Text("\(self.rollNumbers[index])")
                .foregroundColor(self.color)
                .font(.largeTitle)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.color, lineWidth: 2)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.black, radius: 6, x: 0, y: 0)
                )
                .frame(width: 100, height: 100)
                .background(Color.white)
                .cornerRadius(10)
                .accessibility(label: Text("Dice amount is \(self.rollNumbers[index])"))
        }
    }
}

struct PlayView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @EnvironmentObject var dices: Dices
    @State private var engine: CHHapticEngine?
    @State private var rollNumbers: [Int] = [1]
    @State private var sides: String = "6"
    @State private var numberOfDices: String = "1"
    @State private var showingSettingsScreen: Bool = false
    @State private var total: Int = 0
    @State private var runCount: Int = 0
    
    let stopAt = 10
    let interval = 0.1
    
    var dicesCount: Int {
        return Int(numberOfDices) ?? 1
    }
    
    // TODO use modifier
    var purple: Color {
        return differentiateWithoutColor ? Color.black.opacity(0.7) : Color.purple
    }
    var blue: Color {
        return differentiateWithoutColor ? Color.black.opacity(0.7) : Color.blue
    }
        
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    
                    if self.dicesCount > 3 {
                        GeometryReader { fullView in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    DiceBoxes(dicesCount: self.dicesCount, rollNumbers: self.rollNumbers)
                                }
                                .padding(.horizontal, (fullView.size.width - 120) / 2)
                            }
                        }
                        .frame(height: 150)
                    } else {
                        HStack {
                            DiceBoxes(dicesCount: self.dicesCount, rollNumbers: self.rollNumbers)
                        }
                        .frame(height: 150)
                    }
                    
                    Text("Total: \(self.total)")
                        .font(.largeTitle)
                        .accessibility(label: Text("Total amount is \(self.total)"))
                    
                    Spacer()
                    
                    Button(action: {
                        self.addDice()
                    }) {
                        HStack {
                            Text("PLAY")
                                .fontWeight(.semibold)
                                .font(.headline)
                            Image(systemName: "wand.and.stars")
                                .font(.headline)
                        }
                        .padding(16)
                        .padding([.leading, .trailing])
                        .frame(width: geo.size.width * 0.6)
                        .background(LinearGradient(gradient: Gradient(colors: [self.purple, self.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    }
                    .accessibility(label: Text("Play"))
                    .accessibility(hint: Text("Start a game"))
                    .accessibility(addTraits: .isButton)
                    
                    Spacer()
                 }
                .navigationBarTitle("Start The Dice")
                .navigationBarItems(trailing: Button(action: {
                    self.showingSettingsScreen = true
                }) {
                    Text("Settings")
                        .foregroundColor(self.purple)
                })
            }
            .background(Color(red: 0.6, green: 0.3, blue: 0.5, opacity: 0.12))
            .sheet(isPresented: $showingSettingsScreen) {
                SettingsView(sides: self.$sides, dices: self.$numberOfDices, rollNumbers: self.$rollNumbers, total: self.$total)
            }
            .onAppear(perform: prepareHaptics)
        }
    }
    
    func flickDices() {
        runCount += 1
        
        rollNumbers = rollNumbers.map {_ in
            Int.random(in: 1 ... (Int(self.sides) ?? 6))
        }
        total = rollNumbers.reduce(0, {$0 + $1})
        
        if runCount == stopAt {
            self.runCount = 0
            return
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.flickDices()
        }
    }
    
    func addDice() {
        self.flickDices()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + (interval * Double(stopAt))) {
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long

            let dice = Dice()
            dice.createdAt = formatter.string(from: currentDateTime)
            dice.result = self.total
            
            self.dices.add(dice)
            self.complexHapticSuccess()
        }
    }
    
    func complexHapticSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 300)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 100)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
