# contracts/library.cairo
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from openzeppelin.access.ownable.library import Ownable
from starkware.starknet.common.syscalls import get_caller_address
from starkware.starknet.common.messages import send_message_to_l1
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

#
# Storage
#

@storage_var
func l1_interact_address_() -> (l1_address : felt):
end

#
# Events
#

@event
func InterractedWithL1(l1_recipient : felt, amount : Uint256):
end

namespace L1Interaction:

    #
    # Constructor
    #

    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, l1_address : felt
    ):
        Ownable.initializer(owner)
        l1_interact_address_.write(l1_address)
        return ()
    end

    #
    # Getters
    #

    ###
    # Returns the address of the Interacted contract on the L1
    ###
    func l1_interact_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (l1_address : felt):
        return l1_interact_address_.read()
    end



    func interact_with_l1_contract{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        l1_recipient : felt, amount : Uint256
    ):
        alloc_locals
        let (message_payload : felt*) = alloc()
        let (caller) = get_caller_address()
        let (l1_address) = l1_interact_address()
        assert message_payload[0] = l1_recipient
        assert message_payload[1] = amount.low
        assert message_payload[2] = amount.high
        send_message_to_l1(to_address=l1_address, payload_size=3, payload=message_payload)
        InterractedWithL1.emit(l1_recipient, amount)
        return ()
    end


end

namespace internal:
end