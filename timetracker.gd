extends Node2D

const eq=preload("res://event_q.gd")

var timer
var listeners=[]
var id="generic"
var tq
var count=0

	
func _ready() -> void:
	tq=eq.new()

	
#TIMERS
	#testtimerbase()
#	testtimerbound()
#	testtimermultilistener()
#	testmultitimers()
#	testtimermultilisteneroverwrite()
	#testuniquediffcontext()
#	testmultitimerssamename()
	#testmultitimerssamenameunique()
	#testkillalltimers()
	#testkillallspecifictimers()
	
#EVENTS
	testevent()

func _process(delta: float) -> void:
	
	var cevent=tq.consumeEvent("main")
	if cevent!=null:
		print(cevent," : ",count)
	count+=1

func testevent():
	tq.addEvent("doevent","main",true,{"params":["testing"]})
	tq.addEvent("doevent","main",true,{"params":["testing"]})	
	tq.addEvent("doevent","main",true,{"params":["testing"]})
	tq.addEvent("doevent","main",true,{"params":["testing"]})






func testtimerbase():
	tq.dotime(self,[test],1.0,"test",false,"main")

func testtimerbound():
	tq.dotime(self,[test3.bind("yo")],1.0,"test",false,"main")

func testtimermultilistener():
	tq.dotime(self,[test,test2,test3.bind("test3")],1.0,"test",false,"main")

func testtimermultilisteneroverwrite():
	tq.dotime(self,[test,test3.bind("test3")],1.0,"test",false,"main")
	tq.dotime(self,[test2],1.0,"test",true,"main")

func testuniquediffcontext():
	tq.dotime(self,[test,test3.bind("test3")],1.0,"test",true,"main")
	tq.dotime(self,[test2],1.0,"test",true,"temple")


func testmultitimers():
	tq.dotime(self,[test],1.0,"test",false,"main")
	tq.dotime(self,[test2],1.0,"test2",false,"main")
	
func testmultitimerssamename():
	tq.dotime(self,[test],1.0,"test",false,"main")
	tq.dotime(self,[test2],1.0,"test",false,"main")
	
func testmultitimerssamenameunique():
	tq.dotime(self,[test],1.0,"test",true,"main")
	tq.dotime(self,[test2],1.0,"test",true,"main")	

func testkillalltimers():
	tq.dotime(self,[test],5.0,"test",false,"main")
	tq.dotime(self,[test2],5.0,"test",false,"temple")
	tq.dotime(self,[test2],5.0,"test2",false,"main")
	tq.dotime(self,[test2],5.0,"test3",false,"main")
	tq.dotime(self,[test2],5.0,"test4",false,"main")
	tq.timerkillemall()

func testkillallspecifictimers():
	tq.dotime(self,[test],5.0,"test",false,"main")
	tq.dotime(self,[test2],5.0,"test",false,"temple")
	tq.dotime(self,[test2],5.0,"test2",false,"main")
	tq.dotime(self,[test2],5.0,"test3",false,"main")
	tq.dotime(self,[test2],5.0,"test4",false,"main")
	tq.timerkillemall("main")


func test():
	print("test1")
	
func test2():
	print("test2")

func test3(p):
	print(p)	
	
