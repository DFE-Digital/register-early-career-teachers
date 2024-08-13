serve-documentation-site:
	cd documentation/site && bundle exec nanoc live --handler webrick --port 8000

build-documentation-site:
	cd documentation/site && bundle exec nanoc
