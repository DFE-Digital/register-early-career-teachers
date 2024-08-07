watch-documentation-site:
	ls documentation/site/content/**/* | entr -s "cd documentation/site && bundle exec nanoc"

serve-documentation-site:
	cd documentation/site/output && ruby -run -e httpd . -p 8000

build-documentation-site:
	cd documentation/site && bundle exec nanoc