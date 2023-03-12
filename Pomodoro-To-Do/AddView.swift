//
//  AddView.swift
//  PomodoroToDo
//
//  Created by Beyza Nur Deliktaş on 8.03.2023.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFieldText: String = ""
    @State var alertTitle: String = ""
    @State var showalert: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                Spacer(minLength: 40)
                TextField("type", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color("sPurple"))
                    .cornerRadius(10)
                
                Spacer(minLength: 15)
                
                Spacer(minLength: 25)
                
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .bold()
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .shadow(color: Color("Purple") ,radius: 5)
                    
                })
            }
            .padding(14)
        }
        .navigationTitle("Add To-do")
        .alert(isPresented: $showalert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if textIsAppopriate() {
            listViewModel.addItem(title: textFieldText)
            presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func textIsAppopriate() -> Bool {
        if textFieldText.count < 3 {
            alertTitle = "🔎 Write more details"
            showalert.toggle()
            return false
        }
        return true
    }
     
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddView()
        }
        .environmentObject(ListViewModel())
    }
}
