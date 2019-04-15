// Telegram Bot SDK for Swift (unofficial).
// This file is autogenerated by API/generate_wrappers.rb script.

import Foundation


/// This object contains information about one member of a chat.
///
/// - SeeAlso: <https://core.telegram.org/bots/api#chatmember>

public struct ChatMember: JsonConvertible, InternalJsonConvertible {
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

    /// Information about the user
    public var user: User {
        get { return User(internalJson: internalJson["user"]) }
        set { internalJson["user"] = JSON(newValue.json) }
    }

    /// The member's status in the chat. Can be “creator”, “administrator”, “member”, “restricted”, “left” or “kicked”
    public var statusString: String {
        get { return internalJson["status"].stringValue }
        set { internalJson["status"].stringValue = newValue }
    }

    /// Optional. Restricted and kicked only. Date when restrictions will be lifted for this user, unix time
    public var untilDate: Int? {
        get { return internalJson["until_date"].int }
        set { internalJson["until_date"].int = newValue }
    }

    /// Optional. Administrators only. True, if the bot is allowed to edit administrator privileges of that user
    public var canBeEdited: Bool? {
        get { return internalJson["can_be_edited"].bool }
        set { internalJson["can_be_edited"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can change the chat title, photo and other settings
    public var canChangeInfo: Bool? {
        get { return internalJson["can_change_info"].bool }
        set { internalJson["can_change_info"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can post in the channel, channels only
    public var canPostMessages: Bool? {
        get { return internalJson["can_post_messages"].bool }
        set { internalJson["can_post_messages"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can edit messages of other users and can pin messages, channels only
    public var canEditMessages: Bool? {
        get { return internalJson["can_edit_messages"].bool }
        set { internalJson["can_edit_messages"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can delete messages of other users
    public var canDeleteMessages: Bool? {
        get { return internalJson["can_delete_messages"].bool }
        set { internalJson["can_delete_messages"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can invite new users to the chat
    public var canInviteUsers: Bool? {
        get { return internalJson["can_invite_users"].bool }
        set { internalJson["can_invite_users"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can restrict, ban or unban chat members
    public var canRestrictMembers: Bool? {
        get { return internalJson["can_restrict_members"].bool }
        set { internalJson["can_restrict_members"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can pin messages, supergroups only
    public var canPinMessages: Bool? {
        get { return internalJson["can_pin_messages"].bool }
        set { internalJson["can_pin_messages"].bool = newValue }
    }

    /// Optional. Administrators only. True, if the administrator can add new administrators with a subset of his own privileges or demote administrators that he has promoted, directly or indirectly (promoted by administrators that were appointed by the user)
    public var canPromoteMembers: Bool? {
        get { return internalJson["can_promote_members"].bool }
        set { internalJson["can_promote_members"].bool = newValue }
    }

    /// Optional. Restricted only. True, if the user can send text messages, contacts, locations and venues
    public var canSendMessages: Bool? {
        get { return internalJson["can_send_messages"].bool }
        set { internalJson["can_send_messages"].bool = newValue }
    }

    /// Optional. Restricted only. True, if the user can send audios, documents, photos, videos, video notes and voice notes, implies can_send_messages
    public var canSendMediaMessages: Bool? {
        get { return internalJson["can_send_media_messages"].bool }
        set { internalJson["can_send_media_messages"].bool = newValue }
    }

    /// Optional. Restricted only. True, if the user can send animations, games, stickers and use inline bots, implies can_send_media_messages
    public var canSendOtherMessages: Bool? {
        get { return internalJson["can_send_other_messages"].bool }
        set { internalJson["can_send_other_messages"].bool = newValue }
    }

    /// Optional. Restricted only. True, if user may add web page previews to his messages, implies can_send_media_messages
    public var canAddWebPagePreviews: Bool? {
        get { return internalJson["can_add_web_page_previews"].bool }
        set { internalJson["can_add_web_page_previews"].bool = newValue }
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