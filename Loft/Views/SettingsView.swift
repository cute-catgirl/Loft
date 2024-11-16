//
//  SettingsView.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedColor: Color
    @State private var accountEditorShown: Bool = false
    @Environment(\.modelContext) private var context
    @Query var accounts: [Account]
    
    init() {
        self._selectedColor = State(initialValue: SettingsManager.shared.colorAccent)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        ColorSetting(selectedColor: $selectedColor)
                    } header: {
                        Text("Accent Color")
                    }
                    Section {
                        List(accounts) { account in
                            HStack {
                                Button {
                                    for i in 0..<accounts.count {
                                        if accounts[i].id != account.id && accounts[i].isActive {
                                            accounts[i].isActive = false
                                        }
                                    }
                                    account.isActive = true
                                } label: {
                                    HStack {
                                        Image(systemName: account.isActive ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                        VStack(alignment: .leading) {
                                            Text("\(account.username)")
                                            Text(account.instance.name)
                                                .font(.subheadline)
                                                .tint(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        Button("Add account", systemImage: "plus") {
                            accountEditorShown.toggle()
                        }
                    } header: {
                        Text("Accounts")
                    }
                    Section("Misc") {
                        NavigationLink("Changelog") {
                            ChangelogView()
                        }
                    }
                    Section("Links") {
                        Link(destination: URL(string: "https://logiverse.social")!) {
                            Label("The Logiverse", systemImage: "person.bubble.fill")
                        }
                        Link(destination: URL(string: "https://github.com/cute-catgirl/Loft")!) {
                            Label("Github", systemImage: "text.alignleft")
                        }
                        Link(destination: URL(string: "https://ko-fi.com/maemoonowo")!) {
                            Label("Support me on Ko-fi", systemImage: "heart.fill")
                        }
                    }
                    Section {
                        Text("This app is open source and licensed under the GPLv3 license.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .listRowBackground(Color.clear)
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
                .sheet(isPresented: $accountEditorShown) {
                    AccountEditor(account: nil)
                }
                .tint(SettingsManager.shared.colorAccent)
            }
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
        .modelContainer(for: Account.self, inMemory: true)
}
