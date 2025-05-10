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
        
        Tweak(name: "Modify SpringBoard Shelf BG",
              description: "Attempts to alter a 'shelf' background material within SpringBoard. Likely affects the Dock or iPad App Shelf. Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/shelfBackground.materialrecipe"
              ]),
              category: "Dock",
              status: "",
              isProcessing: false),
        
        Tweak(name: "Remove Spotlight Bottom Blur",
              description: "Attempts to remove a blur effect at the bottom of the Spotlight search interface. Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpotlightUIInternal.framework/bottomBlur.materialrecipe"
              ]),
              category: "Spotlight",
              status: "",
              isProcessing: false),

        Tweak(name: "Transparent UI Elements",
              description: "Makes notifications, media player backgrounds transparent.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeLight.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeDark.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/plattersDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platters.materialrecipe"
              ]),
              category: "UI Elements", status: "", isProcessing: false),
        
        Tweak(name: "Transparent Notification Avatars",
              description: "Attempts to make the background behind app icons in notifications transparent. Affects light/dark modes. Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/avatarBackground.materialrecipe",
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/avatarBackgroundDark.materialrecipe"
              ]),
              category: "Notifications",
              status: "",
              isProcessing: false),
        
        Tweak(name: "Hide Folder Backgrounds",
              description: "Makes Home Screen folder backgrounds transparent.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe"
              ]),
              category: "UI Elements", status: "", isProcessing: false),
        
        Tweak(name: "Remove Home Screen Edit Overlay",
              description: "Attempts to remove/alter the overlay (e.g., dimming) when editing the Home Screen (jiggle mode). Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/homeScreenOverlay.materialrecipe"
              ]),
              category: "UI Elements",
              status: "",
              isProcessing: false),
        
        /*Tweak(name: "Remove Platter Shadows",
              description: "Attempts to remove the drop shadows from notifications, widgets, and other platter-based UI. Affects light/dark modes. Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/MaterialKit.framework/platterVibrantShadowDark.visualstyleset",
                "/System/Library/PrivateFrameworks/MaterialKit.framework/platterVibrantShadowLight.visualstyleset"
              ]),
              category: "UI Elements",
              status: "",
              isProcessing: false),*/

        Tweak(name: "Remove App Switcher Blur",
              description: "Attempts to remove the background blur in the App Switcher.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-switcher.materialrecipe"
              ]),
              category: "UI Elements", status: "", isProcessing: false),
        
        Tweak(name: "Remove Spotlight Blur",
              description: "Attempts to remove the background blur in Spotlight search (Home Screen). Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightBlurBackground.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightLumSatBackground.materialrecipe"
              ]),
              category: "UI Elements", 
              status: "",
              isProcessing: false),

        Tweak(name: "Hide Home Bar",
              description: "Attempts to hide the home indicator bar.",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car"]),
              category: "UI Elements", status: "", isProcessing: false),
        
        /*Tweak(name: "Remove Home Screen Text Legibility FX",
              description: "Attempts to remove subtle shadows/blurs behind Home Screen icon labels and widget text. May make text harder to read on some wallpapers. Requires respring.",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/PaperBoardUI.framework/homeScreenLegibility.materialrecipe"
              ]),
              category: "Home Screen", // Or "UI Elements", "Text & Fonts"
              status: "",
              isProcessing: false),*/

        Tweak(name: "Hide Lockscreen Shortcuts",
              description: "Hides flashlight and camera buttons on lockscreen.",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car"]),
              category: "Lockscreen", status: "", isProcessing: false),
        
        Tweak(name: "Silence Charging Sound",
              description: "Attempts to disable the charging connection sound by targeting common and device-specific sound files. Reboot/SSV might restore it.",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/connect_power.caf",
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),

        Tweak(name: "Silence Video Record Sounds",
              description: "Disables sounds when video recording starts/ends.",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/begin_record.caf",
                "/System/Library/Audio/UISounds/end_record.caf"
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),
    
        Tweak(name: "Silence Lock Sound",
              description: "Disables the sound when locking the device.",
              action: .zeroOutFiles(paths: ["/System/Library/Audio/UISounds/lock.caf"]),
              category: "Sounds",
              status: "",
              isProcessing: false),
    
        Tweak(name: "Silence Photo Shutter Sounds",
              description: "Disables camera shutter sounds for photos & bursts.",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/photoShutter.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
                "/System/Library/Audio/UISounds/nano/CameraShutter_Haptic.caf"
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),
    
        Tweak(name: "Silence Keyboard Sounds",
              description: "Disables keyboard tap sounds.",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/key_press_click.caf",
                "/System/Library/Audio/UISounds/key_press_delete.caf",
                "/System/Library/Audio/UISounds/key_press_modifier.caf",
                "/System/Library/Audio/UISounds/keyboard_press_clear.caf",
                "/System/Library/Audio/UISounds/keyboard_press_delete.caf",
                "/System/Library/Audio/UISounds/keyboard_press_normal.caf"
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false)
    ]
    @StateObject private var logStore = LogStore()
    @State private var isAnyTweakProcessing: Bool = false

    private let exploitManager = ExploitManager.shared

    private var groupedTweaks: [String: [Tweak]] {
        Dictionary(grouping: tweaks, by: { $0.category })
    }

    private var sortedCategoryKeys: [String] {
        groupedTweaks.keys.sorted()
    }

    private func applyTweak(id: UUID) {
        guard let tweakIndex = tweaks.firstIndex(where: { $0.id == id }) else {
            logStore.append(message: "Error: Tweak with ID \(id) not found.")
            return
        }
        guard !tweaks[tweakIndex].isProcessing && !isAnyTweakProcessing else {
            logStore.append(message: "Operation already in progress for \(tweaks[tweakIndex].name) or batch.")
            return
        }

        tweaks[tweakIndex].isProcessing = true
        tweaks[tweakIndex].status = "Processing..."
        exploitManager.logStore = self.logStore

        exploitManager.applyPocToFileZero(tweaks[tweakIndex]) { successCount, totalFiles, resultsLog in
            if let updatedTweakIndex = self.tweaks.firstIndex(where: { $0.id == id }) {
                self.tweaks[updatedTweakIndex].status = "\(successCount)/\(totalFiles) Succeeded"
                if !resultsLog.isEmpty {
                     self.logStore.append(message: "Results for '\(self.tweaks[updatedTweakIndex].name)':\n\(resultsLog)")
                }
                self.tweaks[updatedTweakIndex].isProcessing = false
            }
        }
    }
    
    private func applyAllTweaks() {
        guard !isAnyTweakProcessing && !tweaks.contains(where: { $0.isProcessing }) else {
            logStore.append(message: "Operation already in progress.")
            return
        }

        logStore.append(message: "Starting all PoC file-zero tweaks...")
        isAnyTweakProcessing = true
        exploitManager.logStore = self.logStore
        
        let group = DispatchGroup()
        var summary = ""
        
        for i in tweaks.indices {
            if tweaks[i].isProcessing { continue }
            tweaks[i].isProcessing = true
            tweaks[i].status = "Batching..."
            
            group.enter()
            exploitManager.applyPocToFileZero(tweaks[i]) { successCount, totalFiles, _ in
                 if self.tweaks.indices.contains(i) {
                    self.tweaks[i].status = "Batch: \(successCount)/\(totalFiles) OK"
                    summary += "\(self.tweaks[i].name): \(self.tweaks[i].status)\n"
                    self.tweaks[i].isProcessing = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            logStore.append(message: "All tweaks batch completed.\nSummary:\n\(summary)")
            isAnyTweakProcessing = false
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(sortedCategoryKeys, id: \.self) { categoryKey in
                        Section {
                            let indicesForCategory = tweaks.indices.filter { tweaks[$0].category == categoryKey }
                            ForEach(indicesForCategory, id: \.self) { indexInMainArray in
                                TweakRowView(
                                    tweak: $tweaks[indexInMainArray],
                                    isGloballyProcessing: $isAnyTweakProcessing,
                                    action: {
                                        self.applyTweak(id: tweaks[indexInMainArray].id)
                                    }
                                )
                            }
                        } header: {
                             Text(categoryKey)
                                .font(.title3.weight(.semibold))
                                .padding(.vertical, 5)
                        } footer: {
                            if categoryKey == sortedCategoryKeys.last {
                                Text("Manual respring/reboot required for changes to take effect. Use with caution.")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                LogView(logMessages: $logStore.messages, logStore: logStore)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .padding(.top, 8)

            }
            .navigationTitle("iOS File Tweaker")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "hammer.circle.fill")
                        .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        applyAllTweaks()
                    } label: {
                        Text("Apply All")
                    }
                    .buttonStyle(CustomButtonStyle(color: .green, foregroundColor: .white, isDisabledStyle: isAnyTweakProcessing || tweaks.contains(where: {$0.isProcessing})))
                    .disabled(isAnyTweakProcessing || tweaks.contains(where: {$0.isProcessing}))
                }
            }
            .onAppear {
                exploitManager.logStore = self.logStore
            }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
