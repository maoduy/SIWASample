SIWATest — CONTROL experiment (fresh bundle ID)
================================================

Identical code to SIWASample, signed to a brand-new App ID:
  com.dadilo.siwatest (created 2026-08-12, Sign in with Apple capability
  enabled, PRIMARY_APP_CONSENT, team HF53KC83Z3)

Purpose — split the -24000 hypothesis:
- SUCCEEDS here  -> server-side corruption is specific to the
                    com.dadilo.app App ID record.
- FAILS (-24000) -> the rejection is team-wide for HF53KC83Z3.

How to run (Mac + Xcode 15+):
1. Open SIWATest.xcodeproj.
2. Signing is Automatic, team HF53KC83Z3 — sign in to the team in
   Xcode Settings > Accounts. Xcode will mint a development profile
   for com.dadilo.siwatest automatically (the App ID already exists
   with the SIWA capability).
3. Run on a physical iOS device signed into iCloud.
4. Tap either button (scoped / minimal request), complete the sheet,
   read the result on screen.

Related: SIWASample (same code on com.dadilo.app — always fails),
Program Support case #20000132024383,
forum https://developer.apple.com/forums/thread/841195
