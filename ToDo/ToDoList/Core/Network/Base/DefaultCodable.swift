// 
//  DefaultCodable.swift
//  ToDo
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

public protocol DefaultCodableStrategy {
    associatedtype RawValue: Codable
    
    static var defaultValue: RawValue { get }
}

// Decodes values with a reasonable default value
/// `@Defaultable` attempts to decode a value and falls back to a default type provided by the generic `DefaultCodableStrategy`.
@propertyWrapper
public struct DefaultCodable<Default: DefaultCodableStrategy>: Codable {
    public var wrappedValue: Default.RawValue
    
    public init(wrappedValue: Default.RawValue) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            wrappedValue = try container.decode(Default.RawValue.self) 
        } catch {
            wrappedValue = Default.defaultValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultCodable: Equatable where Default.RawValue: Equatable { }
extension DefaultCodable: Hashable where Default.RawValue: Hashable { }

// MARK: - KeyedDecodingContainer
public extension KeyedDecodingContainer {
    // Decodes successfully if key is available
    // If not fallsback to the default value provided.
    func decode<P>(_: DefaultCodable<P>.Type,
                   forKey key: Key) throws -> DefaultCodable<P> {
        if let value = try decodeIfPresent(DefaultCodable<P>.self,
                                           forKey: key) {
            return value
        } else {
            return DefaultCodable(wrappedValue: P.defaultValue)
        }
    }
}

// MARK: - Default Typealias
public struct DefaultFalseStrategy: DefaultCodableStrategy {
    public static var defaultValue: Bool { return false }
}
public typealias DefaultFalse = DefaultCodable<DefaultFalseStrategy> /// `@DefaultFalse` decodes Bools and defaults the value to false if the Decoder is unable to decode the value.

public struct DefaultTrueStrategy: DefaultCodableStrategy {
    public static var defaultValue: Bool { return true }
}
public typealias DefaultTrue = DefaultCodable<DefaultTrueStrategy> /// `@DefaultTrue` decodes Bools and defaults the value to true if the Decoder is unable to decode the value.

public struct DefaultEmptyArrayStrategy<T: Codable>: DefaultCodableStrategy {
    public static var defaultValue: [T] { return [] }
}
public typealias DefaultEmptyArray<T> = DefaultCodable<DefaultEmptyArrayStrategy<T>> where T: Codable /// `@DefaultEmptyArray` decodes Arrays and returns an empty array instead of nil if the Decoder is unable to decode the container.

public struct DefaultEmptyStringStrategy: DefaultCodableStrategy {
    public static var defaultValue: String { return "" }
}
public typealias DefaultEmptyString = DefaultCodable<DefaultEmptyStringStrategy> /// `@DefaultEmptyString` decodes String and returns an empty string instead of nil if the Decoder is unable to decode the container.

public struct DefaultTitleStringStrategy: DefaultCodableStrategy {
    public static var defaultValue: String { return K.titleStringTemplate }
}
public typealias DefaultTitleString = DefaultCodable<DefaultTitleStringStrategy> /// `@DefaultTitleString` decodes String and returns a template  string instead of nil if the Decoder is unable to decode the container.

public struct DefaultDateStartStrategy: DefaultCodableStrategy {
    static let now = Date()
    static let calendar = Calendar.current
    public static var defaultValue: Date {
        let components = calendar.dateComponents([.year,
                                                  .month,
            .day],
                                                 from: now)
        if let midnight = calendar.date(from: components) {
            return(midnight)
        }
        else {
            return Date()
        }
    }
}
public typealias DefaultStartDate = DefaultCodable<DefaultDateStartStrategy> /// `@DefaultTitleString` decodes String and returns a template  string instead of nil if the Decoder is unable to decode the container.

public struct DefaultDateEndStrategy: DefaultCodableStrategy {
    static let now = Date()
    static let calendar = Calendar.current
    public static var defaultValue: Date {
        var components = calendar.dateComponents([.year,
                                                  .month,
            .day],
                                                 from: now)
        components.hour = 23
        components.minute = 59

        if let midnight = calendar.date(from: components) {
            return(midnight)
        }
        else {
            return Date()
        }
    }
}
public typealias DefaultEndDate = DefaultCodable<DefaultDateEndStrategy> /// `@DefaultTitleString` decodes String and returns a template  string instead of nil if the Decoder is unable to decode the container.

public struct DefaultIDStrategy: DefaultCodableStrategy {
    public static var defaultValue: UUID { return UUID() }
}
public typealias DefaultID = DefaultCodable<DefaultIDStrategy> /// `@DefaultTitleString` decodes String and returns a template  string instead of nil if the Decoder is unable to decode the container.

public struct DefaultTaskModelTypeTypeStrategy: DefaultCodableStrategy {
    public static var defaultValue: TaskModelType { return .organic}
}
public typealias DefaultTaskModelType = DefaultCodable<DefaultTaskModelTypeTypeStrategy> /// `@DefaultIntStrategy` decodes String and returns a template  string instead of nil if the Decoder is unable to decode the container.

