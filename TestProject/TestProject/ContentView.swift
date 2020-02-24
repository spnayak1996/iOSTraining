//
//  ContentView.swift
//  TestProject
//
//  Created by vinsol on 17/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        Text("Hello World Hello World Hello World Hello World Hello World")
            .fontWeight(.regular)
            .foregroundColor(Color(UIColor(displayP3Red: 3/255, green: 176/255, blue: 120/255, alpha: 1)))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40.0)
            
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

