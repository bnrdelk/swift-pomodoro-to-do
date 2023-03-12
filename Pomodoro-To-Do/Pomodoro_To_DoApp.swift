//
//  Pomodoro_To_DoApp.swift
//  Pomodoro-To-Do
//
//  Created by Beyza Nur Deliktaş on 12.03.2023.
//

import SwiftUI

@main
struct Pomodoro_To_DoApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    @StateObject var pomodoroModel: PomodoroModel = .init()
    // MARK: Scene Phase
    @Environment(\.scenePhase) var phase

    //MARK: Storing list time stamp
    @State var lastActiveTimeStamp: Date = Date()

    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .environmentObject(pomodoroModel)
                ListView()
            }.environmentObject(listViewModel)
        }.onChange(of: phase) { newValue in
            if pomodoroModel.isStarted {
                switch newValue {
                case .background:
                    lastActiveTimeStamp = Date()
                case .inactive: return
                case .active:
                    // MARK: Finding the difference
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    } else {
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                @unknown default: return
                }
            }
        }
    }

}
