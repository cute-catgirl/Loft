import SwiftUI
import Foundation
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()
    @State private var settingsShown: Bool = false
    @State private var likeAlertShown: Bool = false
    @State private var newStatus: String = ""
    @State private var likeConfirmation: String = "OK"
    @State private var gifMenuShown: Bool = false
    @State private var gifToPost: String? = nil
    let likeConfirmations = [
        "OK",
        "I do",
        "Thanks",
        "<3"
    ]
    let gifFrames = [
        "berd": ["Berd1", "Berd2", "Berd3"],
        "tode": ["Tode1", "Tode2", "Tode3"],
        "bot": ["Bot1", "Bot2", "Bot3"]
    ]
    @Query(filter: #Predicate<Account> { account in
        account.isActive == true
    }) var accounts: [Account]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.statuses) { status in
                            StatusView(status: status)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        newStatus = "@\(status.username)"
                                    } label: {
                                        Label("Reply", systemImage: "arrowshape.turn.up.left")
                                            .labelStyle(.iconOnly)
                                    }
                                    .tint(.blue)
                                    Button {
                                        likeConfirmation = likeConfirmations.randomElement() ?? "OK"
                                        likeAlertShown.toggle()
                                    } label: {
                                        Label("Like", systemImage: "heart")
                                            .labelStyle(.iconOnly)
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.fetchStatuses()
                    }
                    .onAppear {
                        viewModel.fetchStatuses()
                    }
                    if (accounts.count >= 1 || true) {
                        VStack {
                            if (gifMenuShown) {
                                GifMenuView(gifToPost: $gifToPost, gifFrames: gifFrames)
                                    .transition(.moveAndFade)
                            }
                            HStack(spacing: 12) {
                                TextField("Update status", text: $newStatus)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                Button {
                                    withAnimation {
                                        gifMenuShown.toggle()
                                    }
                                } label: {
                                    Image(systemName: "photo.circle.fill")
                                        .font(.system(size: 32))
                                }
                                Button(action: {
                                    if !newStatus.isEmpty {
                                        viewModel.postStatus(
                                            status: newStatus,
                                            username: accounts[0].username,
                                            password: accounts[0].password,
                                            gif: gifToPost,
                                            instance: accounts[0].instance
                                        )
                                        gifMenuShown = false
                                        newStatus = ""
                                        gifToPost = nil
                                    }
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(!newStatus.isEmpty ? SettingsManager.shared.colorAccent : Color(.systemGray4))
                                }
                                .disabled(newStatus.isEmpty)
                            }
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
                    Button(likeConfirmation) {}
                }
            }
        }
        .tint(SettingsManager.shared.colorAccent)
    }
}

struct StatusView: View {
    let status: Status
    let gifFrames = [
        "berd": ["Berd1", "Berd2", "Berd3"],
        "tode": ["Tode1", "Tode2", "Tode3"],
        "bot": ["Bot1", "Bot2", "Bot3"]
    ]
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
            if(status.gif != nil) {
                GifView(frames: gifFrames[status.gif!]!)
                    .frame(width: 150, height: 150)
            }
            Text(status.timestamp)
                .font(.footnote)
        }
        .padding(.vertical, 4)
    }
}

struct GifMenuView: View {
    @Binding var gifToPost: String?
    let gifFrames: [String: [String]]
    
    var body: some View {
        VStack(spacing: 0) {  // Wrapper VStack to ensure full width coverage
            HStack(spacing: 12) {
                Button {
                    gifToPost = nil
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gifToPost == nil ? Color.accentColor.opacity(0.2) : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(gifToPost == nil ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                        
                        Image(systemName: "xmark")
                    }
                    .frame(width: 50, height: 50)
                }
                ForEach(Array(gifFrames.keys), id: \.self) { gifKey in
                    Button {
                        gifToPost = gifKey
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(gifToPost == gifKey ? Color.accentColor.opacity(0.2) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(gifToPost == gifKey ? Color.accentColor : Color.clear, lineWidth: 2)
                                )
                            
                            GifView(frames: gifFrames[gifKey]!)
                                .padding(4)
                        }
                    }
                }
                .frame(width: 50, height: 50)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .opacity
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Account.self, inMemory: true)
}
