#coding:utf-8
import web

urls = (
    '/', 'index',
    '/cluster', 'cluster',
    '/prediction', 'prediction',
    '/relation', 'relation',
    '/favicon.ico', 'icon'
)

# Process favicon.ico requests
class icon:
	def GET(self): raise web.seeother("/static/favicon.ico")

class index:
	def GET(self):
		return "This is BlueTechnology Demo api"


class cluster:
	def GET(self):
		user_data = web.input()
		key1=user_data.key1
		key2=user_data.key2
		return "not implemented yet"

class prediction:
	def GET(self):
		user_data = web.input(country="",site="",product="")
		country=user_data.country
		site=user_data.site
		product=user_data.product
		import prediction_plot
		if ((country=="") and (site=="")) or (product==""):
			return "please input country(or site) and product"
		if country!="":
			return prediction_plot.Forcast_and_Plot_Country(country = country, product = product)
		else:
			return prediction_plot.Forcast_and_Plot_Site(country_site = site, product = product)

class relation:
	def GET(self):
		user_data = web.input()
		key1=user_data.key1
		key2=user_data.key2
		return "not implemented yet"

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
