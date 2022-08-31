# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.library import L1PoolSwapperInteraction
from openzeppelin.access.ownable.library import Ownable

#
# Constructor
#

@constructor
func constructor{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt, l1_address: felt):
    L1PoolSwapperInteraction.initializer(l1_address)
    Ownable.initializer(owner)
    return ()
end

#
# Getters
#
@view
func get_l1_contract{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (l1_address: felt):
    return L1PoolSwapperInteraction.l1_interact_address()
end


#
# Write Functions
#

@external
func swap_token_message{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(token_from: felt, token_to: felt, amount: felt):
    #@TODO Get Layer 1 State
    L1PoolSwapperInteraction.interact_with_l1_contract(token_from, token_to, amount)
    return ()
end

@external
func update_l1_contrat{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(new_l1_address: felt):
    Ownable.assert_only_owner()
    L1PoolSwapperInteraction.update_l1_interact_address(new_l1_address)
    return ()
end