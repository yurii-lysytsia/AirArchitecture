// Copyright © 2023 Yurii Lysytsia. All rights reserved.

import OSLog
import os.log

/// An object for writing interpolated string messages to the unified logging system based on the system `Logger`
///
/// https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
@available(iOS 14.0, *)
public final class OSLogger {
    private lazy var logger = Logger(subsystem: subsystem, category: category)
    
    // MARK: - Dependency Properties
    
    private let subsystem: String
    private let category: String
    private let messagePrefix: String?
    
    // MARK: - Inits
    
    public init(subsystem: String, category: String, messagePrefix: String? = nil) {
        self.subsystem = subsystem
        self.category = category
        self.messagePrefix = messagePrefix
    }
    
    public convenience init(bundle: Bundle, category: String, messagePrefix: String? = nil) {
        self.init(subsystem: bundle.bundleIdentifier ?? "", category: category, messagePrefix: messagePrefix)
    }
    
    // MARK: - Methods
    
    /// Use this method to write messages with the `debug` log level to both the in-memory and on-disk log stores.
    public func log(_ message: String) {
        if let messagePrefix {
            logger.log("\(messagePrefix) \(message, privacy: .auto)")
        } else {
            logger.log("\(message, privacy: .auto)")
        }
    }
    
    /// Use this method to write messages with the `🟡 warning` log level to both the in-memory and on-disk log stores.
    public func warning(_ message: String) {
        if let messagePrefix {
            logger.error("\(messagePrefix) \(message, privacy: .auto)")
        } else {
            logger.error("\(message, privacy: .auto)")
        }
    }
    
    /// Use this method to write messages with the `🔴 error` log level to both the in-memory and on-disk log stores.
    public func error(_ message: String) {
        if let messagePrefix {
            logger.fault("\(messagePrefix) \(message, privacy: .auto)")
        } else {
            logger.fault("\(message, privacy: .auto)")
        }
    }
    
    /// Returns a sequence of log entries filtered by the parameters passed in.
    @available(iOS 15.0, *)
    public func entries(position: LogEntryPosition? = nil) throws -> [LogEntry] {
        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let entries: [LogEntry] = try store
            .getEntries(at: position?.position(store: store), matching: NSPredicate(format: "subsystem == %@ && category == %@", subsystem, category))
            .compactMap { entry -> LogEntry? in
                guard let entryLog = entry as? OSLogEntryLog else { return nil }
                
                // Define log level
                let level: LogLevel
                switch entryLog.level {
                case .fault:
                    level = .error
                case .error:
                    level = .warning
                default:
                    level = .log
                }
                
                // Returns domain entry
                return LogEntry(
                    library: entryLog.sender,
                    subsystem: entryLog.subsystem,
                    category: entryLog.category,
                    level: level,
                    message: entryLog.composedMessage
                )
            }
        return entries
    }
    
    // MARK: - Helpers
    
    @available(iOS 15.0, *)
    public enum LogLevel: String {
        /// A log level that captures diagnostic information.
        case log
        
        /// The log level that captures warning information
        case warning
        
        /// The log level that captures fault information
        case error
    }
    
    @available(iOS 15.0, *)
    public struct LogEntry {
        let library: String // sender
        let subsystem: String // sender
        let category: String // category
        let level: LogLevel // level
        let message: String // composedMessage
    }
    
    @available(iOS 15.0, *)
    public enum LogEntryPosition {
        /// Returns a position representing the time specified.
        case date(date: Date)
        
        /// Returns a position representing time since the last boot in the series of entries.
        case timeIntervalSinceLatestBoot(timeInterval: TimeInterval)
        
        /// Returns a position representing time since the end of the time range that the entries span.
        case timeIntervalSinceEnd(timeInterval: TimeInterval)
        
        fileprivate func position(store: OSLogStore) -> OSLogPosition {
            switch self {
            case .date(let date):
                return store.position(date: date)
            case .timeIntervalSinceEnd(let timeInterval):
                return store.position(timeIntervalSinceEnd: timeInterval)
            case .timeIntervalSinceLatestBoot(let timeInterval):
                return store.position(timeIntervalSinceLatestBoot: timeInterval)
            }
        }
    }
}
