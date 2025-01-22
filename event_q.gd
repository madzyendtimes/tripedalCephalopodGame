extends Node

class_name eventQ

var Q=[]
var size=0
var q={
	"main":
		{"events":[],
		"timers":{}},
	"level":
		{"events":[],
		"timers":{}},
	"stanima":
		{"events":[],
		"timers":{},
		"push":[]},
	"health":
		{"events":[],
		"timers":{},
		"push":[]},
	"witchhut":
		{"events":[],
		"timers":{}},
	"temple":
		{"events":[],
		"timers":{}},
	"cryptominos":
		{"events":[],
		"timers":{}},
	"statsScreen":
		{"events":[],
		"timers":{}},
	"title":
		{"events":[],
		"timers":{}},
	"jobboard":
		{"events":[],
		"timers":{}},
	"home":
		{"events":[],
		"timers":{}},
	"spacetime":
		{"events":[],
		"timers":{}},
	"trader":
		{"events":[],
		"timers":{}},							
	}
var guid=0	

func dotime(callee,timefunc,ntime,name="generic",unique=false,type="main"):
	var gt:Timer=Timer.new()
	callee.add_child(gt)
	gt.wait_time=ntime
	gt.one_shot=true			
	addTimer(name,type,unique,{"timer":gt, "push":timefunc,"uid":callee.get_instance_id()})


func addEventListener(listener,type="main"):
	q[type].push.append(listener)

func addEvent(value="",type="main",unique=false,param={}):
	if value=="":
		return	
	if unique:
		for i in q[type].events:
			if i.name==value:
				var ev={"name":value,"param":param}
				i=ev
				return
	var ev={"name":value,"param":param}
	q[type].events.append(ev)


func addTimer(value="",type="main",unique=false,param={}):
	if value=="":
		return

	if unique:
		killTimer(value,type)
	var tm={"type":type,"name":value,"timer":param.timer,"alert":param.push,"id":guid}
	guid+=1
	tm.timer.timeout.connect(handletimeout.bind(tm))	
	q[type].timers[tm.id]=tm
	tm.timer.start()
	

func handletimeout(tm):
	for i in q[tm.type].timers[tm.id].alert:
		i.call()
	q[tm.type].timers.erase(tm.id)
	
func timerkillemall(type=""):
	if type=="":
		for i in q.keys():
			timerkilltype(i)
	else:
		timerkilltype(type)


func timerkilltype(type="main"):
	var kill=[]
	for i in q[type].timers.values():
		i.timer.stop()
		i.timer.queue_free()
		kill.append(i.id)
	for i in kill:
		q[type].timers.erase(i)

func eventkillemall(type=""):
	if type=="":
		for i in q.keys():
			eventkilltype(i)
	else:
		eventkilltype(type)

func eventkilltype(type="main"):
	var kill=[]
	q[type].events=[]

func killEvent(wtk="",type="main"):

	if wtk!="":
		var kill=[]
		var count=0
		for i in q[type].events:
			if i.name==wtk:
				kill.append(count)
			count+=1
			
		for i in kill:
			q[type].events.remove_at(i)
			
func killTimer(wtk="",type="main"):
	if wtk!="":
		var kill=[]
		for value in q[type].timers.values():
			if value.name==wtk:
				value.timer.stop()
				value.timer.queue_free()
				kill.append(value.id)
		for i in kill:
			q[type].timers.erase(i)

			
func consumeEvent(type="main"):
	var ev=q[type].events.pop_front()
	return ev
