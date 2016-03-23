# SwifTML - A Swift HTML Builder

SwifTML allows you to build HTML pages or fragments directly in Swift. Part of the [Fly](https://github.com/zef/Fly)
framework.

```swift
// TODO code sample
```

Some pre-defined tag helpers have been customized with special arguments and behavior.


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



