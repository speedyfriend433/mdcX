//
//  TweakRowView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct TweakRowView: View {
    @Binding var tweak: Tweak
    @Binding var isGloballyProcessing: Bool

    let action: () -> Void
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Dock": return "menubar.dock.rectangle.badge.record"
        case "UI Elements": return "photo.on.rectangle.angled"
        case "Lockscreen": return "lock.display"
        case "Sounds": return "speaker.wave.2.fill"
        case "Control Center": return "switch.2"
        default: return "gearshape.fill"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconForCategory(tweak.category))
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(tweak.name)
                    .font(.headline)
                    .fontWeight(.medium)

                if let description = tweak.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                if !tweak.status.isEmpty {
                    HStack(spacing: 4) {
                        Text("Status:")
                        Text(tweak.status)
                            .fontWeight(.medium)
                            .foregroundColor(tweak.status.contains("Success") || tweak.status.contains("Succeeded") ? .green : (tweak.status.contains("Failed") ? .red : .orange))
                    }
                    .font(.caption)
                }
            }

            Spacer()

            Button(action: action) {
                if tweak.isProcessing {
                    ProgressView()
                        .scaleEffect(0.7)
                        .frame(width: 44, height: 30) // Consistent size with button
                } else {
                    Image(systemName: "hammer.circle.fill") // "wand.and.stars" or "gearshape.fill"
                        .imageScale(.large)
                }
            }
            .frame(width: 44, height: 30) // Give button a defined tappable area
            .disabled(tweak.isProcessing || isGloballyProcessing)
            .buttonStyle(.borderless) // Use borderless for icon buttons in lists
            .contentShape(Rectangle()) // Ensure whole area is tappable
        }
        .padding(.vertical, 8)
    }
}
