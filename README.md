# SwifTML - A Swift HTML Builder

SwifTML allows you to build HTML pages or fragments directly in Swift. Part of the [Fly](https://github.com/zef/Fly)
framework.

Download the included playground to see how it works.

![Playground Image](/PlaygroundDemo.png?raw=true)

```swift
// TODO code sample
```
The built-in Tag definitions are auto-generated, with some pre-defined tag helpers that are customized with special arguments and behavior.

Examples of custom tags are currently `Link`, `Img`, and `Stylesheet`, with more ideas written down.

You are encouraged to define your own tag helpers with an extension:

```swift
// TODO code sample
```

There are some helpers to control the whitespace between elements, you have to define these yourself in your project.
See the playground for a usage example.

```swift
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
```


### Never-Asked Questions

##### Why would you do this?

Writing HTML tags by hand is for suckers.

Using SwifTML embraces and leans on the compiler to make writing HTML a type-safe activity. I have a
[healthy distrust of String use](https://github.com/zef/Fly#goals) when not necessary. This approach
could also make it easy to enforce semantically valid HTML output.

Other templating solutions require more indirection and give up type-safety/compiler benefits.

Cues have been taken from the [tag helpers in Rails](http://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-content_tag) and templating languages like [Slim](http://slim-lang.com).

We'll see if this is a good idea long-term, but I find this preferable to existing Swift templating
solutions that I'm aware of.

##### This is stupid.

That's not a question? Just go [use Stencil](https://github.com/kylef/Stencil).

### Design Notes

There's some weird and non-standard stuff going on here:

- The tag functions start with an uppercase character, unlike most functions
- Each pre-defined tag has two function variants for taking content:
  - as the first argument for simple content
  - as the last argument for defining a list of sub-tags
- Each tag function pair has both class and instance variants
- Tag functions are auto-generated

These decisions came out of trying to balance aesthetic desires and technical factors and limitations.

I want it as seamless as possible to use SwifTML anywhere without making the functions globally
available. The function definitions for tags look more like a struct, but I don't actually want
them to be individual structs. One benefit here is they each return an instance of the `Tag` struct.


## To Do

- [x] Refactor arguments to take enum cases for attributes instead of each type of argument having its own argument pair.
Something like:
```Swift
Div("content", attributes: .data("name", "value"), .id("page-123"), .class("button"), .classes(["one", "two", "three"]))
-> <div data-name="value", id="page-123", class="button one two three">content</div>
// class and classes would be properly combined, in addition to style classes and other similar things.
```
- [ ] Experiment with short-hand syntax (ZenCoding/Emmet style)? Like `Tag("ul.listClass>li#itemID", "hello")` outputting
  `<ul class="listClass"><li id="itemID">hello</li></ul>`. This gives up too much safety, but something like that might be interesting.

