use starknet::{
    ContractAddress
};

trait InternalFunctions<TContractState> {
    fn _add_address_into_register_(ref self: TContractState, address: ContractAddress);
    fn is_in_register(self: @TContractState, addr: ContractAddress) -> bool;
}