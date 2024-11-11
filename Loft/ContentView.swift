//
//  ContentView.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()
    @State private var settingsShown: Bool = false
    
    var body: some View {
        NavigationView {
            List(viewModel.statuses) { status in
                StatusView(status: status)
            }
            .onAppear {
                viewModel.fetchStatuses()
            }
            .navigationTitle("Loft")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") {
                        settingsShown.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh", systemImage: "arrow.clockwise") {
                        viewModel.fetchStatuses()
                    }
                }
            }
            .sheet(isPresented: $settingsShown) {
                SettingsView()
            }
        }
        .tint(SettingsManager.shared.colorAccent)
    }
}

struct StatusView: View {
    let status: Status
    var body: some View {
        VStack(alignment: .leading) {
            if status.username.count + status.instance.name.count > 30 {
                VStack(alignment: .leading, spacing: 2) {
                    Text(status.username)
                        .font(.title3)
                        .bold()
                    Text(status.instance.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text(status.username)
                        .font(.title3)
                        .bold()
                    Text(status.instance.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Text(status.message)
                .font(.title3)
            Text(status.timestamp)
                .font(.footnote)
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    ContentView()
}
