mod system;

use starknet::{ContractAddress};

#[starknet::interface]
trait IExternalFunctions<TContractState> {
    fn registration_request(ref self: TContractState);
}

#[starknet::contract]
mod contract {
    use starknet::{ContractAddress};
    use option::OptionTrait;
    use super::{IExternalFunctions};
    use super::{
        system::{InternalFunctions},
    };

    #[storage]
    struct Storage {
        register: LegacyMap<ContractAddress, Option<bool>>,
    }

    #[external(v0)]
    impl ExternalFunctionsImpl of IExternalFunctions<ContractState> {
        fn registration_request(ref self: ContractState) {
            let caller = starknet::get_caller_address();
            assert_address_is_not_zero(caller);
            assert_address_is_not_register(@self, caller);

            self._add_address_into_register_(caller);
        }
    }

   

    impl InternalFunctionsImpl of InternalFunctions<ContractState> {
        fn _add_address_into_register_(ref self: ContractState, address: ContractAddress) {
            self.register.write(address, Option::Some(true));
        }
    }

    fn assert_address_is_not_zero(address: ContractAddress) {
        assert(!address.is_zero() ,'INVALID_ADDRESS');
    }
    fn assert_address_is_not_register(self: @ContractState, caller: ContractAddress) {
        assert(self.register.read(caller) == Option::None, 'INVALID_CALL')
    }
}