import SwiftUI
import AuthenticationServices

/// CONTROL experiment for the com.dadilo.app -24000 investigation.
///
/// Identical code to SIWASample, but signed to a BRAND-NEW App ID
/// (com.dadilo.siwatest, created 2026-08-12, SIWA capability PRIMARY).
///
/// - If Sign in with Apple SUCCEEDS here → the server-side corruption is
///   specific to the com.dadilo.app App ID record.
/// - If it FAILS with the same -24000 → the rejection is team-wide
///   (team HF53KC83Z3).
struct ContentView: View {
    @State private var status = "CONTROL sample on fresh bundle com.dadilo.siwatest. Tap either button."

    var body: some View {
        VStack(spacing: 24) {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                report(result, variant: "scoped")
            }
            .frame(width: 280, height: 48)

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = []
            } onCompletion: { result in
                report(result, variant: "minimal")
            }
            .frame(width: 280, height: 48)

            Text(status)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    private func report(_ result: Result<ASAuthorization, Error>, variant: String) {
        switch result {
        case .success(let auth):
            status = "SUCCESS (\(variant)): credential \(type(of: auth.credential))"
        case .failure(let error):
            let ns = error as NSError
            status = "FAILURE (\(variant)): \(ns.domain) code=\(ns.code)\n\(ns.localizedDescription)\nunderlying: \(String(describing: ns.userInfo[NSUnderlyingErrorKey]))"
        }
        NSLog("SIWATest %@", status)
    }
}
