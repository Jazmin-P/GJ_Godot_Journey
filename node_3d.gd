extends Node3D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0,-1): N, 
				  Vector2(1,0) : E,
				  Vector2(0,1) : S,
				  Vector2(-1,0): W}
				
var tile_size = 2
var width = 20
var height = 20

@onready var Map = $GridMap
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	tile_size = Map.cell_size
	make_maze()

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys(): #check the neighbors
		if cell + n in unvisited: #if neighbor unvisited
			list.append(cell + n) #add to list 
	return list 
	
func make_maze():
	var unvisited = [] #array of unvisited tiles 
	var stack = []
	
	#set all tiles to solid 
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cell_item(Vector3i(x, 0, y), N|E|S|W)
	var current = Vector2(0,0) #pick starting cell
	unvisited.erase(current) #remove start
	
	while unvisited: #unvisited is not empty 
		var neighbors = check_neighbors(current, unvisited) #how many unvisited neighbors we have
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()] #pick a random one
			stack.append(current)#put the current cell on the stack 
			
			var dir = next - current #will give us which direction we just moved in
			
			var current_grid_pos = Vector3i(current.x, 0, current.y)#change from 2d to 3d
			var next_grid_pos = Vector3i(next.x, 0, next.y)
			
			#									15		move up = (0,-1) = North wall = 1  15-1=14 which is a cell with the north wall open |_| 
			var current_walls = Map.get_cell_item(current_grid_pos) - cell_walls[dir]
			var next_walls = Map.get_cell_item(next_grid_pos) - cell_walls[-dir]#we want to do the opposite so remove south wall of the cell above us | |
			
			#pointer math 
			Map.set_cell_item(current_grid_pos, current_walls)
			Map.set_cell_item(next_grid_pos, next_walls)
			current = next
			unvisited.erase(current)#take unvisited cell out of array because it was visited 
		elif stack: #backtrack if no neighbors 
			current = stack.pop_back()
		await(get_tree().process_frame)
