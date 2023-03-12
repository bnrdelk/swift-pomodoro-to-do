//
//  Home.swift
//  PomodoroToDo
//
//  Created by Beyza Nur Deliktaş on 8.03.2023.
//
import SwiftUI

struct Home: View {

    @EnvironmentObject var pomodoroModel: PomodoroModel
    @State var animate: Bool = false
    @State var animate2: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    Spacer(minLength: 0.1)
                    HStack{
                        NavigationLink(destination: AddView()
                            .environmentObject(ListViewModel()), label: {
                            Text("🖇 Add To-Do")
                                .foregroundColor(.white)
                                .font(.body)
                                .bold()
                                .frame(height: 55)
                                .padding(.horizontal, 26)
                                .background(.black)
                                .cornerRadius(25)
                        })
                        NavigationLink(destination: ListView()
                            .environmentObject(ListViewModel()), label: {
                            Text("📂 Update To-Do")
                                .foregroundColor(.white)
                                .font(.body)
                                .bold()
                                .frame(height: 55)
                                .padding(.horizontal, 15)
                                .background(.black)
                                .cornerRadius(25)
                        })
                        
                    }
                    
                    
                    // MARK: Timer Ring
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                       
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color("Purple").opacity(0.1), lineWidth: 50)
                            .shadow(color: timerColor(), radius: 20)
                            .shadow(color: Color("Purple"), radius: 50)
                            .shadow(color: Color("Purple"), radius: 50)
                            .shadow(color: timerColor(), radius: 80)
                            .shadow(color: timerColor(), radius: 50)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                            .padding(-30)
                            
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                            .padding(-50)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                            .padding(-70)
                        
                        Circle()
                            .fill(Color("mPurple"))
                            .blur(radius: 30)

                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                        
                       

                        
                        // MARK: Knob
                        
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("sPurple"))
                                .blur(radius: 3)
                                .frame(width: 25, height: 25)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                            // MARK: Since View is Rotated Thats Why Using X
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                        
                            
                        }
                        
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("sPurple"))
                                .blur(radius: 3)
                                .frame(width: 20, height: 20)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                            // MARK: Since View is Rotated Thats Why Using X
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 330))
                        
                            
                        }
                        
                
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                    }.padding(60)
                        .frame(height: proxy.size.width)
                        .rotationEffect(.init(degrees: -90))
                        .animation(.easeInOut, value: pomodoroModel.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    Button {
                        if pomodoroModel.isStarted {
                            pomodoroModel.stopTimer()
                            // MARK: Cancelling all notifications
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        } else {
                            pomodoroModel.addNewTimer = true
                        }
                    } label: {
                        Text(!pomodoroModel.isStarted ? "Create Timer" :  "Pause")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 255, height: 60)
                            .background(timerColor().opacity(0.5))
                            .cornerRadius(50)
                            .shadow(color: timerColor(), radius: 20, x: 0, y: 0)
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
            
        }.padding()
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            .overlay(content: {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            pomodoroModel.hour = 0
                            pomodoroModel.minutes = 0
                            pomodoroModel.seconds = 0
                            pomodoroModel.addNewTimer = false
                        }

                    NewTimer()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
                }.animation(.easeInOut, value: pomodoroModel.addNewTimer)
            })
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                if pomodoroModel.isStarted {
                    pomodoroModel.updateTimer()
                }
            }
            .alert("Time is over ⏰", isPresented: $pomodoroModel.isFinished) {
                Button("Start New", role: .cancel) {
                    pomodoroModel.stopTimer()
                    pomodoroModel.addNewTimer = true
                }
                Button("Close", role: .destructive) {
                    pomodoroModel.stopTimer()
                }
            }
        
    }

    // MARK: New Timer Bottom Sheet
    @ViewBuilder
    func NewTimer() -> some View {
        VStack(spacing: 15) {
            Text("Create New Timer")
                .font(.title2.bold())
                .foregroundColor(timerColor())
                .padding(.top, 10)

            HStack(spacing: 15) {

                Text("\(pomodoroModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(timerColor().opacity(0.3))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            pomodoroModel.minutes = value
                        }
                    }

                Text("\(pomodoroModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(timerColor().opacity(0.3))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            pomodoroModel.seconds = value
                        }
                    }
                
                
            }.padding(.top, 20)
            
            
            Button {
                pomodoroModel.startTimer()
            } label: {
                Text("Start")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 135)
                    .background {
                        Capsule()
                            .fill(timerColor())
                    }
                    .shadow(color: timerColor(), radius: 10, x: 0, y: 0)
            }.disabled(pomodoroModel.seconds == 0 && pomodoroModel.minutes == 0)
                .opacity(pomodoroModel.seconds == 0 && pomodoroModel.minutes == 0 ? 0.3 : 1)
                .padding(.top)
            
            Button {
                pomodoroModel.startPomodoro()
            } label: {
                Text("⏳ Pomodoro")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,80)
                    .background {
                        Capsule()
                            .fill(timerColor())
                    }
                    .shadow(color: timerColor(), radius : animate2 ? 40 : 0 )
                    .shadow(color: timerColor(), radius : animate2 ? 20 : 0 )
                    
            }.onAppear(perform: addAnimation)
                .padding(.top)

        }.padding()
            .frame(maxWidth: .infinity)
            .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white)
                        .ignoresSafeArea()
            }
    }

    // MARK: Reusable Context Menu
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }

    
    private func primaryColor() -> Color {
        if pomodoroModel.totalSeconds == 0 {
            return Color("Purple")
        } else {
            return Color(pomodoroModel.totalSeconds > 300 ? .white : .green)
        }
    }
    
    private func timerColor() -> Color {
        if pomodoroModel.isBreak {
            return .cyan
        } else {
            return Color("lPurple")
        }
    }
    
    private func backgroundColor() -> Color {
        if pomodoroModel.isBreak {
            return .white
        } else {
            return .black
        }
    }
    
    func addAnimation() {
        guard !animate2 else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.5)
                    .repeatForever()
            ){
                animate2.toggle()
            }
        }
    }

}

struct Home_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView{
            ContentView()
                .environmentObject(PomodoroModel())
                .navigationTitle("To-Do Timer")
        }
    }
    
}
