extends RigidBody
#extends KinematicBody

export var speed = 1
export var fall_acceleration = 75

var velocity = Vector3.ZERO

var thrust = Vector2(0, 250)
var torque = 20000

var linearVelocityModule = 5
var anglePlayerRot = get_node(".").get("rotation_degrees") # get_rot() not working!
var posPlayer = get_node(".").get("translation")
var localLinearVelocityX = linearVelocityModule * cos(anglePlayerRot.x) #Can't convert Vector3 to Float!!
var localLinearVelocityY = linearVelocityModule * sin(anglePlayerRot.y)

# Trying this for 3D
var localLinearVelocityZ = linearVelocityModule * tan(anglePlayerRot.z)
var localLinearVelocity = Vector3(localLinearVelocityX, localLinearVelocityY, localLinearVelocityZ) 
#var localLinearVelocity = Vector2(localLinearVelocityX, anglePlayerRot.y) 

var motion = Vector2()
var state = 1
#0 for nothing, 1 = right, 2=left, 3=jump


export var durability : int = 100;
var remove_decal : bool = false;

func _ready():
	$timer.connect("timeout", self, "queue_free");
	$explosion/timer.connect("timeout", self, "_explode_others");

func _damage(damage) -> void:
	if durability > 0:
		var dam_calc = durability - damage;
		
		$audios/impact.pitch_scale = rand_range(0.9, 1.1);
		$audios/impact.play()
		
		if dam_calc <= 0:
			durability -= damage;
			_kill();
			Globals.enemy_killed();
			$explosion/timer.start();
			$timer.start();
		else:
			durability -= damage;
			
#func _integrate_forces(state):
#    if Input.is_action_pressed("ui_up"):
#        applied_force = thrust.rotated(rotation)
#    else:
#        applied_force = Vector2()
#   var rotation_dir = 0
#    if Input.is_action_pressed("ui_right"):
#        rotation_dir += 1
#    if Input.is_action_pressed("ui_left"):
#        rotation_dir -= 1
#    applied_torque = rotation_dir * torque

func _process(_delta) -> void:
	_remove_decal();
	#state = floor(rand_range(0,2))
	print(state)
	print("hi")
	state = 1
	
	if state == 0:
		pass
	elif state ==1:
		motion.x += 5
		set_translation(Vector3(get_node(".").get("translation").x-0.02, get_node(".").get("translation").y, get_node(".").get("translation").z))
		set_rotation(Vector3(0,0,0))
		#add_force(Vector3(1,0,0), Vector3(1,0,0))
		#set_linear_velocity(Vector3(-3, 0, 0))
		#set_linear_velocity(Vector3(localLinearVelocity.x - speed, get_linear_velocity().y, get_linear_velocity().z))
	elif state ==2 :
		motion.y += 5
	
func _kill() -> void:
	$collision.disabled = true;	
	$mesh.visible = false;


func _explosion() -> void:
	$collision.disabled = true;
	
	var main = get_tree().get_root().get_child(0);
	
	var burnt_ground = preload("res://data/scenes/burnt_ground.tscn").instance();
	main.add_child(burnt_ground);
	burnt_ground.translation = global_transform.origin;
	
	#mode = MODE_STATIC;
	
	$mesh.visible = false;
	$effects/ex.emitting = true;
	$effects/plo.emitting = true;
	$effects/sion.emitting = true;
	$audios/explosion.pitch_scale = rand_range(0.9, 1.1);
	$audios/explosion.play();
	
	remove_decal = true;

func _remove_decal():
	if remove_decal:
		for child in get_child_count():
			if get_child(child).is_in_group("decal"):
				get_child(child).queue_free();

func _explode_others():
	for bodie in $explosion.get_overlapping_bodies():
		if bodie.has_method("_damage") and bodie != self:
			if "durability" in bodie:
				if bodie.durability > 0:
					var explosion_distance = (5 * bodie.global_transform.origin.distance_to(global_transform.origin));
					bodie._damage(300 - explosion_distance);
