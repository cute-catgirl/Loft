import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()
    @State private var settingsShown: Bool = false
    @State private var likeAlertShown: Bool = false
    @State private var newStatus: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.statuses) { status in
                            StatusView(status: status)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        likeAlertShown.toggle()
                                    } label: {
                                        Label("Like", systemImage: "heart")
                                            .labelStyle(.iconOnly)
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        viewModel.fetchStatuses()
                    }
                    
                    HStack(spacing: 12) {
                        TextField("Update status", text: $newStatus)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        
                        Button(action: {
                            if !newStatus.isEmpty {
                                viewModel.postStatus(
                                    status: newStatus,
                                    username: AccountManager.shared.username,
                                    password: AccountManager.shared.password,
                                    instance: AccountManager.shared.instances[AccountManager.shared.selectedInstance]
                                )
                                newStatus = ""
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(!newStatus.isEmpty ? SettingsManager.shared.colorAccent : Color(.systemGray4))
                        }
                        .disabled(newStatus.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(.systemGray5)),
                        alignment: .top
                    )
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
                .alert("glad you like it babe", isPresented: $likeAlertShown) {
                    Button("OK") {}
                }
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
