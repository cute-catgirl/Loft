//
//  SettingsView.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedColor: Color
    
    init() {
        self._selectedColor = State(initialValue: SettingsManager.shared.colorAccent)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ColorSetting(selectedColor: $selectedColor)
                } header: {
                    Text("Accent Color")
                }
                Section {
                    List {
                    }
                } header: {
                    Text("Instances")
                }
            }
            .sensoryFeedback(.selection, trigger: selectedColor)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .tint(SettingsManager.shared.colorAccent)
        }
    }
}

struct ColorSetting: View {
    @Binding var selectedColor: Color
    
    private let colors: [Color] = [
        .pink, .red, .orange, .yellow,
        .green, .mint, .teal, .cyan,
        .blue, .indigo, .purple, .brown
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 2)
                                .opacity(selectedColor == color ? 1 : 0)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedColor = color
                                SettingsManager.shared.colorAccent = color
                            }
                        }
                }
            }
            .padding(.vertical, 8)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

#Preview {
    SettingsView()
}
