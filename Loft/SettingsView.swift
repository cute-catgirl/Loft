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
    @State private var username: String = AccountManager.shared.username
    @State private var password: String = AccountManager.shared.password
    @State private var selectedInstance: Int = AccountManager.shared.selectedInstance
    
    let instances: [Instance] = [
        Instance(name: "cute-catgirl.github.io", admin: "Mae", endpointFeed: "https://maemoon-lablogingetusers.web.val.run/", statusFeed: "https://maemoon-labloginupdatestatus.web.val.run"),
        Instance(name: "todepond.com", admin: "TodePond", endpointFeed: "https://todepond-lablogingetusers.web.val.run", statusFeed: "https://todepond-labloginupdatestatus.web.val.run"),
        Instance(name: "svenlaa.com", admin: "Svenlaa", endpointFeed: "https://svenlaa-lablogingetusers.web.val.run", statusFeed: "https://svenlaa-labloginupdatestatus.web.val.run"),
        Instance(name: "evolved.systems", admin: "Evol", endpointFeed: "https://evol-lablogingetusers.web.val.run", statusFeed: "https://evol-labloginupdatestatus.web.val.run")
    ]
    
    init() {
        self._selectedColor = State(initialValue: SettingsManager.shared.colorAccent)
        self._selectedInstance = State(initialValue: AccountManager.shared.selectedInstance)
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
                        TextField("Username", text: $username)
                        SecureField("Password", text: $password)
                        Picker("Instance", selection: $selectedInstance) {
                            ForEach(AccountManager.shared.instances.indices, id: \.self) { index in
                                Text(AccountManager.shared.instances[index].name).tag(index)
                            }
                        }
                        
                        Button("Save Credentials") {
                            AccountManager.shared.username = username
                            AccountManager.shared.password = password
                            AccountManager.shared.selectedInstance = selectedInstance
                        }
                    } header: {
                        Text("Account")
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
}
