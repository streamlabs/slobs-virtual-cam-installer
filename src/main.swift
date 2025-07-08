import Dispatch
import Foundation
import SystemExtensions
import os.log

class ExtensionManager: NSObject, OSSystemExtensionRequestDelegate {

    func activate() {
        let activationRequest = OSSystemExtensionRequest.activationRequest(
            forExtensionWithIdentifier: "com.streamlabs.slobs.mac-camera-extension", queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }

    func deactivate() {
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

        return .replace
    }

    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print(
            "Please approve the system extension request in System Settings > Privacy & Security.")

    }

    func request(
        _ request: OSSystemExtensionRequest,
        didFinishWithResult result: OSSystemExtensionRequest.Result
    ) {
        switch result {
        case OSSystemExtensionRequest.Result.completed:
            print("System extension was installed successfully.")
        case OSSystemExtensionRequest.Result.willCompleteAfterReboot:
            print("System extension will complete after reboot.")
        @unknown default:
            print("System extension request finished with an unknown result.")
        }
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("error: \(error.localizedDescription) code:\(error._code)")
    }
}

let installer = ExtensionManager()
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()

installer.activate()

// Wait asynchronously
dispatchGroup.notify(queue: .main) {
    print("Operation complete.")
}
RunLoop.main.run(until: Date().addingTimeInterval(10))  // Give the script time to wait
