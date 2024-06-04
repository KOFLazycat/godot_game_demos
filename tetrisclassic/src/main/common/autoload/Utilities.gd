extends Node

func delete_children(node: Node):
	for n in node.get_children():
		if n.is_class("Sprite2D"):
			node.remove_child(n)
			n.queue_free()
