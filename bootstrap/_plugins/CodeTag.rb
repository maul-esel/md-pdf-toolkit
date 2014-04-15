class CodeBlock < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    @file = sanitize_filename(markup)
  end

  def sanitize_filename(file)
    file.strip.gsub(/(^"|"$)/, '')
  end

  def render(context)
    validate_file(context)

    code = File.read(full_file_path(context))
    enwrap_code(code, code_lang(context))
  end

  def enwrap_code(code, lang)
    <<-CODE
```#{lang}
#{code}
```
CODE
  end

  def validate_file(context)
    unless File.exists?(full_file_path(context))
      raise ArgumentError.new("code tag error: The specified file '#{full_file_name}' was not found.")
    end
  end

  def full_file_path(context)
    File.join(code_path(context), full_file_name)
  end

  def code_lang(context)
    context.registers[:site].config['code_lang'] || 'c'
  end

  def full_file_name
    if /\..+$/ =~ @file
      @file
    else
      @file + ".c"
    end
  end

  def code_path(context)
    context.registers[:site].config['code_path'] || '.'
  end
end

Liquid::Template.register_tag('code', CodeBlock)