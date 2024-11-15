//
//  ChangelogView.swift
//  Loft
//
//  Created by Mae on 11/12/24.
//

import SwiftUI

struct Version: Identifiable {
    let id = UUID()
    let number: String
    let date: String
    let changes: [ChangeSection]
}

struct ChangeSection: Identifiable {
    let id = UUID()
    let type: ChangeType
    let items: [String]
}

enum ChangeType: String {
    case new = "New Features"
    case improved = "Improvements"
    case fixed = "Bug Fixes"
    
    var icon: String {
        switch self {
        case .new: return "sparkles"
        case .improved: return "wrench"
        case .fixed: return "ant"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .new: return .blue
        case .improved: return .purple
        case .fixed: return .green
        }
    }
}

struct ChangelogView: View {
    let versions: [Version] = [
        Version(
            number: "1.1",
            date: "November 15, 2024",
            changes: [
                ChangeSection(type: .new, items: [
                    "Added account switcher",
                    "Added changelog"
                ]),
                ChangeSection(type: .improved, items: [
                    "You can now scroll up to refresh",
                ])
            ]
        ),
        Version(
            number: "1.0",
            date: "November 12, 2024",
            changes: [
                ChangeSection(type: .new, items: [
                    "First version!"
                ])
            ]
        )
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(versions) { version in
                    VersionDetailView(version: version)
                }
            }
            .padding()
        }
        .navigationTitle("Changelog")
        .background(Color(.systemGroupedBackground))
    }
}

struct VersionDetailView: View {
    let version: Version
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Version header
            HStack {
                Text("Version \(version.number)")
                    .font(.headline)
                Spacer()
                Text(version.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            
            // Changes sections
            ForEach(version.changes) { section in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: section.type.icon)
                            .foregroundColor(section.type.iconColor)
                        Text(section.type.rawValue)
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(section.items, id: \.self) { item in
                            Text(item)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                if section.id != version.changes.last?.id {
                    Divider()
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    NavigationView {
        ChangelogView()
    }
}
