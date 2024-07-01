BLOGS = $(wildcard */listing/)
TEMPLATES = $(BLOGS:/=/headline.html)

init:
	$(MAKE) clean
	$(MAKE) main

main: $(TEMPLATES)
	$(eval header = $(shell cat header.html))
	$(eval footer = $(shell cat footer.html))
	$(eval headlines = $(shell cat headlines.html))
	export BLOG_HEADLINES="$(headlines)" && \
	export HEADER="$(header)" && \
	export FOOTER="$(footer)" && \
	envsubst < index.tmpl > index.html

%/listing/headline.html: %/listing
	cd $^/../ && make
	$(eval desc = $(shell cat $^/description.txt))
	$(eval title = $(shell cat $^/title.txt))
	$(eval thumbnail = $^/thumbnail.png)
	$(eval path = $^/../index.html)
	export BLOG_DESCRIPTION="$(desc)" && \
	export BLOG_TITLE="$(title)" && \
	export BLOG_THUMBNAIL="$(thumbnail)" && \
	export BLOG_PAGE="$(path)" && \
	envsubst < headline_template.tmpl > $^/headline.html && \
	envsubst < headline_template.tmpl >> headlines.html

blogs:

clean:
	rm -f */listing/headline.html
	rm -f headlines.html
	rm -f index.html
	rm -f */index.html
