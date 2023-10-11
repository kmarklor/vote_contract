mod system;

use starknet::{ContractAddress};

#[starknet::interface]
trait IExternalFunctions<TContractState> {
    fn registration_request(ref self: TContractState);
    fn register(self: @TContractState, addr: ContractAddress) -> felt252;
}

#[starknet::contract]
mod contract {
    use starknet::{
        ContractAddress, ContractAddressIntoFelt252,
    };
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into};
    use super::{IExternalFunctions};
    use super::{
        system::{InternalFunctions},
    };

    #[storage]
    struct Storage {
        register: LegacyMap<ContractAddress, Option<bool>>, // change option<bool> by option<VOTER>
    }

    #[event]
    #[derive(starknet::Event, Drop, Serde)]
    enum Event {
        Registration: Registration,
    }

    #[derive(starknet::Event, Drop, Serde)]
    struct Registration {
        #[key]
        address: ContractAddress,
        #[data]
        msg: felt252
    }

    #[external(v0)]
    impl ExternalFunctionsImpl of IExternalFunctions<ContractState> {
        fn registration_request(ref self: ContractState) {
            let caller = starknet::get_caller_address();
            assert_address_is_not_zero(caller);
            assert_address_is_not_register(@self, caller);

            self._add_address_into_register_(caller);
            self.emit( Registration { address: caller, msg: 'NEW_VOTER' } );
        }

        fn register(self: @ContractState, addr: ContractAddress) -> felt252 {
            if self.is_in_register(addr) {
                ContractAddressIntoFelt252::into(addr)
            } else {
                'UNREGISTRED'
            }
        }
    }

   

    impl InternalFunctionsImpl of InternalFunctions<ContractState> {
        fn _add_address_into_register_(ref self: ContractState, address: ContractAddress) {
            self.register.write(address, Option::Some(true));
        }
        fn is_in_register(self: @ContractState, addr: ContractAddress) -> bool {
            self.register.read(addr).is_some()
        }
    }

    fn assert_address_is_not_zero(address: ContractAddress) {
        assert(!address.is_zero() ,'INVALID_ADDRESS');
    }
    fn assert_address_is_not_register(self: @ContractState, contract_address: ContractAddress) {
        assert(!self.is_in_register(contract_address), 'NON_VALID_REQUEST')
    }
}

#[cfg(test)]
mod tests {
    mod internal_functions;
}