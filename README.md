# Sleetjs
Sleetjs is a litte indent-based language that compiles into HTML/XML.

It is not a template engine , so it can't render data.
However, you can override tags to generate a output file that can be used to
render data with a template engine.

## Installation
Make sure you have npm installed, then

    $ npm install -g sleet

## Command line usage

    $ sleet [options] input1 [input2...]

Sleet compiles input files to html/xml files. It can take multiple inputs,
either file or directory. For the directory input, it will scan the directory
recursively to find these files whose extension is `.sleet` and compile them.

$ sleet -h
/usr/local/bin/sleet [options] input.st [input2.st...]

```
Options:
-o, --output     The output directory
-e, --extension  The file extension of output file
-w, --watch      Watch file changes
-v, --version    Show the version number
-h, --help       Show this message
```

The option `-o, --output` is used to specify out folder. Any file inputs will be
placed in the destination folder flatly. And directory inputs will keep the sub
directory structure.

#### examples:
- Compile a directory tree of `.sleet` files in `src` into a parallel tree of
`.html` files in `dest`

        $ sleet src/ -o dest/

- Compile files into `.tag` files

        $ sleet src/ -o dest/ -e tag

- Watch for changes, and compile file every time it is saved

        $ sleet src/ -o dest/ -w

## Grammar
Sleet is indent based, it checks indent strictly. You can indent with any number
of `spaces` or a single `tab` character. But you have to keep consistent within
a given file.

```
doctype html
html
    head
        meta(charset='utf-8')
        title Welcom to Sleetjs
        link(rel='stylesheet' href='index.css')
        script(type='text/javascript'): uglify: coffee(bare=true).
            number = 2
            square = (x) -> x * x
            console.log square number
    body
        .container: p.
            This
            is
            a text block
        #footer
            p The end
```

compiles to:
```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Welcom to Sleetjs</title>
        <link rel="stylesheet" href="index.css"/>
        <script type="text/javascript">
var number,square;number=2,square=function(r){return r*r},console.log(square(number));
        </script>
    </head>
    <body>
        <div class="container"><p>
            This
            is
            a text block
        </p></div>
        <div id="footer">
            <p>The end</p>
        </div>
    </body>
</html>
```

### Tag
The first character of a tag name can be `[a-zA-Z$@_]` and the rest can be
`$[a-zA-Z0-9$_-]`.

```
html
    @at1
    $dollar2
    _underscore3
```

compiles to
```html
<html>
    <@at1></@at1>
    <$dollar2></$dollar2>
    <_underscore3></_underscore3>
</html>
```

Tag name, class literal, id literal are all optional. But you should specify one
of these at least.

```
#id
    .class
    #id2.class2
    .class3#id3.class4
    a#id3.class5
```
compiles to
```html
<div id="id">
    <div class="class"></div>
    <div id="id2" class="class2"></div>
    <div id="id3" class="class3 class4"></div>
    <a id="id3" class="class5"></a>
</div>
```

Inline tag could save indents.

```
.container
    div: #id: p text
```
compiles to
```html
<div class="container">
    <div><div id="id"><p>text</p></div></div>
</div>
```

### Attribute
A tag can have multiple attribute groups.

```
a.btn(href="#index")(class='btn-default') btn
```
compiles to
```html
<a class="btn btn-default" href="#index">btn</a>
```

If attribute value only contains `[a-zA-Z0-9$@_-]`, the quotes are optional.

```
a.btn(href="#index")(class=btn-default target=_blank) btn
```
compiles to
```html
<a class="btn btn-default" href="#index" target="_blank">btn</a>
```

Attribute groups could have multiple lines, each line present only one
attribute. And quotes are optional.

```
a#btn(
    href = #index
    class = btn btn-default and-something-else
)(target=_blank) btn
```
compiles to
```html
<a id="btn" href="#index" class="btn btn-default and-something-else" target="_blank">btn</a>
```



__Each attribute group could have an attribute predict. But by default the
predicts are all ignored. It just for extension.__
For example, if you use `Handlebars` as template engine:

```
a(class=active)&if(data) text
```
could be compiled to
```html
<a {{#if data}}class="active"{{/if}}>text</a>
```

or if you use `underscore` like template engine, it could be compiled to
```html
<a <% if (data) { %>class="active"<% } %>>text</a>
```

### Text
Inline text

```
p these are text
```
compiles to
```html
<p>these are text</p>
```

Text block, a dot immediately after tag

```
p.
    the indent of
        text block must
      equal or greater than parent's indent + 1
```
compiles to
```html
<p>
    the indent of
        text block must
      equal or greater than parent's indent + 1
</p>

```

Pipeline text and pipeline text block

```
p
    | pipeline
    | text
    | multiple lines
    .child-of-p
    a
        |.
            pipeline
                text block
        .child-of-a
```
compiles to
```html
<p>
pipeline
text
multiple lines
    <div class="child-of-p"></div>
    <a>
        pipeline
            text block
        <div class="child-of-a"></div>
    </a>
</p>
```

### Comment
Single line comment and comment block

```
# single line comment
.container
    #.
        multiple
        line
        comments
    .row
        .col-md-12 text
```
compiles to
```html
<!-- single line comment -->
<div class="container">
    <!--
        multiple
        line
        comments
    -->
    <div class="row">
        <div class="col-md-12">text</div>
    </div>
</div>
```

## API
to be continued

## License
MIT