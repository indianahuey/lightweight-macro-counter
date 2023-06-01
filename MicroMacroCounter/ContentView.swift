//
//  ContentView.swift
//  MicroMacroCounter
//
//  Created by Indiana Huey on 5/27/23.
//

import SwiftUI

enum Macro: String, CaseIterable {
    case calories, protein, carbs, fat
}

var colors: [Macro : Color] = [
    .calories : .green,
    .protein : .red,
    .carbs : .orange,
    .fat : .yellow
]

var targets: [Macro : Int] = [:]
var currents: [Macro : Int] =  [:]

enum Field {
    case current, target
}

struct ContentView: View {
    @State var incrementing_macro: Bool = false
    @State var setting_target: Bool = false
    @State var macro_input: String = ""
    @State var target_input: String = ""
    
    @FocusState var focusedField: Field?
    
    @AppStorage("current calories") var current_calories: Int = 0
    @AppStorage("current protein") var current_protein: Int = 0
    @AppStorage("current carbs") var current_carbs: Int = 0
    @AppStorage("current fat") var current_fat: Int = 0
    
    @AppStorage("target calories") var target_calories: Int = 2500
    @AppStorage("target protein") var target_protein: Int = 150
    @AppStorage("target carbs") var target_carbs: Int = 330
    @AppStorage("target fat") var target_fat: Int = 70
    
    var body: some View {
        
        let _: () = {
            currents[.calories] = current_calories
            currents[.protein] = current_protein
            currents[.carbs] = current_carbs
            currents[.fat] = current_fat
            
            targets[.calories] = target_calories
            targets[.protein] = target_protein
            targets[.carbs] = target_carbs
            targets[.fat] = target_fat
        }()
        
        GeometryReader { metrics in
            TabView {
                ForEach(Macro.allCases, id: \.self) { macro in
                    ZStack {
                        colors[macro]?.edgesIgnoringSafeArea(.all)
                        
                        Rectangle()
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(Color.purple)
                            .frame(height: metrics.size.height * 2 * (CGFloat(currents[macro]!) / CGFloat(targets[macro]!)))
                            .position(x: metrics.size.width / 2,
                                      y: metrics.size.height)
                            .colorMultiply(colors[macro]!)
                            .opacity(0.5)
                        
                        VStack {
                            Spacer()
                            if incrementing_macro && !setting_target {
                                TextField("+", text: $macro_input)
                                    .font(.system(size: 35))
                                    .fontWeight(.regular)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: .current)
                                    .accentColor(.clear)
                                    .opacity(0.75)
                            }
                            if setting_target && !incrementing_macro{
                                TextField("=", text: $target_input)
                                    .font(.system(size: 35))
                                    .fontWeight(.regular)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: .target)
                                    .accentColor(.clear)
                                    .opacity(0.75)
                            }
                            Spacer()
                            Spacer()
                        }
                        
                        VStack {
                            Button(macro.rawValue) {
                                currents[macro] = 0
                                current_calories = currents[.calories]!
                                current_protein = currents[.protein]!
                                current_carbs = currents[.carbs]!
                                current_fat = currents[.fat]!
                                incrementing_macro.toggle()
                                incrementing_macro.toggle()
                            }
                            .font(.system(size: 35))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(String(currents[macro]!)) {
                                target_input = ""
                                setting_target = false
                                incrementing_macro.toggle()
                                focusedField = .current
                                currents[macro]! += Int(macro_input) ?? 0
                                current_calories = currents[.calories]!
                                current_protein = currents[.protein]!
                                current_carbs = currents[.carbs]!
                                current_fat = currents[.fat]!
                                macro_input = ""
                            }
                            .font(.system(size: 35))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            
                            Button(String(targets[macro]!)) {
                                macro_input = ""
                                incrementing_macro = false
                                setting_target.toggle()
                                focusedField = .target
                                targets[macro] = Int(target_input) ?? targets[macro]
                                target_calories = targets[.calories]!
                                target_protein = targets[.protein]!
                                target_carbs = targets[.carbs]!
                                target_fat = targets[.fat]!
                                target_input = ""
                            }
                            .font(.system(size: 35))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                }
            }
            .tabViewStyle(.page)
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
