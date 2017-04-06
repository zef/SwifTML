import UIKit
import WebKit
import PlaygroundSupport

let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 600.0, height: 600.0))
PlaygroundPage.current.liveView = webView

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

struct Bootstrap: HTMLView {
    var title: String
    var content: [HTMLElement]

    var render: String {
        return HTML5(
            head: [
                Meta(attributes: ["charset": "utf-8"]),
                Meta(attributes: ["name":"viewport", "content":"width=device-width, initial-scale=1"]),
                Title(title),
                Stylesheet(at: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css", attributes: [
                    "integrity": "sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u",
                    "crossorigin": "anonymous"
                ])
            ], body: [
                navigation,
                Div(classes: ["container"], [
                    Section(content),
                    Hr(),
                    footer
                ])
            ]
        ).render
    }

    static func Jumbotron(_ elements: [HTMLElement]) -> HTMLElement {
        return Div(classes: ["container"], [
            Div(classes: ["jumbotron"], elements)
        ])
    }

    var navigation: HTMLElement {
        return Nav(classes: ["navbar navbar-inverse navbar-fixed-top"], [
            Div(classes: ["container"], [
                Div(classes: ["navbar-header"], [
                    Link(title, to: "#", classes: ["navbar-brand"])
                ])
            ])
        ])
    }
    var footer: HTMLElement {
        return Footer(classes: ["footer"], [
            Ul([
                Li(Link("About Us", to: "#about-us")),
                Li(Link("Contact", to: "#contact"))
            ])
        ])
    }

}

struct ProductPage: HTMLView {
    let product: Product

    func Button(_ text: String, to: String) -> HTMLElement {
        return Link(text, to: to, classes: ["btn btn-primary btn-lg"], attributes: ["role": "button"])
    }

    var content: [HTMLElement] {
        return [
            Bootstrap.Jumbotron([
                H1(product.name),
                P(product.subtitle),
                Button("View on GitHub", to: product.github)
            ]),
            Ul(classes: ["bullet-list"],
               product.bulletPoints.map { Li($0) }
            ),
            P([
                Span("Here's an example of"),
                <<Strong("using Prefix and Postfix")>>,
                Span("operators to add whitespace around your tags."),
            ])
        ]
    }

    var title: String {
        return "\(product.name) | \(product.subtitle)"
    }

    var render: String {
        return Bootstrap(title: title, content: content).render
    }
}

struct Product {
    let name: String
    let subtitle: String
    let github: String
    let bulletPoints: [String]
}

let swifTML = Product(name: "SwifTML",
                      subtitle: "An HTML Builder for Swift",
                      github: "https://github.com/zef/SwifTML",
                      bulletPoints: [
                        "Swift is really great",
                        "There are some cool things we could do with Swift",
                        "Especially now that you can run it on linux",
                        "So we should write an HTML Builder for it",
                    ])

let page = ProductPage(product: swifTML)
let html = page.render

webView.loadHTMLString(html, baseURL: nil)
print(html)
