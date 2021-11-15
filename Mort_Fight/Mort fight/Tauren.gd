extends KinematicBody2D
var team
var HP
var actionlock
var is_player
signal attacked
signal walk_left
signal walk_right
signal chop_down
signal idle
signal stab
signal slash_around
enum Status{
	Walk,
	Chop_down,
	Die,
	Gasp,
	Idle,
	Scorn,
	Slash_around,
	Stab,
	Attacked
}
var dic={
	Status.Walk:"Walk",
	Status.Chop_down:"Chop_down",
	Status.Die:"Die",
	Status.Gasp:"Gasp",
	Status.Idle:"Idle",
	Status.Scorn:"Scorn",
	Status.Slash_around:"Slash_around",
	Status.Stab:"Stab",
	Status.Attacked:"Attacked"
}
var current_status
var connect_err
func _ready():
	is_player=0
	HP=100
	actionlock=0
	current_status=Status.Idle
	connect_err = $Actionlocktimer.connect("timeout",self,"reset_actionlock")
	print(connect_err)
	playanimation(dic[current_status])
	connect_err = $"Attack Area/Chop down".connect("body_entered",self,"damage")
	print(connect_err)
	connect_err = $"Attack Area/Slash around".connect("body_entered",self,"damage")
	print(connect_err)
	connect_err = $"Attack Area/Stab".connect("body_entered",self,"damage")
	print(connect_err)
	connect_err = connect("attacked",self,"Attacked")
	$Sprite/AnimationPlayer.connect("animation_finished",self,"_on_idle")
	connect("idle",self,"Idle")
	connect("stab",self,"Stab")
	connect("chop_down",self,"Chop_down")
	connect("walk_left",self,"Walk_left")
	connect("walk_right",self,"Walk_right")
	connect("slash_around",self,"Slash_around")
	pass
func _on_idle(anim):
	emit_signal("idle")
func _on_dead():
	get_parent().remove_child(self)
func damage(player):
	if !player.team==self.team:
		player.emit_signal("attacked")
func set_player():
	is_player=1
func playanimation(name):
	$Sprite/AnimationPlayer.play(name)
func lockaction(time):
	set_actionlock()
	var timer = $Actionlocktimer
	timer.wait_time=time
	timer.start()
func reset_actionlock():
	actionlock=0
func set_actionlock():
	actionlock=1
func set_team(group_name):
	self.add_to_group(group_name)
	team=group_name
func Walk_left():
	if actionlock==0:
		self.scale.x=-1
		self.position.x-=2
		current_status=Status.Walk
		playanimation(dic[current_status])
func Walk_right():
	if actionlock==0:
		self.scale.x=1
		self.position.x+=2
		current_status=Status.Walk
		playanimation(dic[current_status])
func Chop_down():
	if actionlock==0:
		current_status=Status.Chop_down
		lockaction(0.35)
		playanimation(dic[current_status])
func Stab():
	if actionlock==0:
		current_status=Status.Stab
		lockaction(0.3)
		playanimation(dic[current_status])
func Slash_around():
	if actionlock==0:
		current_status=Status.Slash_around
		lockaction(0.7)
		playanimation(dic[current_status])
func Idle():
	current_status=Status.Idle
	playanimation(dic[current_status])
func Attacked():
	HP-=5
	$HPbar.rect_size.x=50*HP/100
	if HP>0:
		reset_actionlock()
		current_status=Status.Attacked
		playanimation(dic[current_status])
		lockaction(0.3)
	else:
		$Actionlocktimer.disconnect("timeout",self,"reset_actionlock")
		$Sprite/AnimationPlayer.disconnect("animation_finished",self,"_on_idle")
		current_status=Status.Die
		playanimation(dic[current_status])
		set_actionlock()
		connect_err = $Actionlocktimer.connect("timeout",self,"_on_dead")
		print(connect_err)
		$Actionlocktimer.wait_time=1.5
		$Actionlocktimer.start()
