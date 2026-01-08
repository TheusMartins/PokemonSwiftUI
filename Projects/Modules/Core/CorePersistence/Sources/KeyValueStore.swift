import Foundation

/// A tiny abstraction over key-value persistence.
/// This keeps CorePersistence testable and decoupled from UserDefaults/CoreData.
///
/// Note: We'll provide a UserDefaults-backed implementation later.
public protocol KeyValueStore: Sendable {
    func data(forKey key: String) -> Data?
    func set(_ data: Data?, forKey key: String)
    func removeValue(forKey key: String)
}
