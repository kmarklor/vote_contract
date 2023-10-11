use super::super::contract;

use starknet::contract_address;

#[test]
#[available_gas(6000)]
fn assert_address_is_not_zero_works() {
    let address = starknet::contract_address_const::<0x1234>();
    contract::assert_address_is_not_zero(address);
}

#[test]
#[available_gas(6000)]
#[should_panic(expected: ('INVALID_ADDRESS', ))]
fn assert_address_is_not_zero_panic() {
    let address = starknet::contract_address_const::<0x00>();
    contract::assert_address_is_not_zero(address);
}