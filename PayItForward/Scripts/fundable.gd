class_name Fundable
extends Node

var balance: int = 0


func add_funds(funds: int) -> void:
	balance += funds


func withdraw_funds(funds: int) -> void:
	if (funds > balance):
		push_error("Fundable.withdraw_funds: Insufficient funds (request: %d, balance: %d)" % [funds, balance])
		return
	balance -= funds
