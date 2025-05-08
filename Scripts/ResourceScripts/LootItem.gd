class_name LootItem extends Resource

@export var item: Item
@export_range(1, 999, 1) var amount: int = 1 #por defecto 1
@export_range(0.0, 1.0, 0.01) var probability: float = 0.1  # 10% por defecto
