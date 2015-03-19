# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
user = User.create(email:"test@test.se",password:"123", isAdmin:true)
user.save
user2 = User.create(email:"tester2@test.se",password:"123")
user2.save
user3 = User.create(email:"testare3@test.se",password:"123")
user3.save
user4 = User.create(email:"megatester4@test.se",password:"123")
user4.save

App.delete_all
app = App.create(name:"testers App")
app.user = user
app.save
app2 = App.create(name:"CoolAppio")
app2.user = user
app2.save
app3 = App.create(name:"SuperChicken App")
app3.user = user2
app3.save
app4 = App.create(name:"Duckhunter App")
app4.user = user3
app4.save

Position.delete_all
pos = Position.create(latitude:58.305881, longitude:16.199341, name:"testPosition Kronan")
pos.save
pos2 = Position.create(latitude:59.020061, longitude:16.089478, name:"testPosition2 Lövet")
pos2.save
pos3 = Position.create(latitude:58.546403,  longitude:15.015564, name:"testPosition3 Flaskan")
pos3.save
pos4 = Position.create(latitude:58.760723, longitude:16.954651, name:"testPosition4 Skivan")
pos4.save
pos5 = Position.create(name:"mjölby"   ,     latitude:58.3226908 ,   longitude:15.1335348)
pos5.save
pos6 = Position.create(name:"linköping",     latitude:58.410807  ,   longitude:15.6213727)
pos6.save
pos7 = Position.create(name:"mantorp")
pos7.save

Event.delete_all
event = Event.create(name:"Kronans Event", eventDate:"12/12/2012", desc:"En krona som har ett event, eller något")
event.user = user
event.position = pos
event.save
event2 = Event.create(name:"Disco", eventDate:"11/11/2011", desc:"ett löv som har något trevligt för sig, ett disco kanske")
event2.user = user
event2.position = pos2
event2.save
event3 = Event.create(name:"Uppror", eventDate:"10/11/2015", desc:"Uppror på en skiva")
event3.user = user3
event3.position = pos4
event3.save


Tag.delete_all
tag = Tag.create(name:"krona")
tag.save
tag2 = Tag.create(name:"löv")
tag2.save
tag3 = Tag.create(name:"Flaska")
tag3.save
tag4 = Tag.create(name:"Skiva")
tag4.save
tag5 = Tag.create(name:"Disco")
tag5.save
tag6 = Tag.create(name:"Stek")
tag6.save
tag7 = Tag.create(name:"Energi")
tag7.save
tag8 = Tag.create(name:"Burk")
tag8.save
tag9 = Tag.create(name:"Mat")
tag9.save
tag10 = Tag.create(name:"Spel")
tag10.save
tag11 = Tag.create(name:"Grönsaker")
tag11.save
tag12 = Tag.create(name:"Salt")
tag12.save
tag13 = Tag.create(name:"Skärm")
tag13.save
tag14 = Tag.create(name:"Coolt")
tag14.save
tag15 = Tag.create(name:"ballt")
tag15.save
tag16 = Tag.create(name:"fränt")
tag16.save
tag17 = Tag.create(name:"fiskigt")
tag17.save
tag18 = Tag.create(name:"Politiskt")
tag18.save
tag19 = Tag.create(name:"trevligt")
tag19.save
tag20 = Tag.create(name:"morotskaka")
tag20.save
tag21 = Tag.create(name:"framtid")
tag21.save
tag22 = Tag.create(name:"museum")
tag22.save
tag23 = Tag.create(name:"galleria")
tag23.save
tag24 = Tag.create(name:"shopping")
tag24.save
tag25 = Tag.create(name:"glass")
tag25.save
tag26 = Tag.create(name:"musik")
tag26.save
tag27 = Tag.create(name:"café")
tag27.save
tag28 = Tag.create(name:"kiosk")
tag28.save
tag29 = Tag.create(name:"mössor")
tag29.save
tag30 = Tag.create(name:"hamn")
tag30.save
tag31 = Tag.create(name:"hus")
tag31.save


TagOnEvent.delete_all
toe = TagOnEvent.new
toe.event = event
toe.tag = tag
toe.save

toe2 = TagOnEvent.new
toe2.event = event2
toe2.tag = tag2
toe2.save

toe3 = TagOnEvent.new
toe3.event = event3
toe3.tag = tag4
toe3.save

toe4 = TagOnEvent.new
toe4.event = event3
toe4.tag = tag5
toe4.save

toe5 = TagOnEvent.new
toe5.event = event3
toe5.tag = tag6
toe5.save

toe6 = TagOnEvent.new
toe6.event = event2
toe6.tag = tag7
toe6.save

toe7 = TagOnEvent.new
toe7.event = event
toe7.tag = tag7
toe7.save

toe8 = TagOnEvent.new
toe8.event = event3
toe8.tag = tag7
toe8.save






