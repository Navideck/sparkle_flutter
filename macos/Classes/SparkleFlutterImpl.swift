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
        }

        public func feedURLString(for _: SPUUpdater) -> String? {
            return feedURL?.absoluteString
        }

        func initialize(feedUrl: String?) throws {
            let hostBundle = Bundle.main
            _userDriver = SPUStandardUserDriver(hostBundle: hostBundle, delegate: self)
            _updater = SPUUpdater(
                hostBundle: hostBundle,
                applicationBundle: hostBundle,
                userDriver: _userDriver!,
                delegate: self
            )
            _updater?.clearFeedURLFromUserDefaults()
            if feedUrl != nil {
                feedURL = URL(string: feedUrl!)
            }

            do {
                try _updater?.start()
            } catch {
                throw PigeonError(code: "Failed", message: error.localizedDescription, details: nil)
            }
        }

        func automaticallyDownloadsUpdates(automaticallyDownloads: Bool) throws {
            _updater?.automaticallyDownloadsUpdates = automaticallyDownloads
        }

        func automaticallyChecksForUpdates(automaticallyChecks: Bool) throws {
            _updater?.automaticallyDownloadsUpdates = automaticallyChecks
        }

        func canCheckForUpdates() throws -> Bool {
            return _updater?.canCheckForUpdates ?? false
        }

        func sessionInProgress() throws -> Bool {
            return _updater?.sessionInProgress ?? false
        }

        func checkForUpdates(inBackground: Bool?) throws {
            if _updater?.sessionInProgress == true {
                throw PigeonError(code: "SessionInProgress", message: "Session Already in progress, check for update later", details: nil)
            }
            if inBackground == true {
                _updater?.checkForUpdatesInBackground()
            } else {
                _updater?.checkForUpdates()
            }
        }

        func setScheduledCheckInterval(interval: Int64) throws {
            _updater?.updateCheckInterval = TimeInterval(interval)
        }

        func addUpdateCheckOptionInAppMenu(title: String?, menuName: String?) throws {
            guard let mainMenu = NSApp.mainMenu else {
                throw PigeonError(code: "NoMenuAvailable", message: "NoMenu available", details: nil)
            }

            let updateTitle = title ?? "Check For Updates"
            let checkForUpdateItem = NSMenuItem(
                title: updateTitle,
                action: #selector(checkForUpdateFromMenu),
                keyEquivalent: "u"
            )
            checkForUpdateItem.target = self

            if let menuName = menuName {
                if let existingMenuItem = mainMenu.items.first(where: {
                    $0.submenu?.title == menuName
                }) {
                    if let submenu = existingMenuItem.submenu,
                       submenu.items.contains(where: { $0.title == updateTitle }) {
                        return
                    }
                    existingMenuItem.submenu?.addItem(checkForUpdateItem)
                } else {
                    let customMenuItem = NSMenuItem()
                    let customMenu = NSMenu(title: menuName)
                    customMenu.addItem(checkForUpdateItem)
                    customMenuItem.submenu = customMenu
                    mainMenu.addItem(customMenuItem)
                }
            } else if let appMenuItem = mainMenu.items.first,
                      let appMenu = appMenuItem.submenu {
                if appMenu.items.contains(where: { $0.title == updateTitle }) {
                    return 
                }
                appMenu.insertItem(checkForUpdateItem, at: 1)
            } else {
                throw PigeonError(code: "AppMenuNotFound", message: "NoMenu available", details: nil)
            }
        }

        @objc func checkForUpdateFromMenu() {
            _updater?.checkForUpdates()
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

        public func updater(_: SPUUpdater, didFinishUpdateCycleFor updateCheck: SPUUpdateCheck, error: (any Error)?) {
            callbackChannel.onUpdateDidFinishUpdateCycle(event: updateCheck.toUpdateCheckEvent(), error: error?.localizedDescription) { _ in }
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

    extension SPUUpdateCheck {
        func toUpdateCheckEvent() -> UpdateCheckEvent {
            if rawValue == 1 {
                return .checkUpdatesInBackground
            }
            if rawValue == 2 {
                return .checkUpdateInformation
            }
            return .checkUpdates
        }
    }
#endif
