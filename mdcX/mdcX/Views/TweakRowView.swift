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

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: action) {
                if tweak.isProcessing {
                    HStack {
                        Text("Processing: \(tweak.name)")
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.7)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Text(tweak.name)
                }
            }
            .buttonStyle(CustomButtonStyle(color: .accentColor))
            .disabled(tweak.isProcessing || isGloballyProcessing)

            if let description = tweak.description, !description.isEmpty {
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !tweak.status.isEmpty { 
                HStack {
                    Text("Status:")
                    Text(tweak.status)
                        .foregroundColor(tweak.status.contains("Success") || tweak.status.contains("Succeeded") ? .green : (tweak.status.contains("Failed") ? .red : .orange))
                }
                .font(.caption)
                .padding(.top, 2)
            }
        }
    }
}
