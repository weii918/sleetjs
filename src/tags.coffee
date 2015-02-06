isString = (str) -> Object.prototype.toString.call(str) is '[object String]'

exports.Tag = class Tag
    @types = {}
    @registerTag = (type, clazz) -> @types[type] = clazz
    @create = (options, parent) ->
        name = options.name
        clazz = @types[name] or Tag
        new clazz(options, parent)

    constructor: (@options, @parent) ->
        @attributes = {}
        @content = ''
        @name = options.name
        @indent = options.indent
        @haveAttributes = false

        @setId(options.id) if options.id
        @setClass(options.clazz) if options.clazz.length > 0
        @appendContent(options.text) if options.text
        @setAttribute key, value for key, value of options.attrs or {}

    setId: (text) ->
        @setAttribute 'id', text

    setClass: (clazz) ->
        @setAttribute 'class', if Array.isArray(clazz) then clazz.join(' ') else clazz

    setAttribute: (name, value) ->
        @haveAttributes = true
        if name is 'clazz' or name is 'class'
            if @attributes['class']
                @attributes['class'] += ' ' + value
            else
                @attributes['class'] = value
        else
            @attributes[name] = value

    appendContent: (text) ->
        @content += text

    generateAttributes: (result) ->
        return unless @haveAttributes
        result.push ' '
        result.push if value is null then key else "#{key}=\"#{value}\"" for key, value of @attributes

    generateContent: (result) ->
        children = []
        for item in @options.children
            if isString(item)
                @appendContent item
            else
                children.push Tag.create(item, @).getOutput()

        result.push @content
        result.push item for item in children

    generateOpen: (result) ->
        result.push '<'
        result.push @name
        @generateAttributes(result)
        result.push '>'

    generateClose: (result) ->
        if result[result.length - 1] is '>'
            result.pop()
            result.push '/>'
        else
            result.push "</#{@name}>"

    getOutput: ->
        result = []
        @generateOpen result
        @generateContent result
        @generateClose result

        result.join ''
