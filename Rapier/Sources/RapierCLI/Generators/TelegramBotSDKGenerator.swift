import Foundation
import Rapier

private struct Context {
    let directory: String
    
    var outTypes: String = ""
    var outMethods: String = ""
    
    init(directory: String) {
        self.directory = directory
    }
}

class TelegramBotSDKGenerator: CodeGenerator {
    required init(directory: String) {
        self.context = Context(directory: directory)
    }
    
    func start() throws {
        
    }
    
    func beforeGeneratingTypes() throws {
        let header = """
        // This file is automatically generated by Rapier
        
        import Foundation

        
        """
        context.outTypes.append(header)
    }
    
    func generateType(name: String, info: TypeInfo) throws {
        context.outTypes.append("""
            public struct \(name): JsonConvertible, InternalJsonConvertible {
                /// Original JSON for fields not yet added to Swift structures.
                public var json: Any {
                    get { return internalJson.object }
                    set { internalJson = JSON(newValue) }
                }
                internal var internalJson: JSON
            
            """)
        var allInitParams: [String] = []
        info.fields.sorted { $0.key < $1.key }.forEach { fieldName, fieldInfo in
            let getterName = makeGetterName(typeName: name, fieldName: fieldName, fieldType: fieldInfo.type)
            if fieldInfo.type == "True" {
                allInitParams.append(#""\#(fieldName)" = true"#)
            } else {
                if let field = buildFieldTemplate(fieldName: getterName, fieldInfo: fieldInfo) {
                    context.outTypes.append(field)
                }
            }
            
        }
        let initParamsString = allInitParams.joined(separator: ", ")
        context.outTypes.append("""
            internal init(internalJson: JSON = \(initParamsString)) {
                self.internalJson = internalJson
            }
            public init(json: Any) {
                self.internalJson = JSON(json)
            }
            public init(data: Data) {
                self.internalJson = JSON(data: data)
            }
        }\n\n\n
        """)
    }
    
    func afterGeneratingTypes() throws {
    }
    
    func beforeGeneratingMethods() throws {
        let methodsHeader = """
        // This file is automatically generated by Rapier


        import Foundation
        import Dispatch

        public extension TelegramBot {


        """
        
        context.outMethods.append(methodsHeader)
    }
    
    func generateMethod(name: String, info: MethodInfo) throws {
        
        let parameters = info.parameters.sorted { $0.key < $1.key }
        
        let fields: [String] = parameters.map { fieldName, fieldInfo in
            var result = "\(fieldName.camelized()): \(buildSwiftType(fieldInfo: fieldInfo))"
            if fieldInfo.isOptional {
                result.append(" = nil")
            }
            
            return result
        }
        
        let arrayFields: [String] = parameters.map { fieldName, _ in
            return #""\#(fieldName)": \#(fieldName.camelized())"#
        }
        
        let fieldsString = fields.joined(separator: ",\n        ")
        let arrayFieldsString = arrayFields.joined(separator: ",\n")
        
        let completionName = (name.first?.uppercased() ?? "") + name.dropFirst() + "Completion"
        let resultSwiftType = buildSwiftType(fieldInfo: info.result)
        
        let method = """
            typealias \(completionName) = (_ result: \(resultSwiftType), _ error: DataTaskError?) -> ()
        
            @discardableResult
            public func \(name)Sync(
                    \(fieldsString),
                    _ parameters: [String: Any?] = [:]) -> Bool? {
                return requestSync("addStickerToSet", defaultParameters["addStickerToSet"], parameters, [
                    \(arrayFieldsString)])
            }

            public func \(name)Async(
                    \(fieldsString)
                    _ parameters: [String: Any?] = [:],
                    queue: DispatchQueue = .main,
                    completion: \(completionName)? = nil) {
                return requestAsync("addStickerToSet", defaultParameters["addStickerToSet"], parameters, [
                    \(arrayFieldsString)],
                    queue: queue, completion: completion)
            }
        
        """
        
        context.outMethods.append(method)
    }
    
    func afterGeneratingMethods() throws {
        context.outMethods.append("\n}\n")
    }
    
    func finish() throws {
        try saveTypes()
        try saveMethods()
    }
    
    private func saveTypes() throws {
        let dir = URL(fileURLWithPath: context.directory, isDirectory: true)
        let file = dir.appendingPathComponent("types.swift", isDirectory: false)
        try context.outTypes.write(to: file, atomically: true, encoding: .utf8)
    }
    
    private func saveMethods() throws {
        let dir = URL(fileURLWithPath: context.directory, isDirectory: true)
        let file = dir.appendingPathComponent("methods.swift", isDirectory: false)
        try context.outMethods.write(to: file, atomically: true, encoding: .utf8)
    }
    
    private func buildSwiftType(fieldInfo: FieldInfo) -> String {
        var type: String
        if (fieldInfo.isArray) {
            type = "[\(fieldInfo.type)]"
        } else {
            type = fieldInfo.type
        }
        if (fieldInfo.isOptional) {
            type.append("?")
        }
        return type
    }
    
    private func buildFieldTemplate(fieldName: String, fieldInfo: FieldInfo) -> String? {
        switch (fieldInfo.type, fieldInfo.isOptional) {
        case ("String", true):
            return """
                public var \(fieldName.camelized()): String? {
                    get { return internalJson["\(fieldName)"].string }
                    set { internalJson["\(fieldName)"].string = newValue }
                }\n\n
            """
        case ("String", false):
            return """
                public var \(fieldName.camelized()): String {
                    get { return internalJson["\(fieldName)"].stringValue }
                    set { internalJson["\(fieldName)"].stringValue = newValue }
                }\n\n
            """
        case ("Int", true):
            return """
                public var \(fieldName.camelized()): Int? {
                    get { return internalJson["\(fieldName)"].int }
                    set { internalJson["\(fieldName)"].int = newValue }
                }\n\n
            """
        case ("Int", false):
            return """
                public var \(fieldName.camelized()): Int {
                    get { return internalJson["\(fieldName)"].intValue }
                    set { internalJson["\(fieldName)"].intValue = newValue }
                }\n\n
            """
        case ("Int64", true):
            return """
                public var \(fieldName.camelized()): Int64? {
                    get { return internalJson["\(fieldName)"].int64 }
                    set { internalJson["\(fieldName)"].int64 = newValue }
                }\n\n
            """
        case ("Int64", false):
            return """
                public var \(fieldName.camelized()): Int64 {
                    get { return internalJson["\(fieldName)"].int64Value }
                    set { internalJson["\(fieldName)"].int64Value = newValue }
                }\n\n
            """
        case ("Date", true):
            return """
                public var \(fieldName.camelized()): Date? {
                    get {
                        guard let date = internalJson["\(fieldName)"].double else { return nil }
                        return Date(timeIntervalSince1970: date)
                    }
                    set {
                        internalJson["\(fieldName)"].double = newValue?.timeIntervalSince1970
                    }
                }\n\n
            """
        case ("Date", false):
            return """
            public var \(fieldName.camelized()): Date {
                    get { return Date(timeIntervalSince1970: internalJson["\(fieldName)"].doubleValue) }
                    set { internalJson["\(fieldName)"].double = newValue.timeIntervalSince1970 }
                }\n\n
            """
        case ("Float", true):
            return """
                public var \(fieldName.camelized()): Float? {
                    get { return internalJson["\(fieldName)"].float }
                    set { internalJson["\(fieldName)"].float = newValue }
                }\n\n
            """
        case ("Float", false):
            return """
                public var \(fieldName.camelized()): Float {
                    get { return internalJson["\(fieldName)"].floatValue }
                    set { internalJson["\(fieldName)"].floatValue = newValue }
                }\n\n
            """
        case ("Bool", true):
            return """
                public var \(fieldName.camelized()): Bool? {
                    get { return internalJson["\(fieldName)"].bool }
                    set { internalJson["\(fieldName)"].bool = newValue }
                }\n\n
            """
        case ("Bool", false):
            return """
                public var \(fieldName.camelized()): Bool {
                    get { return internalJson["\(fieldName)"].boolValue }
                    set { internalJson["\(fieldName)"].boolValue = newValue }
                }\n\n
            """
        case (_, _):
            if fieldInfo.isArrayOfArray {
                if fieldInfo.isOptional {
                    return """
                        public var \(fieldName.camelized()): [[\(fieldInfo.type)]] {
                            get { return internalJson["\(fieldName)"].twoDArrayValue() }
                            set {
                                if newValue.isEmpty {
                                    json["\(fieldName)"] = JSON.null
                                    return
                                }\n"\
                                var rowsJson = [JSON]()
                                rowsJson.reserveCapacity(newValue.count)
                                for row in newValue {
                                    var colsJson = [JSON]()
                                    colsJson.reserveCapacity(row.count)
                                    for col in row {
                                        let json = col.internalJson
                                        colsJson.append(json)
                                    }
                                    rowsJson.append(JSON(colsJson))
                                }
                                internalJson["\(fieldName)"] = JSON(rowsJson)
                            }
                        }\n\n
                    """
                } else {
                    return """
                        public var \(fieldName.camelized()): [[\(fieldInfo.type)]] {
                            get { return internalJson["\(fieldName)"].twoDArrayValue() }
                            set {
                                var rowsJson = [JSON]()
                                rowsJson.reserveCapacity(newValue.count)
                                for row in newValue {
                                    var colsJson = [JSON]()
                                    colsJson.reserveCapacity(row.count)
                                    for col in row {
                                        let json = col.internalJson
                                        colsJson.append(json)
                                    }
                                    rowsJson.append(JSON(colsJson))
                                }
                                internalJson["\(fieldName)"] = JSON(rowsJson)
                            }
                        }\n\n
                    """
                }
            } else if fieldInfo.isArray {
                if fieldInfo.isOptional {
                    return """
                        public var \(fieldName): [\(fieldInfo.type)] {
                            get { return internalJson["\(fieldName)"].customArrayValue() }
                            set { internalJson["\(fieldName)"] = newValue.isEmpty ? JSON.null : JSON.initFrom(newValue) }
                        }\n\n
                    """
                } else {
                    return """
                        public var \(fieldName.camelized()): [\(fieldInfo.type)] {
                            get { return internalJson["\(fieldName)"].customArrayValue() }
                            set { internalJson["\(fieldName)"] = JSON.initFrom(newValue) }
                        }\n\n
                    """
                }
            } else if fieldInfo.type.starts(with: "InputMessageContent") {
                if fieldInfo.isOptional {
                    return """
                        public var inputMessageContent: InputMessageContent? {
                            get {
                                fatalError("Not implemented")
                            }
                            set {
                                internalJson["input_message_content"] = JSON(newValue?.json ?? JSON.null)
                            }
                        }\n\n
                    """
                } else {
                    return """
                        public var inputMessageContent: InputMessageContent {
                            get {
                                fatalError("Not implemented")
                            }
                            set {
                                internalJson["input_message_content"] = JSON(newValue.json)
                            }
                        }\n\n
                    """
                }
            } else {
                if fieldInfo.isOptional {
                    return """
                        public var \(fieldName.camelized()): \(fieldInfo.type)? {
                            get {
                                let value = internalJson["\(fieldName)"]
                                return value.isNullOrUnknown ? nil : \(fieldInfo.type)(internalJson: value)
                            }
                            set {
                                internalJson["\(fieldName)"] = newValue?.internalJson ?? JSON.null
                            }
                        }\n\n
                    """
                } else {
                    return """
                        public var \(fieldName.camelized()): \(fieldInfo.type) {
                            get { return \(fieldInfo.type)(internalJson: internalJson["\(fieldName)"]) }
                            set { internalJson["\(fieldName)"] = JSON(newValue.json) }
                        }\n\n
                    """
                }
            }
        }
    }
    
    private var context: Context
}

extension TelegramBotSDKGenerator {
    private func makeGetterName(typeName: String, fieldName: String, fieldType: String) -> String {
        switch (typeName, fieldName) {
        case ("ChatMember", "status"):
            return "status_string"
        default:
            if fieldName == "type" && fieldType == "String" {
                return "type_string"
                
            }
            if fieldName == "parse_mode" && fieldType == "String" {
                return "parse_mode_string"
            }
            break
        }
        return fieldName
    }
}


extension String {
    fileprivate func camelized() -> String {
        let components = self.components(separatedBy: "_")
        
        let firstLowercasedWord = components.first?.lowercased()
        
        let remainingWords = components.dropFirst().map {
            $0.prefix(1).uppercased() + $0.dropFirst().lowercased()
        }
        return ([firstLowercasedWord].compactMap{ $0 } + remainingWords).joined()
    }
}
