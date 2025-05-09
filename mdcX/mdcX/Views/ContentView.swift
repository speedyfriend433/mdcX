//
//  ContentView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tweaks: [Tweak] = [
        Tweak(name: "Hide Dock",
              description: "Makes the dock background transparent.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe"
              ]),
              category: "Dock", status: "", isProcessing: false),
        Tweak(name: "Transparent UI Elements",
              description: "Makes notifications, media player, folders transparent.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeLight.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeDark.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/plattersDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platters.materialrecipe"
              ]),
              category: "UI", status: "", isProcessing: false),
        Tweak(name: "Hide Home Bar",
              description: "Attempts to hide the home indicator bar.",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car"]),
              category: "UI", status: "", isProcessing: false),
        Tweak(name: "Hide Lockscreen Shortcuts",
              description: "Hides flashlight and camera buttons on lockscreen.",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car"]),
              category: "UI", status: "", isProcessing: false)
    ]
    
    @StateObject private var logStore = LogStore()
    @State private var isAnyTweakProcessing: Bool = false
    
    private let exploitManager = ExploitManager.shared
    
    private func applyTweakAtIndex(_ index: Int) {
        guard tweaks.indices.contains(index) else { return }
        
        guard !tweaks[index].isProcessing else {
            logStore.append(message: "Tweak '\(tweaks[index].name)' is already processing.")
            return
        }
        
        guard !isAnyTweakProcessing else {
            logStore.append(message: "Another batch operation is in progress.")
            return
        }
        
        tweaks[index].isProcessing = true
        tweaks[index].status = "Processing..."
        exploitManager.logStore = self.logStore
        
        exploitManager.applyTweak(tweaks[index]) { successCount, totalFiles, resultsLog in
            tweaks[index].status = "\(successCount)/\(totalFiles) Succeeded"
            if !resultsLog.isEmpty {
                logStore.append(message: "Detailed results for '\(tweaks[index].name)':\n\(resultsLog)")
            }
            tweaks[index].isProcessing = false
        }
    }
    
    private func applyAllTweaks() {
        guard !isAnyTweakProcessing else {
            logStore.append(message: "Apply All is already in progress.")
            return
        }
        if tweaks.contains(where: { $0.isProcessing }) {
            logStore.append(message: "An individual tweak is currently processing. Please wait.")
            return
        }
        
        logStore.append(message: "Starting all tweaks...")
        isAnyTweakProcessing = true
        exploitManager.logStore = self.logStore
        
        let group = DispatchGroup()
        var allTweaksOverallStatusSummary = ""
        
        for i in tweaks.indices {
            tweaks[i].status = "Batch Processing..."
            
            group.enter()
            exploitManager.applyTweak(tweaks[i]) { successCount, totalFiles, detailedResults in
                tweaks[i].status = "Batch: \(successCount)/\(totalFiles) Succeeded"
                allTweaksOverallStatusSummary += "\(tweaks[i].name): \(tweaks[i].status)\n"
                // if !detailedResults.isEmpty {
                //     logStore.append(message: "Batch details for '\(tweaks[i].name)':\n\(detailedResults)")
                // }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            logStore.append(message: "All tweaks batch processing completed.\nSummary:\n\(allTweaksOverallStatusSummary)")
            isAnyTweakProcessing = false
        }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        Button("Apply All Tweaks") {
                            applyAllTweaks()
                        }
                        .buttonStyle(CustomButtonStyle(color: .green))
                        .disabled(isAnyTweakProcessing || tweaks.contains(where: {$0.isProcessing} ))
                        Spacer()
                    }
                    
                    List {
                        ForEach($tweaks) { $tweakItemInLoop in
                            TweakRowView(
                                tweak: $tweakItemInLoop,
                                isGloballyProcessing: $isAnyTweakProcessing,
                                action: {
                                    if let index = tweaks.firstIndex(where: { $0.id == tweakItemInLoop.id }) {
                                        applyTweakAtIndex(index)
                                    }
                                }
                            )
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(.plain)
                    
                    LogView(logMessages: $logStore.messages, logStore: logStore)
                        .padding(.top, 5)
                    
                    Text("Modifies system files. A respring is required for UI changes. Use responsibly on supported iOS versions.")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                .padding()
                .navigationTitle("System Tweaks")
            }
            .tabItem {
                Label("Tweaks", systemImage: "slider.horizontal.3")
            }
            
            NavigationView {
                ExperimentalView(logStore: logStore)
                    .tabItem {
                        Label("Experimental", systemImage: "testtube.2")
                    }
            }
            .onAppear {
                exploitManager.logStore = self.logStore
            }
        }
    }
    
    struct CustomButtonStyle: ButtonStyle {
        var color: Color
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(configuration.isPressed ? color.opacity(0.7) : color)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: color.opacity(0.3), radius: configuration.isPressed ? 0 : 3, x: 0, y: 2)
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

#Preview {
    ContentView()
}
