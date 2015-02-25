# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
user = User.create(email:"test@test.se",password:"123")
user.save

App.delete_all
app = App.create(name:"testers App")
app.user = user
app.save

Position.delete_all
pos = Position.create(lat:"321.12332", lng:"31.3214", name:"testPosition")
pos.save

Event.delete_all
event = Event.create(name:"eventName", eventDate:"12/12/2012", desc:"desc of event")

event.user = user
event.position = pos
event.save

Tag.delete_all
tag = Tag.create(name:"yoolo mah tag")
tag.save

TagOnEvent.delete_all
toe = TagOnEvent.new

toe.event = event
toe.tag = tag
toe.save






