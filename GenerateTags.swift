import Foundation

// let read = try! String(contentsOfFile: "/Users/zef/code/Fly/HTMLTags.swift")
func write(_ text: String, path: String) {
    do {
        try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
    } catch {
        print("file write failed")
    }
}

extension String {
    mutating func addLine(_ content: String, indent: Int = 0) {
        var indentation = ""
        for _ in 0..<indent where !content.isEmpty {
            indentation += "    "
        }
        self += "\n" + indentation + content
    }
    var quoted: String {
        return "\"\(self)\""
    }
}

struct TagDefinition {
    let functionName: String
    let tag: String
    var arguments: [Argument]

    static let voidElements = ["area", "base", "br", "col", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"]
    var isVoid: Bool {
        return TagDefinition.voidElements.contains(tag)
    }

    var methodDefinition: String {
        var def = ""

        let args = allArguments
        if isVoid {
            def.addLine("public func \(functionName)(\(Argument.constructString(args))) -> Tag {")
            def += Argument.attributeCombinationCode(args)
            def.addLine("return Tag(\(tag.quoted), \"\", attributes: attributes)", indent: 1)
            def.addLine("}")
        } else {
            var contentArg = Argument(label: "content", type: "[HTMLElement]", isOptional: false, defaultValue: nil, requireLabel: false, addToAttributesAs: nil)
            var contentSuffixArgs = args
            contentSuffixArgs.append(contentArg)

            def.addLine("public func \(functionName)(\(Argument.constructString(contentSuffixArgs))) -> Tag {")
            def += Argument.attributeCombinationCode(args)
            def.addLine("return Tag(\(tag.quoted), attributes: attributes, content)", indent: 1)
            def.addLine("}")

            var contentPrefixArgs = args
            contentArg.type = "HTMLElement"
            contentPrefixArgs.insert(contentArg, at: 0)
            def.addLine("public func \(functionName)(\(Argument.constructString(contentPrefixArgs))) -> Tag {")
            def += Argument.attributeCombinationCode(args)
            def.addLine("return Tag(\(tag.quoted), attributes: attributes, [content])", indent: 1)
            def.addLine("}")
        }

        def += def.replacingOccurrences(of: "public func", with: "public static func")
        def.addLine("")

        return def
    }

    var allArguments: [Argument] {
        var args = arguments
        args.append(contentsOf: TagDefinition.defaultArguments)
        return args
    }


    static var defaultArguments: [Argument] {
        return [
            Argument(label: "attributes", type: "[Attribute]", isOptional: false, defaultValue: "[]", requireLabel: true, addToAttributesAs: nil)
        ]
    }
}

struct Argument {
    var label: String
    var type: String
    var isOptional: Bool
    var defaultValue: String?
    var requireLabel = true

    var addToAttributesAs: String? = nil

    func string() -> String {
        var prefixString = ""
        if !requireLabel {
            prefixString = "_ "
        }

        let optionalString = isOptional ? "?" : ""
        var defaultString = ""
        if let defaultValue = defaultValue {
            defaultString = " = \(defaultValue)"
        }

        return "\(prefixString)\(label): \(type)\(optionalString)\(defaultString)"
    }


    static func attributeCombinationCode(_ arguments: [Argument]) -> String {
        var code = ""
        let arguments = arguments.filter { $0.addToAttributesAs != nil }
        if !arguments.isEmpty {
            code.addLine("var attributes = attributes", indent: 1)
            for argument in arguments {
                let append = "attributes.append(.attribute(\"\(argument.addToAttributesAs!)\", \(argument.label)))"
                if argument.isOptional {
                    code.addLine("if let \(argument.label) = \(argument.label) { \(append) }", indent: 1)
                } else {
                    code.addLine(append, indent: 1)
                }
            }
        }
        return code
    }

    static func constructString(_ arguments: [Argument]) -> String {
        return arguments.map { $0.string() }.joined(separator: ", ")
    }
}

// to handle manually:
// a link img video input

let customTags = [
    TagDefinition(functionName: "Link", tag: "a", arguments: [
        Argument(label: "to", type: "String", isOptional: false, defaultValue: nil, requireLabel: true, addToAttributesAs: "href"),
        Argument(label: "target", type: "String", isOptional: true, defaultValue: "nil", requireLabel: true, addToAttributesAs: "target")
    ]),
    TagDefinition(functionName: "Img", tag: "img", arguments: [
        Argument(label: "src", type: "String", isOptional: false, defaultValue: nil, requireLabel: true, addToAttributesAs: "src"),
        Argument(label: "alt", type: "String", isOptional: false, defaultValue: "\"\"", requireLabel: true, addToAttributesAs: "alt")
    ]),
    TagDefinition(functionName: "Stylesheet", tag: "link", arguments: [
        Argument(label: "at", type: "String", isOptional: false, defaultValue: "\"\"", requireLabel: true, addToAttributesAs: "href"),
        Argument(label: "rel", type: "String", isOptional: false, defaultValue: "\"stylesheet\"", requireLabel: true, addToAttributesAs: "rel"),
    ]),
    // "input": "type"
    // text|password|checkbox|radio|submit|reset|file|hidden|image|button

    // "link":

    // "video":
    // "script":
]


let basicTagGroups = [
    "html head body title",
    "div span",
    "article aside header footer nav main section",
    "h1 h2 h3 h4 h5 h6",
    "p strong em i",
    "ul ol li",
    "br hr meta",
]

var tags = basicTagGroups.reduce([TagDefinition]()) { tags, group in
    var tags = tags
    let newTags = group.components(separatedBy: " ").map { TagDefinition(functionName: $0.capitalized, tag: $0, arguments: []) }
    tags.append(contentsOf: newTags)
    return tags
}
tags.append(contentsOf: customTags)

var code = "// This file is auto-generated by GenerateTags.swift, editing by hand is not recommended"
code.addLine("")
code.addLine("extension SwifTML {")
for tag in tags {
    for line in tag.methodDefinition.components(separatedBy: "\n") {
        code.addLine(line, indent: 1)
    }
}
code.addLine("}")

write(code, path: "./Sources/TagDefinitions.swift")


