use starknet::{ContractAddress};

struct EmitTx {
    emit_description: felt252,
    emit_version: u8,
    // temp
    contract_address: ContractAddress,
}

impl EmitTxDrop of Drop<EmitTx>;

#[generate_trait]
impl EmitTxImpl of EmitTxTrait {
    fn make_wrap(contract_address: ContractAddress, emit_description: felt252) -> EmitTx {
        EmitTx { emit_description, emit_version: 0, contract_address }
    }
}