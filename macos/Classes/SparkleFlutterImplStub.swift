
class SparkleFlutterImplStub: NSObject, SparkleFlutterChannel {
    let notImportedError = PigeonError(code: "SparkleNotImported", message: "Sparkle not imported", details: nil)
    func initialize(feedUrl _: String?) throws {
        throw notImportedError
    }

    func automaticallyDownloadsUpdates(automaticallyDownloads _: Bool) throws {
        throw notImportedError
    }

    func automaticallyChecksForUpdates(automaticallyChecks _: Bool) throws {
        throw notImportedError
    }

    func canCheckForUpdates() throws -> Bool {
        throw notImportedError
    }

    func sessionInProgress() throws -> Bool {
        throw notImportedError
    }

    func checkForUpdates(inBackground _: Bool?) throws {
        throw notImportedError
    }

    func setScheduledCheckInterval(interval _: Int64) throws {
        throw notImportedError
    }
}
