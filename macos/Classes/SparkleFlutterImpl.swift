//
//  SparkleFlutterImpl.swift
//  Pods
//
//  Created by Rohit Sangwan on 03/06/25.
//

#if ENABLE_SPARKLE
    import Sparkle

    class SparkleFlutterImpl: NSObject, SparkleFlutterChannel, SPUUpdaterDelegate, SPUStandardUserDriverDelegate {
        public var callbackChannel: SparkleFlutterCallbackChannel
        var _userDriver: SPUStandardUserDriver?
        var _updater: SPUUpdater?
        var feedURL: URL?

        init(callbackChannel: SparkleFlutterCallbackChannel) {
            self.callbackChannel = callbackChannel
            super.init()

            let hostBundle = Bundle.main
            _userDriver = SPUStandardUserDriver(hostBundle: hostBundle, delegate: self)
            _updater = SPUUpdater(
                hostBundle: hostBundle,
                applicationBundle: hostBundle,
                userDriver: _userDriver!,
                delegate: self
            )
            _updater?.clearFeedURLFromUserDefaults()
            try? _updater?.start()
        }

        func setFeedURL(url: String) {
            feedURL = URL(string: url)
            try? _updater?.start()
        }

        func checkForUpdates(inBackground: Bool?) {
            if inBackground == true {
                _updater?.checkForUpdatesInBackground()
            } else {
                _updater?.checkForUpdates()
            }
        }

        func setScheduledCheckInterval(interval: Int64) {
            _updater?.updateCheckInterval = TimeInterval(interval)
        }

        // SPUUpdaterDelegate
        public func updater(_: SPUUpdater, didAbortWithError error: Error) {
            callbackChannel.onUpdaterError(error: error.localizedDescription) { _ in }
        }

        public func updater(_: SPUUpdater, didFinishLoading appcast: SUAppcast) {
            callbackChannel.onUpdaterCheckingForUpdate(appcast: appcast.toDartAppcast()) { _ in }
        }

        public func updater(_: SPUUpdater, didFindValidUpdate item: SUAppcastItem) {
            callbackChannel.onUpdaterUpdateAvailable(appcastItem: item.toAppCastItem()) { _ in }
        }

        public func updaterDidNotFindUpdate(_: SPUUpdater, error: Error) {
            callbackChannel.onUpdaterUpdateNotAvailable(error: error.localizedDescription) { _ in }
        }

        public func updater(_: SPUUpdater, didDownloadUpdate item: SUAppcastItem) {
            callbackChannel.onUpdaterUpdateDownloaded(appcastItem: item.toAppCastItem()) { _ in }
        }

        public func updater(_: SPUUpdater, willInstallUpdateOnQuit item: SUAppcastItem, immediateInstallationBlock _: @escaping () -> Void) -> Bool {
            callbackChannel.onUpdaterBeforeQuitForUpdate(appcastItem: item.toAppCastItem()) { _ in }
            return true
        }
    }

    extension SUAppcast {
        func toDartAppcast() -> Appcast {
            return Appcast(items: items.map { item in
                item.toAppCastItem()
            })
        }
    }

    extension SUAppcastItem {
        func toAppCastItem() -> AppcastItem {
            return AppcastItem(
                versionString: versionString,
                displayVersionString: displayVersionString,
                fileURL: fileURL?.absoluteString ?? "",
                contentLength: Int64(bitPattern: contentLength),
                infoURL: infoURL?.absoluteString ?? "",
                title: title ?? "",
                dateString: dateString ?? "",
                releaseNotesURL: releaseNotesURL?.absoluteString ?? "",
                itemDescription: itemDescription ?? "",
                itemDescriptionFormat: itemDescriptionFormat ?? "",
                fullReleaseNotesURL: fullReleaseNotesURL?.absoluteString ?? "",
                minimumSystemVersion: minimumSystemVersion ?? "",
                minimumOperatingSystemVersionIsOK: minimumOperatingSystemVersionIsOK,
                maximumSystemVersion: maximumSystemVersion ?? "",
                maximumOperatingSystemVersionIsOK: maximumOperatingSystemVersionIsOK,
                channel: channel ?? ""
            )
        }
    }
#endif
