class_name Fundable
extends Node

var balance: int = 0


func transfer_funds(target: Fundable, amount: int):
	remove_funds(amount)
	target.balance += amount


func remove_funds(amount: int):
	if (amount > balance):
		push_error("fundable.remove_funds: Insufficient funds (request: %d, balance: %d)" % [amount, balance])
		return
	balance -= amount
