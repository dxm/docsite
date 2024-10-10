PUBLIC ?= public
SOURCE = source
DOCS := $(shell find $(SOURCE) -name '*.md' -exec basename {} \;)
TEMP := $(DOCS:%=$(PUBLIC)/%)
HTML := $(TEMP:.md=.html)

all: public html images

public:
	@mkdir -p $(PUBLIC)

clean:
	@rm -rf $(PUBLIC)

run:
	@for i in `hostname -I`;do echo "http://$$i:8000";done
	@python3 -m http.server -d $(PUBLIC) 8000

images:
	@if [ -d $(SOURCE)/images ];then rsync -a --delete $(SOURCE)/images/ $(PUBLIC)/images/;fi

html: $(HTML)

$(PUBLIC)/manual.html: $(SOURCE)/manual.md
	discount-theme -c '+toc,+fencedcode,+dlextra,+header' -t manual.theme -E -f -o $@ $<

$(PUBLIC)/%.html: $(SOURCE)/%.md
	discount-theme -c '+fencedcode' -t page.theme -E -f -o $@ $<

.PHONY: build clean images
