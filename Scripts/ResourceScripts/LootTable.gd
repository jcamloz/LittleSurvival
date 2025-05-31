class_name LootTable
extends Resource

@export var loot_items: Array[LootItem] = []

#Devuelve un LootItem (item y cantidad) random. 
#El nivel pasado por parámetro aumentará las probabilidades de los items
func get_random_item(tool_level: int = 1) -> LootItem:
	var selected_loot: LootItem = null

	if !loot_items.is_empty():
		var total_weight = 0.0
		var adjusted_probs := []

		# Aumenta la diferencia entre comunes y raros según el nivel
		for loot_item in loot_items:
			var base_prob = loot_item.probability
			var adjusted_prob = pow(base_prob, 1.0 / tool_level)  # menor probabilidad => sube más
			adjusted_probs.append(adjusted_prob)
			total_weight += adjusted_prob

		if total_weight > 0.0:
			#Genero un valor aleatorio entre 0 y el peso total
			var rand_value = randf() * total_weight
			var accumulation = 0.0

			for i in range(loot_items.size()):
				accumulation += adjusted_probs[i]
				if rand_value <= accumulation:
					selected_loot = loot_items[i]
					break

	return selected_loot
