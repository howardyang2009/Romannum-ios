//
//  ContentView.swift
//  Romannum-IOS
//
//  Created by 杨晗 on 28.08.23.
//

import SwiftUI

struct ContentView: View {
    @State var number:Number
    @State var calculator : RomannumCalculator = RomannumCalculator()
    
    func calc() {
        print("Hello world")
        
        do {
            calculator.initialize()
            
            let num1: Int = try calculator.str2num(inputStr: number.num1)
            let num2: Int = try calculator.str2num(inputStr: number.num2)
            
            let sum:Int = num1 + num2
            
            number.sum = try calculator.num2str(number: sum)
        }
        catch {
            print("error: \(error).")
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            
            HStack(
                spacing:10
            ) {
                Text("Num1").bold()
                Divider()
                TextField("Num1", text: $number.num1)
            }
            .frame(height: 50)
            
            Text("+")
            
            HStack(
                spacing:10
            ) {
                Text("Num2").bold()
                Divider()
                TextField("Num2", text: $number.num2)
            }
            .frame(height: 50)
            
            Text("--------------------------")
            
            HStack(
                spacing:10
            ) {
                Text("Sum").bold()
                Divider()
                TextField("Sum", text: $number.sum)
            }
            .frame(height: 50)
            
            Button(action: calc){
                Text("Calc")
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(number: Number.default)
    }
}
