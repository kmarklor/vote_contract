mod process_block;
mod emitter_block;
mod system;

#[starknet::interface]
trait IVoteContract<TContractState> {
    fn registration_request(ref self: TContractState);
}

#[starknet::contract]
mod contract {
    use starknet::{ContractAddress};
    use option::OptionTrait;
    use super::{IVoteContract};
    use super::{
        emitter_block::{EmitTxImpl, EmitTx},
        process_block::{EmitTxToProcessingTx, ProcessingTx},
        system::{InternalFunctions},
    };

    #[storage]
    struct Storage {
        register: LegacyMap<ContractAddress, Option<bool>>,
    }

    #[external(v0)]
    impl VoteContractImpl of IVoteContract<ContractState> {
        fn registration_request(ref self: ContractState) {
            let caller = starknet::get_caller_address();
            assert(!caller.is_zero(), 'INVALID_ADDRESS');

            let send_emit_tx: EmitTx = EmitTxImpl::make_wrap(caller, 'REGISTRATION_REQUEST');
            self.registration_request_syscall(send_emit_tx);
        }
    }

    impl InternalFunctionsImpl of InternalFunctions<ContractState> {
        fn registration_request_syscall(ref self: ContractState, emit_tx: EmitTx) {
            let processing_tx = EmitTxToProcessingTx::wrap_syscall(
                input: emit_tx, descriptor: 'ADD_ADDRESS_IN_REGISTER'
            );
            let caller = processing_tx.contract_address;
            match self.register.read(caller) {
                Option::Some(_) => (), // module C
                Option::None(_) => self.register.write(caller, Option::Some(true)),
            }
        }
    }
}