import Foundation

public typealias HTMLAttributes = [String: String]

public protocol HTMLElement {
    var htmlString: String { get }
}

extension String: HTMLElement {
    public var htmlString: String { return self }
}

public enum Attribute {
    case id(String)
    case `class`(String)
    case classes([String])
    case data(String, String)
    case attribute(String, String)
    case style(String)
    // could be useful to have some resettable attributes?
    // case resetClasses
    // case resetStyle
    // case resetAll

    typealias AttributePair = (key: String, value: String)

    var attributePair: AttributePair {
        switch self {
        case .id(let value):
            return ("id", value)
        case .class(let value):
            return ("class", value)
        case .classes(let value):
            return ("class", value.joined(separator: " "))
        case .data(let key, let value):
            // TODO: escape quotes and other chars in value
            // anywhere else besides data? Probably style too?
            return ("data-\(key)", value)
        case .attribute(let key, let value):
            return (key, value)
        case .style(let value):
            return ("style", value)
        }
    }

    static func tagString(attributes: [Attribute]) -> String {
        var normalized = [String: String]()
        for attribute in attributes {
            let pair = attribute.attributePair
            normalized[pair.key] = pair.value
        }
        return normalized.map { key, value in
            return "\(key)=\"\(value)\""
        }.joined(separator: " ")
    }
}

public struct Tag: HTMLElement {
    public var type: String
    public var content = [HTMLElement]()
    public var attributes = [Attribute]()
    public var whitespace = Whitespace.None

    public init(_ type: String, attributes: [Attribute] = [], _ content: [HTMLElement]) {
        self.type = type
        self.attributes = attributes
        self.content = content
    }

    public init(_ type: String, _ content: HTMLElement = "", attributes: [Attribute] = []) {
        self.type = type
        self.attributes = attributes
        self.content = [content]
    }

    public var htmlString: String {
        let tag: String
        if isVoid {
            tag = "<\(type)\(attributeString) />"
        } else {
            tag = "<\(type)\(attributeString)>\(contentString)</\(type)>"
        }
        return whitespace.pre + tag + whitespace.post
    }

    static let voidElements = ["area", "base", "br", "col", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"]
    public var isVoid: Bool {
        return Tag.voidElements.contains(type)
    }

    public var contentString: String {
        return content.map { $0.htmlString }.joined(separator: "")
    }

    private var attributeString: String {
        guard !attributes.isEmpty else { return "" }
        return Attribute.tagString(attributes: attributes)
    }

    private func combined(attributes: HTMLAttributes, id: String?, classes: [String]?, data: HTMLAttributes?) -> HTMLAttributes {
        var attributes = attributes
        if let data = data {
            for (name, value) in data {
                attributes["data-\(name)"] = value
            }
        }
        if let classes = classes {
            attributes["class"] = classes.joined(separator: " ")
        }
        if let id = id {
            attributes["id"] = id
        }
        return attributes
    }

}

extension Tag: CustomStringConvertible {
    public var description: String {
        return htmlString
    }
}

extension Tag {
    public enum Whitespace {
        case None, Pre, Post, All
        var pre: String {
            switch self {
            case .Pre, .All:
                return " "
            default:
                return ""
            }
        }

        var post: String {
            switch self {
            case .Post, .All:
                return " "
            default:
                return ""
            }
        }

        public mutating func combine(_ other: Whitespace) {
            switch other {
            case .Pre where self == .Post:
                self = .All
            case .Post where self == .Pre:
                self = .All
            default:
                self = other
            }
        }
    }
}
