//
//  ListRowView.swift
//  PomodoroToDo
//
//  Created by Beyza Nur Deliktaş on 8.03.2023.
//
import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .purple)
            Text(item.title)
            Spacer()
        }
        .font(.title3)
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
    }
}

struct ListRowView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(title: "First item", isCompleted: true)
    
    static var previews: some View {
        Group {
            ListRowView(item: item1)
        }
        .previewLayout(.sizeThatFits)
    }
}
