import SwiftUI
import AuthenticationServices

/// Minimal reproduction of: every Sign in with Apple request for bundle
/// com.dadilo.app (team HF53KC83Z3) is rejected server-side.
///
/// The system sheet opens and Face ID / password + scope selection complete,
/// then iOS shows "Sign-Up Not Completed" and the completion handler gets
/// ASAuthorizationError code 1001. Device syslog at that moment shows:
///   akd: SRP authentication with server failed!
///        (AppleIDAuthSupport Code=2)
///   AKAuthenticationServerResponse ... contents: (null)
///        (AKAuthenticationServerError Code=-24000)
///
/// IMPORTANT: reproduction is bound to our App ID — sign this project with
/// team HF53KC83Z3 / bundle com.dadilo.app. The same two devices and Apple
/// IDs complete brand-new authorizations for other bundles normally
/// (verified with a fresh ChatGPT sign-up minutes after our app failed).
struct ContentView: View {
    @State private var status = "Tap either button. On com.dadilo.app both always fail with ASAuthorizationError 1001."

    var body: some View {
        VStack(spacing: 24) {
            SignInWithAppleButton(.signIn) { request in
                // Standard request — matches our production app.
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                report(result, variant: "scoped")
            }
            .frame(width: 280, height: 48)

            SignInWithAppleButton(.signIn) { request in
                // Minimal request — no scopes, no nonce. Fails identically.
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
        NSLog("SIWASample %@", status)
    }
}
