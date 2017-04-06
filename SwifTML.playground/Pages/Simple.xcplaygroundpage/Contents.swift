import UIKit
import WebKit
import PlaygroundSupport

let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 600.0, height: 600.0))
PlaygroundPage.current.liveView = webView

struct MyView: HTMLView {

    var render: String {
        return HTML5(
            head: [
                Title("My View"),
            ], body: [
                Header(H1("We're writing HTML")),
                P("But in Swift"),
                P("Let's make a list for fun!"),
                Hr(),
                Section([
                    H3("This is a list:"),
                    Ul((1...10).map { Li(String($0)) })
                ]),
                Footer("That's all for now.")
            ]
        ).render
    }
}


let html = MyView().render
webView.loadHTMLString(html, baseURL: nil)
print(html)
