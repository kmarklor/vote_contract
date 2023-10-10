use starknet::{ContractAddress};
use super::system::{TxWrap};
use super::emitter_block::{EmitTx};

struct ProcessingTx {
    processing_description: felt252,
    emit_description: felt252,
    processing_version: u8,
    emit_version: u8,
    // temp
    contract_address: ContractAddress,
}

impl EmitTxToProcessingTx of TxWrap<EmitTx, ProcessingTx> {
    fn wrap_syscall(input: EmitTx, descriptor: felt252) -> ProcessingTx {
        ProcessingTx {
            processing_description: descriptor,
            emit_description: input.emit_description,
            processing_version: 0,
            emit_version: input.emit_version,
            contract_address: input.contract_address
        }
    }
}