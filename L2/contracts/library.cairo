// contracts/library.cairo
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_caller_address
from starkware.starknet.common.messages import send_message_to_l1
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

//
// Storage
//

@storage_var
func l1_interact_address_() -> (l1_address: felt) {
}

//
// Events
//

@event
func InterractedWithL1(l1_recipient: felt, token_from: felt, token_to: felt, amount: felt) {
}

namespace L1PoolSwapperInteraction {
    //
    // Initializer
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        l1_address: felt
    ) {
        l1_interact_address_.write(l1_address);
        return ();
    }

    //
    // Getters
    //

    //##
    // Returns the address of the Interacted contract on the L1
    //##
    func l1_interact_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        l1_address: felt
    ) {
        return l1_interact_address_.read();
    }

    //##
    // Update L1 Address interact
    //##
    func update_l1_interact_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(l1_address: felt) {
        l1_interact_address_.write(l1_address);
        return ();
    }

    //##
    // Send message to L1 Contract
    //##
    func interact_with_l1_contract{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        l1_caller: felt, token_from: felt, token_to: felt, amount: felt
    ) {
        alloc_locals;
        let (l1_address) = l1_interact_address();
        let (message_payload: felt*) = alloc();

        assert message_payload[0] = l1_caller;

        assert message_payload[1] = token_from;

        assert message_payload[2] = token_to;

        assert message_payload[3] = amount;

        send_message_to_l1(to_address=l1_address, payload_size=4, payload=message_payload);
        InterractedWithL1.emit(l1_caller, token_from, token_to, amount);
        return ();
    }
}

namespace internal {
}
