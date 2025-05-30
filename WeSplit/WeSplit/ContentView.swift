//
//  ContentView.swift
//  WeSplit
//
//  Created by windlliu on 2024/9/12.
//

import SwiftUI

struct ContentView: View {
  @State private var checkAmount = 0.0
  @State private var numberOfPeople = 2
  @State private var tipPercentage = 20
  @FocusState private var amountIsFocused: Bool

  let tipPercentages = [10, 15, 20, 25, 0]

  var totalPerPerson: Double {
    let tipSelection = Double(tipPercentage)

    let tipValue = checkAmount / 100 * tipSelection
    let grandTotal = checkAmount + tipValue
    let amountPerPerson = grandTotal / Double(numberOfPeople)

    return amountPerPerson
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField(
            "Amount", value: $checkAmount,
            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
          )
          .keyboardType(.decimalPad)
          .focused($amountIsFocused)

          Picker("Number of people", selection: $numberOfPeople) {
            // 此处以id为值, 默认以索引为值
            ForEach(2..<100, id: \.self) {
              Text("\($0) people")
            }
          }.pickerStyle(.navigationLink)
        }

        Section("How much do you want to tip?") {
          Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(tipPercentages, id: \.self) {
              Text($0, format: .percent)
            }
          }.pickerStyle(.segmented)
        }

        Section {
          Text(
            totalPerPerson,
            format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
      }
      .navigationTitle("WeSplit2")
      .toolbar {
        if amountIsFocused {
          Button("Done!") {
            amountIsFocused = false
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()

  }
}
