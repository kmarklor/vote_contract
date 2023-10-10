use super::{
    emitter_block::{EmitTx},
    process_block::{ProcessingTx},
};

trait TxWrap<I, O> {
    fn wrap_syscall(input: I, descriptor: felt252) -> O;
}

trait InternalFunctions<TContractState> {
    fn registration_request_syscall(ref self: TContractState, emit_tx: EmitTx);
}