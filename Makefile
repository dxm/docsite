PUBLIC ?= public
SOURCE = source
DOCS := $(shell find $(SOURCE) -name '*.md' -exec basename {} \;)
TEMP := $(DOCS:%=$(PUBLIC)/%)
HTML := $(TEMP:.md=.html)

all: public html

public:
	@mkdir -p $(PUBLIC)

clean:
	@rm -rf $(PUBLIC)

run:
	python3 -m http.server -d $(PUBLIC) 8000

html: $(HTML)

$(PUBLIC)/%.html: $(SOURCE)/%.md
	discount-theme -c '-toc,+fencedcode,+dlextra,+header' -t page.theme -E -f -o $@ $<

.PHONY: build clean
