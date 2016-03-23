public protocol SwifTML { }

public protocol HTMLView: SwifTML {
    var render: String { get }
}


struct HTML5: HTMLView {
    let doctype = "<!DOCTYPE html>"
    var head: [HTMLElement]
    var body: [HTMLElement]

    var template: Tag {
        return Html([
            Head(head),
            Body(body)
        ])
    }

    var render: String {
        return doctype + template.htmlString
    }
}
