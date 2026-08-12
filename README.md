SIWASample — focused reproduction project for DTS
==================================================

Issue: every Sign in with Apple credential request for bundle com.dadilo.app
(team HF53KC83Z3) is rejected server-side. The system sheet completes
(Face ID/password + scope selection), then iOS shows "Sign-Up Not Completed"
and ASAuthorizationController's completion receives ASAuthorizationError 1001.
Device syslog at that moment:

    akd: SRP authentication with server failed! (AppleIDAuthSupport Code=2)
    AKAuthenticationServerResponse ... contents: (null)
    (AKAuthenticationServerError Code=-24000; acname/ut/authType all null)

How to reproduce
----------------
1. Open SIWASample.xcodeproj in Xcode (15 or later).
2. Signing is set to Automatic, team HF53KC83Z3, bundle com.dadilo.app —
   the reproduction is BOUND to this App ID. Signed with any other
   team/bundle the request succeeds, which is precisely the issue.
3. Run on any iOS 15+ device signed into iCloud (reproduced on
   iPadOS 26.5.2 and iOS 26.x).
4. Tap either button (scoped request or minimal request — both fail
   identically). Complete the authorization sheet.
5. Observe "Sign-Up Not Completed" and FAILURE code 1001 on screen
   (also NSLog'd with the underlying error).

Control: the same devices and Apple IDs complete brand-new Sign in with
Apple authorizations for other bundles normally.

Alternatively we can add a DTS tester Apple ID to our TestFlight build
(app Apple ID 6782634291) for one-tap reproduction without building.

Related: Program Support case #20000132024383,
forum thread https://developer.apple.com/forums/thread/841195
