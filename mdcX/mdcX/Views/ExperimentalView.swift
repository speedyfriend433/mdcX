//
//  ExperimentalView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

//// Define AlertItem locally if it's not a shared utility yet.
//fileprivate struct AlertItem: Identifiable {
//    let id = UUID()
//    var title: Text
//    var message: Text?
//    var primaryButton: Alert.Button
//    var secondaryButton: Alert.Button?
//}
/*class ExperimentRunner: ObservableObject {

    func performXPCRespring(logStore: LogStore,
                            statusUpdate: @escaping (String) -> Void,
                            processingUpdate: @escaping (Bool) -> Void) {
        processingUpdate(true)
        statusUpdate("Attempting XPC respring...")
        logStore.append(message: "EXP_RUNNER: Attempting respring via XPC...")

        DispatchQueue.global(qos: .userInitiated).async {
            let result = attempt_respring_via_xpc()

            DispatchQueue.main.async {
                if result == 0 {
                    statusUpdate("XPC command sent. Respring likely if vulnerable.")
                    logStore.append(message: "EXP_RUNNER: XPC respring command sent successfully.")
                } else {
                    statusUpdate("XPC command failed (code: \(result)).")
                    logStore.append(message: "EXP_RUNNER: XPC respring command failed (C code: \(result)).")
                    processingUpdate(false)
                }
            }
        }
    }

    func performGenericFileZero(
        targetPath: String,
        tweakName: String,
        logStore: LogStore,
        statusUpdate: @escaping (String) -> Void,
        processingUpdate: @escaping (Bool) -> Void
    ) {
        processingUpdate(true)
        let fileName = (targetPath as NSString).lastPathComponent
        statusUpdate("Attempting to zero out '\(fileName)' for \(tweakName)...")
        logStore.append(message: "EXP_RUNNER: Attempting \(tweakName): \(targetPath)")

        DispatchQueue.global(qos: .userInitiated).async {
            var success = false
            var c_result: Int32 = -1

            if targetPath.isEmpty {
                c_result = -99 
            } else {
                targetPath.withCString { cPathPtr in
                    c_result = zero_out_first_page(cPathPtr)
                    success = (c_result == 0)
                }
            }

            DispatchQueue.main.async {
                if success {
                    statusUpdate("'\(fileName)' zeroed for \(tweakName). Effect may require respring.")
                    logStore.append(message: "EXP_RUNNER: \(tweakName) - Target file zeroed successfully.")
                } else {
                    statusUpdate("Failed to zero '\(fileName)' for \(tweakName) (code: \(c_result)).")
                    logStore.append(message: "EXP_RUNNER: \(tweakName) - Failed to zero target file (C code: \(c_result)).")
                }
                processingUpdate(false)
            }
        }
    }
}

struct ExperimentalView: View {
    @ObservedObject var logStore: LogStore
    @StateObject private var experimentRunner = ExperimentRunner()

    @State private var xpcRespringStatus: String = ""
    @State private var isProcessingXPCRespring: Bool = false
    @State private var fileCorruptionSbPlistStatus: String = ""
    @State private var isProcessingFileCorruptionSbPlist: Bool = false
    @State private var fileCorruptionCacheStatus: String = ""
    @State private var isProcessingFileCorruptionCache: Bool = false


    @State private var alertItem: AlertItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Image(systemName: "beaker.halffull")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .padding(.top)

                Text("Danger Zone: Experimental")
                    .font(.title.bold())
                    .foregroundColor(.red)

                Text("These features are highly unstable, iOS version-dependent, and can potentially render your device unusable without a restore. PROCEED WITH EXTREME CAUTION. For testing purposes only.")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "Respring (XPC Crash)",
                    description: "Attempts to crash 'com.apple.backboard.TouchDeliveryPolicyServer' via a crafted XPC message. Success depends on a specific, often older, vulnerability.",
                    buttonLabel: "Attempt XPC Respring",
                    buttonColor: .orange,
                    status: $xpcRespringStatus,
                    isProcessing: $isProcessingXPCRespring
                ) {
                    self.alertItem = AlertItem(
                        title: Text("Confirm XPC Respring"),
                        message: Text("This method is risky and targets a system service. Ensure you understand the implications. Continue?"),
                        primaryButton: .destructive(Text("Yes, Attempt XPC")) {
                            experimentRunner.performXPCRespring(
                                logStore: logStore,
                                statusUpdate: { newStatus in xpcRespringStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingXPCRespring = newProcessing }
                            )
                        },
                        secondaryButton: .cancel()
                    )
                }

                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "Respring (Corrupt SB Plist)",
                    description: "Attempts to crash SpringBoard by zeroing its preferences file. EXTREMELY DANGEROUS. Target: '/var/mobile/Library/Preferences/com.apple.springboard.plist'",
                    buttonLabel: "Attempt SB Plist Corruption",
                    buttonColor: .purple,
                    status: $fileCorruptionSbPlistStatus,
                    isProcessing: $isProcessingFileCorruptionSbPlist
                ) {
                    let targetPath = "/var/mobile/Library/Preferences/com.apple.springboard.plist"
                    let targetFileName = (targetPath as NSString).lastPathComponent
                    
                    self.alertItem = AlertItem(
                        title: Text("EXTREME DANGER!"),
                        message: Text("You are about to zero out '\(targetFileName)'. This can lead to boot loops, data loss, or an unusable SpringBoard, requiring a device restore. This is IRREVERSIBLE for the file. ONLY proceed on a test device you are willing to erase.\n\nARE YOU ABSOLUTELY SURE?"),
                        primaryButton: .destructive(Text("I Understand Risks, Proceed")) {
                            experimentRunner.performGenericFileZero(
                                targetPath: targetPath,
                                tweakName: "SB Plist Corruption",
                                logStore: logStore,
                                statusUpdate: { newStatus in fileCorruptionSbPlistStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingFileCorruptionSbPlist = newProcessing }
                            )
                        },
                        secondaryButton: .cancel(Text("NO! Cancel Immediately"))
                    )
                }
                
                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "Respring (Corrupt Cache File - PoC)",
                    description: "Attempts to trigger UI reload by zeroing a hypothetical SpringBoard cache file. Effect varies. Target: '/var/mobile/Library/Caches/com.apple.springboard/Cache.db'",
                    buttonLabel: "Attempt Cache Corruption",
                    buttonColor: .green,
                    status: $fileCorruptionCacheStatus,
                    isProcessing: $isProcessingFileCorruptionCache
                ) {
                    let cacheTargetPath = "/var/mobile/Library/Caches/com.apple.springboard/Cache.db"
                    let cacheFileName = (cacheTargetPath as NSString).lastPathComponent

                    self.alertItem = AlertItem(
                        title: Text("Confirm Cache Corruption"),
                        message: Text("Corrupting '\(cacheFileName)' might cause UI glitches or a SpringBoard data refresh. Lower risk of boot loop compared to plists, but data loss for that cache is certain. Proceed?"),
                        primaryButton: .destructive(Text("Corrupt Cache")) {
                             experimentRunner.performGenericFileZero(
                                targetPath: cacheTargetPath,
                                tweakName: "Cache File Corruption",
                                logStore: logStore,
                                statusUpdate: { newStatus in fileCorruptionCacheStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingFileCorruptionCache = newProcessing }
                            )
                        },
                        secondaryButton: .cancel()
                    )
                }


                VStack(alignment: .leading) {
                     Text("Experimental Action Log (Shared):")
                         .font(.caption.bold())
                     LogView(logMessages: $logStore.messages, logStore: logStore)
                 }.padding(.top, 20)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Experimental Zone")
        .alert(item: $alertItem) { item in
            Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
        }
    }
}

struct ExperimentActionView: View {
    let title: String
    let description: String
    let buttonLabel: String
    let buttonColor: Color
    @Binding var status: String
    @Binding var isProcessing: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: action) {
                if isProcessing {
                    HStack {
                        Text("Processing...")
                            .frame(maxWidth: .infinity, alignment: .center)
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Text(buttonLabel)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(CustomButtonStyle(color: buttonColor))
            .disabled(isProcessing)

            if !status.isEmpty {
                HStack {
                    Text("Status:")
                    Text(status)
                        .font(.caption)
                        .foregroundColor(status.contains("Sent") || status.contains("Zeroed") || status.contains("OK") || status.contains("Success") ? .green : (status.contains("Failed") || status.contains("Error") ? .red : .orange))
                        .lineLimit(2)
                }
                .padding(.top, 3)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct ExperimentalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExperimentalView(logStore: LogStore())
        }
    }
}
*/
