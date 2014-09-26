# DocPad Configuration File
# http://docpad.org/docs/config

cheerio = require('cheerio')
url = require('url')

# Define the DocPad Configuration
docpadConfig = {
	templateData:
		# Specify some site properties
		site:
			# The production url of our website
			url: "http://msdevshow.com"

			# The default title of our website
			title: "MS Dev Show Podcast"

			# The website author's name
			author: "MS Dev Show"

			# The website author's email
			email: "jason@ytechie.com"


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} - #{@site.title}"
				# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		getPageUrlWithHostname: ->
			"#{@site.url}#{@document.url}"

		getIdForDocument: (document) ->
			hostname = url.parse(@site.url).hostname
			date = document.date.toISOString().split('T')[0]
			path = document.url
			"tag:#{hostname},#{date},#{path}"

		getOldUrl: (newUrl) ->
			newUrl.substr(0,newUrl.length-1) + '.html'

		fixLinks: (content, baseUrlOverride) ->
			baseUrl = @site.url
			if baseUrlOverride
				baseUrl = baseUrlOverride
			regex = /^(http|https|ftp|mailto):/

			$ = cheerio.load(content)
			$('img').each ->
				$img = $(@)
				src = $img.attr('src')
				$img.attr('src', baseUrl + src) unless regex.test(src)
			$('a').each ->
				$a = $(@)
				href = $a.attr('href')
				$a.attr('href', baseUrl + href) unless regex.test(href)
			$.html()

		moment: require('moment')

		getJavascriptEncodedTitle: (title) ->
			title.replace("'", "\\'")

		# Discus.com settings
		disqusShortName: 'msdevshow'

		# Google+ settings
		#googlePlusId: '105512648454315380048'

		# RSS Feed
		rssFeedUrl: 'http://msdevshow.libsyn.com/rss'

	collections:
		posts: ->
			@getCollection("html").findAllLive({layout: 'post', draft: $exists: false},[{date:-1}])
		menuPages: ->
			@getCollection("html").findAllLive({menu: $exists: true},[{menuOrder:1}])

	plugins:
		tagging:
			collectionName: 'posts'
			indexPageLowercase: true
		#dateurls:
		#	cleanurl: true
		#	trailingSlashes: true
		#	keepOriginalUrls: false
		#	collectionName: 'posts'
		#	dateIncludesTime: true
		paged:
			cleanurl: true
			startingPageNumber: 2
		cleanurls:
			trailingSlashes: true
		sass:
			compass: false
			sourcemap: true
}

# Export the DocPad Configuration
module.exports = docpadConfig