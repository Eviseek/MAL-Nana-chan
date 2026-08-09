//
//  ReachabilityService.swift
//  MAL Nana-chan
//

import Foundation
import Alamofire

/// Tells interested screens when the connection comes back.
protocol ReachabilityObserving: AnyObject {

    var isReachable: Bool { get }

    func startMonitoring()

    /// Registers `observer` for "connection restored". The registration is held
    /// weakly and drops itself when `observer` is deallocated.
    func addObserver(_ observer: AnyObject, onConnectionRestored handler: @escaping () -> Void)

    func removeObserver(_ observer: AnyObject)
}

/// Alamofire-backed reachability.
final class ReachabilityService: ReachabilityObserving {

    /// A weakly-held registration.
    private struct Registration {
        weak var observer: AnyObject?
        let handler: () -> Void
    }

    private let manager: NetworkReachabilityManager?
    private var registrations: [Registration] = []
    private var wasUnreachable = false

    init(host: String = "www.google.com") {
        manager = NetworkReachabilityManager(host: host)
    }

    var isReachable: Bool { manager?.isReachable ?? true }

    func startMonitoring() {
        // Alamofire delivers this on `.main` by default. The compiler can't see
        // that, so capturing `self` (a non-`Sendable` class) in its `@Sendable`
        // listener warns under strict checking. `MainActor.assumeIsolated` does
        // *not* fix it — asserting the isolation still sends `self` across — so
        // silencing it properly means making this type main-actor-isolated, which
        // pulls its protocol and every observing view model with it. Left as a
        // warning pending that decision.
        manager?.startListening { [weak self] status in
            self?.handle(status)
        }
    }

    /// Multiple observers, not one.
    func addObserver(_ observer: AnyObject, onConnectionRestored handler: @escaping () -> Void) {
        removeObserver(observer)
        registrations.append(Registration(observer: observer, handler: handler))
    }

    func removeObserver(_ observer: AnyObject) {
        registrations.removeAll { $0.observer === observer || $0.observer == nil }
    }

    private func handle(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            wasUnreachable = true
        case .reachable:
            let isReconnect = wasUnreachable
            wasUnreachable = false
            if isReconnect {
                notifyConnectionRestored()
            }
        case .unknown:
            // Deliberately not treated as "offline": `.unknown` is also the
            // status before the first callback arrives, and treating it as a
            // drop would fire a spurious "reconnected" on the next update.
            break
        }
    }

    private func notifyConnectionRestored() {
        registrations.removeAll { $0.observer == nil }
        registrations.forEach { $0.handler() }
    }
}
