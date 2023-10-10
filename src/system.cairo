use starknet::{
    ContractAddress
};

trait InternalFunctions<TContractState> {
    fn _add_address_into_register_(ref self: TContractState, address: ContractAddress);
}