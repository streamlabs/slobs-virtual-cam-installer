import Dispatch
import Foundation
import SystemExtensions
import os.log

class AtomicBool {
    private var value: Bool
    private let queue = DispatchQueue(label: "AtomicBoolQueue")
    
    init(initialValue: Bool) {
        self.value = initialValue
    }

    func get() -> Bool {
        return queue.sync { value } // Safely read
    }

    func set(newValue: Bool) {
        queue.sync { value = newValue } // Safely write
    }
}

class ExtensionManager: NSObject, OSSystemExtensionRequestDelegate {

    func activate() {
        state = InstallState.installing
        let activationRequest = OSSystemExtensionRequest.activationRequest(
            forExtensionWithIdentifier: "com.streamlabs.slobs.mac-camera-extension", queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }

    func deactivate() {
        state = InstallState.uninstalling
        let activationRequest = OSSystemExtensionRequest.deactivationRequest(
            forExtensionWithIdentifier: "com.streamlabs.slobs.mac-camera-extension", queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }

    func request(
        _ request: OSSystemExtensionRequest,
        actionForReplacingExtension existing: OSSystemExtensionProperties,
        withExtension ext: OSSystemExtensionProperties
    ) -> OSSystemExtensionRequest.ReplacementAction {
        os_log(
            "Replacing extension. Existing: %@, New: %@", String(describing: existing),
            String(describing: ext))
        isDone.set(newValue: true)

        return .replace
    }

    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print(
            "Please approve the system extension request in System Settings > Privacy & Security.")
        isDone.set(newValue: true)
    }

    func request(
        _ request: OSSystemExtensionRequest,
        didFinishWithResult result: OSSystemExtensionRequest.Result
    ) {
        switch result {
        case OSSystemExtensionRequest.Result.completed:
            if (state == InstallState.installing) {
                print("System extension was installed successfully.")
            } else if (state == InstallState.uninstalling) {
                print("System extension was uninstalled successfully.")
            }
        case OSSystemExtensionRequest.Result.willCompleteAfterReboot:
            print("System extension will complete after reboot.")
        @unknown default:
            print("System extension request finished with an unknown result.")
        }
        isDone.set(newValue: true)
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("error: \(error.localizedDescription) code:\(error._code)")
        isDone.set(newValue: true)
    }
    
    func isFinished() -> Bool {
        return isDone.get()
    }
    
    enum InstallState {
        case unknown
        case installing
        case uninstalling
    }
    var state : InstallState = InstallState.unknown
    var isDone : AtomicBool = AtomicBool(initialValue: false)
}

let installer = ExtensionManager()
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()

let arguments = CommandLine.arguments
if arguments.count > 1 && arguments[1] == "--deactivate" {
    installer.deactivate()
} else {
    installer.activate()
}

// Wait asynchronously
dispatchGroup.notify(queue: .main) {
    print("Operation complete.")
}

let stopTime = Date().addingTimeInterval(10) // Set the maximum time to wait

while !installer.isFinished() && Date() < stopTime {
    // Process one cycle of the RunLoop and exit if there's no input
    RunLoop.main.run(mode: RunLoopMode.defaultRunLoopMode, before: Date().addingTimeInterval(0.1))
}
