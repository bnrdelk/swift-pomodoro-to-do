//
//  NoItemsView.swift
//  PomodoroToDo
//
//  Created by Beyza Nur Deliktaş on 8.03.2023.
//

import SwiftUI

struct NoItemsView: View {
    
    @State var animate: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10){
                Spacer(minLength: 30)
                Text("🌬This place is completely empty.")
                    .font(.title)
                    .foregroundColor(Color("Purple"))
                    .fontWeight(.semibold)
                Spacer(minLength: 30)
                Text("add to-dos for to-do.add to-dos for to-do.add to-dos for to-do.add to-dos for to-do.add to-dos for to-do.add to-dos for to-do..")
                    .foregroundColor(Color("Purple"))
                Spacer(minLength: 300)
                NavigationLink(destination: AddView(), label: {
                    Text("🖇 Add a Task.")
                        .foregroundColor(.white)
                        .font(.body)
                        .bold()
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(animate ? Color("Purple") : .cyan)
                        .cornerRadius(50)
                })
                .shadow(color: Color("mPurple"), radius : animate ? 40 : 0 )
                
            }
            .multilineTextAlignment(.center)
            .padding(30)
            .onAppear (perform: addAnimation)
        }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ){
                animate.toggle()
            }
        }
    }
    
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NoItemsView()
                .navigationTitle("To-Do List")
        }
        
    }
}
