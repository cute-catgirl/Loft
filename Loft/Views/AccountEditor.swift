//
//  AccountEditor.swift
//  Loft
//
//  Created by Mae on 11/15/24.
//

import SwiftUI
import SwiftData

struct AccountEditor: View {
    let account: Account?
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var instance: Instance = InstanceManager.shared.instances[0]
    @StateObject private var viewModel = StatusViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            Form {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                Picker("Instance", selection: $instance) {
                    ForEach(InstanceManager.shared.instances) { instance in
                        Text(instance.name).tag(instance)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Login") {
                        withAnimation {
                            save()
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle(account == nil ? "New Account" : "Edit Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func save() {
        let newAccount = Account(username: username, password: password, instance: instance, isActive: false)

        // Attempt to log in with the provided credentials
        viewModel.login(account: newAccount) { success in
            if success {
                // Only save if the login is successful
                context.insert(newAccount)
                withAnimation {
                    dismiss() // Dismiss the view upon successful save
                }
            } else {
                // Provide feedback (e.g., show an error message)
                showAlert(title: "Login Failed", message: "Please check your credentials and try again.")
            }
        }
    }
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    AccountEditor(account: nil)
}
