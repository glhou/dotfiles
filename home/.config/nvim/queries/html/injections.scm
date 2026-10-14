; Jinja2 expressions: {{ ... }}
((text) @injection.content
 (#match? @injection.content "\\v\\{\\{.*\\}\\}")
 (#set! injection.language "jinja"))

; Jinja2 statements: {% ... %}
((text) @injection.content
 (#match? @injection.content "\\v\\{\\%.*\\%\\}")
 (#set! injection.language "jinja"))

; Jinja2 comments: {# ... #}
((text) @injection.content
 (#match? @injection.content "\\v\\{\\#.*\\#\\}")
 (#set! injection.language "jinja"))
