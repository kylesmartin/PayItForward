class_name Fundable
extends Node

# the current balance of this account
var balance: int = 0


# transfer funds to another account
func transfer_funds(target: Fundable, amount: int):
	var success: bool = remove_funds(amount)
	if success:
		target.balance += amount


# remove funds from this account
func remove_funds(amount: int) -> bool:
	if (amount > balance):
		push_error("fundable.remove_funds: Insufficient funds (request: %d, balance: %d)" % [amount, balance])
		return false
	balance -= amount
	return true
