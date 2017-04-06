import Foundation

public typealias HTMLAttributes = [String: String]

public protocol HTMLElement {
    var htmlString: String { get }
}

extension String: HTMLElement {
    public var htmlString: String { return self }
}

public struct Tag: HTMLElement {
    public var type: String
    public var content = [HTMLElement]()
    public var attributes = HTMLAttributes()
    public var whitespace = Whitespace.None

    public init(_ type: String, id: String? = nil, classes: [String]? = nil, data: HTMLAttributes? = nil, attributes: HTMLAttributes = HTMLAttributes(), _ content: [HTMLElement]) {
        self.type = type
        self.attributes = combined(attributes: attributes, id: id, classes: classes, data: data)
        self.content = content
    }

    public init(_ type: String, _ content: HTMLElement = "", id: String? = nil, classes: [String]? = nil, data: HTMLAttributes? = nil, attributes: HTMLAttributes = HTMLAttributes()) {
        self.type = type
        self.attributes = combined(attributes: attributes, id: id, classes: classes, data: data)
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
        return attributes.reduce("") { (result, pair) -> String in
            var result = result
            let (key, value) = pair
            // TODO: escape quotes and other chars in value
            result += " \(key)=\"\(value)\""
            return result
        }
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

prefix operator <<
prefix func <<(tag: Tag) -> Tag {
    var tag = tag
    tag.whitespace.combine(.Pre)
    return tag
}

postfix operator >>
postfix func >>(tag: Tag) -> Tag {
    var tag = tag
    tag.whitespace.combine(.Post)
    return tag
}

prefix operator <<>>
prefix func <<>>(tag: Tag) -> Tag {
    var tag = tag
    tag.whitespace = .All
    return tag
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
