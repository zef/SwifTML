public protocol SwifTML { }

public protocol HTMLView: SwifTML {
    var render: String { get }
}


public struct HTML5: HTMLView {
    let doctype = "<!DOCTYPE html>"
    public var head: [HTMLElement]
    public var body: [HTMLElement]

    public init(head: [HTMLElement], body: [HTMLElement]) {
        self.head = head
        self.body = body
    }

    public var template: Tag {
        return Html([
            Head(head),
            Body(body)
        ])
    }

    public var render: String {
        return doctype + template.htmlString
    }
}
