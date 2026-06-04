import Sparkle

extension SPUStandardUpdaterController {
    /// Shared updater controller for the app.
    /// Sparkle adds a "Check for Updates…" menu item automatically.
    static let shared = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )
}
