// Telegram Bot SDK for Swift (unofficial).
// This file is autogenerated by API/generate_wrappers.rb script.

import Foundation


/// This object represents a video file.
///
/// - SeeAlso: <https://core.telegram.org/bots/api#video>

public struct Video: JsonConvertible, InternalJsonConvertible {
    /// Original JSON for fields not yet added to Swift structures.
    public var json: Any {
        get {
            return internalJson.object
        }
        set {
            internalJson = JSON(newValue)
        }
    }
    internal var internalJson: JSON

    /// Unique identifier for this file
    public var fileId: String {
        get { return internalJson["file_id"].stringValue }
        set { internalJson["file_id"].stringValue = newValue }
    }

    /// Video width as defined by sender
    public var width: Int {
        get { return internalJson["width"].intValue }
        set { internalJson["width"].intValue = newValue }
    }

    /// Video height as defined by sender
    public var height: Int {
        get { return internalJson["height"].intValue }
        set { internalJson["height"].intValue = newValue }
    }

    /// Duration of the video in seconds as defined by sender
    public var duration: Int {
        get { return internalJson["duration"].intValue }
        set { internalJson["duration"].intValue = newValue }
    }

    /// Optional. Video thumbnail
    public var thumb: PhotoSize? {
        get {
            let value = internalJson["thumb"]
            return value.isNullOrUnknown ? nil : PhotoSize(internalJson: value)
        }
        set {
            internalJson["thumb"] = newValue?.internalJson ?? JSON.null
        }
    }

    /// Optional. Mime type of a file as defined by sender
    public var mimeType: String? {
        get { return internalJson["mime_type"].string }
        set { internalJson["mime_type"].string = newValue }
    }

    /// Optional. File size
    public var fileSize: Int? {
        get { return internalJson["file_size"].int }
        set { internalJson["file_size"].int = newValue }
    }

    internal init(internalJson: JSON = [:]) {
        self.internalJson = internalJson
    }
    public init(json: Any) {
        self.internalJson = JSON(json)
    }
    public init(data: Data) {
        self.internalJson = JSON(data: data)
    }
}