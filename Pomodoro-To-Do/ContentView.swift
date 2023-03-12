//
//  ContentView.swift
//  PomodoroToDo
//
//  Created by Beyza Nur Deliktaş on 8.03.2023.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var pomodoroModel: PomodoroModel

    var body: some View {
        Home()
            .environmentObject(pomodoroModel)
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView{
            ContentView()
                .environmentObject(PomodoroModel())
                .navigationTitle("To-Do Timer")
        }
       
    }
    
}
