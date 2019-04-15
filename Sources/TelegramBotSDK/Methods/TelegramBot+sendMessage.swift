// Telegram Bot SDK for Swift (unofficial).
// This file is autogenerated by API/generate_wrappers.rb script.

import Foundation
import Dispatch

public extension TelegramBot {
    typealias SendMessageCompletion = (_ result: Message?, _ error: DataTaskError?) -> ()

    /// Use this method to send text messages. On success, the sent Message is returned.
    /// - Parameters:
    ///     - chat_id: Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    ///     - text: Text of the message to be sent
    ///     - parse_mode: Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message.
    ///     - disable_web_page_preview: Disables link previews for links in this message
    ///     - disable_notification: Sends the message silently. Users will receive a notification with no sound.
    ///     - reply_to_message_id: If the message is a reply, ID of the original message
    ///     - reply_markup: Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
    /// - Returns: Message on success. Nil on error, in which case `TelegramBot.lastError` contains the details.
    /// - Note: Blocking version of the method.
    ///
    /// - SeeAlso: <https://core.telegram.org/bots/api#sendmessage>
    @discardableResult
    public func sendMessageSync(
            chatId: ChatId,
            text: String,
            parseMode: ParseMode? = nil,
            disableWebPagePreview: Bool? = nil,
            disableNotification: Bool? = nil,
            replyToMessageId: Int? = nil,
            replyMarkup: ReplyMarkup? = nil,
            _ parameters: [String: Any?] = [:]) -> Message? {
        return requestSync("sendMessage", defaultParameters["sendMessage"], parameters, [
            "chat_id": chatId,
            "text": text,
            "parse_mode": parseMode?.rawValue,
            "disable_web_page_preview": disableWebPagePreview,
            "disable_notification": disableNotification,
            "reply_to_message_id": replyToMessageId,
            "reply_markup": replyMarkup])
    }

    /// Use this method to send text messages. On success, the sent Message is returned.
    /// - Parameters:
    ///     - chat_id: Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    ///     - text: Text of the message to be sent
    ///     - parse_mode: Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message.
    ///     - disable_web_page_preview: Disables link previews for links in this message
    ///     - disable_notification: Sends the message silently. Users will receive a notification with no sound.
    ///     - reply_to_message_id: If the message is a reply, ID of the original message
    ///     - reply_markup: Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
    /// - Returns: Message on success. Nil on error, in which case `error` contains the details.
    /// - Note: Asynchronous version of the method.
    ///
    /// - SeeAlso: <https://core.telegram.org/bots/api#sendmessage>
    public func sendMessageAsync(
            chatId: ChatId,
            text: String,
            parseMode: ParseMode? = nil,
            disableWebPagePreview: Bool? = nil,
            disableNotification: Bool? = nil,
            replyToMessageId: Int? = nil,
            replyMarkup: ReplyMarkup? = nil,
            _ parameters: [String: Any?] = [:],
            queue: DispatchQueue = .main,
            completion: SendMessageCompletion? = nil) {
        return requestAsync("sendMessage", defaultParameters["sendMessage"], parameters, [
            "chat_id": chatId,
            "text": text,
            "parse_mode": parseMode?.rawValue,
            "disable_web_page_preview": disableWebPagePreview,
            "disable_notification": disableNotification,
            "reply_to_message_id": replyToMessageId,
            "reply_markup": replyMarkup],
            queue: queue, completion: completion)
    }
}
